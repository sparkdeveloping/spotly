"use client";

import { AnimatePresence, motion } from "motion/react";
import { Eraser, PenLine, X } from "lucide-react";
import { useEffect, useRef, useState } from "react";

export function SignatureDialog({
  open,
  onClose,
  onSave,
}: {
  open: boolean;
  onClose: () => void;
  onSave: (dataUrl: string) => void;
}) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [drawing, setDrawing] = useState(false);

  useEffect(() => {
    if (!open) return;
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ratio = window.devicePixelRatio || 1;
    canvas.width = 520 * ratio;
    canvas.height = 180 * ratio;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;
    ctx.scale(ratio, ratio);
    ctx.lineCap = "round";
    ctx.lineJoin = "round";
    ctx.lineWidth = 2.4;
    ctx.strokeStyle = "#111827";
  }, [open]);

  const point = (event: React.PointerEvent<HTMLCanvasElement>) => {
    const rect = event.currentTarget.getBoundingClientRect();
    return { x: event.clientX - rect.left, y: event.clientY - rect.top };
  };

  return (
    <AnimatePresence>
      {open && (
        <motion.div
          className="fixed inset-0 z-50 grid place-items-center bg-black/65 p-5 backdrop-blur-sm"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          onMouseDown={(e) => e.target === e.currentTarget && onClose()}
        >
          <motion.div
            initial={{ opacity: 0, scale: 0.96, y: 12 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.98, y: 8 }}
            className="w-full max-w-[580px] rounded-2xl border border-white/10 bg-[#15181e] p-4 shadow-2xl"
          >
            <div className="mb-4 flex items-center justify-between">
              <div>
                <div className="flex items-center gap-2 text-sm font-semibold"><PenLine size={16} /> Draw signature</div>
                <p className="mt-1 text-xs text-zinc-500">Sign in the box, then place it on any page.</p>
              </div>
              <button className="rounded-lg p-2 text-zinc-400 hover:bg-white/5 hover:text-white" onClick={onClose}><X size={17} /></button>
            </div>

            <div className="overflow-hidden rounded-xl border border-zinc-300 bg-white checkerboard">
              <canvas
                ref={canvasRef}
                className="block h-[180px] w-full touch-none bg-white/80"
                onPointerDown={(event) => {
                  setDrawing(true);
                  event.currentTarget.setPointerCapture(event.pointerId);
                  const p = point(event);
                  const ctx = event.currentTarget.getContext("2d");
                  ctx?.beginPath();
                  ctx?.moveTo(p.x, p.y);
                }}
                onPointerMove={(event) => {
                  if (!drawing) return;
                  const p = point(event);
                  const ctx = event.currentTarget.getContext("2d");
                  ctx?.lineTo(p.x, p.y);
                  ctx?.stroke();
                }}
                onPointerUp={() => setDrawing(false)}
                onPointerCancel={() => setDrawing(false)}
              />
            </div>

            <div className="mt-4 flex items-center justify-between gap-3">
              <button
                className="inline-flex items-center gap-2 rounded-xl border border-white/10 px-3 py-2 text-sm text-zinc-300 hover:bg-white/5"
                onClick={() => {
                  const canvas = canvasRef.current;
                  const ctx = canvas?.getContext("2d");
                  if (canvas && ctx) ctx.clearRect(0, 0, canvas.width, canvas.height);
                }}
              ><Eraser size={15} /> Clear</button>
              <div className="flex gap-2">
                <button className="rounded-xl px-4 py-2 text-sm text-zinc-400 hover:bg-white/5" onClick={onClose}>Cancel</button>
                <button
                  className="rounded-xl bg-white px-4 py-2 text-sm font-semibold text-black hover:bg-zinc-200"
                  onClick={() => {
                    const url = canvasRef.current?.toDataURL("image/png");
                    if (url) onSave(url);
                  }}
                >Use signature</button>
              </div>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
