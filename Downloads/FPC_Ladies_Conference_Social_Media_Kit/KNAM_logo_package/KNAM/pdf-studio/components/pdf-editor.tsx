"use client";

import { AnimatePresence, motion } from "motion/react";
import {
  Circle,
  Copy,
  Download,
  FilePlus2,
  Highlighter,
  ImagePlus,
  LoaderCircle,
  MousePointer2,
  PanelLeftClose,
  PanelLeftOpen,
  PanelRightClose,
  PanelRightOpen,
  PenLine,
  Pencil,
  Plus,
  Redo2,
  RotateCw,
  ScanText,
  Square,
  Trash2,
  Type,
  Undo2,
  Upload,
  ZoomIn,
  ZoomOut,
} from "lucide-react";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { PdfPage } from "@/components/pdf-page";
import { PageThumbnail } from "@/components/page-thumbnail";
import { OcrPanel } from "@/components/ocr-panel";
import { SignatureDialog } from "@/components/signature-dialog";
import { exportEditedPdf } from "@/lib/export-pdf";
import { makeOcrResult, ocrTextFromWords, parseBlockWords, parseTsvWords, renderPageForOcr } from "@/lib/ocr";
import { extractNativeEditableText, inspectPageTextMode } from "@/lib/native-text";
import type { Annotation, EditorPage, EditorSnapshot, EditorTool, OcrPageResult, OcrWord } from "@/lib/types";
import { clamp, downloadBlob, fileToDataUrl, uid } from "@/lib/utils";

type PdfJsDocument = any;

function yieldToBrowser() {
  return new Promise<void>((resolve) => window.setTimeout(resolve, 0));
}


function overlapArea(a: { x: number; y: number; width: number; height: number }, b: { x: number; y: number; width: number; height: number }) {
  const left = Math.max(a.x, b.x);
  const top = Math.max(a.y, b.y);
  const right = Math.min(a.x + a.width, b.x + b.width);
  const bottom = Math.min(a.y + a.height, b.y + b.height);
  return Math.max(0, right - left) * Math.max(0, bottom - top);
}

function mergeMixedText(nativeResult: OcrPageResult, scanResult: OcrPageResult): OcrPageResult {
  const scanOnly = scanResult.words.filter((scan) => {
    const area = Math.max(1, scan.width * scan.height);
    const covered = nativeResult.words.reduce((sum, native) => sum + overlapArea(scan, native), 0);
    // OCR over real PDF text is a duplicate, not a separate editable object.
    return covered / area < 0.18 && scan.confidence >= 45;
  });
  const words = [...nativeResult.words, ...scanOnly].sort((a, b) => Math.abs(a.y - b.y) > 2 ? a.y - b.y : a.x - b.x);
  return {
    ...scanResult,
    mode: "mixed",
    text: ocrTextFromWords(words),
    words,
  };
}

const tools: Array<{ id: EditorTool; label: string; icon: typeof MousePointer2; shortcut?: string }> = [
  { id: "select", label: "Select", icon: MousePointer2, shortcut: "V" },
  { id: "text", label: "Text", icon: Type, shortcut: "T" },
  { id: "highlight", label: "Highlight", icon: Highlighter, shortcut: "H" },
  { id: "rect", label: "Rectangle", icon: Square, shortcut: "R" },
  { id: "ellipse", label: "Ellipse", icon: Circle, shortcut: "O" },
  { id: "draw", label: "Draw", icon: Pencil, shortcut: "P" },
];

export function PdfEditor() {
  const [pdf, setPdf] = useState<PdfJsDocument | null>(null);
  const [sourceBytes, setSourceBytes] = useState<Uint8Array | null>(null);
  const [filename, setFilename] = useState("document.pdf");
  const [pages, setPages] = useState<EditorPage[]>([]);
  const [annotations, setAnnotations] = useState<Annotation[]>([]);
  const [activePageId, setActivePageId] = useState<string | null>(null);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [tool, setTool] = useState<EditorTool>("select");
  const [zoom, setZoom] = useState(0.95);
  const [leftOpen, setLeftOpen] = useState(true);
  const [rightOpen, setRightOpen] = useState(true);
  const [past, setPast] = useState<EditorSnapshot[]>([]);
  const [future, setFuture] = useState<EditorSnapshot[]>([]);
  const [dragIndex, setDragIndex] = useState<number | null>(null);
  const [loading, setLoading] = useState(false);
  const [exporting, setExporting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [signatureOpen, setSignatureOpen] = useState(false);
  const [pendingImage, setPendingImage] = useState<string | null>(null);
  const [defaults, setDefaults] = useState({ color: "#2563eb", opacity: 1, strokeWidth: 2, fontSize: 18 });
  const [rightPanel, setRightPanel] = useState<"properties" | "ocr">("properties");
  const [ocrResults, setOcrResults] = useState<OcrPageResult[]>([]);
  const [ocrLanguage, setOcrLanguage] = useState("eng");
  const [ocrRunning, setOcrRunning] = useState(false);
  const [ocrProgress, setOcrProgress] = useState({ progress: 0, status: "", pageLabel: "" });
  const [ocrSearch, setOcrSearch] = useState("");
  const [ocrSelectable, setOcrSelectable] = useState(false);

  const fileInput = useRef<HTMLInputElement>(null);
  const imageInput = useRef<HTMLInputElement>(null);

  const activePage = pages.find((page) => page.id === activePageId) ?? pages[0] ?? null;
  const selected = annotations.find((annotation) => annotation.id === selectedId) ?? null;
  const pageAnnotations = activePage ? annotations.filter((annotation) => annotation.pageId === activePage.id) : [];
  const activeOcrResult = activePage ? ocrResults.find((result) => result.pageId === activePage.id) ?? null : null;
  const normalizedOcrSearch = ocrSearch.trim().toLocaleLowerCase();
  const ocrSearchTerms = useMemo(() => normalizedOcrSearch.split(/\s+/).filter(Boolean), [normalizedOcrSearch]);
  const ocrSearchHits = useMemo(() => {
    if (!ocrSearchTerms.length) return [];
    return pages.flatMap((page) => {
      const result = ocrResults.find((item) => item.pageId === page.id);
      if (!result) return [];
      const count = result.words.filter((word) => {
        const value = word.text.toLocaleLowerCase();
        return ocrSearchTerms.some((term) => value.includes(term));
      }).length;
      return count ? [{ pageId: page.id, label: page.label, count }] : [];
    });
  }, [ocrSearchTerms, ocrResults, pages]);

  const snapshot = useCallback((): EditorSnapshot => ({
    // Editor updates are immutable, so undo can retain structural references.
    // Deep-cloning OCR results here copied every PNG repair patch on each edit
    // and became another major source of main-thread stalls.
    pages,
    annotations,
    ocrResults,
  }), [pages, annotations, ocrResults]);

  const checkpoint = useCallback(() => {
    const current = snapshot();
    setPast((items) => [...items.slice(-49), current]);
    setFuture([]);
  }, [snapshot]);

  const undo = useCallback(() => {
    if (!past.length) return;
    const previous = past[past.length - 1];
    setPast((items) => items.slice(0, -1));
    setFuture((items) => [snapshot(), ...items].slice(0, 50));
    setPages(previous.pages);
    setAnnotations(previous.annotations);
    setOcrResults(previous.ocrResults);
    setSelectedId(null);
  }, [past, snapshot]);

  const redo = useCallback(() => {
    if (!future.length) return;
    const next = future[0];
    setFuture((items) => items.slice(1));
    setPast((items) => [...items.slice(-49), snapshot()]);
    setPages(next.pages);
    setAnnotations(next.annotations);
    setOcrResults(next.ocrResults);
    setSelectedId(null);
  }, [future, snapshot]);

  const openFile = useCallback(async (file: File) => {
    if (!file || file.type !== "application/pdf") {
      setError("Choose a PDF file.");
      return;
    }
    setLoading(true);
    setError(null);
    try {
      const bytes = new Uint8Array(await file.arrayBuffer());
      const pdfjs = await import("pdfjs-dist");
      pdfjs.GlobalWorkerOptions.workerSrc = "/pdf.worker.min.mjs";
      const task = pdfjs.getDocument({ data: bytes.slice() });
      const document = await task.promise;
      const loadedPages: EditorPage[] = [];
      for (let index = 0; index < document.numPages; index++) {
        const proxy = await document.getPage(index + 1);
        const normalizedRotation = (((proxy.rotate || 0) % 360) + 360) % 360 as 0 | 90 | 180 | 270;
        loadedPages.push({ id: uid("page"), sourceIndex: index, rotation: normalizedRotation, label: `Page ${index + 1}` });
      }
      setPdf(document);
      setSourceBytes(bytes);
      setFilename(file.name || "document.pdf");
      setPages(loadedPages);
      setAnnotations([]);
      setOcrResults([]);
      setOcrSearch("");
      setOcrSelectable(false);
      setActivePageId(loadedPages[0]?.id ?? null);
      setSelectedId(null);
      setPast([]);
      setFuture([]);
      setTool("select");
    } catch (cause) {
      console.error(cause);
      setError("This PDF could not be opened. Password-protected or damaged PDFs may need to be unlocked first.");
    } finally {
      setLoading(false);
    }
  }, []);

  const patchAnnotation = useCallback((id: string, patch: Partial<Annotation>) => {
    setAnnotations((items) => items.map((item) => item.id === id ? { ...item, ...patch } : item));
  }, []);

  const deleteSelected = useCallback(() => {
    if (!selectedId) return;
    checkpoint();
    setAnnotations((items) => items.filter((item) => item.id !== selectedId));
    setSelectedId(null);
  }, [selectedId, checkpoint]);

  const rotatePage = useCallback(async (pageId: string) => {
    const page = pages.find((item) => item.id === pageId);
    if (!page || !pdf) return;
    checkpoint();
    const nextRotation = ((page.rotation + 90) % 360) as 0 | 90 | 180 | 270;
    const proxy = await pdf.getPage(page.sourceIndex + 1);
    const oldViewport = proxy.getViewport({ scale: 1, rotation: page.rotation });
    const newViewport = proxy.getViewport({ scale: 1, rotation: nextRotation });

    const transformPoint = (x: number, y: number) => {
      const [pdfX, pdfY] = oldViewport.convertToPdfPoint(x, y);
      const [nextX, nextY] = newViewport.convertToViewportPoint(pdfX, pdfY);
      return { x: nextX, y: nextY };
    };

    setPages((items) => items.map((item) => item.id === pageId ? { ...item, rotation: nextRotation } : item));
    setAnnotations((items) => items.map((annotation) => {
      if (annotation.pageId !== pageId) return annotation;
      if (annotation.type === "draw" && annotation.points) {
        const points = annotation.points.map((point) => transformPoint(point.x, point.y));
        const xs = points.map((point) => point.x); const ys = points.map((point) => point.y);
        return { ...annotation, points, x: Math.min(...xs), y: Math.min(...ys), width: Math.max(...xs) - Math.min(...xs), height: Math.max(...ys) - Math.min(...ys) };
      }
      const a = transformPoint(annotation.x, annotation.y);
      const b = transformPoint(annotation.x + annotation.width, annotation.y + annotation.height);
      return { ...annotation, x: Math.min(a.x, b.x), y: Math.min(a.y, b.y), width: Math.abs(b.x - a.x), height: Math.abs(b.y - a.y) };
    }));
    setOcrResults((items) => items.filter((result) => result.pageId !== pageId));
  }, [pages, pdf, checkpoint]);

  const deletePage = useCallback((pageId: string) => {
    if (pages.length <= 1) return;
    checkpoint();
    const index = pages.findIndex((page) => page.id === pageId);
    const next = pages.filter((page) => page.id !== pageId);
    setPages(next);
    setAnnotations((items) => items.filter((item) => item.pageId !== pageId));
    setOcrResults((items) => items.filter((item) => item.pageId !== pageId));
    if (activePageId === pageId) setActivePageId(next[Math.min(index, next.length - 1)]?.id ?? null);
    setSelectedId(null);
  }, [pages, checkpoint, activePageId]);

  const duplicatePage = useCallback(() => {
    if (!activePage) return;
    checkpoint();
    const copyId = uid("page");
    const pageCopy: EditorPage = { ...activePage, id: copyId, label: `${activePage.label} copy` };
    const index = pages.findIndex((page) => page.id === activePage.id);
    setPages((items) => [...items.slice(0, index + 1), pageCopy, ...items.slice(index + 1)]);
    const copiedAnnotations = annotations
      .filter((annotation) => annotation.pageId === activePage.id)
      .map((annotation) => ({ ...structuredClone(annotation), id: uid("ann"), pageId: copyId }));
    setAnnotations((items) => [...items, ...copiedAnnotations]);
    const sourceOcr = ocrResults.find((result) => result.pageId === activePage.id);
    if (sourceOcr) {
      setOcrResults((items) => [...items, {
        ...structuredClone(sourceOcr),
        pageId: copyId,
        words: sourceOcr.words.map((word, index) => ({ ...word, id: `ocr_${copyId}_${index}`, pageId: copyId })),
      }]);
    }
    setActivePageId(copyId);
  }, [activePage, pages, annotations, ocrResults, checkpoint]);

  const movePage = useCallback((from: number, to: number) => {
    if (from === to) return;
    checkpoint();
    setPages((items) => {
      const next = [...items];
      const [moved] = next.splice(from, 1);
      next.splice(to, 0, moved);
      return next;
    });
  }, [checkpoint]);

  const recognizePages = useCallback(async (targetPages: EditorPage[]) => {
    if (!pdf || !targetPages.length || ocrRunning) return;
    checkpoint();
    setOcrRunning(true);
    setError(null);
    setOcrSelectable(false);
    let worker: any = null;
    let pageCursor = 0;
    let lastProgressPaint = 0;

    try {
      for (let index = 0; index < targetPages.length; index++) {
        pageCursor = index;
        const page = targetPages[index];
        setOcrProgress({ progress: index / targetPages.length, status: "Inspecting PDF text", pageLabel: page.label });
        await yieldToBrowser();

        // First choice: actual PDF text. This preserves the PDF's own embedded
        // font/metrics and avoids OCR on text that already exists as real content.
        const inspection = await inspectPageTextMode(pdf, page);
        const nativeResult = inspection.mode === "native" ? await extractNativeEditableText({ pdf, page }) : null;
        if (nativeResult?.words.length && !inspection.hasRasterImages) {
          setOcrResults((items) => [...items.filter((item) => item.pageId !== page.id), nativeResult]);
          setOcrProgress({
            progress: (index + 1) / targetPages.length,
            status: `${nativeResult.words.length} native text blocks · OCR skipped`,
            pageLabel: page.label,
          });
          await yieldToBrowser();
          continue;
        }

        // Scan/mixed path: OCR is semantic/layout analysis only. On mixed pages
        // we later discard OCR regions already covered by real PDF text.
        if (!worker) {
          const { createWorker } = await import("tesseract.js");
          worker = await createWorker(ocrLanguage, 1, {
            logger: (message: { status?: string; progress?: number }) => {
              const now = performance.now();
              const complete = typeof message.progress === "number" && message.progress >= 1;
              if (!complete && now - lastProgressPaint < 90) return;
              lastProgressPaint = now;
              const withinPage = typeof message.progress === "number" ? message.progress : 0;
              const overall = (pageCursor + withinPage) / targetPages.length;
              setOcrProgress((current) => ({
                ...current,
                progress: Math.min(0.99, overall),
                status: message.status || current.status || "Reconstructing scanned text",
              }));
            },
          });
          await worker.setParameters?.({
            hocr_font_info: "1",
            preserve_interword_spaces: "1",
          });
        }

        setOcrProgress({ progress: index / targetPages.length, status: "Rendering scan", pageLabel: page.label });
        const rendered = await renderPageForOcr(pdf, page);
        const response = await worker.recognize(rendered.canvas, {}, { text: true, blocks: true, tsv: true });
        const structuredLines = parseBlockWords({
          blocks: response.data.blocks,
          pageId: page.id,
          canvasWidth: rendered.canvas.width,
          canvasHeight: rendered.canvas.height,
          baseWidth: rendered.baseWidth,
          baseHeight: rendered.baseHeight,
          canvas: rendered.canvas,
        });
        const lines = structuredLines.length ? structuredLines : parseTsvWords({
          tsv: response.data.tsv || "",
          pageId: page.id,
          canvasWidth: rendered.canvas.width,
          canvasHeight: rendered.canvas.height,
          baseWidth: rendered.baseWidth,
          baseHeight: rendered.baseHeight,
          canvas: rendered.canvas,
        });
        const scanResult = makeOcrResult({ page, language: ocrLanguage, text: response.data.text || "", words: lines });
        const result = nativeResult?.words.length ? mergeMixedText(nativeResult, scanResult) : scanResult;
        setOcrResults((items) => [...items.filter((item) => item.pageId !== page.id), result]);
        const scanCount = result.words.filter((word) => word.source === "scan-ocr").length;
        const nativeCount = result.words.filter((word) => word.source === "native-pdf").length;
        setOcrProgress({
          progress: (index + 1) / targetPages.length,
          status: result.mode === "mixed"
            ? `${nativeCount} native blocks + ${scanCount} reconstructed scan lines`
            : `${scanCount} editable scan lines reconstructed`,
          pageLabel: page.label,
        });
        await yieldToBrowser();
      }
      setOcrSelectable(true);
    } catch (cause) {
      console.error(cause);
      setError("Text preparation failed. Native PDF text is handled locally; scanned pages may also need the OCR language model.");
    } finally {
      try { await worker?.terminate?.(); } catch {}
      setOcrRunning(false);
    }
  }, [pdf, ocrLanguage, ocrRunning, checkpoint]);

  const clearOcrPage = useCallback((pageId: string) => {
    checkpoint();
    setOcrResults((items) => items.filter((item) => item.pageId !== pageId));
    setOcrSelectable(false);
  }, [checkpoint]);

  const clearAllOcr = useCallback(() => {
    if (!ocrResults.length) return;
    checkpoint();
    setOcrResults([]);
    setOcrSelectable(false);
  }, [ocrResults.length, checkpoint]);

  const patchOcrWord = useCallback((pageId: string, wordId: string, patch: Partial<OcrWord>) => {
    setOcrResults((items) => items.map((result) => {
      if (result.pageId !== pageId) return result;
      const words = result.words.map((word) => {
        if (word.id !== wordId) return word;
        const next = { ...word, ...patch };
        return { ...next, edited: next.text !== next.originalText };
      });
      return { ...result, words, text: ocrTextFromWords(words) };
    }));
  }, []);

  const copyOcrText = useCallback(async () => {
    if (!activeOcrResult?.text) return;
    try {
      await navigator.clipboard.writeText(activeOcrResult.text);
    } catch {
      setError("Could not copy OCR text to the clipboard.");
    }
  }, [activeOcrResult]);

  const exportPdf = useCallback(async () => {
    if (!pdf || !sourceBytes || !pages.length) return;
    setExporting(true);
    setError(null);
    try {
      const bytes = await exportEditedPdf({ sourceBytes, pdfJsDocument: pdf, pages, annotations, ocrResults });
      const base = filename.replace(/\.pdf$/i, "") || "document";
      downloadBlob(bytes, `${base}-edited.pdf`);
    } catch (cause) {
      console.error(cause);
      setError("Export failed. Try removing a problematic image or reopening the PDF.");
    } finally {
      setExporting(false);
    }
  }, [pdf, sourceBytes, pages, annotations, ocrResults, filename]);

  useEffect(() => {
    const onKey = (event: KeyboardEvent) => {
      const target = event.target as HTMLElement | null;
      const typing = target?.tagName === "INPUT" || target?.tagName === "TEXTAREA" || target?.isContentEditable;
      const mod = event.metaKey || event.ctrlKey;
      if (mod && event.key.toLowerCase() === "z") {
        event.preventDefault();
        event.shiftKey ? redo() : undo();
      } else if (mod && event.key.toLowerCase() === "y") {
        event.preventDefault(); redo();
      } else if (!typing && (event.key === "Backspace" || event.key === "Delete")) {
        event.preventDefault(); deleteSelected();
      } else if (!typing && event.key === "Escape") {
        setTool("select"); setSelectedId(null); setPendingImage(null); setOcrSelectable(false);
      } else if (!typing && !mod) {
        const key = event.key.toLowerCase();
        const found = tools.find((item) => item.shortcut?.toLowerCase() === key);
        if (found) setTool(found.id);
      }
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [undo, redo, deleteSelected]);

  const inspectorPatch = (patch: Partial<Annotation>) => {
    if (!selected) return;
    checkpoint();
    patchAnnotation(selected.id, patch);
  };

  if (!pdf) {
    return (
      <div
        className="relative flex h-dvh items-center justify-center overflow-hidden bg-[#090a0c] p-6"
        onDragOver={(e) => e.preventDefault()}
        onDrop={(e) => { e.preventDefault(); const file = e.dataTransfer.files?.[0]; if (file) openFile(file); }}
      >
        <div className="pointer-events-none absolute inset-0 opacity-50 [background-image:radial-gradient(circle_at_50%_0%,rgba(59,130,246,.16),transparent_32%),linear-gradient(rgba(255,255,255,.025)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,.025)_1px,transparent_1px)] [background-size:auto,32px_32px,32px_32px]" />
        <motion.div initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} className="relative w-full max-w-xl rounded-3xl border border-white/10 bg-[#111318]/95 p-7 shadow-2xl shadow-black/50 backdrop-blur-xl">
          <div className="mb-8 flex items-center gap-3">
            <div className="grid h-10 w-10 place-items-center rounded-xl bg-blue-600 shadow-lg shadow-blue-600/20"><FilePlus2 size={20} /></div>
            <div><h1 className="text-lg font-semibold tracking-tight">PDF Studio</h1><p className="text-xs text-zinc-500">Private, browser-first PDF editing</p></div>
          </div>
          <button
            className="group flex min-h-[260px] w-full flex-col items-center justify-center rounded-2xl border border-dashed border-white/15 bg-white/[0.025] px-8 transition hover:border-blue-500/50 hover:bg-blue-500/[0.04]"
            onClick={() => fileInput.current?.click()}
          >
            <div className="mb-4 grid h-14 w-14 place-items-center rounded-2xl border border-white/10 bg-white/[0.04] text-zinc-300 transition group-hover:scale-105 group-hover:text-white"><Upload size={24} /></div>
            <div className="text-sm font-medium">Drop a PDF here or click to open</div>
            <div className="mt-2 max-w-sm text-center text-xs leading-5 text-zinc-500">The document stays in your browser. Edit pages, add text, markup, drawings, images and signatures, then export a new PDF.</div>
          </button>
          <input ref={fileInput} type="file" accept="application/pdf" className="hidden" onChange={(e) => { const file = e.target.files?.[0]; if (file) openFile(file); e.currentTarget.value = ""; }} />
          {loading && <div className="mt-4 flex items-center justify-center gap-2 text-xs text-zinc-400"><LoaderCircle size={14} className="animate-spin" /> Opening PDF…</div>}
          {error && <div className="mt-4 rounded-xl border border-red-500/20 bg-red-500/10 p-3 text-xs text-red-300">{error}</div>}
          <div className="mt-5 flex items-center justify-between text-[11px] text-zinc-600"><span>Next.js · Tailwind · Motion</span><span>PDF.js + pdf-lib</span></div>
        </motion.div>
      </div>
    );
  }

  return (
    <div className="flex h-dvh flex-col bg-[#0a0b0d] text-zinc-100" onDragOver={(e) => e.preventDefault()} onDrop={(e) => { const file = e.dataTransfer.files?.[0]; if (file?.type === "application/pdf") { e.preventDefault(); openFile(file); } }}>
      <header className="z-30 flex h-14 shrink-0 items-center border-b border-white/8 bg-[#0f1115]/95 px-3 backdrop-blur-xl">
        <div className="flex min-w-0 items-center gap-2">
          <button className="grid h-8 w-8 place-items-center rounded-lg bg-blue-600"><FilePlus2 size={16} /></button>
          <div className="min-w-0">
            <div className="max-w-[240px] truncate text-sm font-medium">{filename}</div>
            <div className="text-[10px] text-zinc-600">{pages.length} page{pages.length === 1 ? "" : "s"} · local editing</div>
          </div>
        </div>

        <div className="mx-auto hidden items-center gap-1 rounded-xl border border-white/8 bg-white/[0.025] p-1 md:flex">
          {tools.map(({ id, label, icon: Icon, shortcut }) => (
            <button key={id} title={`${label}${shortcut ? ` (${shortcut})` : ""}`} onClick={() => { setTool(id); setPendingImage(null); setOcrSelectable(false); }} className={`grid h-8 w-8 place-items-center rounded-lg transition ${tool === id ? "bg-white text-black shadow" : "text-zinc-500 hover:bg-white/5 hover:text-zinc-200"}`}><Icon size={15} /></button>
          ))}
          <div className="mx-1 h-5 w-px bg-white/8" />
          <button title="Insert image" onClick={() => imageInput.current?.click()} className={`grid h-8 w-8 place-items-center rounded-lg text-zinc-500 transition hover:bg-white/5 hover:text-zinc-200 ${tool === "image" && pendingImage ? "bg-white text-black" : ""}`}><ImagePlus size={15} /></button>
          <button title="Signature" onClick={() => setSignatureOpen(true)} className="grid h-8 w-8 place-items-center rounded-lg text-zinc-500 transition hover:bg-white/5 hover:text-zinc-200"><PenLine size={15} /></button>
          <div className="mx-1 h-5 w-px bg-white/8" />
          <button title="Text preparation" onClick={() => { setRightPanel("ocr"); setRightOpen(true); setSelectedId(null); }} className={`grid h-8 w-8 place-items-center rounded-lg transition ${rightOpen && rightPanel === "ocr" ? "bg-blue-500/15 text-blue-300" : "text-zinc-500 hover:bg-white/5 hover:text-zinc-200"}`}><ScanText size={15} /></button>
        </div>

        <div className="ml-auto flex items-center gap-1.5">
          <button disabled={!past.length} title="Undo" className="grid h-8 w-8 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white disabled:opacity-30" onClick={undo}><Undo2 size={15} /></button>
          <button disabled={!future.length} title="Redo" className="grid h-8 w-8 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white disabled:opacity-30" onClick={redo}><Redo2 size={15} /></button>
          <div className="mx-1 h-5 w-px bg-white/8" />
          <button title="Open another PDF" className="hidden h-8 items-center gap-2 rounded-lg px-2.5 text-xs text-zinc-400 hover:bg-white/5 hover:text-white sm:flex" onClick={() => fileInput.current?.click()}><Upload size={14} /> Open</button>
          <button disabled={exporting} onClick={exportPdf} className="flex h-8 items-center gap-2 rounded-lg bg-white px-3 text-xs font-semibold text-black transition hover:bg-zinc-200 disabled:opacity-60">{exporting ? <LoaderCircle size={14} className="animate-spin" /> : <Download size={14} />} Export</button>
        </div>
      </header>

      <div className="flex min-h-0 flex-1">
        <AnimatePresence initial={false}>
          {leftOpen && (
            <motion.aside initial={{ width: 0, opacity: 0 }} animate={{ width: 220, opacity: 1 }} exit={{ width: 0, opacity: 0 }} className="relative z-20 shrink-0 overflow-hidden border-r border-white/8 bg-[#0f1115]">
              <div className="flex h-full w-[220px] flex-col">
                <div className="flex h-11 shrink-0 items-center justify-between border-b border-white/6 px-3">
                  <span className="text-xs font-semibold text-zinc-300">Pages</span>
                  <div className="flex gap-1">
                    <button title="Duplicate current page" onClick={duplicatePage} className="rounded-md p-1.5 text-zinc-500 hover:bg-white/5 hover:text-white"><Copy size={14} /></button>
                    <button onClick={() => setLeftOpen(false)} className="rounded-md p-1.5 text-zinc-500 hover:bg-white/5 hover:text-white"><PanelLeftClose size={14} /></button>
                  </div>
                </div>
                <div className="editor-scrollbar flex-1 space-y-2 overflow-y-auto p-2.5">
                  {pages.map((page, index) => (
                    <PageThumbnail key={page.id} pdf={pdf} page={page} index={index} active={page.id === activePage?.id} onSelect={() => { setActivePageId(page.id); setSelectedId(null); }} onDelete={() => deletePage(page.id)} onRotate={() => rotatePage(page.id)} onDragStart={() => setDragIndex(index)} onDrop={() => { if (dragIndex !== null) movePage(dragIndex, index); setDragIndex(null); }} />
                  ))}
                </div>
              </div>
            </motion.aside>
          )}
        </AnimatePresence>

        <main className="relative min-w-0 flex-1 overflow-hidden bg-[#17191d]">
          {!leftOpen && <button title="Show pages" onClick={() => setLeftOpen(true)} className="absolute left-3 top-3 z-20 grid h-8 w-8 place-items-center rounded-lg border border-white/8 bg-[#111318]/90 text-zinc-400 shadow-lg backdrop-blur hover:text-white"><PanelLeftOpen size={15} /></button>}

          <div className="absolute left-1/2 top-3 z-20 flex -translate-x-1/2 items-center gap-1 rounded-xl border border-white/10 bg-[#111318]/92 p-1 shadow-xl backdrop-blur">
            <button title="Zoom out" className="grid h-7 w-7 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white" onClick={() => setZoom((z) => clamp(Number((z - 0.1).toFixed(2)), 0.25, 2.5))}><ZoomOut size={14} /></button>
            <button className="h-7 min-w-[58px] rounded-lg px-2 text-[11px] font-medium text-zinc-300 hover:bg-white/5" onClick={() => setZoom(1)}>{Math.round(zoom * 100)}%</button>
            <button title="Zoom in" className="grid h-7 w-7 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white" onClick={() => setZoom((z) => clamp(Number((z + 0.1).toFixed(2)), 0.25, 2.5))}><ZoomIn size={14} /></button>
          </div>

          <div className="editor-scrollbar h-full overflow-auto px-16 pb-20 pt-20">
            <AnimatePresence mode="wait">
              {activePage && (
                <motion.div key={activePage.id} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -8 }} transition={{ duration: 0.16 }} className="mx-auto w-fit">
                  <PdfPage
                    pdf={pdf}
                    page={activePage}
                    zoom={zoom}
                    annotations={pageAnnotations}
                    tool={tool}
                    selectedId={selectedId}
                    pendingImage={pendingImage}
                    defaults={defaults}
                    ocrResult={activeOcrResult}
                    ocrSearch={ocrSearch}
                    ocrSelectable={ocrSelectable}
                    onCreate={(annotation) => { checkpoint(); setAnnotations((items) => [...items, annotation]); setSelectedId(annotation.id); setTool("select"); }}
                    onSelect={setSelectedId}
                    onPatch={patchAnnotation}
                    onBeginMutation={checkpoint}
                    onConsumeImage={() => { setPendingImage(null); setTool("select"); }}
                    onOcrWordPatch={(wordId, patch) => activePage && patchOcrWord(activePage.id, wordId, patch)}
                  />
                  <div className="mt-4 text-center text-[11px] text-zinc-600">{activePage.label} · source page {activePage.sourceIndex + 1}</div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          <div className="absolute bottom-4 left-1/2 z-20 flex -translate-x-1/2 items-center gap-1.5 rounded-xl border border-white/10 bg-[#111318]/94 px-2 py-1.5 shadow-xl backdrop-blur md:hidden">
            {tools.slice(0, 6).map(({ id, icon: Icon }) => <button key={id} onClick={() => { setTool(id); setOcrSelectable(false); }} className={`grid h-8 w-8 place-items-center rounded-lg ${tool === id ? "bg-white text-black" : "text-zinc-400"}`}><Icon size={15} /></button>)}
          </div>
        </main>

        <AnimatePresence initial={false}>
          {rightOpen && (
            <motion.aside initial={{ width: 0, opacity: 0 }} animate={{ width: 260, opacity: 1 }} exit={{ width: 0, opacity: 0 }} className="relative z-20 shrink-0 overflow-hidden border-l border-white/8 bg-[#0f1115]">
              <div className="flex h-full w-[260px] flex-col">
                <div className="flex h-11 shrink-0 items-center justify-between border-b border-white/6 px-2">
                  <div className="flex items-center gap-1 rounded-lg bg-white/[0.025] p-0.5">
                    <button onClick={() => setRightPanel("properties")} className={`rounded-md px-2 py-1.5 text-[11px] ${rightPanel === "properties" ? "bg-white/8 text-zinc-200" : "text-zinc-600 hover:text-zinc-300"}`}>Properties</button>
                    <button onClick={() => setRightPanel("ocr")} className={`flex items-center gap-1 rounded-md px-2 py-1.5 text-[11px] ${rightPanel === "ocr" ? "bg-blue-500/10 text-blue-300" : "text-zinc-600 hover:text-zinc-300"}`}><ScanText size={12} /> Text</button>
                  </div>
                  <button onClick={() => setRightOpen(false)} className="rounded-md p-1.5 text-zinc-500 hover:bg-white/5 hover:text-white"><PanelRightClose size={14} /></button>
                </div>
                <div className="editor-scrollbar flex-1 overflow-y-auto p-3">
                  {rightPanel === "ocr" ? (
                    <OcrPanel
                      activePage={activePage}
                      activeResult={activeOcrResult}
                      language={ocrLanguage}
                      onLanguageChange={setOcrLanguage}
                      running={ocrRunning}
                      progress={ocrProgress}
                      recognizedCount={ocrResults.length}
                      totalPages={pages.length}
                      onRecognizePage={() => activePage && recognizePages([activePage])}
                      onRecognizeAll={() => recognizePages(pages)}
                      search={ocrSearch}
                      onSearchChange={setOcrSearch}
                      searchHits={ocrSearchHits}
                      onSelectPage={(pageId) => { setActivePageId(pageId); setSelectedId(null); }}
                      selectable={ocrSelectable}
                      onSelectableChange={(value) => { setOcrSelectable(value); if (value) { setTool("select"); setSelectedId(null); } }}
                      onCopyText={copyOcrText}
                      onClearPage={() => activePage && clearOcrPage(activePage.id)}
                      onClearAll={clearAllOcr}
                    />
                  ) : selected ? (
                    <div className="space-y-5">
                      <section>
                        <div className="mb-2 flex items-center justify-between"><span className="text-[11px] font-semibold uppercase tracking-wider text-zinc-600">Selected</span><span className="rounded-md bg-white/5 px-1.5 py-1 text-[10px] capitalize text-zinc-400">{selected.type}</span></div>
                        {selected.type === "text" && <textarea value={selected.text || ""} onFocus={checkpoint} onChange={(e) => patchAnnotation(selected.id, { text: e.target.value })} className="min-h-24 w-full resize-y rounded-xl border border-white/8 bg-white/[0.025] p-2.5 text-xs leading-5 text-zinc-200 outline-none focus:border-blue-500/50" />}
                      </section>

                      {selected.type !== "image" && <PropertyColor value={selected.color} onChange={(color) => inspectorPatch({ color })} />}
                      <PropertyRange label="Opacity" value={Math.round(selected.opacity * 100)} min={5} max={100} suffix="%" onChange={(value) => inspectorPatch({ opacity: value / 100 })} />
                      {(selected.type === "rect" || selected.type === "ellipse" || selected.type === "draw") && <PropertyRange label="Stroke" value={selected.strokeWidth} min={1} max={12} suffix="px" onChange={(value) => inspectorPatch({ strokeWidth: value })} />}
                      {selected.type === "text" && <PropertyRange label="Font size" value={selected.fontSize} min={8} max={72} suffix="pt" onChange={(value) => inspectorPatch({ fontSize: value, height: value * 1.6 })} />}

                      <div className="grid grid-cols-2 gap-2 border-t border-white/7 pt-4">
                        <NumberField label="X" value={selected.x} onChange={(x) => inspectorPatch({ x })} />
                        <NumberField label="Y" value={selected.y} onChange={(y) => inspectorPatch({ y })} />
                        <NumberField label="W" value={selected.width} onChange={(width) => inspectorPatch({ width: Math.max(1, width) })} />
                        <NumberField label="H" value={selected.height} onChange={(height) => inspectorPatch({ height: Math.max(1, height) })} />
                      </div>
                      <button onClick={deleteSelected} className="flex w-full items-center justify-center gap-2 rounded-xl border border-red-500/15 bg-red-500/[0.06] py-2 text-xs font-medium text-red-300 hover:bg-red-500/10"><Trash2 size={14} /> Delete annotation</button>
                    </div>
                  ) : (
                    <div className="space-y-5">
                      <section>
                        <div className="mb-3 text-[11px] font-semibold uppercase tracking-wider text-zinc-600">Tool defaults</div>
                        <PropertyColor value={defaults.color} onChange={(color) => setDefaults((d) => ({ ...d, color }))} />
                        <div className="mt-4"><PropertyRange label="Opacity" value={Math.round(defaults.opacity * 100)} min={10} max={100} suffix="%" onChange={(value) => setDefaults((d) => ({ ...d, opacity: value / 100 }))} /></div>
                        <div className="mt-4"><PropertyRange label="Stroke" value={defaults.strokeWidth} min={1} max={12} suffix="px" onChange={(value) => setDefaults((d) => ({ ...d, strokeWidth: value }))} /></div>
                        <div className="mt-4"><PropertyRange label="Font size" value={defaults.fontSize} min={8} max={72} suffix="pt" onChange={(value) => setDefaults((d) => ({ ...d, fontSize: value }))} /></div>
                      </section>
                      <section className="border-t border-white/7 pt-4">
                        <div className="mb-3 text-[11px] font-semibold uppercase tracking-wider text-zinc-600">Page</div>
                        <div className="grid grid-cols-2 gap-2">
                          <button onClick={() => activePage && rotatePage(activePage.id)} className="flex items-center justify-center gap-2 rounded-xl border border-white/8 bg-white/[0.025] py-2 text-xs text-zinc-300 hover:bg-white/5"><RotateCw size={14} /> Rotate</button>
                          <button onClick={duplicatePage} className="flex items-center justify-center gap-2 rounded-xl border border-white/8 bg-white/[0.025] py-2 text-xs text-zinc-300 hover:bg-white/5"><Copy size={14} /> Duplicate</button>
                        </div>
                      </section>
                      <div className="rounded-xl border border-white/7 bg-white/[0.02] p-3 text-[11px] leading-5 text-zinc-500">Choose a tool above, then click or drag on the page. Press <b className="font-medium text-zinc-400">V</b> to return to Select. Double-click text to edit it quickly.</div>
                    </div>
                  )}
                </div>
              </div>
            </motion.aside>
          )}
        </AnimatePresence>

        {!rightOpen && <button title="Show side panel" onClick={() => setRightOpen(true)} className="absolute right-3 top-[70px] z-30 grid h-8 w-8 place-items-center rounded-lg border border-white/8 bg-[#111318]/90 text-zinc-400 shadow-lg backdrop-blur hover:text-white"><PanelRightOpen size={15} /></button>}
      </div>

      <input ref={fileInput} type="file" accept="application/pdf" className="hidden" onChange={(e) => { const file = e.target.files?.[0]; if (file) openFile(file); e.currentTarget.value = ""; }} />
      <input ref={imageInput} type="file" accept="image/png,image/jpeg" className="hidden" onChange={async (e) => { const file = e.target.files?.[0]; if (!file) return; const dataUrl = await fileToDataUrl(file); setPendingImage(dataUrl); setTool("image"); setSelectedId(null); e.currentTarget.value = ""; }} />

      <SignatureDialog open={signatureOpen} onClose={() => setSignatureOpen(false)} onSave={(dataUrl) => { setSignatureOpen(false); setPendingImage(dataUrl); setTool("image"); setSelectedId(null); }} />

      <AnimatePresence>
        {pendingImage && tool === "image" && <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: 8 }} className="pointer-events-none fixed bottom-5 left-1/2 z-40 -translate-x-1/2 rounded-xl border border-blue-500/25 bg-blue-500/15 px-3 py-2 text-xs text-blue-100 shadow-xl backdrop-blur">Click the page to place the image</motion.div>}
        {error && <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0 }} className="fixed bottom-5 right-5 z-50 max-w-sm rounded-xl border border-red-500/20 bg-[#241315] px-4 py-3 text-xs text-red-200 shadow-2xl">{error}<button className="ml-3 text-red-400" onClick={() => setError(null)}>Dismiss</button></motion.div>}
      </AnimatePresence>
    </div>
  );
}

function PropertyColor({ value, onChange }: { value: string; onChange: (value: string) => void }) {
  return (
    <div>
      <div className="mb-2 flex items-center justify-between text-[11px] text-zinc-500"><span>Color</span><span className="font-mono text-[10px] uppercase">{value}</span></div>
      <div className="flex gap-2">
        {["#111827", "#2563eb", "#dc2626", "#16a34a", "#facc15", "#a855f7"].map((color) => <button key={color} aria-label={`Use ${color}`} onClick={() => onChange(color)} className={`h-6 flex-1 rounded-md border ${value === color ? "border-white ring-1 ring-white/40" : "border-white/10"}`} style={{ background: color }} />)}
        <label className="relative grid h-6 w-7 shrink-0 cursor-pointer place-items-center overflow-hidden rounded-md border border-white/10 bg-white/5"><Plus size={12} className="pointer-events-none absolute" /><input aria-label="Custom color" type="color" value={value} onChange={(e) => onChange(e.target.value)} className="absolute inset-0 h-10 w-10 cursor-pointer opacity-0" /></label>
      </div>
    </div>
  );
}

function PropertyRange({ label, value, min, max, suffix, onChange }: { label: string; value: number; min: number; max: number; suffix: string; onChange: (value: number) => void }) {
  return (
    <div>
      <div className="mb-2 flex items-center justify-between text-[11px] text-zinc-500"><span>{label}</span><span>{Math.round(value)}{suffix}</span></div>
      <input type="range" min={min} max={max} value={value} onChange={(e) => onChange(Number(e.target.value))} className="h-1.5 w-full cursor-pointer accent-blue-500" />
    </div>
  );
}

function NumberField({ label, value, onChange }: { label: string; value: number; onChange: (value: number) => void }) {
  return (
    <label className="flex items-center rounded-lg border border-white/8 bg-white/[0.025] px-2.5 py-2 text-[10px] text-zinc-600 focus-within:border-blue-500/40">
      <span className="w-4">{label}</span>
      <input type="number" value={Math.round(value)} onChange={(e) => onChange(Number(e.target.value))} className="min-w-0 flex-1 bg-transparent text-right text-xs text-zinc-300 outline-none" />
    </label>
  );
}
