"use client";

import { Copy, LoaderCircle, PencilLine, ScanText, Search, Trash2 } from "lucide-react";
import { OCR_LANGUAGES } from "@/lib/ocr";
import type { EditorPage, OcrPageResult } from "@/lib/types";

export function OcrPanel({
  activePage,
  activeResult,
  language,
  onLanguageChange,
  running,
  progress,
  recognizedCount,
  totalPages,
  onRecognizePage,
  onRecognizeAll,
  search,
  onSearchChange,
  searchHits,
  onSelectPage,
  selectable,
  onSelectableChange,
  onCopyText,
  onClearPage,
  onClearAll,
}: {
  activePage: EditorPage | null;
  activeResult: OcrPageResult | null;
  language: string;
  onLanguageChange: (value: string) => void;
  running: boolean;
  progress: { progress: number; status: string; pageLabel: string };
  recognizedCount: number;
  totalPages: number;
  onRecognizePage: () => void;
  onRecognizeAll: () => void;
  search: string;
  onSearchChange: (value: string) => void;
  searchHits: Array<{ pageId: string; label: string; count: number }>;
  onSelectPage: (pageId: string) => void;
  selectable: boolean;
  onSelectableChange: (value: boolean) => void;
  onCopyText: () => void;
  onClearPage: () => void;
  onClearAll: () => void;
}) {
  const scanWords = activeResult?.words.filter((word) => word.source === "scan-ocr") ?? [];
  const nativeWords = activeResult?.words.filter((word) => word.source === "native-pdf") ?? [];
  const averageConfidence = scanWords.length
    ? Math.round(scanWords.reduce((sum, word) => sum + word.confidence, 0) / scanWords.length)
    : null;
  const totalMatches = searchHits.reduce((sum, item) => sum + item.count, 0);
  const editedCount = activeResult?.words.filter((word) => word.edited).length ?? 0;

  return (
    <div className="space-y-5">
      <section>
        <div className="mb-2 text-[11px] font-semibold uppercase tracking-wider text-zinc-600">Editable text</div>
        <label className="block text-[11px] text-zinc-500">
          Language
          <select
            value={language}
            disabled={running}
            onChange={(event) => onLanguageChange(event.target.value)}
            className="mt-2 w-full rounded-xl border border-white/8 bg-[#15171c] px-2.5 py-2 text-xs text-zinc-200 outline-none focus:border-blue-500/50 disabled:opacity-50"
          >
            {OCR_LANGUAGES.map((item) => <option key={item.code} value={item.code}>{item.label}</option>)}
          </select>
        </label>
        <div className="mt-3 grid grid-cols-2 gap-2">
          <button
            disabled={running || !activePage}
            onClick={onRecognizePage}
            className="flex items-center justify-center gap-2 rounded-xl bg-blue-600 px-2 py-2 text-xs font-semibold text-white hover:bg-blue-500 disabled:opacity-45"
          >
            {running ? <LoaderCircle size={14} className="animate-spin" /> : <ScanText size={14} />}
            Prepare page
          </button>
          <button
            disabled={running || totalPages === 0}
            onClick={onRecognizeAll}
            className="rounded-xl border border-white/8 bg-white/[0.025] px-2 py-2 text-xs text-zinc-300 hover:bg-white/5 disabled:opacity-45"
          >
            Prepare all
          </button>
        </div>
        <div className="mt-3 text-[10px] text-zinc-600">{recognizedCount}/{totalPages} pages prepared</div>
        {running && (
          <div className="mt-3 rounded-xl border border-blue-500/15 bg-blue-500/[0.05] p-3">
            <div className="mb-2 flex items-center justify-between gap-2 text-[10px] text-blue-200">
              <span className="truncate">{progress.pageLabel || "Preparing text"}</span>
              <span>{Math.round(progress.progress * 100)}%</span>
            </div>
            <div className="h-1.5 overflow-hidden rounded-full bg-white/8"><div className="h-full bg-blue-500 transition-[width]" style={{ width: `${Math.round(progress.progress * 100)}%` }} /></div>
            <div className="mt-2 truncate text-[10px] capitalize text-zinc-500">{progress.status || "Starting"}</div>
          </div>
        )}
      </section>

      <section className="border-t border-white/7 pt-4">
        <div className="mb-2 flex items-center justify-between">
          <span className="text-[11px] font-semibold uppercase tracking-wider text-zinc-600">Search text</span>
          {search && <span className="text-[10px] text-zinc-500">{totalMatches} match{totalMatches === 1 ? "" : "es"}</span>}
        </div>
        <div className="relative">
          <Search size={13} className="pointer-events-none absolute left-2.5 top-2.5 text-zinc-600" />
          <input
            value={search}
            onChange={(event) => onSearchChange(event.target.value)}
            placeholder="Search editable text"
            className="w-full rounded-xl border border-white/8 bg-white/[0.025] py-2 pl-8 pr-2.5 text-xs text-zinc-200 outline-none placeholder:text-zinc-700 focus:border-blue-500/50"
          />
        </div>
        {search && (
          <div className="mt-2 max-h-32 space-y-1 overflow-y-auto">
            {searchHits.length ? searchHits.map((hit) => (
              <button key={hit.pageId} onClick={() => onSelectPage(hit.pageId)} className="flex w-full items-center justify-between rounded-lg px-2 py-1.5 text-left text-[11px] text-zinc-400 hover:bg-white/5 hover:text-zinc-200">
                <span className="truncate">{hit.label}</span><span className="ml-2 rounded bg-white/5 px-1.5 py-0.5 text-[10px]">{hit.count}</span>
              </button>
            )) : <div className="px-2 py-2 text-[10px] text-zinc-600">No matches.</div>}
          </div>
        )}
      </section>

      <section className="border-t border-white/7 pt-4">
        <button
          disabled={!activeResult}
          onClick={() => onSelectableChange(!selectable)}
          className={`flex w-full items-center justify-between rounded-xl border px-3 py-2 text-xs transition disabled:opacity-40 ${selectable ? "border-blue-500/30 bg-blue-500/10 text-blue-200" : "border-white/8 bg-white/[0.025] text-zinc-300 hover:bg-white/5"}`}
        >
          <span className="flex items-center gap-2"><PencilLine size={14} /> Edit text on page</span>
          <span className="text-[10px]">{selectable ? "On" : "Off"}</span>
        </button>
        <div className="mt-2 text-[10px] leading-4 text-zinc-600">Turn this on, then click a native PDF text run or a reconstructed scan line directly on the page. Native text reuses PDF font geometry; scans repair the original pixels and redraw the whole line instead of pasting a word label.</div>
      </section>

      {activeResult ? (
        <section className="border-t border-white/7 pt-4">
          <div className="mb-2 flex items-center justify-between">
            <div>
              <div className="text-[11px] font-semibold uppercase tracking-wider text-zinc-600">Current page</div>
              <div className="mt-1 text-[10px] text-zinc-600">
                {activeResult.mode === "native" && `${nativeWords.length} native text blocks`}
                {activeResult.mode === "scan" && `${scanWords.length} reconstructed scan lines`}
                {activeResult.mode === "mixed" && `${nativeWords.length} native blocks + ${scanWords.length} scan lines`}
                {averageConfidence !== null ? ` · ${averageConfidence}% scan confidence` : ""}
                {editedCount ? ` · ${editedCount} edited` : ""}
              </div>
            </div>
            <button title="Copy editable text" onClick={onCopyText} className="rounded-lg p-2 text-zinc-500 hover:bg-white/5 hover:text-white"><Copy size={14} /></button>
          </div>
          <textarea readOnly value={activeResult.text} className="h-36 w-full resize-y rounded-xl border border-white/8 bg-white/[0.025] p-2.5 text-[11px] leading-5 text-zinc-400 outline-none" />
          <button onClick={onClearPage} className="mt-2 flex w-full items-center justify-center gap-2 rounded-xl border border-red-500/15 bg-red-500/[0.04] py-2 text-[11px] text-red-300 hover:bg-red-500/10"><Trash2 size={13} /> Clear editable text on this page</button>
        </section>
      ) : (
        <div className="rounded-xl border border-white/7 bg-white/[0.02] p-3 text-[11px] leading-5 text-zinc-500">No editable text model on {activePage?.label || "this page"}. Prepare the page: real PDF text is used directly when available; scanned pages fall back to OCR reconstruction.</div>
      )}

      {recognizedCount > 0 && <button onClick={onClearAll} className="w-full py-1 text-[10px] text-zinc-600 hover:text-red-300">Clear editable text from all pages</button>}
    </div>
  );
}
