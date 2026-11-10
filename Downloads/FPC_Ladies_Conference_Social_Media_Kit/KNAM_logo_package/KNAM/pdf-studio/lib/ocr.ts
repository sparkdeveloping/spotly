import type { EditorPage, OcrPageResult, OcrTypography, OcrWord } from "@/lib/types";
import { sampleTextAppearance } from "@/lib/text-pixels";

export const OCR_RENDER_SCALE = 2.2;
const OCR_MAX_PIXELS = 4_500_000;

export const OCR_LANGUAGES = [
  { code: "eng", label: "English" },
  { code: "spa", label: "Spanish" },
  { code: "fra", label: "French" },
  { code: "deu", label: "German" },
  { code: "ita", label: "Italian" },
  { code: "por", label: "Portuguese" },
  { code: "nld", label: "Dutch" },
  { code: "pol", label: "Polish" },
  { code: "rus", label: "Russian" },
  { code: "ukr", label: "Ukrainian" },
  { code: "ara", label: "Arabic" },
  { code: "hin", label: "Hindi" },
  { code: "jpn", label: "Japanese" },
  { code: "kor", label: "Korean" },
  { code: "chi_sim", label: "Chinese (Simplified)" },
  { code: "chi_tra", label: "Chinese (Traditional)" },
];

type PdfJsDoc = { getPage: (pageNumber: number) => Promise<any> };

type Box = { x0: number; y0: number; x1: number; y1: number };
type TesseractWord = {
  text?: string;
  confidence?: number;
  bbox?: Box;
  font_name?: string;
};
type TesseractLine = {
  text?: string;
  words?: TesseractWord[];
  bbox?: Box;
  baseline?: { x0?: number; y0?: number; x1?: number; y1?: number };
  rowAttributes?: { ascenders?: number; descenders?: number; rowHeight?: number };
};
type TesseractBlock = { paragraphs?: Array<{ lines?: TesseractLine[] }> };

type Appearance = {
  backgroundColor: string;
  textColor: string;
  inkCoverage: number;
};

const FONT_CANDIDATES = [
  { family: 'Arial, Helvetica, sans-serif', kind: "sans" },
  { family: '"Calibri", "Segoe UI", Arial, sans-serif', kind: "sans" },
  { family: '"Segoe UI", Arial, sans-serif', kind: "sans" },
  { family: 'Verdana, Arial, sans-serif', kind: "sans" },
  { family: 'Tahoma, Arial, sans-serif', kind: "sans" },
  { family: '"Trebuchet MS", Arial, sans-serif', kind: "sans" },
  { family: '"Times New Roman", Times, serif', kind: "serif" },
  { family: 'Georgia, "Times New Roman", serif', kind: "serif" },
  { family: 'Cambria, Georgia, "Times New Roman", serif', kind: "serif" },
  { family: 'Garamond, Georgia, "Times New Roman", serif', kind: "serif" },
  { family: '"Courier New", Courier, monospace', kind: "mono" },
] as const;

let measureCanvas: HTMLCanvasElement | null = null;
function measureContext() {
  if (typeof document === "undefined") return null;
  if (!measureCanvas) measureCanvas = document.createElement("canvas");
  return measureCanvas.getContext("2d");
}

export async function renderPageForOcr(pdf: PdfJsDoc, page: EditorPage) {
  const proxy = await pdf.getPage(page.sourceIndex + 1);
  const base = proxy.getViewport({ scale: 1, rotation: page.rotation });
  const pageArea = Math.max(1, base.width * base.height);
  const pixelCappedScale = Math.sqrt(OCR_MAX_PIXELS / pageArea);
  const scale = Math.max(1, Math.min(OCR_RENDER_SCALE, pixelCappedScale));
  const viewport = proxy.getViewport({ scale, rotation: page.rotation });
  const canvas = document.createElement("canvas");
  canvas.width = Math.max(1, Math.ceil(viewport.width));
  canvas.height = Math.max(1, Math.ceil(viewport.height));
  const context = canvas.getContext("2d", { alpha: false });
  if (!context) throw new Error("Could not create an OCR rendering canvas.");
  context.fillStyle = "#ffffff";
  context.fillRect(0, 0, canvas.width, canvas.height);
  await proxy.render({ canvasContext: context, viewport }).promise;
  return { canvas, baseWidth: base.width, baseHeight: base.height, scale };
}

function clamp(value: number, min: number, max: number) {
  return Math.min(max, Math.max(min, value));
}

function median(values: number[]) {
  if (!values.length) return 0;
  const sorted = [...values].sort((a, b) => a - b);
  const middle = Math.floor(sorted.length / 2);
  return sorted.length % 2 ? sorted[middle] : (sorted[middle - 1] + sorted[middle]) / 2;
}

function sampleAppearance(canvas: HTMLCanvasElement | undefined, left: number, top: number, width: number, height: number): Appearance {
  return sampleTextAppearance(canvas, left, top, width, height);
}

function typographyFontString(typography: Pick<OcrTypography, "fontFamily" | "fontWeight" | "fontStyle" | "fontSize">, size = typography.fontSize) {
  return `${typography.fontStyle} ${typography.fontWeight} ${Math.max(1, size)}px ${typography.fontFamily}`;
}

export function ocrCssFont(typography: OcrTypography, size = typography.fontSize) {
  return typographyFontString(typography, size);
}

function textMetrics(text: string, fontFamily: string, fontWeight: number, fontStyle: "normal" | "italic", fontSize: number) {
  const context = measureContext();
  if (!context) {
    return {
      width: Math.max(1, text.length) * fontSize * 0.52,
      ascent: fontSize * 0.78,
      descent: fontSize * 0.2,
    };
  }
  context.font = `${fontStyle} ${fontWeight} ${fontSize}px ${fontFamily}`;
  const metrics = context.measureText(text || "M");
  const ascent = metrics.actualBoundingBoxAscent || fontSize * 0.78;
  const descent = metrics.actualBoundingBoxDescent || fontSize * 0.2;
  return { width: metrics.width, ascent, descent };
}

export function measureOcrText(text: string, typography: OcrTypography) {
  const metrics = textMetrics(text || " ", typography.fontFamily, typography.fontWeight, typography.fontStyle, typography.fontSize);
  const spacing = Math.max(0, (text.length - 1)) * typography.letterSpacing;
  const naturalWidth = Math.max(1, metrics.width + spacing);
  return {
    naturalWidth,
    width: naturalWidth * typography.scaleX,
    ascent: metrics.ascent,
    descent: metrics.descent,
    height: metrics.ascent + metrics.descent,
  };
}

function normalizedFontName(raw?: string) {
  return (raw || "").replace(/[_-]+/g, " ").replace(/\s+/g, " ").trim();
}

function fontStyleFromName(normalized: string) {
  const lower = normalized.toLocaleLowerCase();
  const fontWeight: 400 | 500 | 600 | 700 = /black|heavy|extra\s*bold|bold/.test(lower)
    ? 700
    : /semi\s*bold|demi/.test(lower)
      ? 600
      : /medium/.test(lower)
        ? 500
        : 400;
  const fontStyle: "normal" | "italic" = /italic|oblique/.test(lower) ? "italic" : "normal";
  return { fontWeight, fontStyle };
}

function stripStyleTokens(normalized: string) {
  return normalized
    .replace(/\b(regular|roman|book|normal|medium|semi\s*bold|semibold|demi|extra\s*bold|extrabold|bold|black|heavy|italic|oblique)\b/gi, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function quotedFamily(name: string) {
  return `"${name.replace(/"/g, "")}"`;
}

function fontFromTesseract(raw?: string) {
  const normalized = normalizedFontName(raw);
  if (!normalized) return null;
  const lower = normalized.toLocaleLowerCase();
  const { fontWeight, fontStyle } = fontStyleFromName(normalized);

  if (/courier|mono|typewriter/.test(lower)) return { fontFamily: '"Courier New", Courier, monospace', fontWeight, fontStyle };
  if (/times/.test(lower)) return { fontFamily: '"Times New Roman", Times, serif', fontWeight, fontStyle };
  if (/cambria/.test(lower)) return { fontFamily: 'Cambria, Georgia, "Times New Roman", serif', fontWeight, fontStyle };
  if (/georgia/.test(lower)) return { fontFamily: 'Georgia, "Times New Roman", serif', fontWeight, fontStyle };
  if (/garamond/.test(lower)) return { fontFamily: 'Garamond, Georgia, "Times New Roman", serif', fontWeight, fontStyle };
  if (/baskerville/.test(lower)) return { fontFamily: 'Baskerville, Georgia, "Times New Roman", serif', fontWeight, fontStyle };
  if (/palatino/.test(lower)) return { fontFamily: '"Palatino Linotype", Palatino, Georgia, serif', fontWeight, fontStyle };
  if (/bookman/.test(lower)) return { fontFamily: '"Bookman Old Style", Georgia, serif', fontWeight, fontStyle };
  if (/verdana/.test(lower)) return { fontFamily: 'Verdana, Arial, sans-serif', fontWeight, fontStyle };
  if (/tahoma/.test(lower)) return { fontFamily: 'Tahoma, Arial, sans-serif', fontWeight, fontStyle };
  if (/trebuchet/.test(lower)) return { fontFamily: '"Trebuchet MS", Arial, sans-serif', fontWeight, fontStyle };
  if (/calibri/.test(lower)) return { fontFamily: 'Calibri, "Segoe UI", Arial, sans-serif', fontWeight, fontStyle };
  if (/segoe/.test(lower)) return { fontFamily: '"Segoe UI", Arial, sans-serif', fontWeight, fontStyle };
  if (/roboto/.test(lower)) return { fontFamily: 'Roboto, Arial, sans-serif', fontWeight, fontStyle };
  if (/open\s+sans/.test(lower)) return { fontFamily: '"Open Sans", Arial, sans-serif', fontWeight, fontStyle };
  if (/noto\s+sans/.test(lower)) return { fontFamily: '"Noto Sans", Arial, sans-serif', fontWeight, fontStyle };
  if (/arial/.test(lower)) return { fontFamily: 'Arial, Helvetica, sans-serif', fontWeight, fontStyle };
  if (/helvetica/.test(lower)) return { fontFamily: 'Helvetica, Arial, sans-serif', fontWeight, fontStyle };

  // Tesseract sometimes returns a usable family name that is not in our map.
  // Preserve it rather than silently replacing it with Arial. A generic stack
  // remains as a fallback if the font is not installed on the user's system.
  const family = stripStyleTokens(normalized);
  if (family && !/^serif$|^sans$|^font$/i.test(family)) {
    const generic = /serif/i.test(normalized) ? "serif" : "sans-serif";
    return { fontFamily: `${quotedFamily(family)}, ${generic}`, fontWeight, fontStyle };
  }
  if (/serif/.test(lower)) return { fontFamily: '"Times New Roman", Times, serif', fontWeight, fontStyle };
  if (/sans/.test(lower)) return { fontFamily: 'Arial, Helvetica, sans-serif', fontWeight, fontStyle };
  return null;
}

function chooseVisualWeight(coverageValues: number[]): 400 | 700 {
  // Be deliberately conservative. Coverage varies a lot with letters such as
  // "m" vs "i"; guessing 500/600 produced a visibly wrong pasted-label look.
  // Use bold only when a line has consistently high ink density.
  const values = coverageValues.filter(Number.isFinite);
  if (!values.length) return 400;
  const coverage = median(values);
  const strong = values.filter((value) => value >= 0.39).length / values.length;
  return coverage >= 0.36 && strong >= 0.45 ? 700 : 400;
}

function representativeWords(words: TesseractWord[]) {
  return words
    .filter((word) => (word.text || "").replace(/[^\p{L}\p{N}]/gu, "").length >= 2 && word.bbox)
    .sort((a, b) => (b.text?.length || 0) - (a.text?.length || 0))
    .slice(0, 4);
}

function chooseVisualFont(words: TesseractWord[], weight: number, style: "normal" | "italic") {
  const reps = representativeWords(words);
  if (!reps.length) return 'Arial, Helvetica, sans-serif';

  let bestFamily: string = FONT_CANDIDATES[0].family;
  let bestScore = Number.POSITIVE_INFINITY;
  for (const candidate of FONT_CANDIDATES) {
    const scores: number[] = [];
    for (const word of reps) {
      const text = word.text || "";
      const box = word.bbox!;
      const targetWidth = Math.max(1, box.x1 - box.x0);
      const targetHeight = Math.max(1, box.y1 - box.y0);
      const metrics = textMetrics(text, candidate.family, weight, style, 100);
      const glyphHeight = Math.max(1, metrics.ascent + metrics.descent);
      const targetRatio = targetWidth / targetHeight;
      const candidateRatio = metrics.width / glyphHeight;
      scores.push(Math.abs(Math.log(Math.max(0.05, targetRatio) / Math.max(0.05, candidateRatio))));
    }
    const score = median(scores);
    if (score < bestScore) {
      bestScore = score;
      bestFamily = candidate.family;
    }
  }
  return bestFamily;
}

function inferLineTypography({
  line,
  canvas,
  scaleX,
  scaleY,
}: {
  line: TesseractLine;
  canvas?: HTMLCanvasElement;
  scaleX: number;
  scaleY: number;
}) {
  const words = line.words || [];

  // Tesseract's font metadata is cheap to consume. Avoid probing many raster
  // word boxes here; appearance is sampled once for the final editable line.
  const tesseractStyle = words.map((word) => fontFromTesseract(word.font_name)).find(Boolean) || null;
  const fontWeight = tesseractStyle?.fontWeight ?? 400;
  const fontStyle = tesseractStyle?.fontStyle ?? "normal";
  const fontFamily = tesseractStyle?.fontFamily ?? chooseVisualFont(words, fontWeight, fontStyle);

  const rowHeightImage = Number(line.rowAttributes?.rowHeight);
  const measuredLineHeight = Math.max(1, ((line.bbox?.y1 || 0) - (line.bbox?.y0 || 0)) * scaleY);
  const rowHeight = Number.isFinite(rowHeightImage) && rowHeightImage > 0
    ? rowHeightImage * scaleY
    : measuredLineHeight;

  // Tesseract's rowHeight is x-height + ascenders - descenders. Tesseract itself
  // uses this row metric to derive point size; individual word boxes are not a
  // stable font-size metric because "ace" and "Hgj" naturally have different
  // visible heights in the same font. Since our OCR canvas is rendered directly
  // from PDF points, converting rowHeight back to page coordinates gives the
  // correct primary size estimate for the fixed-layout overlay.
  let fontSize = rowHeight;

  // Keep a word-bbox estimate only as a guard for malformed/missing row metrics.
  // It must never drive ordinary lines, which was the source of size jitter.
  const bboxSizes: number[] = [];
  for (const word of representativeWords(words)) {
    const b = word.bbox!;
    const targetHeight = Math.max(1, (b.y1 - b.y0) * scaleY);
    const metrics100 = textMetrics(word.text || "M", fontFamily, fontWeight, fontStyle, 100);
    const measuredHeight = Math.max(1, metrics100.ascent + metrics100.descent);
    bboxSizes.push((targetHeight / measuredHeight) * 100);
  }
  const bboxEstimate = bboxSizes.length ? median(bboxSizes) : 0;
  if (!(Number.isFinite(rowHeightImage) && rowHeightImage > 0) && bboxEstimate > 0) {
    fontSize = bboxEstimate;
  } else if (bboxEstimate > 0 && (fontSize > bboxEstimate * 1.65 || fontSize < bboxEstimate * 0.72)) {
    // Corrupt row metadata: fall back instead of rendering an obviously absurd size.
    fontSize = bboxEstimate;
  }
  fontSize = clamp(fontSize, 3, Math.max(5, measuredLineHeight * 1.55));

  return {
    fontFamily,
    fontWeight,
    fontStyle,
    fontSize,
    lineHeight: Math.max(rowHeight, fontSize),
    source: tesseractStyle ? "tesseract" as const : "visual" as const,
  };
}

function lineBaselineAt(line: TesseractLine, xImage: number, scaleY: number) {
  const baseline = line.baseline;
  const x0 = Number(baseline?.x0);
  const x1 = Number(baseline?.x1);
  const y0 = Number(baseline?.y0);
  const y1 = Number(baseline?.y1);
  if ([x0, x1, y0, y1].every(Number.isFinite) && Math.abs(x1 - x0) > 0.001) {
    const t = (xImage - x0) / (x1 - x0);
    return (y0 + (y1 - y0) * t) * scaleY;
  }
  if (Number.isFinite(y0)) return y0 * scaleY;
  return null;
}

function makeTypographyForWord({
  line,
  word,
  lineStyle,
  scaleX,
  scaleY,
}: {
  line: TesseractLine;
  word: TesseractWord;
  lineStyle: ReturnType<typeof inferLineTypography>;
  scaleX: number;
  scaleY: number;
}): OcrTypography {
  const b = word.bbox!;
  const text = word.text || "";
  const metrics = textMetrics(text || "M", lineStyle.fontFamily, lineStyle.fontWeight, lineStyle.fontStyle, lineStyle.fontSize);
  const targetWidth = Math.max(1, (b.x1 - b.x0) * scaleX);
  const charGaps = Math.max(0, text.length - 1);
  const desiredSpacing = charGaps ? (targetWidth - metrics.width) / charGaps : 0;
  const letterSpacing = clamp(desiredSpacing, -lineStyle.fontSize * 0.055, lineStyle.fontSize * 0.09);
  const withTracking = Math.max(1, metrics.width + charGaps * letterSpacing);
  const scaleCorrection = targetWidth / withTracking;
  // Glyph distortion is deliberately tightly bounded. The old implementation
  // used arbitrary scaleX down to 0.45, which made text visibly unlike the scan.
  const horizontalScale = clamp(scaleCorrection, 0.94, 1.06);

  const xCenterImage = (b.x0 + b.x1) / 2;
  const baseline = lineBaselineAt(line, xCenterImage, scaleY);
  const baselineY = baseline ?? (b.y1 * scaleY - Math.max(0, metrics.descent * 0.12));

  return {
    fontFamily: lineStyle.fontFamily,
    fontWeight: lineStyle.fontWeight,
    fontStyle: lineStyle.fontStyle,
    fontSize: lineStyle.fontSize,
    lineHeight: lineStyle.lineHeight,
    baselineY,
    ascent: metrics.ascent,
    descent: metrics.descent,
    letterSpacing,
    scaleX: horizontalScale,
    source: lineStyle.source,
  };
}

export function parseBlockWords({
  blocks,
  pageId,
  canvasWidth,
  canvasHeight,
  baseWidth,
  baseHeight,
  canvas,
}: {
  blocks: TesseractBlock[] | null | undefined;
  pageId: string;
  canvasWidth: number;
  canvasHeight: number;
  baseWidth: number;
  baseHeight: number;
  canvas?: HTMLCanvasElement;
}): OcrWord[] {
  if (!blocks?.length) return [];
  const scaleX = baseWidth / Math.max(1, canvasWidth);
  const scaleY = baseHeight / Math.max(1, canvasHeight);
  const output: OcrWord[] = [];
  let lineCounter = 0;

  blocks.forEach((block, blockIndex) => {
    block.paragraphs?.forEach((paragraph, paragraphIndex) => {
      paragraph.lines?.forEach((line, lineIndex) => {
        const words = (line.words || []).filter((word) => word.bbox && (word.text || "").trim());
        if (!words.length) return;
        const lineStyle = inferLineTypography({ line: { ...line, words }, canvas, scaleX, scaleY });
        const lineKey = `${blockIndex}:${paragraphIndex}:${lineIndex}`;
        const boxes = words.map((word) => word.bbox!);
        const box = line.bbox || {
          x0: Math.min(...boxes.map((b) => b.x0)),
          y0: Math.min(...boxes.map((b) => b.y0)),
          x1: Math.max(...boxes.map((b) => b.x1)),
          y1: Math.max(...boxes.map((b) => b.y1)),
        };
        const text = (line.text || words.map((word) => (word.text || "").trim()).join(" ")).trim();
        if (!text) return;
        const width = Math.max(1, box.x1 - box.x0);
        const height = Math.max(1, box.y1 - box.y0);
        const appearance = sampleAppearance(canvas, box.x0, box.y0, width, height);
        const syntheticWord: TesseractWord = {
          text,
          bbox: box,
          confidence: median(words.map((word) => Number(word.confidence) || 0)),
          font_name: words.map((word) => word.font_name).find(Boolean),
        };

        output.push({
          id: `ocr_${pageId}_line_${lineCounter++}`,
          pageId,
          text,
          originalText: text,
          edited: false,
          confidence: Number(syntheticWord.confidence) || 0,
          x: box.x0 * scaleX,
          y: box.y0 * scaleY,
          width: width * scaleX,
          height: height * scaleY,
          lineKey,
          source: "scan-ocr",
          backgroundColor: appearance.backgroundColor,
          textColor: appearance.textColor,
          typography: makeTypographyForWord({ line, word: syntheticWord, lineStyle, scaleX, scaleY }),
        });
      });
    });
  });

  return output;
}

/** TSV fallback. It intentionally emits one editable object per OCR line, not
 * one object per word. Reconstructing a full line avoids the pasted-label look
 * caused by replacing a single raster word with synthetic browser text. */
export function parseTsvWords({
  tsv,
  pageId,
  canvasWidth,
  canvasHeight,
  baseWidth,
  baseHeight,
  canvas,
}: {
  tsv: string;
  pageId: string;
  canvasWidth: number;
  canvasHeight: number;
  baseWidth: number;
  baseHeight: number;
  canvas?: HTMLCanvasElement;
}): OcrWord[] {
  if (!tsv) return [];
  const scaleX = baseWidth / Math.max(1, canvasWidth);
  const scaleY = baseHeight / Math.max(1, canvasHeight);
  const lines = tsv.split(/\r?\n/);
  const raw: Array<{ text: string; left: number; top: number; width: number; height: number; confidence: number; lineKey: string }> = [];

  for (let index = 1; index < lines.length; index++) {
    const columns = lines[index].split("\t");
    if (columns.length < 12 || columns[0] !== "5") continue;
    const text = columns.slice(11).join("\t").trim();
    if (!text) continue;
    const left = Number(columns[6]);
    const top = Number(columns[7]);
    const width = Number(columns[8]);
    const height = Number(columns[9]);
    const confidence = Number(columns[10]);
    if (![left, top, width, height].every(Number.isFinite) || width <= 0 || height <= 0) continue;
    raw.push({
      text,
      left,
      top,
      width,
      height,
      confidence,
      lineKey: `${columns[2] || 0}:${columns[3] || 0}:${columns[4] || 0}`,
    });
  }

  const byLine = new Map<string, typeof raw>();
  raw.forEach((word) => {
    if (!byLine.has(word.lineKey)) byLine.set(word.lineKey, []);
    byLine.get(word.lineKey)!.push(word);
  });

  return Array.from(byLine.entries()).map(([lineKey, lineWords], lineIndex) => {
    lineWords.sort((a, b) => a.left - b.left);
    const left = Math.min(...lineWords.map((word) => word.left));
    const top = Math.min(...lineWords.map((word) => word.top));
    const right = Math.max(...lineWords.map((word) => word.left + word.width));
    const bottom = Math.max(...lineWords.map((word) => word.top + word.height));
    const width = right - left;
    const height = bottom - top;
    const text = lineWords.map((word) => word.text).join(" ");
    const appearance = sampleAppearance(canvas, left, top, width, height);
    const fontWeight: 400 = 400;
    const fontFamily = 'Arial, Helvetica, sans-serif';
    const fontSize = Math.max(4, median(lineWords.map((item) => item.height * scaleY)) * 1.03);
    const metrics = textMetrics(text, fontFamily, fontWeight, "normal", fontSize);
    const targetWidth = width * scaleX;
    const charGaps = Math.max(0, text.length - 1);
    const letterSpacing = charGaps ? clamp((targetWidth - metrics.width) / charGaps, -fontSize * 0.05, fontSize * 0.08) : 0;
    const scaleCorrection = targetWidth / Math.max(1, metrics.width + charGaps * letterSpacing);
    return {
      id: `ocr_${pageId}_line_${lineIndex}`,
      pageId,
      text,
      originalText: text,
      edited: false,
      confidence: median(lineWords.map((word) => Number.isFinite(word.confidence) ? word.confidence : 0)),
      x: left * scaleX,
      y: top * scaleY,
      width: targetWidth,
      height: height * scaleY,
      lineKey,
      source: "scan-ocr" as const,
      backgroundColor: appearance.backgroundColor,
      textColor: appearance.textColor,
      typography: {
        fontFamily,
        fontWeight,
        fontStyle: "normal" as const,
        fontSize,
        lineHeight: Math.max(height * scaleY, fontSize),
        baselineY: bottom * scaleY - metrics.descent * 0.12,
        ascent: metrics.ascent,
        descent: metrics.descent,
        letterSpacing,
        scaleX: clamp(scaleCorrection, 0.94, 1.06),
        source: "fallback" as const,
      },
    };
  });
}

export function ocrTextFromWords(words: OcrWord[]) {
  const lineOrder: string[] = [];
  const lines = new Map<string, OcrWord[]>();
  for (const word of words) {
    if (!lines.has(word.lineKey)) {
      lines.set(word.lineKey, []);
      lineOrder.push(word.lineKey);
    }
    lines.get(word.lineKey)!.push(word);
  }
  return lineOrder
    .map((key) => lines.get(key)!.sort((a, b) => a.x - b.x).map((word) => word.text).filter(Boolean).join(" "))
    .filter(Boolean)
    .join("\n");
}

export function makeOcrResult({
  page,
  language,
  text,
  words,
}: {
  page: EditorPage;
  language: string;
  text: string;
  words: OcrWord[];
}): OcrPageResult {
  return {
    pageId: page.id,
    language,
    mode: "scan",
    text: text.trim() || ocrTextFromWords(words),
    words,
    recognizedAt: Date.now(),
  };
}
