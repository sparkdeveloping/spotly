export type EditorTool = "select" | "text" | "highlight" | "rect" | "ellipse" | "draw" | "image";

export type EditorPage = {
  id: string;
  sourceIndex: number;
  rotation: 0 | 90 | 180 | 270;
  label: string;
};

export type Point = { x: number; y: number };

export type Annotation = {
  id: string;
  pageId: string;
  type: "text" | "highlight" | "rect" | "ellipse" | "draw" | "image";
  x: number;
  y: number;
  width: number;
  height: number;
  color: string;
  opacity: number;
  strokeWidth: number;
  fontSize: number;
  text?: string;
  points?: Point[];
  dataUrl?: string;
};

export type EditableTextSource = "native-pdf" | "scan-ocr";

export type OcrTypography = {
  /** CSS font stack / PDF.js loaded font used by both editing and export. */
  fontFamily: string;
  fontWeight: 400 | 500 | 600 | 700;
  fontStyle: "normal" | "italic";
  /** Font size in the editor's scale=1 page coordinate space. */
  fontSize: number;
  lineHeight: number;
  /** Absolute baseline Y in page viewport coordinates. */
  baselineY: number;
  ascent: number;
  descent: number;
  letterSpacing: number;
  /** Small horizontal correction only. */
  scaleX: number;
  source: "native" | "tesseract" | "visual" | "fallback";
};

export type BackgroundPatch = {
  /** PNG patch synthesized from the pixels surrounding the original text. */
  dataUrl: string;
  x: number;
  y: number;
  width: number;
  height: number;
};

export type OcrWord = {
  id: string;
  pageId: string;
  text: string;
  originalText: string;
  edited: boolean;
  confidence: number;
  x: number;
  y: number;
  width: number;
  height: number;
  lineKey: string;
  source: EditableTextSource;
  /** PDF.js internal font object name, when this came from real PDF text. */
  nativeFontName?: string;
  backgroundColor?: string;
  textColor?: string;
  backgroundPatch?: BackgroundPatch;
  typography: OcrTypography;
};

export type OcrPageResult = {
  pageId: string;
  /** "native" means OCR was intentionally bypassed. */
  language: string;
  mode: "native" | "scan" | "mixed";
  text: string;
  words: OcrWord[];
  recognizedAt: number;
};

export type EditorSnapshot = {
  pages: EditorPage[];
  annotations: Annotation[];
  ocrResults: OcrPageResult[];
};
