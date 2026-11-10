# PDF Studio — Hybrid Precision Text Editing

A browser-first PDF editor built with Next.js App Router, Tailwind CSS, Motion, PDF.js, pdf-lib, and Tesseract.js.

The text editor no longer treats every document as OCR. It automatically chooses the least destructive path for each page:

- **Native PDF text** — PDF.js text geometry and loaded embedded fonts are reused; OCR is skipped.
- **Scanned/image-only pages** — OCR is used for recognition/layout only. Editing repairs the source pixels and reconstructs a full text line.
- **Mixed pages** — native PDF text and scan regions are combined. OCR regions overlapping real PDF text are discarded so the page does not get duplicate editable layers.
- **Searchable scans** — invisible OCR text layers are detected and treated as scans because changing hidden text would not change the photographed letters.

## Included

- PDF import and local rendering with PDF.js
- Page thumbnails, reorder, rotate, duplicate, delete
- Text, highlight, rectangle, ellipse, freehand, image and signature annotations
- Undo / redo
- Zoom and responsive editor chrome
- Hybrid editable-text preparation
- Native PDF font/geometry reuse when real text exists
- Client-side Tesseract.js OCR for raster text
- Line-level scan reconstruction instead of pasted word labels
- Local background repair for edited scan/native regions
- Search and copy prepared text
- Mixed native + raster pages
- Export edited PDF with pdf-lib
- Separate invisible search text for edited raster replacements where encodable

## Run

Requires Node.js 20.9+.

```bash
npm install
npm run dev
```

Open `http://localhost:3000`.

## Editing text

1. Open a PDF.
2. Open the **Text** panel on the right.
3. Click **Prepare page** or **Prepare all**.
4. The editor inspects the PDF before deciding whether OCR is needed.
5. Turn on **Edit text on page**.
6. Click the text at its actual location and edit it inline.
7. Export the PDF.

### What happens under the hood

For a normal digitally generated PDF, PDF.js provides the source text transform, baseline, font metrics, and a browser-loaded representation of the embedded PDF font. Those are used as the editing model instead of asking OCR to guess the font.

For a scan, the source has no text object or font file—only pixels. Tesseract provides text and layout semantics. The editor reconstructs a whole line, synthesizes a local background patch from pixels surrounding the original line, then redraws the edited line using one consistent typography model. This is materially cleaner than replacing individual words with HTML labels.

On a mixed page, the editor keeps real PDF text and only retains OCR-derived regions that are not already covered by native text.

## Important boundary

This project is still an open-source overlay/compositing editor. `pdf-lib` cannot rewrite arbitrary existing PDF page text/content streams. Native edits therefore preserve appearance by using PDF.js geometry/font rendering plus a repaired background and replacement layer rather than mutating the original `Tj/TJ` operators.

For Acrobat-class content-stream editing of arbitrary native PDFs—including true paragraph reflow, original content removal, subset-font rewriting, complex scripts and exact structural edits—a dedicated PDF content-edit SDK such as Apryse WebViewer Content Edit or Nutrient Content Editor is the appropriate engine.

For scans, no engine can recover a font file that was never embedded in the document. Exact scan typography can only be approximated/reconstructed from the pixels unless the original font is separately available.

## Responsiveness fixes in this build

The hybrid editor previously had a main-thread performance bug that could trigger Chromium's **Page Unresponsive** dialog on dense or multi-page documents.

This build changes the preparation pipeline:

- Background repair PNGs are **lazy**: they are created only for a line the user actually edits.
- Canvas pixel analysis uses bounded bulk `getImageData()` reads, never a 1×1 readback inside a per-pixel loop.
- Native PDF preparation no longer renders a separate 2.5× bitmap merely to precompute cleanup patches.
- OCR render size is adaptive and capped to roughly 4.5 million pixels per page.
- Tesseract progress updates are throttled so recognition does not flood React with state updates.
- The preparation loop yields to the browser between pages.
- Thumbnails are rendered with `IntersectionObserver` only when they approach the sidebar viewport.
- Undo snapshots retain immutable state references instead of deep-cloning every OCR PNG patch.
- Inline typing is kept local to the `contenteditable` surface and committed once, rather than rebuilding the complete OCR page model on every keystroke.

These changes are specifically intended to keep scrolling, progress UI and browser input responsive while text preparation is running.
