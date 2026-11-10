"use client";

import type { EditorPage } from "@/lib/types";
import { GripVertical, RotateCw, Trash2 } from "lucide-react";
import { useEffect, useRef, useState } from "react";

type PdfJsDoc = { getPage: (pageNumber: number) => Promise<any> };

export function PageThumbnail({
  pdf,
  page,
  index,
  active,
  onSelect,
  onDelete,
  onRotate,
  onDragStart,
  onDrop,
}: {
  pdf: PdfJsDoc;
  page: EditorPage;
  index: number;
  active: boolean;
  onSelect: () => void;
  onDelete: () => void;
  onRotate: () => void;
  onDragStart: () => void;
  onDrop: () => void;
}) {
  const ref = useRef<HTMLCanvasElement>(null);
  const rootRef = useRef<HTMLDivElement>(null);
  const [visible, setVisible] = useState(active);

  useEffect(() => {
    if (active) {
      setVisible(true);
      return;
    }
    const node = rootRef.current;
    if (!node || typeof IntersectionObserver === "undefined") {
      setVisible(true);
      return;
    }
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries.some((entry) => entry.isIntersecting)) {
          setVisible(true);
          observer.disconnect();
        }
      },
      { rootMargin: "320px 0px" },
    );
    observer.observe(node);
    return () => observer.disconnect();
  }, [active]);

  useEffect(() => {
    if (!visible) return;
    let cancelled = false;
    let renderTask: any;
    (async () => {
      const proxy = await pdf.getPage(page.sourceIndex + 1);
      const viewport = proxy.getViewport({ scale: 0.22, rotation: page.rotation });
      const canvas = ref.current;
      if (!canvas || cancelled) return;
      const ratio = Math.min(window.devicePixelRatio || 1, 2);
      canvas.width = viewport.width * ratio;
      canvas.height = viewport.height * ratio;
      canvas.style.width = `${viewport.width}px`;
      canvas.style.height = `${viewport.height}px`;
      const ctx = canvas.getContext("2d");
      if (!ctx) return;
      renderTask = proxy.render({ canvasContext: ctx, viewport, transform: ratio === 1 ? undefined : [ratio, 0, 0, ratio, 0, 0] });
      await renderTask.promise;
    })().catch((error) => {
      if (!cancelled && error?.name !== "RenderingCancelledException") console.error(error);
    });
    return () => { cancelled = true; renderTask?.cancel?.(); };
  }, [pdf, page.sourceIndex, page.rotation, visible]);

  return (
    <div
      ref={rootRef}
      draggable
      onDragStart={onDragStart}
      onDragOver={(e) => e.preventDefault()}
      onDrop={(e) => { e.preventDefault(); onDrop(); }}
      onClick={onSelect}
      className={`group relative cursor-pointer rounded-xl border p-2 transition ${active ? "border-blue-500/80 bg-blue-500/10" : "border-white/8 bg-white/[0.025] hover:border-white/15 hover:bg-white/[0.045]"}`}
    >
      <div className="flex items-start gap-2">
        <GripVertical size={14} className="mt-1 shrink-0 text-zinc-600 group-hover:text-zinc-400" />
        <div className="min-w-0 flex-1">
          <div className="flex min-h-[118px] items-center justify-center overflow-hidden rounded-md bg-zinc-800 p-1 shadow-inner">
            <canvas ref={ref} className="max-h-[126px] max-w-full bg-white shadow" />
          </div>
          <div className="mt-2 flex items-center justify-between">
            <span className="text-[11px] font-medium text-zinc-400">Page {index + 1}</span>
            <div className="flex opacity-0 transition group-hover:opacity-100">
              <button className="rounded p-1 text-zinc-500 hover:bg-white/10 hover:text-white" onClick={(e) => { e.stopPropagation(); onRotate(); }}><RotateCw size={13} /></button>
              <button className="rounded p-1 text-zinc-500 hover:bg-red-500/10 hover:text-red-300" onClick={(e) => { e.stopPropagation(); onDelete(); }}><Trash2 size={13} /></button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
