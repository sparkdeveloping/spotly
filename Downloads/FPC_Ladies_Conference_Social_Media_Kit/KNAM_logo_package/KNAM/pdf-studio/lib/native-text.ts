import type { EditorPage, OcrPageResult, OcrTypography, OcrWord } from "@/lib/types";
import { measureOcrText } from "@/lib/ocr";
import { uid } from "@/lib/utils";

type PdfTextItem = {
  str: string;
  dir?: string;
  transform: number[];
  width: number;
  height: number;
  fontName: string;
  hasEOL?: boolean;
};

type PdfTextStyle = { ascent?: number; descent?: number; vertical?: boolean; fontFamily?: string };
type PdfJsDoc = { getPage: (pageNumber: number) => Promise<any> };

function multiplyTransform(a: number[], b: number[]) {
  return [
    a[0] * b[0] + a[2] * b[1],
    a[1] * b[0] + a[3] * b[1],
    a[0] * b[2] + a[2] * b[3],
    a[1] * b[2] + a[3] * b[3],
    a[0] * b[4] + a[2] * b[5] + a[4],
    a[1] * b[4] + a[3] * b[5] + a[5],
  ];
}

function clamp(value: number, min: number, max: number) {
  return Math.min(max, Math.max(min, value));
}

function weightFromFont(font: any): 400 | 500 | 600 | 700 {
  const raw = `${font?.cssFontInfo?.fontWeight || ""} ${font?.name || ""} ${font?.fallbackName || ""}`.toLowerCase();
  const numeric = Number.parseInt(String(font?.cssFontInfo?.fontWeight || ""), 10);
  if (numeric >= 650 || /bold|black|heavy/.test(raw)) return 700;
  if (numeric >= 550 || /semi|demi/.test(raw)) return 600;
  if (numeric >= 450 || /medium/.test(raw)) return 500;
  return 400;
}

function styleFromFont(font: any): "normal" | "italic" {
  const raw = `${font?.cssFontInfo?.italicAngle || ""} ${font?.name || ""}`.toLowerCase();
  const angle = Number(font?.cssFontInfo?.italicAngle);
  const hasItalicAngle = Number.isFinite(angle) && angle !== 0;
  return hasItalicAngle || /italic|oblique/.test(raw) ? "italic" : "normal";
}

function getFontObject(proxy: any, fontName: string) {
  try {
    return proxy.commonObjs?.get?.(fontName) || null;
  } catch {
    return null;
  }
}

function isTextShowOp(fn: number, OPS: any) {
  return fn === OPS.showText || fn === OPS.showSpacedText || fn === OPS.nextLineShowText || fn === OPS.nextLineSetSpacingShowText;
}

/**
 * Distinguish real PDF text from the invisible OCR layer common in searchable
 * scans. Invisible OCR is useful for search, but editing it does not alter the
 * photographed letters, so those pages must still go through scan editing.
 */
export async function inspectPageTextMode(pdf: PdfJsDoc, page: EditorPage) {
  const proxy = await pdf.getPage(page.sourceIndex + 1);
  const textContent = await proxy.getTextContent();
  const items = (textContent.items || []).filter((item: any) => typeof item?.str === "string") as PdfTextItem[];
  const characterCount = items.reduce((sum, item) => sum + item.str.trim().length, 0);
  if (characterCount < 4) return { mode: "scan" as const, characterCount, textContent, proxy };

  let visibleShows = 0;
  let invisibleShows = 0;
  let imagePaintOps = 0;
  try {
    const pdfjs = await import("pdfjs-dist");
    const OPS = (pdfjs as any).OPS;
    const opList = await proxy.getOperatorList();
    let renderMode = 0;
    for (let i = 0; i < opList.fnArray.length; i++) {
      const fn = opList.fnArray[i];
      if (fn === OPS.setTextRenderingMode) {
        renderMode = Number(opList.argsArray[i]?.[0] ?? 0);
      } else if (fn === OPS.paintImageXObject || fn === OPS.paintInlineImageXObject || fn === OPS.paintImageMaskXObject || fn === OPS.paintSolidColorImageMask) {
        imagePaintOps++;
      } else if (isTextShowOp(fn, OPS)) {
        // Rendering modes 3 and 7 do not paint glyphs; 7 only clips.
        if (renderMode === 3 || renderMode === 7) invisibleShows++;
        else visibleShows++;
      }
    }
  } catch {
    // If operator inspection fails, ordinary text content is still a better
    // signal than OCR for digitally generated PDFs.
    visibleShows = Math.max(1, items.length);
  }

  const mode = invisibleShows > visibleShows * 1.25 ? "scan" as const : "native" as const;
  return { mode, characterCount, visibleShows, invisibleShows, imagePaintOps, hasRasterImages: imagePaintOps > 0, textContent, proxy };
}

type NativeRun = {
  item: PdfTextItem;
  x: number;
  y: number;
  width: number;
  height: number;
  baselineY: number;
  fontSize: number;
  ascent: number;
  descent: number;
  fontFamily: string;
  fontWeight: 400 | 500 | 600 | 700;
  fontStyle: "normal" | "italic";
  nativeFontName: string;
  hasEOL: boolean;
};

function mergeRuns(runs: NativeRun[]) {
  const merged: NativeRun[] = [];
  for (const run of runs) {
    const previous = merged[merged.length - 1];
    const sameLine = previous && Math.abs(previous.baselineY - run.baselineY) <= Math.max(1.5, run.fontSize * 0.12);
    const sameFont = previous && previous.nativeFontName === run.nativeFontName && Math.abs(previous.fontSize - run.fontSize) <= 0.7;
    const gap = previous ? run.x - (previous.x + previous.width) : Number.POSITIVE_INFINITY;
    if (previous && sameLine && sameFont && !previous.hasEOL && gap > -run.fontSize * 0.2 && gap < run.fontSize * 1.4) {
      const needsSpace = gap > run.fontSize * 0.16 && !previous.item.str.endsWith(" ") && !run.item.str.startsWith(" ");
      previous.item = { ...previous.item, str: `${previous.item.str}${needsSpace ? " " : ""}${run.item.str}` };
      previous.width = Math.max(previous.width, run.x + run.width - previous.x);
      previous.y = Math.min(previous.y, run.y);
      previous.height = Math.max(previous.height, run.y + run.height - previous.y);
      previous.hasEOL = run.hasEOL;
    } else {
      merged.push({ ...run, item: { ...run.item } });
    }
  }
  return merged;
}

export async function extractNativeEditableText({ pdf, page }: { pdf: PdfJsDoc; page: EditorPage }): Promise<OcrPageResult | null> {
  const inspection = await inspectPageTextMode(pdf, page);
  if (inspection.mode !== "native") return null;
  const proxy = inspection.proxy;
  // Rendering/getOperatorList ensures PDF.js has loaded embedded fonts into its
  // common object store and browser FontFace set before we reuse them.
  try { await proxy.getOperatorList(); } catch {}

  const base = proxy.getViewport({ scale: 1, rotation: page.rotation });
  const textContent = inspection.textContent;
  const styles = (textContent.styles || {}) as Record<string, PdfTextStyle>;
  const rawRuns: NativeRun[] = [];
  for (const raw of textContent.items || []) {
    if (typeof raw?.str !== "string" || !raw.str.trim()) continue;
    const item = raw as PdfTextItem;
    const tx = multiplyTransform(base.transform, item.transform);
    const fontSize = Math.max(1, Math.hypot(tx[2], tx[3]));
    const style = styles[item.fontName] || {};
    const font = getFontObject(proxy, item.fontName);
    const ascentRatio = Number.isFinite(style.ascent) ? Number(style.ascent) : 0.78;
    const descentRatio = Number.isFinite(style.descent) ? Math.abs(Number(style.descent)) : 0.2;
    const ascent = fontSize * ascentRatio;
    const descent = fontSize * descentRatio;
    const baselineY = tx[5];
    const y = baselineY - ascent;
    const width = Math.max(1, Math.abs(item.width));
    const height = Math.max(2, ascent + descent);
    const loadedName = font?.loadedName || item.fontName;
    const family = loadedName ? `"${loadedName}", ${style.fontFamily || "sans-serif"}` : (style.fontFamily || "sans-serif");

    rawRuns.push({
      item,
      x: tx[4],
      y,
      width,
      height,
      baselineY,
      fontSize,
      ascent,
      descent,
      fontFamily: family,
      fontWeight: weightFromFont(font),
      fontStyle: styleFromFont(font),
      nativeFontName: item.fontName,
      hasEOL: Boolean(item.hasEOL),
    });
  }

  const merged = mergeRuns(rawRuns);
  const words: OcrWord[] = merged.map((run, index) => {
    const typographyBase: OcrTypography = {
      fontFamily: run.fontFamily,
      fontWeight: run.fontWeight,
      fontStyle: run.fontStyle,
      fontSize: run.fontSize,
      lineHeight: run.height,
      baselineY: run.baselineY,
      ascent: run.ascent,
      descent: run.descent,
      letterSpacing: 0,
      scaleX: 1,
      source: "native",
    };
    const measured = measureOcrText(run.item.str, typographyBase);
    const scaleCorrection = run.width / Math.max(1, measured.naturalWidth);
    const typography = { ...typographyBase, scaleX: clamp(scaleCorrection, 0.9, 1.1) };

    return {
      id: uid("native"),
      pageId: page.id,
      text: run.item.str,
      originalText: run.item.str,
      edited: false,
      confidence: 100,
      x: run.x,
      y: run.y,
      width: run.width,
      height: run.height,
      lineKey: `native_${index}`,
      source: "native-pdf" as const,
      nativeFontName: run.nativeFontName,
      // Appearance and cleanup pixels are sampled lazily from the already-rendered
      // page canvas only when this run is actually edited.
      backgroundColor: "#ffffff",
      textColor: "#111111",
      typography,
    };
  });

  return {
    pageId: page.id,
    language: "native",
    mode: "native",
    text: words.map((word) => word.text).join(" "),
    words,
    recognizedAt: Date.now(),
  };
}
