# Hybrid text-editing implementation audit

## Why the previous OCR approach failed

The earlier editor made OCR words behave like positioned HTML labels. That has four structural problems:

1. OCR bounding boxes describe detected ink, not true font metrics.
2. A scan contains pixels, not a recoverable PDF font/text object.
3. Replacing one word independently makes any font/weight/antialias mismatch obvious against the untouched sentence.
4. `pdf-lib` can draw new content but does not provide general editing/removal of arbitrary existing PDF page text.

No amount of `fontSize = bboxHeight * constant` tuning fixes those facts.

## New architecture

### 1. Inspect before recognizing

`lib/native-text.ts` inspects PDF.js text content and the page operator list.

It tracks:
- visible text-show operations,
- invisible text-show operations (PDF text rendering modes 3/7),
- raster-image paint operations.

This allows the editor to distinguish:
- ordinary native text,
- image-only scans,
- searchable scans with hidden OCR text,
- mixed native+raster pages.

### 2. Native PDF path

Native pages bypass Tesseract.

The editor uses PDF.js:
- text strings,
- text transform matrices,
- page viewport transform,
- baseline position,
- ascent/descent,
- loaded internal font name,
- CSS font information/weight/style where available.

Nearby text items on the same baseline/font are merged into editable runs. The browser therefore renders replacements with the same PDF.js-loaded embedded font face when it is available, instead of guessing Arial/Calibri.

A local background patch is still required because pdf-lib cannot remove the original native text object. The visible replacement is rasterized at export with the same browser typography model used in the editor, preventing editor/export font divergence.

### 3. Scan path

Tesseract is now a semantic/layout detector, not the visual renderer.

Structured `blocks` output supplies:
- lines,
- words,
- line bounding boxes,
- baselines,
- row height / ascender / descender metrics,
- confidence,
- font-name hints where Tesseract exposes them.

The editor creates **one editable object per OCR line**, not one per word. This reduces the pasted-label discontinuity because an edited line is reconstructed using one typography model.

The TSV path is retained only as a fallback when structured blocks are unavailable.

### 4. Pixel repair

`lib/text-pixels.ts` synthesizes a replacement background patch from samples around all four sides of the text region.

Instead of painting a flat white rectangle, each pixel inside the removed text region is interpolated from the nearest top/bottom/left/right boundary samples. This can retain paper tone, simple gradients, and rules that pass through a text region significantly better than a solid fill.

### 5. Mixed pages

If a page contains real visible PDF text and raster images, the editor prepares both paths.

OCR-derived scan lines are discarded when their region is substantially covered by native PDF text. Remaining scan lines are merged with native runs into one editable model. This avoids duplicate OCR/native overlays while keeping raster text in embedded scans/photos editable.

### 6. Export

For edited regions:
1. draw the synthesized background patch,
2. draw the visible replacement with the same typography model used by the live editor,
3. add a separate invisible search-text layer when the standard search font can encode the text.

The invisible layer does not control visual appearance.

## Known limits

### Native PDF structural editing

This project does not rewrite arbitrary original PDF content streams. True editing can involve `Tj/TJ` strings, custom encodings, subset fonts, nested Form XObjects, clipping, text matrices and resource dictionaries. General mutation of that content is outside pdf-lib's feature set.

### Scanned typography

A scan may not contain the source font file at all. OCR can infer text/layout and sometimes a font name, but it cannot guarantee exact original glyph design. The line-level reconstruction plus source-pixel repair is therefore the best open-source/browser approach in this stack, not a claim of perfect font recovery.

### Paragraph reflow

Edits are fixed-layout. Large replacements may overflow the original run/line. Full Word-like paragraph reflow requires a document-layout engine and is intentionally not faked here.

## Files changed for the hybrid engine

- `lib/native-text.ts` — native/invisible-text inspection, PDF.js font/geometry extraction
- `lib/text-pixels.ts` — text/background sampling and local background synthesis
- `lib/ocr.ts` — line-level OCR reconstruction
- `lib/types.ts` — native/scan/mixed text model
- `components/pdf-editor.tsx` — hybrid preparation and mixed-page merge
- `components/pdf-page.tsx` — direct editing UI using shared typography/pixel patches
- `components/ocr-panel.tsx` — renamed text-preparation UX and source-aware status
- `lib/export-pdf.ts` — matching background repair + visible replacement export

## Performance audit: Page Unresponsive fix

### Root cause

The previous `lib/text-pixels.ts` implementation used a helper that called:

```ts
context.getImageData(x, y, 1, 1)
```

for individual pixels. `synthesizeBackgroundPatch()` then called that helper up to four times for every output pixel. A single 1,000×50 text line could therefore cause roughly 200,000 synchronous canvas readbacks. Preparation eagerly generated one of these patches for every native run/OCR line, so dense pages could generate millions of main-thread canvas readbacks before the user edited anything.

At the same time, native-text preparation rendered an additional high-resolution page solely for appearance/patch extraction, every sidebar thumbnail rendered immediately, OCR progress could update React at worker-message frequency, and undo checkpoints deep-cloned OCR results including base64 PNG patch strings.

### Fix

`lib/text-pixels.ts` now performs one bounded `getImageData()` call for the local region and all subsequent sampling/interpolation reads directly from its `Uint8ClampedArray`.

Cleanup patch generation is no longer part of page preparation. `components/pdf-page.tsx` creates the patch lazily from the already-rendered visible PDF canvas after the user clicks a specific editable line. This means a 60-line page generates zero cleanup PNGs until an edit actually happens.

Native PDF preparation now stays geometry-only. It does not render a high-resolution duplicate page for every native-text page.

OCR rendering is capped with an adaptive scale so unusual page dimensions cannot create an unbounded bitmap. Tesseract continues to do OCR in its own browser worker; main-thread work after recognition is kept bounded and the multi-page loop explicitly yields between pages.

Sidebar thumbnails use `IntersectionObserver` with a preload margin so off-screen pages do not all start PDF.js rendering simultaneously.

Undo uses immutable structural snapshots rather than `structuredClone()` for the complete editor model. Since editor updates replace arrays/objects rather than mutating them, retaining those references is safe and avoids copying potentially large base64 patches.

Finally, inline OCR/native editing keeps draft keystrokes inside the `contenteditable` element and updates the React document model only when the edit is committed.
