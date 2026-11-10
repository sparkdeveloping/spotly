"use client";

import type { Annotation, EditorPage, EditorTool, OcrPageResult, OcrWord, Point } from "@/lib/types";
import { measureOcrText } from "@/lib/ocr";
import { sampleTextAppearance, synthesizeBackgroundPatch } from "@/lib/text-pixels";
import { clamp, uid } from "@/lib/utils";
import { useEffect, useMemo, useRef, useState } from "react";

type PdfJsDoc = { getPage: (pageNumber: number) => Promise<any> };

type Draft = { type: "highlight" | "rect" | "ellipse"; start: Point; current: Point } | { type: "draw"; points: Point[] };

export function PdfPage({
  pdf,
  page,
  zoom,
  annotations,
  tool,
  selectedId,
  pendingImage,
  defaults,
  ocrResult,
  ocrSearch,
  ocrSelectable,
  onCreate,
  onSelect,
  onPatch,
  onBeginMutation,
  onConsumeImage,
  onOcrWordPatch,
}: {
  pdf: PdfJsDoc;
  page: EditorPage;
  zoom: number;
  annotations: Annotation[];
  tool: EditorTool;
  selectedId: string | null;
  pendingImage: string | null;
  defaults: { color: string; opacity: number; strokeWidth: number; fontSize: number };
  ocrResult: OcrPageResult | null;
  ocrSearch: string;
  ocrSelectable: boolean;
  onCreate: (annotation: Annotation) => void;
  onSelect: (id: string | null) => void;
  onPatch: (id: string, patch: Partial<Annotation>) => void;
  onBeginMutation: () => void;
  onConsumeImage: () => void;
  onOcrWordPatch: (wordId: string, patch: Partial<OcrWord>) => void;
}) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const layerRef = useRef<HTMLDivElement>(null);
  const [baseSize, setBaseSize] = useState({ width: 612, height: 792 });
  const [draft, setDraft] = useState<Draft | null>(null);
  const [editingWordId, setEditingWordId] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    let renderTask: any;
    (async () => {
      const proxy = await pdf.getPage(page.sourceIndex + 1);
      const base = proxy.getViewport({ scale: 1, rotation: page.rotation });
      const viewport = proxy.getViewport({ scale: zoom, rotation: page.rotation });
      const canvas = canvasRef.current;
      if (!canvas || cancelled) return;
      setBaseSize({ width: base.width, height: base.height });
      const ratio = Math.min(window.devicePixelRatio || 1, 2);
      canvas.width = Math.floor(viewport.width * ratio);
      canvas.height = Math.floor(viewport.height * ratio);
      canvas.style.width = `${viewport.width}px`;
      canvas.style.height = `${viewport.height}px`;
      const ctx = canvas.getContext("2d", { alpha: false });
      if (!ctx) return;
      renderTask = proxy.render({
        canvasContext: ctx,
        viewport,
        transform: ratio === 1 ? undefined : [ratio, 0, 0, ratio, 0, 0],
      });
      await renderTask.promise;
    })();
    return () => { cancelled = true; renderTask?.cancel?.(); };
  }, [pdf, page.sourceIndex, page.rotation, zoom]);

  useEffect(() => {
    if (!ocrSelectable) setEditingWordId(null);
  }, [ocrSelectable]);

  const pointFromEvent = (event: React.PointerEvent) => {
    const rect = layerRef.current!.getBoundingClientRect();
    return {
      x: clamp((event.clientX - rect.left) / zoom, 0, baseSize.width),
      y: clamp((event.clientY - rect.top) / zoom, 0, baseSize.height),
    };
  };

  const draftBox = useMemo(() => {
    if (!draft || draft.type === "draw") return null;
    return {
      x: Math.min(draft.start.x, draft.current.x),
      y: Math.min(draft.start.y, draft.current.y),
      width: Math.abs(draft.current.x - draft.start.x),
      height: Math.abs(draft.current.y - draft.start.y),
    };
  }, [draft]);

  const normalizedSearch = ocrSearch.trim().toLocaleLowerCase();
  const searchTerms = normalizedSearch.split(/\s+/).filter(Boolean);

  const prepareWordVisual = (word: OcrWord) => {
    if (word.backgroundPatch) return;
    const canvas = canvasRef.current;
    if (!canvas || baseSize.width <= 0 || baseSize.height <= 0) return;
    const scaleX = canvas.width / baseSize.width;
    const scaleY = canvas.height / baseSize.height;
    if (!Number.isFinite(scaleX) || !Number.isFinite(scaleY) || scaleX <= 0 || scaleY <= 0) return;

    const left = word.x * scaleX;
    const top = word.y * scaleY;
    const width = Math.max(1, word.width * scaleX);
    const height = Math.max(1, word.height * scaleY);
    const appearance = sampleTextAppearance(canvas, left, top, width, height);
    const patch = synthesizeBackgroundPatch(
      canvas,
      left,
      top,
      width,
      height,
      Math.max(3, Math.round(height * 0.12)),
    );

    onOcrWordPatch(word.id, {
      backgroundColor: appearance.backgroundColor,
      textColor: appearance.textColor,
      backgroundPatch: patch ? {
        dataUrl: patch.dataUrl,
        x: patch.x / scaleX,
        y: patch.y / scaleY,
        width: patch.width / scaleX,
        height: patch.height / scaleY,
      } : undefined,
    });
  };

  return (
    <div className="relative bg-white shadow-[0_24px_80px_rgba(0,0,0,.35)]" style={{ width: baseSize.width * zoom, height: baseSize.height * zoom }}>
      <canvas ref={canvasRef} className="absolute inset-0 block" />
      {ocrResult && (
        <div
          className={`absolute inset-0 z-30 overflow-hidden ${ocrSelectable ? "cursor-text" : "pointer-events-none select-none"}`}
          aria-label="Editable recognized text layer"
        >
          {ocrResult.words.map((word) => {
            const wordValue = word.text.toLocaleLowerCase();
            const match = searchTerms.length > 0 && searchTerms.some((term) => wordValue.includes(term));
            return (
              <OcrWordView
                key={word.id}
                word={word}
                zoom={zoom}
                editable={ocrSelectable}
                editing={editingWordId === word.id}
                match={match}
                onStartEdit={() => {
                  if (!ocrSelectable) return;
                  onBeginMutation();
                  setEditingWordId(word.id);
                  // Let the editable surface paint first, then synthesize a
                  // cleanup patch for this one line from the existing page canvas.
                  // Preparation no longer precomputes patches for every line.
                  requestAnimationFrame(() => prepareWordVisual(word));
                }}
                onCommit={(text) => {
                  onOcrWordPatch(word.id, { text });
                  setEditingWordId(null);
                }}
                onCancel={() => setEditingWordId(null)}
              />
            );
          })}
        </div>
      )}
      <div
        ref={layerRef}
        className={`absolute inset-0 z-20 touch-none ${ocrSelectable ? "pointer-events-none" : ""} ${tool === "select" ? "cursor-default" : tool === "text" ? "cursor-text" : "cursor-crosshair"}`}
        onPointerDown={(event) => {
          if (event.button !== 0 || event.target !== event.currentTarget) return;
          const p = pointFromEvent(event);
          onSelect(null);

          if (tool === "text") {
            onCreate({
              id: uid("ann"), pageId: page.id, type: "text", x: p.x, y: p.y, width: 180, height: defaults.fontSize * 1.6,
              color: defaults.color, opacity: defaults.opacity, strokeWidth: defaults.strokeWidth, fontSize: defaults.fontSize, text: "Double-click to edit",
            });
          } else if (tool === "image" && pendingImage) {
            onCreate({
              id: uid("ann"), pageId: page.id, type: "image", x: p.x, y: p.y, width: 180, height: 100,
              color: defaults.color, opacity: defaults.opacity, strokeWidth: defaults.strokeWidth, fontSize: defaults.fontSize, dataUrl: pendingImage,
            });
            onConsumeImage();
          } else if (tool === "highlight" || tool === "rect" || tool === "ellipse") {
            event.currentTarget.setPointerCapture(event.pointerId);
            setDraft({ type: tool, start: p, current: p });
          } else if (tool === "draw") {
            event.currentTarget.setPointerCapture(event.pointerId);
            setDraft({ type: "draw", points: [p] });
          }
        }}
        onPointerMove={(event) => {
          if (!draft) return;
          const p = pointFromEvent(event);
          setDraft((current) => {
            if (!current) return null;
            if (current.type === "draw") return { ...current, points: [...current.points, p] };
            return { ...current, current: p };
          });
        }}
        onPointerUp={() => {
          if (!draft) return;
          if (draft.type === "draw" && draft.points.length > 1) {
            const xs = draft.points.map((p) => p.x); const ys = draft.points.map((p) => p.y);
            onCreate({
              id: uid("ann"), pageId: page.id, type: "draw", x: Math.min(...xs), y: Math.min(...ys), width: Math.max(...xs) - Math.min(...xs), height: Math.max(...ys) - Math.min(...ys),
              color: defaults.color, opacity: defaults.opacity, strokeWidth: defaults.strokeWidth, fontSize: defaults.fontSize, points: draft.points,
            });
          } else if (draft.type !== "draw") {
            const b = {
              x: Math.min(draft.start.x, draft.current.x), y: Math.min(draft.start.y, draft.current.y),
              width: Math.abs(draft.current.x - draft.start.x), height: Math.abs(draft.current.y - draft.start.y),
            };
            if (b.width > 3 && b.height > 3) {
              onCreate({
                id: uid("ann"), pageId: page.id, type: draft.type, ...b,
                color: draft.type === "highlight" ? "#facc15" : defaults.color,
                opacity: draft.type === "highlight" ? 0.28 : defaults.opacity,
                strokeWidth: defaults.strokeWidth, fontSize: defaults.fontSize,
              });
            }
          }
          setDraft(null);
        }}
      >
        {annotations.map((annotation) => (
          <AnnotationView
            key={annotation.id}
            annotation={annotation}
            zoom={zoom}
            selected={annotation.id === selectedId}
            selectable={tool === "select" && !ocrSelectable}
            onSelect={() => onSelect(annotation.id)}
            onPatch={(patch) => onPatch(annotation.id, patch)}
            onBeginMutation={onBeginMutation}
          />
        ))}

        {draftBox && (
          <div
            className="pointer-events-none absolute border border-blue-500 bg-blue-500/10"
            style={{ left: draftBox.x * zoom, top: draftBox.y * zoom, width: draftBox.width * zoom, height: draftBox.height * zoom, borderRadius: draft.type === "ellipse" ? 999 : 2, background: draft.type === "highlight" ? "rgba(250,204,21,.28)" : undefined }}
          />
        )}
        {draft?.type === "draw" && (
          <svg className="pointer-events-none absolute inset-0 overflow-visible" width="100%" height="100%">
            <polyline points={draft.points.map((p) => `${p.x * zoom},${p.y * zoom}`).join(" ")} fill="none" stroke={defaults.color} strokeWidth={defaults.strokeWidth * zoom} strokeLinecap="round" strokeLinejoin="round" />
          </svg>
        )}
      </div>
    </div>
  );
}

function OcrWordView({ word, zoom, editable, editing, match, onStartEdit, onCommit, onCancel }: {
  word: OcrWord;
  zoom: number;
  editable: boolean;
  editing: boolean;
  match: boolean;
  onStartEdit: () => void;
  onCommit: (text: string) => void;
  onCancel: () => void;
}) {
  const editorRef = useRef<HTMLDivElement>(null);
  const draftText = useRef(word.text);
  useEffect(() => {
    if (!editing) return;
    const editor = editorRef.current;
    if (!editor) return;
    draftText.current = word.text;
    editor.textContent = word.text;
    editor.focus();
    const selection = window.getSelection();
    const range = document.createRange();
    range.selectNodeContents(editor);
    selection?.removeAllRanges();
    selection?.addRange(range);
  }, [editing]);

  const left = word.x * zoom;
  const top = word.y * zoom;
  const originalWidth = Math.max(2, word.width * zoom);
  const originalHeight = Math.max(2, word.height * zoom);
  const typography = word.typography;
  const metrics = measureOcrText(word.text || " ", typography);
  const renderedWidth = Math.max(1, metrics.width * zoom);
  // Only cover the pixels that belonged to the original scanned word. Expanding
  // the patch to the replacement width can erase neighboring words on the line.
  const coverWidth = originalWidth;
  const glyphTop = (typography.baselineY - metrics.ascent) * zoom;
  const glyphHeight = Math.max(2, (metrics.ascent + metrics.descent) * zoom);
  const background = word.backgroundColor || "#ffffff";
  const foreground = word.textColor || "#111111";
  const fontSize = typography.fontSize * zoom;
  const letterSpacing = typography.letterSpacing * zoom;
  const repair = word.backgroundPatch ? {
    left: (word.backgroundPatch.x - word.x) * zoom,
    top: (word.backgroundPatch.y - word.y) * zoom,
    width: word.backgroundPatch.width * zoom,
    height: word.backgroundPatch.height * zoom,
    backgroundImage: `url(${word.backgroundPatch.dataUrl})`,
    backgroundSize: "100% 100%",
    backgroundRepeat: "no-repeat",
  } satisfies React.CSSProperties : null;

  const textStyle: React.CSSProperties = {
    fontFamily: typography.fontFamily,
    fontWeight: typography.fontWeight,
    fontStyle: typography.fontStyle,
    fontSize,
    lineHeight: 1,
    letterSpacing,
    color: foreground,
    whiteSpace: "nowrap",
    transform: `scaleX(${typography.scaleX})`,
    transformOrigin: "left top",
  };

  if (editing) {
    const editorWidth = Math.max(originalWidth, renderedWidth + 24);
    return (
      <div
        className="absolute z-20"
        style={{ left, top, width: Math.max(coverWidth, editorWidth), height: originalHeight }}
      >
        {repair ? (
          <div aria-hidden="true" className="pointer-events-none absolute" style={repair} />
        ) : (
          <div aria-hidden="true" className="pointer-events-none absolute inset-y-0 left-0" style={{ width: originalWidth, backgroundColor: background }} />
        )}
        <div
          ref={editorRef}
          contentEditable
          suppressContentEditableWarning
          role="textbox"
          aria-label={`Edit ${word.source === "native-pdf" ? "PDF" : "scanned"} text: ${word.originalText}`}
          className="absolute z-20 m-0 border-0 bg-transparent p-0 outline-none ring-2 ring-blue-500/60 ring-offset-1"
          style={{
            ...textStyle,
            left: 0,
            top: glyphTop - top,
            minWidth: editorWidth / Math.max(0.01, typography.scaleX),
            height: Math.max(18, glyphHeight),
            caretColor: foreground,
            overflow: "visible",
          }}
          onInput={(event) => { draftText.current = event.currentTarget.textContent || ""; }}
          onBlur={() => onCommit(draftText.current)}
          onKeyDown={(event) => {
            if (event.key === "Enter") { event.preventDefault(); onCommit(draftText.current); }
            if (event.key === "Escape") { event.preventDefault(); onCancel(); }
          }}
        />
      </div>
    );
  }

  if (word.edited) {
    return (
      <button
        type="button"
        title={editable ? `Edit “${word.text || word.originalText}” · ${typography.fontFamily.split(",")[0].replaceAll("\"", "")} · ${typography.fontSize.toFixed(1)} pt · ${typography.fontWeight}` : undefined}
        onClick={(event) => { event.stopPropagation(); if (editable) onStartEdit(); }}
        className={`absolute text-left ${editable ? "pointer-events-auto cursor-text hover:outline hover:outline-1 hover:outline-blue-400" : "pointer-events-none"} ${match ? "outline outline-2 outline-amber-400" : ""}`}
        style={{ left, top, width: coverWidth, height: originalHeight, backgroundColor: repair ? "transparent" : background, overflow: "visible" }}
      >
        {repair && <span aria-hidden="true" className="pointer-events-none absolute" style={repair} />}
        {word.text && (
          <span
            className="absolute block"
            style={{
              ...textStyle,
              left: 0,
              top: glyphTop - top,
              width: Math.max(1, metrics.naturalWidth * zoom),
              height: glyphHeight,
            }}
          >
            {word.text}
          </span>
        )}
      </button>
    );
  }

  return (
    <button
      type="button"
      title={editable ? `${word.text} · ${word.source === "native-pdf" ? "native PDF" : `${Math.round(word.confidence)}% OCR`} · ${typography.fontFamily.split(",")[0].replaceAll("\"", "")} · ${typography.fontSize.toFixed(1)} pt · weight ${typography.fontWeight}` : undefined}
      onClick={(event) => { event.stopPropagation(); if (editable) onStartEdit(); }}
      className={`ocr-word absolute whitespace-nowrap text-transparent ${editable ? "pointer-events-auto cursor-text hover:bg-blue-400/10 hover:outline hover:outline-1 hover:outline-blue-400/70" : "pointer-events-none"} ${match ? "bg-amber-300/55 outline outline-1 outline-amber-500/30" : ""}`}
      style={{ left, top, width: originalWidth, height: originalHeight, fontSize, lineHeight: `${originalHeight}px` }}
    >
      {word.text}&nbsp;
    </button>
  );
}
function AnnotationView({ annotation, zoom, selected, selectable, onSelect, onPatch, onBeginMutation }: {
  annotation: Annotation;
  zoom: number;
  selected: boolean;
  selectable: boolean;
  onSelect: () => void;
  onPatch: (patch: Partial<Annotation>) => void;
  onBeginMutation: () => void;
}) {
  const drag = useRef<{ x: number; y: number; startX: number; startY: number } | null>(null);

  if (annotation.type === "draw" && annotation.points) {
    return (
      <svg className="pointer-events-none absolute inset-0 overflow-visible" width="100%" height="100%">
        <polyline
          points={annotation.points.map((p) => `${p.x * zoom},${p.y * zoom}`).join(" ")}
          fill="none"
          stroke={annotation.color}
          opacity={annotation.opacity}
          strokeWidth={annotation.strokeWidth * zoom}
          strokeLinecap="round"
          strokeLinejoin="round"
          style={{ pointerEvents: selectable ? "stroke" : "none" }}
          onPointerDown={(e) => { if (!selectable) return; e.stopPropagation(); onSelect(); }}
        />
      </svg>
    );
  }

  const style: React.CSSProperties = {
    left: annotation.x * zoom,
    top: annotation.y * zoom,
    width: Math.max(2, annotation.width * zoom),
    height: Math.max(2, annotation.height * zoom),
    opacity: annotation.opacity,
  };

  return (
    <div
      className={`absolute ${selectable ? "pointer-events-auto" : "pointer-events-none"} ${selected ? "ring-1 ring-blue-500 ring-offset-1 ring-offset-white" : ""}`}
      style={style}
      onDoubleClick={(event) => {
        if (annotation.type !== "text") return;
        event.stopPropagation();
        const next = window.prompt("Edit text", annotation.text || "");
        if (next !== null) { onBeginMutation(); onPatch({ text: next }); }
      }}
      onPointerDown={(event) => {
        if (!selectable || event.button !== 0) return;
        event.stopPropagation();
        onSelect();
        onBeginMutation();
        drag.current = { x: annotation.x, y: annotation.y, startX: event.clientX, startY: event.clientY };
        event.currentTarget.setPointerCapture(event.pointerId);
      }}
      onPointerMove={(event) => {
        if (!drag.current) return;
        onPatch({ x: drag.current.x + (event.clientX - drag.current.startX) / zoom, y: drag.current.y + (event.clientY - drag.current.startY) / zoom });
      }}
      onPointerUp={() => { drag.current = null; }}
    >
      {annotation.type === "text" && (
        <div className="h-full w-full whitespace-pre-wrap leading-tight" style={{ color: annotation.color, fontSize: annotation.fontSize * zoom }}>{annotation.text}</div>
      )}
      {annotation.type === "highlight" && <div className="h-full w-full" style={{ background: annotation.color }} />}
      {annotation.type === "rect" && <div className="h-full w-full" style={{ border: `${annotation.strokeWidth * zoom}px solid ${annotation.color}` }} />}
      {annotation.type === "ellipse" && <div className="h-full w-full rounded-full" style={{ border: `${annotation.strokeWidth * zoom}px solid ${annotation.color}` }} />}
      {annotation.type === "image" && annotation.dataUrl && <img src={annotation.dataUrl} alt="Placed" className="h-full w-full object-contain" draggable={false} />}
      {selected && annotation.type !== "draw" && (
        <ResizeHandle
          annotation={annotation}
          zoom={zoom}
          onBeginMutation={onBeginMutation}
          onPatch={onPatch}
        />
      )}
    </div>
  );
}

function ResizeHandle({ annotation, zoom, onPatch, onBeginMutation }: { annotation: Annotation; zoom: number; onPatch: (patch: Partial<Annotation>) => void; onBeginMutation: () => void }) {
  const drag = useRef<{ width: number; height: number; startX: number; startY: number } | null>(null);
  return (
    <button
      aria-label="Resize annotation"
      className="absolute -bottom-1.5 -right-1.5 h-3 w-3 cursor-nwse-resize rounded-sm border border-white bg-blue-500 shadow"
      onPointerDown={(event) => {
        event.stopPropagation();
        onBeginMutation();
        drag.current = { width: annotation.width, height: annotation.height, startX: event.clientX, startY: event.clientY };
        event.currentTarget.setPointerCapture(event.pointerId);
      }}
      onPointerMove={(event) => {
        if (!drag.current) return;
        onPatch({ width: Math.max(12, drag.current.width + (event.clientX - drag.current.startX) / zoom), height: Math.max(12, drag.current.height + (event.clientY - drag.current.startY) / zoom) });
      }}
      onPointerUp={(event) => { event.stopPropagation(); drag.current = null; }}
    />
  );
}
