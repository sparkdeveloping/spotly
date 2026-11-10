(globalThis["TURBOPACK"] || (globalThis["TURBOPACK"] = [])).push([typeof document === "object" ? document.currentScript : undefined,
"[project]/components/ocr-panel.tsx [app-client] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "OcrPanel",
    ()=>OcrPanel
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/compiled/react/jsx-dev-runtime.js [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$copy$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Copy$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/copy.mjs [app-client] (ecmascript) <export default as Copy>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$loader$2d$circle$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__LoaderCircle$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/loader-circle.mjs [app-client] (ecmascript) <export default as LoaderCircle>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pencil$2d$line$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PencilLine$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/pencil-line.mjs [app-client] (ecmascript) <export default as PencilLine>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$scan$2d$text$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__ScanText$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/scan-text.mjs [app-client] (ecmascript) <export default as ScanText>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$search$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Search$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/search.mjs [app-client] (ecmascript) <export default as Search>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/trash.mjs [app-client] (ecmascript) <export default as Trash2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/ocr.ts [app-client] (ecmascript)");
"use client";
;
;
;
function OcrPanel({ activePage, activeResult, language, onLanguageChange, running, progress, recognizedCount, totalPages, onRecognizePage, onRecognizeAll, search, onSearchChange, searchHits, onSelectPage, selectable, onSelectableChange, onCopyText, onClearPage, onClearAll }) {
    const averageConfidence = activeResult?.words.length ? Math.round(activeResult.words.reduce((sum, word)=>sum + word.confidence, 0) / activeResult.words.length) : null;
    const totalMatches = searchHits.reduce((sum, item)=>sum + item.count, 0);
    const editedCount = activeResult?.words.filter((word)=>word.edited).length ?? 0;
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        className: "space-y-5",
        children: [
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mb-2 text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                        children: "Recognition"
                    }, void 0, false, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 57,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("label", {
                        className: "block text-[11px] text-zinc-500",
                        children: [
                            "Language",
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("select", {
                                value: language,
                                disabled: running,
                                onChange: (event)=>onLanguageChange(event.target.value),
                                className: "mt-2 w-full rounded-xl border border-white/8 bg-[#15171c] px-2.5 py-2 text-xs text-zinc-200 outline-none focus:border-blue-500/50 disabled:opacity-50",
                                children: __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["OCR_LANGUAGES"].map((item)=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("option", {
                                        value: item.code,
                                        children: item.label
                                    }, item.code, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 66,
                                        columnNumber: 42
                                    }, this))
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 60,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 58,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-3 grid grid-cols-2 gap-2",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                disabled: running || !activePage,
                                onClick: onRecognizePage,
                                className: "flex items-center justify-center gap-2 rounded-xl bg-blue-600 px-2 py-2 text-xs font-semibold text-white hover:bg-blue-500 disabled:opacity-45",
                                children: [
                                    running ? /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$loader$2d$circle$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__LoaderCircle$3e$__["LoaderCircle"], {
                                        size: 14,
                                        className: "animate-spin"
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 75,
                                        columnNumber: 24
                                    }, this) : /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$scan$2d$text$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__ScanText$3e$__["ScanText"], {
                                        size: 14
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 75,
                                        columnNumber: 78
                                    }, this),
                                    "This page"
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 70,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                disabled: running || totalPages === 0,
                                onClick: onRecognizeAll,
                                className: "rounded-xl border border-white/8 bg-white/[0.025] px-2 py-2 text-xs text-zinc-300 hover:bg-white/5 disabled:opacity-45",
                                children: "All pages"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 78,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 69,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-3 text-[10px] text-zinc-600",
                        children: [
                            recognizedCount,
                            "/",
                            totalPages,
                            " pages recognized"
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 86,
                        columnNumber: 9
                    }, this),
                    running && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-3 rounded-xl border border-blue-500/15 bg-blue-500/[0.05] p-3",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "mb-2 flex items-center justify-between gap-2 text-[10px] text-blue-200",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                        className: "truncate",
                                        children: progress.pageLabel || "Preparing OCR"
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 90,
                                        columnNumber: 15
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                        children: [
                                            Math.round(progress.progress * 100),
                                            "%"
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 91,
                                        columnNumber: 15
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 89,
                                columnNumber: 13
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "h-1.5 overflow-hidden rounded-full bg-white/8",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "h-full bg-blue-500 transition-[width]",
                                    style: {
                                        width: `${Math.round(progress.progress * 100)}%`
                                    }
                                }, void 0, false, {
                                    fileName: "[project]/components/ocr-panel.tsx",
                                    lineNumber: 93,
                                    columnNumber: 76
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 93,
                                columnNumber: 13
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "mt-2 truncate text-[10px] capitalize text-zinc-500",
                                children: progress.status || "Starting"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 94,
                                columnNumber: 13
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 88,
                        columnNumber: 11
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 56,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                className: "border-t border-white/7 pt-4",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mb-2 flex items-center justify-between",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                className: "text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                                children: "Search OCR"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 101,
                                columnNumber: 11
                            }, this),
                            search && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                className: "text-[10px] text-zinc-500",
                                children: [
                                    totalMatches,
                                    " match",
                                    totalMatches === 1 ? "" : "es"
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 102,
                                columnNumber: 22
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 100,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "relative",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$search$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Search$3e$__["Search"], {
                                size: 13,
                                className: "pointer-events-none absolute left-2.5 top-2.5 text-zinc-600"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 105,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                                value: search,
                                onChange: (event)=>onSearchChange(event.target.value),
                                placeholder: "Search recognized text",
                                className: "w-full rounded-xl border border-white/8 bg-white/[0.025] py-2 pl-8 pr-2.5 text-xs text-zinc-200 outline-none placeholder:text-zinc-700 focus:border-blue-500/50"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 106,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 104,
                        columnNumber: 9
                    }, this),
                    search && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-2 max-h-32 space-y-1 overflow-y-auto",
                        children: searchHits.length ? searchHits.map((hit)=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                onClick: ()=>onSelectPage(hit.pageId),
                                className: "flex w-full items-center justify-between rounded-lg px-2 py-1.5 text-left text-[11px] text-zinc-400 hover:bg-white/5 hover:text-zinc-200",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                        className: "truncate",
                                        children: hit.label
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 117,
                                        columnNumber: 17
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                        className: "ml-2 rounded bg-white/5 px-1.5 py-0.5 text-[10px]",
                                        children: hit.count
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 117,
                                        columnNumber: 62
                                    }, this)
                                ]
                            }, hit.pageId, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 116,
                                columnNumber: 15
                            }, this)) : /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "px-2 py-2 text-[10px] text-zinc-600",
                            children: "No recognized matches."
                        }, void 0, false, {
                            fileName: "[project]/components/ocr-panel.tsx",
                            lineNumber: 119,
                            columnNumber: 18
                        }, this)
                    }, void 0, false, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 114,
                        columnNumber: 11
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 99,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                className: "border-t border-white/7 pt-4",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                        disabled: !activeResult,
                        onClick: ()=>onSelectableChange(!selectable),
                        className: `flex w-full items-center justify-between rounded-xl border px-3 py-2 text-xs transition disabled:opacity-40 ${selectable ? "border-blue-500/30 bg-blue-500/10 text-blue-200" : "border-white/8 bg-white/[0.025] text-zinc-300 hover:bg-white/5"}`,
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                className: "flex items-center gap-2",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pencil$2d$line$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PencilLine$3e$__["PencilLine"], {
                                        size: 14
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 130,
                                        columnNumber: 53
                                    }, this),
                                    " Edit OCR text on page"
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 130,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                className: "text-[10px]",
                                children: selectable ? "On" : "Off"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 131,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 125,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-2 text-[10px] leading-4 text-zinc-600",
                        children: "Turn this on, then click any recognized word directly on the PDF and type its replacement. Enter or clicking away commits; Escape cancels. Delete the word contents to visually remove it."
                    }, void 0, false, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 133,
                        columnNumber: 9
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 124,
                columnNumber: 7
            }, this),
            activeResult ? /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                className: "border-t border-white/7 pt-4",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mb-2 flex items-center justify-between",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                                        children: "Current page"
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 140,
                                        columnNumber: 15
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "mt-1 text-[10px] text-zinc-600",
                                        children: [
                                            activeResult.words.length,
                                            " words",
                                            averageConfidence !== null ? ` · ${averageConfidence}% avg confidence` : "",
                                            editedCount ? ` · ${editedCount} edited` : ""
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 141,
                                        columnNumber: 15
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 139,
                                columnNumber: 13
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "Copy recognized text",
                                onClick: onCopyText,
                                className: "rounded-lg p-2 text-zinc-500 hover:bg-white/5 hover:text-white",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$copy$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Copy$3e$__["Copy"], {
                                    size: 14
                                }, void 0, false, {
                                    fileName: "[project]/components/ocr-panel.tsx",
                                    lineNumber: 143,
                                    columnNumber: 146
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 143,
                                columnNumber: 13
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 138,
                        columnNumber: 11
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("textarea", {
                        readOnly: true,
                        value: activeResult.text,
                        className: "h-36 w-full resize-y rounded-xl border border-white/8 bg-white/[0.025] p-2.5 text-[11px] leading-5 text-zinc-400 outline-none"
                    }, void 0, false, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 145,
                        columnNumber: 11
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                        onClick: onClearPage,
                        className: "mt-2 flex w-full items-center justify-center gap-2 rounded-xl border border-red-500/15 bg-red-500/[0.04] py-2 text-[11px] text-red-300 hover:bg-red-500/10",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__["Trash2"], {
                                size: 13
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 146,
                                columnNumber: 208
                            }, this),
                            " Clear OCR on this page"
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 146,
                        columnNumber: 11
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 137,
                columnNumber: 9
            }, this) : /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "rounded-xl border border-white/7 bg-white/[0.02] p-3 text-[11px] leading-5 text-zinc-500",
                children: [
                    "No OCR layer on ",
                    activePage?.label || "this page",
                    ". Recognize the page to make scanned text directly editable in place."
                ]
            }, void 0, true, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 149,
                columnNumber: 9
            }, this),
            recognizedCount > 0 && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                onClick: onClearAll,
                className: "w-full py-1 text-[10px] text-zinc-600 hover:text-red-300",
                children: "Clear OCR from all pages"
            }, void 0, false, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 152,
                columnNumber: 31
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/ocr-panel.tsx",
        lineNumber: 55,
        columnNumber: 5
    }, this);
}
_c = OcrPanel;
var _c;
__turbopack_context__.k.register(_c, "OcrPanel");
if (typeof globalThis.$RefreshHelpers$ === 'object' && globalThis.$RefreshHelpers !== null) {
    __turbopack_context__.k.registerExports(__turbopack_context__.m, globalThis.$RefreshHelpers$);
}
}),
"[project]/components/page-thumbnail.tsx [app-client] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "PageThumbnail",
    ()=>PageThumbnail
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/compiled/react/jsx-dev-runtime.js [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$grip$2d$vertical$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__GripVertical$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/grip-vertical.mjs [app-client] (ecmascript) <export default as GripVertical>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$rotate$2d$cw$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__RotateCw$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/rotate-cw.mjs [app-client] (ecmascript) <export default as RotateCw>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/trash.mjs [app-client] (ecmascript) <export default as Trash2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/compiled/react/index.js [app-client] (ecmascript)");
;
var _s = __turbopack_context__.k.signature();
"use client";
;
;
function PageThumbnail({ pdf, page, index, active, onSelect, onDelete, onRotate, onDragStart, onDrop }) {
    _s();
    const ref = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useRef"])(null);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useEffect"])({
        "PageThumbnail.useEffect": ()=>{
            let cancelled = false;
            ({
                "PageThumbnail.useEffect": async ()=>{
                    const proxy = await pdf.getPage(page.sourceIndex + 1);
                    const viewport = proxy.getViewport({
                        scale: 0.22,
                        rotation: page.rotation
                    });
                    const canvas = ref.current;
                    if (!canvas || cancelled) return;
                    const ratio = Math.min(window.devicePixelRatio || 1, 2);
                    canvas.width = viewport.width * ratio;
                    canvas.height = viewport.height * ratio;
                    canvas.style.width = `${viewport.width}px`;
                    canvas.style.height = `${viewport.height}px`;
                    const ctx = canvas.getContext("2d");
                    if (!ctx) return;
                    await proxy.render({
                        canvasContext: ctx,
                        viewport,
                        transform: ratio === 1 ? undefined : [
                            ratio,
                            0,
                            0,
                            ratio,
                            0,
                            0
                        ]
                    }).promise;
                }
            })["PageThumbnail.useEffect"]();
            return ({
                "PageThumbnail.useEffect": ()=>{
                    cancelled = true;
                }
            })["PageThumbnail.useEffect"];
        }
    }["PageThumbnail.useEffect"], [
        pdf,
        page.sourceIndex,
        page.rotation
    ]);
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        draggable: true,
        onDragStart: onDragStart,
        onDragOver: (e)=>e.preventDefault(),
        onDrop: (e)=>{
            e.preventDefault();
            onDrop();
        },
        onClick: onSelect,
        className: `group relative cursor-pointer rounded-xl border p-2 transition ${active ? "border-blue-500/80 bg-blue-500/10" : "border-white/8 bg-white/[0.025] hover:border-white/15 hover:bg-white/[0.045]"}`,
        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
            className: "flex items-start gap-2",
            children: [
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$grip$2d$vertical$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__GripVertical$3e$__["GripVertical"], {
                    size: 14,
                    className: "mt-1 shrink-0 text-zinc-600 group-hover:text-zinc-400"
                }, void 0, false, {
                    fileName: "[project]/components/page-thumbnail.tsx",
                    lineNumber: 61,
                    columnNumber: 9
                }, this),
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                    className: "min-w-0 flex-1",
                    children: [
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "flex min-h-[118px] items-center justify-center overflow-hidden rounded-md bg-zinc-800 p-1 shadow-inner",
                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("canvas", {
                                ref: ref,
                                className: "max-h-[126px] max-w-full bg-white shadow"
                            }, void 0, false, {
                                fileName: "[project]/components/page-thumbnail.tsx",
                                lineNumber: 64,
                                columnNumber: 13
                            }, this)
                        }, void 0, false, {
                            fileName: "[project]/components/page-thumbnail.tsx",
                            lineNumber: 63,
                            columnNumber: 11
                        }, this),
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "mt-2 flex items-center justify-between",
                            children: [
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                    className: "text-[11px] font-medium text-zinc-400",
                                    children: [
                                        "Page ",
                                        index + 1
                                    ]
                                }, void 0, true, {
                                    fileName: "[project]/components/page-thumbnail.tsx",
                                    lineNumber: 67,
                                    columnNumber: 13
                                }, this),
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "flex opacity-0 transition group-hover:opacity-100",
                                    children: [
                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                            className: "rounded p-1 text-zinc-500 hover:bg-white/10 hover:text-white",
                                            onClick: (e)=>{
                                                e.stopPropagation();
                                                onRotate();
                                            },
                                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$rotate$2d$cw$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__RotateCw$3e$__["RotateCw"], {
                                                size: 13
                                            }, void 0, false, {
                                                fileName: "[project]/components/page-thumbnail.tsx",
                                                lineNumber: 69,
                                                columnNumber: 150
                                            }, this)
                                        }, void 0, false, {
                                            fileName: "[project]/components/page-thumbnail.tsx",
                                            lineNumber: 69,
                                            columnNumber: 15
                                        }, this),
                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                            className: "rounded p-1 text-zinc-500 hover:bg-red-500/10 hover:text-red-300",
                                            onClick: (e)=>{
                                                e.stopPropagation();
                                                onDelete();
                                            },
                                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__["Trash2"], {
                                                size: 13
                                            }, void 0, false, {
                                                fileName: "[project]/components/page-thumbnail.tsx",
                                                lineNumber: 70,
                                                columnNumber: 154
                                            }, this)
                                        }, void 0, false, {
                                            fileName: "[project]/components/page-thumbnail.tsx",
                                            lineNumber: 70,
                                            columnNumber: 15
                                        }, this)
                                    ]
                                }, void 0, true, {
                                    fileName: "[project]/components/page-thumbnail.tsx",
                                    lineNumber: 68,
                                    columnNumber: 13
                                }, this)
                            ]
                        }, void 0, true, {
                            fileName: "[project]/components/page-thumbnail.tsx",
                            lineNumber: 66,
                            columnNumber: 11
                        }, this)
                    ]
                }, void 0, true, {
                    fileName: "[project]/components/page-thumbnail.tsx",
                    lineNumber: 62,
                    columnNumber: 9
                }, this)
            ]
        }, void 0, true, {
            fileName: "[project]/components/page-thumbnail.tsx",
            lineNumber: 60,
            columnNumber: 7
        }, this)
    }, void 0, false, {
        fileName: "[project]/components/page-thumbnail.tsx",
        lineNumber: 52,
        columnNumber: 5
    }, this);
}
_s(PageThumbnail, "8uVE59eA/r6b92xF80p7sH8rXLk=");
_c = PageThumbnail;
var _c;
__turbopack_context__.k.register(_c, "PageThumbnail");
if (typeof globalThis.$RefreshHelpers$ === 'object' && globalThis.$RefreshHelpers !== null) {
    __turbopack_context__.k.registerExports(__turbopack_context__.m, globalThis.$RefreshHelpers$);
}
}),
"[project]/components/pdf-editor.tsx [app-client] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "PdfEditor",
    ()=>PdfEditor
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/compiled/react/jsx-dev-runtime.js [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/framer-motion/dist/es/components/AnimatePresence/index.mjs [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$locals$3e$__ = __turbopack_context__.i("[project]/node_modules/motion/dist/es/react.mjs [app-client] (ecmascript) <locals>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$circle$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Circle$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/circle.mjs [app-client] (ecmascript) <export default as Circle>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$copy$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Copy$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/copy.mjs [app-client] (ecmascript) <export default as Copy>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$download$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Download$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/download.mjs [app-client] (ecmascript) <export default as Download>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$file$2d$plus$2d$corner$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__FilePlus2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/file-plus-corner.mjs [app-client] (ecmascript) <export default as FilePlus2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$highlighter$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Highlighter$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/highlighter.mjs [app-client] (ecmascript) <export default as Highlighter>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$image$2d$plus$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__ImagePlus$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/image-plus.mjs [app-client] (ecmascript) <export default as ImagePlus>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$loader$2d$circle$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__LoaderCircle$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/loader-circle.mjs [app-client] (ecmascript) <export default as LoaderCircle>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$mouse$2d$pointer$2d$2$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__MousePointer2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/mouse-pointer-2.mjs [app-client] (ecmascript) <export default as MousePointer2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$left$2d$close$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelLeftClose$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/panel-left-close.mjs [app-client] (ecmascript) <export default as PanelLeftClose>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$left$2d$open$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelLeftOpen$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/panel-left-open.mjs [app-client] (ecmascript) <export default as PanelLeftOpen>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$right$2d$close$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelRightClose$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/panel-right-close.mjs [app-client] (ecmascript) <export default as PanelRightClose>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$right$2d$open$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelRightOpen$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/panel-right-open.mjs [app-client] (ecmascript) <export default as PanelRightOpen>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pen$2d$line$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PenLine$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/pen-line.mjs [app-client] (ecmascript) <export default as PenLine>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pencil$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Pencil$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/pencil.mjs [app-client] (ecmascript) <export default as Pencil>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$plus$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Plus$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/plus.mjs [app-client] (ecmascript) <export default as Plus>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$redo$2d$2$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Redo2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/redo-2.mjs [app-client] (ecmascript) <export default as Redo2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$rotate$2d$cw$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__RotateCw$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/rotate-cw.mjs [app-client] (ecmascript) <export default as RotateCw>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$scan$2d$text$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__ScanText$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/scan-text.mjs [app-client] (ecmascript) <export default as ScanText>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$square$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Square$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/square.mjs [app-client] (ecmascript) <export default as Square>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/trash.mjs [app-client] (ecmascript) <export default as Trash2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$type$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Type$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/type.mjs [app-client] (ecmascript) <export default as Type>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$undo$2d$2$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Undo2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/undo-2.mjs [app-client] (ecmascript) <export default as Undo2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$upload$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Upload$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/upload.mjs [app-client] (ecmascript) <export default as Upload>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$zoom$2d$in$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__ZoomIn$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/zoom-in.mjs [app-client] (ecmascript) <export default as ZoomIn>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$zoom$2d$out$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__ZoomOut$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/zoom-out.mjs [app-client] (ecmascript) <export default as ZoomOut>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/compiled/react/index.js [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$components$2f$pdf$2d$page$2e$tsx__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/components/pdf-page.tsx [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$components$2f$page$2d$thumbnail$2e$tsx__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/components/page-thumbnail.tsx [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$components$2f$ocr$2d$panel$2e$tsx__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/components/ocr-panel.tsx [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$components$2f$signature$2d$dialog$2e$tsx__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/components/signature-dialog.tsx [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$export$2d$pdf$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/export-pdf.ts [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/ocr.ts [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/utils.ts [app-client] (ecmascript)");
;
var _s = __turbopack_context__.k.signature();
"use client";
;
;
;
;
;
;
;
;
;
;
const tools = [
    {
        id: "select",
        label: "Select",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$mouse$2d$pointer$2d$2$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__MousePointer2$3e$__["MousePointer2"],
        shortcut: "V"
    },
    {
        id: "text",
        label: "Text",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$type$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Type$3e$__["Type"],
        shortcut: "T"
    },
    {
        id: "highlight",
        label: "Highlight",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$highlighter$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Highlighter$3e$__["Highlighter"],
        shortcut: "H"
    },
    {
        id: "rect",
        label: "Rectangle",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$square$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Square$3e$__["Square"],
        shortcut: "R"
    },
    {
        id: "ellipse",
        label: "Ellipse",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$circle$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Circle$3e$__["Circle"],
        shortcut: "O"
    },
    {
        id: "draw",
        label: "Draw",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pencil$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Pencil$3e$__["Pencil"],
        shortcut: "P"
    }
];
function PdfEditor() {
    _s();
    const [pdf, setPdf] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(null);
    const [sourceBytes, setSourceBytes] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(null);
    const [filename, setFilename] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])("document.pdf");
    const [pages, setPages] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])([]);
    const [annotations, setAnnotations] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])([]);
    const [activePageId, setActivePageId] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(null);
    const [selectedId, setSelectedId] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(null);
    const [tool, setTool] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])("select");
    const [zoom, setZoom] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(0.95);
    const [leftOpen, setLeftOpen] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(true);
    const [rightOpen, setRightOpen] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(true);
    const [past, setPast] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])([]);
    const [future, setFuture] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])([]);
    const [dragIndex, setDragIndex] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(null);
    const [loading, setLoading] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(false);
    const [exporting, setExporting] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(false);
    const [error, setError] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(null);
    const [signatureOpen, setSignatureOpen] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(false);
    const [pendingImage, setPendingImage] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(null);
    const [defaults, setDefaults] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])({
        color: "#2563eb",
        opacity: 1,
        strokeWidth: 2,
        fontSize: 18
    });
    const [rightPanel, setRightPanel] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])("properties");
    const [ocrResults, setOcrResults] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])([]);
    const [ocrLanguage, setOcrLanguage] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])("eng");
    const [ocrRunning, setOcrRunning] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(false);
    const [ocrProgress, setOcrProgress] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])({
        progress: 0,
        status: "",
        pageLabel: ""
    });
    const [ocrSearch, setOcrSearch] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])("");
    const [ocrSelectable, setOcrSelectable] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(false);
    const fileInput = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useRef"])(null);
    const imageInput = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useRef"])(null);
    const activePage = pages.find((page)=>page.id === activePageId) ?? pages[0] ?? null;
    const selected = annotations.find((annotation)=>annotation.id === selectedId) ?? null;
    const pageAnnotations = activePage ? annotations.filter((annotation)=>annotation.pageId === activePage.id) : [];
    const activeOcrResult = activePage ? ocrResults.find((result)=>result.pageId === activePage.id) ?? null : null;
    const normalizedOcrSearch = ocrSearch.trim().toLocaleLowerCase();
    const ocrSearchTerms = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useMemo"])({
        "PdfEditor.useMemo[ocrSearchTerms]": ()=>normalizedOcrSearch.split(/\s+/).filter(Boolean)
    }["PdfEditor.useMemo[ocrSearchTerms]"], [
        normalizedOcrSearch
    ]);
    const ocrSearchHits = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useMemo"])({
        "PdfEditor.useMemo[ocrSearchHits]": ()=>{
            if (!ocrSearchTerms.length) return [];
            return pages.flatMap({
                "PdfEditor.useMemo[ocrSearchHits]": (page)=>{
                    const result = ocrResults.find({
                        "PdfEditor.useMemo[ocrSearchHits].result": (item)=>item.pageId === page.id
                    }["PdfEditor.useMemo[ocrSearchHits].result"]);
                    if (!result) return [];
                    const count = result.words.filter({
                        "PdfEditor.useMemo[ocrSearchHits]": (word)=>{
                            const value = word.text.toLocaleLowerCase();
                            return ocrSearchTerms.some({
                                "PdfEditor.useMemo[ocrSearchHits]": (term)=>value.includes(term)
                            }["PdfEditor.useMemo[ocrSearchHits]"]);
                        }
                    }["PdfEditor.useMemo[ocrSearchHits]"]).length;
                    return count ? [
                        {
                            pageId: page.id,
                            label: page.label,
                            count
                        }
                    ] : [];
                }
            }["PdfEditor.useMemo[ocrSearchHits]"]);
        }
    }["PdfEditor.useMemo[ocrSearchHits]"], [
        ocrSearchTerms,
        ocrResults,
        pages
    ]);
    const snapshot = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[snapshot]": ()=>({
                pages: structuredClone(pages),
                annotations: structuredClone(annotations),
                ocrResults: structuredClone(ocrResults)
            })
    }["PdfEditor.useCallback[snapshot]"], [
        pages,
        annotations,
        ocrResults
    ]);
    const checkpoint = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[checkpoint]": ()=>{
            const current = snapshot();
            setPast({
                "PdfEditor.useCallback[checkpoint]": (items)=>[
                        ...items.slice(-49),
                        current
                    ]
            }["PdfEditor.useCallback[checkpoint]"]);
            setFuture([]);
        }
    }["PdfEditor.useCallback[checkpoint]"], [
        snapshot
    ]);
    const undo = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[undo]": ()=>{
            if (!past.length) return;
            const previous = past[past.length - 1];
            setPast({
                "PdfEditor.useCallback[undo]": (items)=>items.slice(0, -1)
            }["PdfEditor.useCallback[undo]"]);
            setFuture({
                "PdfEditor.useCallback[undo]": (items)=>[
                        snapshot(),
                        ...items
                    ].slice(0, 50)
            }["PdfEditor.useCallback[undo]"]);
            setPages(previous.pages);
            setAnnotations(previous.annotations);
            setOcrResults(previous.ocrResults);
            setSelectedId(null);
        }
    }["PdfEditor.useCallback[undo]"], [
        past,
        snapshot
    ]);
    const redo = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[redo]": ()=>{
            if (!future.length) return;
            const next = future[0];
            setFuture({
                "PdfEditor.useCallback[redo]": (items)=>items.slice(1)
            }["PdfEditor.useCallback[redo]"]);
            setPast({
                "PdfEditor.useCallback[redo]": (items)=>[
                        ...items.slice(-49),
                        snapshot()
                    ]
            }["PdfEditor.useCallback[redo]"]);
            setPages(next.pages);
            setAnnotations(next.annotations);
            setOcrResults(next.ocrResults);
            setSelectedId(null);
        }
    }["PdfEditor.useCallback[redo]"], [
        future,
        snapshot
    ]);
    const openFile = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[openFile]": async (file)=>{
            if (!file || file.type !== "application/pdf") {
                setError("Choose a PDF file.");
                return;
            }
            setLoading(true);
            setError(null);
            try {
                const bytes = new Uint8Array(await file.arrayBuffer());
                const pdfjs = await __turbopack_context__.A("[project]/node_modules/pdfjs-dist/build/pdf.mjs [app-client] (ecmascript, async loader)");
                pdfjs.GlobalWorkerOptions.workerSrc = "/pdf.worker.min.mjs";
                const task = pdfjs.getDocument({
                    data: bytes.slice()
                });
                const document = await task.promise;
                const loadedPages = [];
                for(let index = 0; index < document.numPages; index++){
                    const proxy = await document.getPage(index + 1);
                    const normalizedRotation = ((proxy.rotate || 0) % 360 + 360) % 360;
                    loadedPages.push({
                        id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["uid"])("page"),
                        sourceIndex: index,
                        rotation: normalizedRotation,
                        label: `Page ${index + 1}`
                    });
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
            } finally{
                setLoading(false);
            }
        }
    }["PdfEditor.useCallback[openFile]"], []);
    const patchAnnotation = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[patchAnnotation]": (id, patch)=>{
            setAnnotations({
                "PdfEditor.useCallback[patchAnnotation]": (items)=>items.map({
                        "PdfEditor.useCallback[patchAnnotation]": (item)=>item.id === id ? {
                                ...item,
                                ...patch
                            } : item
                    }["PdfEditor.useCallback[patchAnnotation]"])
            }["PdfEditor.useCallback[patchAnnotation]"]);
        }
    }["PdfEditor.useCallback[patchAnnotation]"], []);
    const deleteSelected = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[deleteSelected]": ()=>{
            if (!selectedId) return;
            checkpoint();
            setAnnotations({
                "PdfEditor.useCallback[deleteSelected]": (items)=>items.filter({
                        "PdfEditor.useCallback[deleteSelected]": (item)=>item.id !== selectedId
                    }["PdfEditor.useCallback[deleteSelected]"])
            }["PdfEditor.useCallback[deleteSelected]"]);
            setSelectedId(null);
        }
    }["PdfEditor.useCallback[deleteSelected]"], [
        selectedId,
        checkpoint
    ]);
    const rotatePage = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[rotatePage]": async (pageId)=>{
            const page = pages.find({
                "PdfEditor.useCallback[rotatePage].page": (item)=>item.id === pageId
            }["PdfEditor.useCallback[rotatePage].page"]);
            if (!page || !pdf) return;
            checkpoint();
            const nextRotation = (page.rotation + 90) % 360;
            const proxy = await pdf.getPage(page.sourceIndex + 1);
            const oldViewport = proxy.getViewport({
                scale: 1,
                rotation: page.rotation
            });
            const newViewport = proxy.getViewport({
                scale: 1,
                rotation: nextRotation
            });
            const transformPoint = {
                "PdfEditor.useCallback[rotatePage].transformPoint": (x, y)=>{
                    const [pdfX, pdfY] = oldViewport.convertToPdfPoint(x, y);
                    const [nextX, nextY] = newViewport.convertToViewportPoint(pdfX, pdfY);
                    return {
                        x: nextX,
                        y: nextY
                    };
                }
            }["PdfEditor.useCallback[rotatePage].transformPoint"];
            setPages({
                "PdfEditor.useCallback[rotatePage]": (items)=>items.map({
                        "PdfEditor.useCallback[rotatePage]": (item)=>item.id === pageId ? {
                                ...item,
                                rotation: nextRotation
                            } : item
                    }["PdfEditor.useCallback[rotatePage]"])
            }["PdfEditor.useCallback[rotatePage]"]);
            setAnnotations({
                "PdfEditor.useCallback[rotatePage]": (items)=>items.map({
                        "PdfEditor.useCallback[rotatePage]": (annotation)=>{
                            if (annotation.pageId !== pageId) return annotation;
                            if (annotation.type === "draw" && annotation.points) {
                                const points = annotation.points.map({
                                    "PdfEditor.useCallback[rotatePage].points": (point)=>transformPoint(point.x, point.y)
                                }["PdfEditor.useCallback[rotatePage].points"]);
                                const xs = points.map({
                                    "PdfEditor.useCallback[rotatePage].xs": (point)=>point.x
                                }["PdfEditor.useCallback[rotatePage].xs"]);
                                const ys = points.map({
                                    "PdfEditor.useCallback[rotatePage].ys": (point)=>point.y
                                }["PdfEditor.useCallback[rotatePage].ys"]);
                                return {
                                    ...annotation,
                                    points,
                                    x: Math.min(...xs),
                                    y: Math.min(...ys),
                                    width: Math.max(...xs) - Math.min(...xs),
                                    height: Math.max(...ys) - Math.min(...ys)
                                };
                            }
                            const a = transformPoint(annotation.x, annotation.y);
                            const b = transformPoint(annotation.x + annotation.width, annotation.y + annotation.height);
                            return {
                                ...annotation,
                                x: Math.min(a.x, b.x),
                                y: Math.min(a.y, b.y),
                                width: Math.abs(b.x - a.x),
                                height: Math.abs(b.y - a.y)
                            };
                        }
                    }["PdfEditor.useCallback[rotatePage]"])
            }["PdfEditor.useCallback[rotatePage]"]);
            setOcrResults({
                "PdfEditor.useCallback[rotatePage]": (items)=>items.filter({
                        "PdfEditor.useCallback[rotatePage]": (result)=>result.pageId !== pageId
                    }["PdfEditor.useCallback[rotatePage]"])
            }["PdfEditor.useCallback[rotatePage]"]);
        }
    }["PdfEditor.useCallback[rotatePage]"], [
        pages,
        pdf,
        checkpoint
    ]);
    const deletePage = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[deletePage]": (pageId)=>{
            if (pages.length <= 1) return;
            checkpoint();
            const index = pages.findIndex({
                "PdfEditor.useCallback[deletePage].index": (page)=>page.id === pageId
            }["PdfEditor.useCallback[deletePage].index"]);
            const next = pages.filter({
                "PdfEditor.useCallback[deletePage].next": (page)=>page.id !== pageId
            }["PdfEditor.useCallback[deletePage].next"]);
            setPages(next);
            setAnnotations({
                "PdfEditor.useCallback[deletePage]": (items)=>items.filter({
                        "PdfEditor.useCallback[deletePage]": (item)=>item.pageId !== pageId
                    }["PdfEditor.useCallback[deletePage]"])
            }["PdfEditor.useCallback[deletePage]"]);
            setOcrResults({
                "PdfEditor.useCallback[deletePage]": (items)=>items.filter({
                        "PdfEditor.useCallback[deletePage]": (item)=>item.pageId !== pageId
                    }["PdfEditor.useCallback[deletePage]"])
            }["PdfEditor.useCallback[deletePage]"]);
            if (activePageId === pageId) setActivePageId(next[Math.min(index, next.length - 1)]?.id ?? null);
            setSelectedId(null);
        }
    }["PdfEditor.useCallback[deletePage]"], [
        pages,
        checkpoint,
        activePageId
    ]);
    const duplicatePage = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[duplicatePage]": ()=>{
            if (!activePage) return;
            checkpoint();
            const copyId = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["uid"])("page");
            const pageCopy = {
                ...activePage,
                id: copyId,
                label: `${activePage.label} copy`
            };
            const index = pages.findIndex({
                "PdfEditor.useCallback[duplicatePage].index": (page)=>page.id === activePage.id
            }["PdfEditor.useCallback[duplicatePage].index"]);
            setPages({
                "PdfEditor.useCallback[duplicatePage]": (items)=>[
                        ...items.slice(0, index + 1),
                        pageCopy,
                        ...items.slice(index + 1)
                    ]
            }["PdfEditor.useCallback[duplicatePage]"]);
            const copiedAnnotations = annotations.filter({
                "PdfEditor.useCallback[duplicatePage].copiedAnnotations": (annotation)=>annotation.pageId === activePage.id
            }["PdfEditor.useCallback[duplicatePage].copiedAnnotations"]).map({
                "PdfEditor.useCallback[duplicatePage].copiedAnnotations": (annotation)=>({
                        ...structuredClone(annotation),
                        id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["uid"])("ann"),
                        pageId: copyId
                    })
            }["PdfEditor.useCallback[duplicatePage].copiedAnnotations"]);
            setAnnotations({
                "PdfEditor.useCallback[duplicatePage]": (items)=>[
                        ...items,
                        ...copiedAnnotations
                    ]
            }["PdfEditor.useCallback[duplicatePage]"]);
            const sourceOcr = ocrResults.find({
                "PdfEditor.useCallback[duplicatePage].sourceOcr": (result)=>result.pageId === activePage.id
            }["PdfEditor.useCallback[duplicatePage].sourceOcr"]);
            if (sourceOcr) {
                setOcrResults({
                    "PdfEditor.useCallback[duplicatePage]": (items)=>[
                            ...items,
                            {
                                ...structuredClone(sourceOcr),
                                pageId: copyId,
                                words: sourceOcr.words.map({
                                    "PdfEditor.useCallback[duplicatePage]": (word, index)=>({
                                            ...word,
                                            id: `ocr_${copyId}_${index}`,
                                            pageId: copyId
                                        })
                                }["PdfEditor.useCallback[duplicatePage]"])
                            }
                        ]
                }["PdfEditor.useCallback[duplicatePage]"]);
            }
            setActivePageId(copyId);
        }
    }["PdfEditor.useCallback[duplicatePage]"], [
        activePage,
        pages,
        annotations,
        ocrResults,
        checkpoint
    ]);
    const movePage = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[movePage]": (from, to)=>{
            if (from === to) return;
            checkpoint();
            setPages({
                "PdfEditor.useCallback[movePage]": (items)=>{
                    const next = [
                        ...items
                    ];
                    const [moved] = next.splice(from, 1);
                    next.splice(to, 0, moved);
                    return next;
                }
            }["PdfEditor.useCallback[movePage]"]);
        }
    }["PdfEditor.useCallback[movePage]"], [
        checkpoint
    ]);
    const recognizePages = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[recognizePages]": async (targetPages)=>{
            if (!pdf || !targetPages.length || ocrRunning) return;
            checkpoint();
            setOcrRunning(true);
            setError(null);
            setOcrSelectable(false);
            let worker = null;
            let pageCursor = 0;
            try {
                const { createWorker } = await __turbopack_context__.A("[project]/node_modules/tesseract.js/src/index.js [app-client] (ecmascript, async loader)");
                worker = await createWorker(ocrLanguage, 1, {
                    logger: {
                        "PdfEditor.useCallback[recognizePages]": (message)=>{
                            const withinPage = typeof message.progress === "number" ? message.progress : 0;
                            const overall = (pageCursor + withinPage) / targetPages.length;
                            setOcrProgress({
                                "PdfEditor.useCallback[recognizePages]": (current)=>({
                                        ...current,
                                        progress: Math.min(0.99, overall),
                                        status: message.status || current.status || "Recognizing text"
                                    })
                            }["PdfEditor.useCallback[recognizePages]"]);
                        }
                    }["PdfEditor.useCallback[recognizePages]"]
                });
                // Ask Tesseract for font metadata when available. LSTM models do not
                // always return a useful family name, so the OCR parser also performs
                // visual fallback matching and uses line metrics for size/baseline.
                await worker.setParameters?.({
                    hocr_font_info: "1",
                    preserve_interword_spaces: "1"
                });
                for(let index = 0; index < targetPages.length; index++){
                    pageCursor = index;
                    const page = targetPages[index];
                    setOcrProgress({
                        progress: index / targetPages.length,
                        status: "Rendering page",
                        pageLabel: page.label
                    });
                    const rendered = await (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["renderPageForOcr"])(pdf, page);
                    const response = await worker.recognize(rendered.canvas, {}, {
                        text: true,
                        blocks: true,
                        tsv: true
                    });
                    const structuredWords = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["parseBlockWords"])({
                        blocks: response.data.blocks,
                        pageId: page.id,
                        canvasWidth: rendered.canvas.width,
                        canvasHeight: rendered.canvas.height,
                        baseWidth: rendered.baseWidth,
                        baseHeight: rendered.baseHeight,
                        canvas: rendered.canvas
                    });
                    const words = structuredWords.length ? structuredWords : (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["parseTsvWords"])({
                        tsv: response.data.tsv || "",
                        pageId: page.id,
                        canvasWidth: rendered.canvas.width,
                        canvasHeight: rendered.canvas.height,
                        baseWidth: rendered.baseWidth,
                        baseHeight: rendered.baseHeight,
                        canvas: rendered.canvas
                    });
                    const result = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["makeOcrResult"])({
                        page,
                        language: ocrLanguage,
                        text: response.data.text || "",
                        words
                    });
                    setOcrResults({
                        "PdfEditor.useCallback[recognizePages]": (items)=>[
                                ...items.filter({
                                    "PdfEditor.useCallback[recognizePages]": (item)=>item.pageId !== page.id
                                }["PdfEditor.useCallback[recognizePages]"]),
                                result
                            ]
                    }["PdfEditor.useCallback[recognizePages]"]);
                    setOcrProgress({
                        progress: (index + 1) / targetPages.length,
                        status: `${words.length} words recognized`,
                        pageLabel: page.label
                    });
                }
                setOcrSelectable(true);
            } catch (cause) {
                console.error(cause);
                setError("OCR failed. Check your network connection for the language model, then try again.");
            } finally{
                try {
                    await worker?.terminate?.();
                } catch  {}
                setOcrRunning(false);
            }
        }
    }["PdfEditor.useCallback[recognizePages]"], [
        pdf,
        ocrLanguage,
        ocrRunning,
        checkpoint
    ]);
    const clearOcrPage = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[clearOcrPage]": (pageId)=>{
            checkpoint();
            setOcrResults({
                "PdfEditor.useCallback[clearOcrPage]": (items)=>items.filter({
                        "PdfEditor.useCallback[clearOcrPage]": (item)=>item.pageId !== pageId
                    }["PdfEditor.useCallback[clearOcrPage]"])
            }["PdfEditor.useCallback[clearOcrPage]"]);
            setOcrSelectable(false);
        }
    }["PdfEditor.useCallback[clearOcrPage]"], [
        checkpoint
    ]);
    const clearAllOcr = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[clearAllOcr]": ()=>{
            if (!ocrResults.length) return;
            checkpoint();
            setOcrResults([]);
            setOcrSelectable(false);
        }
    }["PdfEditor.useCallback[clearAllOcr]"], [
        ocrResults.length,
        checkpoint
    ]);
    const patchOcrWord = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[patchOcrWord]": (pageId, wordId, text)=>{
            setOcrResults({
                "PdfEditor.useCallback[patchOcrWord]": (items)=>items.map({
                        "PdfEditor.useCallback[patchOcrWord]": (result)=>{
                            if (result.pageId !== pageId) return result;
                            const words = result.words.map({
                                "PdfEditor.useCallback[patchOcrWord].words": (word)=>word.id === wordId ? {
                                        ...word,
                                        text,
                                        edited: text !== word.originalText
                                    } : word
                            }["PdfEditor.useCallback[patchOcrWord].words"]);
                            return {
                                ...result,
                                words,
                                text: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["ocrTextFromWords"])(words)
                            };
                        }
                    }["PdfEditor.useCallback[patchOcrWord]"])
            }["PdfEditor.useCallback[patchOcrWord]"]);
        }
    }["PdfEditor.useCallback[patchOcrWord]"], []);
    const copyOcrText = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[copyOcrText]": async ()=>{
            if (!activeOcrResult?.text) return;
            try {
                await navigator.clipboard.writeText(activeOcrResult.text);
            } catch  {
                setError("Could not copy OCR text to the clipboard.");
            }
        }
    }["PdfEditor.useCallback[copyOcrText]"], [
        activeOcrResult
    ]);
    const exportPdf = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useCallback"])({
        "PdfEditor.useCallback[exportPdf]": async ()=>{
            if (!pdf || !sourceBytes || !pages.length) return;
            setExporting(true);
            setError(null);
            try {
                const bytes = await (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$export$2d$pdf$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["exportEditedPdf"])({
                    sourceBytes,
                    pdfJsDocument: pdf,
                    pages,
                    annotations,
                    ocrResults
                });
                const base = filename.replace(/\.pdf$/i, "") || "document";
                (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["downloadBlob"])(bytes, `${base}-edited.pdf`);
            } catch (cause) {
                console.error(cause);
                setError("Export failed. Try removing a problematic image or reopening the PDF.");
            } finally{
                setExporting(false);
            }
        }
    }["PdfEditor.useCallback[exportPdf]"], [
        pdf,
        sourceBytes,
        pages,
        annotations,
        ocrResults,
        filename
    ]);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useEffect"])({
        "PdfEditor.useEffect": ()=>{
            const onKey = {
                "PdfEditor.useEffect.onKey": (event)=>{
                    const target = event.target;
                    const typing = target?.tagName === "INPUT" || target?.tagName === "TEXTAREA" || target?.isContentEditable;
                    const mod = event.metaKey || event.ctrlKey;
                    if (mod && event.key.toLowerCase() === "z") {
                        event.preventDefault();
                        event.shiftKey ? redo() : undo();
                    } else if (mod && event.key.toLowerCase() === "y") {
                        event.preventDefault();
                        redo();
                    } else if (!typing && (event.key === "Backspace" || event.key === "Delete")) {
                        event.preventDefault();
                        deleteSelected();
                    } else if (!typing && event.key === "Escape") {
                        setTool("select");
                        setSelectedId(null);
                        setPendingImage(null);
                        setOcrSelectable(false);
                    } else if (!typing && !mod) {
                        const key = event.key.toLowerCase();
                        const found = tools.find({
                            "PdfEditor.useEffect.onKey.found": (item)=>item.shortcut?.toLowerCase() === key
                        }["PdfEditor.useEffect.onKey.found"]);
                        if (found) setTool(found.id);
                    }
                }
            }["PdfEditor.useEffect.onKey"];
            window.addEventListener("keydown", onKey);
            return ({
                "PdfEditor.useEffect": ()=>window.removeEventListener("keydown", onKey)
            })["PdfEditor.useEffect"];
        }
    }["PdfEditor.useEffect"], [
        undo,
        redo,
        deleteSelected
    ]);
    const inspectorPatch = (patch)=>{
        if (!selected) return;
        checkpoint();
        patchAnnotation(selected.id, patch);
    };
    if (!pdf) {
        return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
            className: "relative flex h-dvh items-center justify-center overflow-hidden bg-[#090a0c] p-6",
            onDragOver: (e)=>e.preventDefault(),
            onDrop: (e)=>{
                e.preventDefault();
                const file = e.dataTransfer.files?.[0];
                if (file) openFile(file);
            },
            children: [
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                    className: "pointer-events-none absolute inset-0 opacity-50 [background-image:radial-gradient(circle_at_50%_0%,rgba(59,130,246,.16),transparent_32%),linear-gradient(rgba(255,255,255,.025)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,.025)_1px,transparent_1px)] [background-size:auto,32px_32px,32px_32px]"
                }, void 0, false, {
                    fileName: "[project]/components/pdf-editor.tsx",
                    lineNumber: 416,
                    columnNumber: 9
                }, this),
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
                    initial: {
                        opacity: 0,
                        y: 16
                    },
                    animate: {
                        opacity: 1,
                        y: 0
                    },
                    className: "relative w-full max-w-xl rounded-3xl border border-white/10 bg-[#111318]/95 p-7 shadow-2xl shadow-black/50 backdrop-blur-xl",
                    children: [
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "mb-8 flex items-center gap-3",
                            children: [
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "grid h-10 w-10 place-items-center rounded-xl bg-blue-600 shadow-lg shadow-blue-600/20",
                                    children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$file$2d$plus$2d$corner$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__FilePlus2$3e$__["FilePlus2"], {
                                        size: 20
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 419,
                                        columnNumber: 116
                                    }, this)
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 419,
                                    columnNumber: 13
                                }, this),
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    children: [
                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("h1", {
                                            className: "text-lg font-semibold tracking-tight",
                                            children: "PDF Studio"
                                        }, void 0, false, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 420,
                                            columnNumber: 18
                                        }, this),
                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("p", {
                                            className: "text-xs text-zinc-500",
                                            children: "Private, browser-first PDF editing"
                                        }, void 0, false, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 420,
                                            columnNumber: 86
                                        }, this)
                                    ]
                                }, void 0, true, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 420,
                                    columnNumber: 13
                                }, this)
                            ]
                        }, void 0, true, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 418,
                            columnNumber: 11
                        }, this),
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                            className: "group flex min-h-[260px] w-full flex-col items-center justify-center rounded-2xl border border-dashed border-white/15 bg-white/[0.025] px-8 transition hover:border-blue-500/50 hover:bg-blue-500/[0.04]",
                            onClick: ()=>fileInput.current?.click(),
                            children: [
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "mb-4 grid h-14 w-14 place-items-center rounded-2xl border border-white/10 bg-white/[0.04] text-zinc-300 transition group-hover:scale-105 group-hover:text-white",
                                    children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$upload$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Upload$3e$__["Upload"], {
                                        size: 24
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 426,
                                        columnNumber: 190
                                    }, this)
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 426,
                                    columnNumber: 13
                                }, this),
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "text-sm font-medium",
                                    children: "Drop a PDF here or click to open"
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 427,
                                    columnNumber: 13
                                }, this),
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "mt-2 max-w-sm text-center text-xs leading-5 text-zinc-500",
                                    children: "The document stays in your browser. Edit pages, add text, markup, drawings, images and signatures, then export a new PDF."
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 428,
                                    columnNumber: 13
                                }, this)
                            ]
                        }, void 0, true, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 422,
                            columnNumber: 11
                        }, this),
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                            ref: fileInput,
                            type: "file",
                            accept: "application/pdf",
                            className: "hidden",
                            onChange: (e)=>{
                                const file = e.target.files?.[0];
                                if (file) openFile(file);
                                e.currentTarget.value = "";
                            }
                        }, void 0, false, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 430,
                            columnNumber: 11
                        }, this),
                        loading && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "mt-4 flex items-center justify-center gap-2 text-xs text-zinc-400",
                            children: [
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$loader$2d$circle$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__LoaderCircle$3e$__["LoaderCircle"], {
                                    size: 14,
                                    className: "animate-spin"
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 431,
                                    columnNumber: 106
                                }, this),
                                " Opening PDF…"
                            ]
                        }, void 0, true, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 431,
                            columnNumber: 23
                        }, this),
                        error && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "mt-4 rounded-xl border border-red-500/20 bg-red-500/10 p-3 text-xs text-red-300",
                            children: error
                        }, void 0, false, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 432,
                            columnNumber: 21
                        }, this),
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "mt-5 flex items-center justify-between text-[11px] text-zinc-600",
                            children: [
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                    children: "Next.js · Tailwind · Motion"
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 433,
                                    columnNumber: 93
                                }, this),
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                    children: "PDF.js + pdf-lib"
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 433,
                                    columnNumber: 133
                                }, this)
                            ]
                        }, void 0, true, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 433,
                            columnNumber: 11
                        }, this)
                    ]
                }, void 0, true, {
                    fileName: "[project]/components/pdf-editor.tsx",
                    lineNumber: 417,
                    columnNumber: 9
                }, this)
            ]
        }, void 0, true, {
            fileName: "[project]/components/pdf-editor.tsx",
            lineNumber: 411,
            columnNumber: 7
        }, this);
    }
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        className: "flex h-dvh flex-col bg-[#0a0b0d] text-zinc-100",
        onDragOver: (e)=>e.preventDefault(),
        onDrop: (e)=>{
            const file = e.dataTransfer.files?.[0];
            if (file?.type === "application/pdf") {
                e.preventDefault();
                openFile(file);
            }
        },
        children: [
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("header", {
                className: "z-30 flex h-14 shrink-0 items-center border-b border-white/8 bg-[#0f1115]/95 px-3 backdrop-blur-xl",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "flex min-w-0 items-center gap-2",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                className: "grid h-8 w-8 place-items-center rounded-lg bg-blue-600",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$file$2d$plus$2d$corner$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__FilePlus2$3e$__["FilePlus2"], {
                                    size: 16
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 443,
                                    columnNumber: 86
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 443,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "min-w-0",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "max-w-[240px] truncate text-sm font-medium",
                                        children: filename
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 445,
                                        columnNumber: 13
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "text-[10px] text-zinc-600",
                                        children: [
                                            pages.length,
                                            " page",
                                            pages.length === 1 ? "" : "s",
                                            " · local editing"
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 446,
                                        columnNumber: 13
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 444,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 442,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mx-auto hidden items-center gap-1 rounded-xl border border-white/8 bg-white/[0.025] p-1 md:flex",
                        children: [
                            tools.map(({ id, label, icon: Icon, shortcut })=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                    title: `${label}${shortcut ? ` (${shortcut})` : ""}`,
                                    onClick: ()=>{
                                        setTool(id);
                                        setPendingImage(null);
                                        setOcrSelectable(false);
                                    },
                                    className: `grid h-8 w-8 place-items-center rounded-lg transition ${tool === id ? "bg-white text-black shadow" : "text-zinc-500 hover:bg-white/5 hover:text-zinc-200"}`,
                                    children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(Icon, {
                                        size: 15
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 452,
                                        columnNumber: 334
                                    }, this)
                                }, id, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 452,
                                    columnNumber: 13
                                }, this)),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "mx-1 h-5 w-px bg-white/8"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 454,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "Insert image",
                                onClick: ()=>imageInput.current?.click(),
                                className: `grid h-8 w-8 place-items-center rounded-lg text-zinc-500 transition hover:bg-white/5 hover:text-zinc-200 ${tool === "image" && pendingImage ? "bg-white text-black" : ""}`,
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$image$2d$plus$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__ImagePlus$3e$__["ImagePlus"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 455,
                                    columnNumber: 268
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 455,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "Signature",
                                onClick: ()=>setSignatureOpen(true),
                                className: "grid h-8 w-8 place-items-center rounded-lg text-zinc-500 transition hover:bg-white/5 hover:text-zinc-200",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pen$2d$line$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PenLine$3e$__["PenLine"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 456,
                                    columnNumber: 193
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 456,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "mx-1 h-5 w-px bg-white/8"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 457,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "OCR",
                                onClick: ()=>{
                                    setRightPanel("ocr");
                                    setRightOpen(true);
                                    setSelectedId(null);
                                },
                                className: `grid h-8 w-8 place-items-center rounded-lg transition ${rightOpen && rightPanel === "ocr" ? "bg-blue-500/15 text-blue-300" : "text-zinc-500 hover:bg-white/5 hover:text-zinc-200"}`,
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$scan$2d$text$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__ScanText$3e$__["ScanText"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 458,
                                    columnNumber: 307
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 458,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 450,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "ml-auto flex items-center gap-1.5",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                disabled: !past.length,
                                title: "Undo",
                                className: "grid h-8 w-8 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white disabled:opacity-30",
                                onClick: undo,
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$undo$2d$2$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Undo2$3e$__["Undo2"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 462,
                                    columnNumber: 194
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 462,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                disabled: !future.length,
                                title: "Redo",
                                className: "grid h-8 w-8 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white disabled:opacity-30",
                                onClick: redo,
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$redo$2d$2$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Redo2$3e$__["Redo2"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 463,
                                    columnNumber: 196
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 463,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "mx-1 h-5 w-px bg-white/8"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 464,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "Open another PDF",
                                className: "hidden h-8 items-center gap-2 rounded-lg px-2.5 text-xs text-zinc-400 hover:bg-white/5 hover:text-white sm:flex",
                                onClick: ()=>fileInput.current?.click(),
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$upload$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Upload$3e$__["Upload"], {
                                        size: 14
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 465,
                                        columnNumber: 211
                                    }, this),
                                    " Open"
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 465,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                disabled: exporting,
                                onClick: exportPdf,
                                className: "flex h-8 items-center gap-2 rounded-lg bg-white px-3 text-xs font-semibold text-black transition hover:bg-zinc-200 disabled:opacity-60",
                                children: [
                                    exporting ? /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$loader$2d$circle$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__LoaderCircle$3e$__["LoaderCircle"], {
                                        size: 14,
                                        className: "animate-spin"
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 466,
                                        columnNumber: 220
                                    }, this) : /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$download$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Download$3e$__["Download"], {
                                        size: 14
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 466,
                                        columnNumber: 274
                                    }, this),
                                    " Export"
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 466,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 461,
                        columnNumber: 9
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 441,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "flex min-h-0 flex-1",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__["AnimatePresence"], {
                        initial: false,
                        children: leftOpen && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].aside, {
                            initial: {
                                width: 0,
                                opacity: 0
                            },
                            animate: {
                                width: 220,
                                opacity: 1
                            },
                            exit: {
                                width: 0,
                                opacity: 0
                            },
                            className: "relative z-20 shrink-0 overflow-hidden border-r border-white/8 bg-[#0f1115]",
                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "flex h-full w-[220px] flex-col",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "flex h-11 shrink-0 items-center justify-between border-b border-white/6 px-3",
                                        children: [
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                                className: "text-xs font-semibold text-zinc-300",
                                                children: "Pages"
                                            }, void 0, false, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 476,
                                                columnNumber: 19
                                            }, this),
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                className: "flex gap-1",
                                                children: [
                                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                        title: "Duplicate current page",
                                                        onClick: duplicatePage,
                                                        className: "rounded-md p-1.5 text-zinc-500 hover:bg-white/5 hover:text-white",
                                                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$copy$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Copy$3e$__["Copy"], {
                                                            size: 14
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 478,
                                                            columnNumber: 161
                                                        }, this)
                                                    }, void 0, false, {
                                                        fileName: "[project]/components/pdf-editor.tsx",
                                                        lineNumber: 478,
                                                        columnNumber: 21
                                                    }, this),
                                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                        onClick: ()=>setLeftOpen(false),
                                                        className: "rounded-md p-1.5 text-zinc-500 hover:bg-white/5 hover:text-white",
                                                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$left$2d$close$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelLeftClose$3e$__["PanelLeftClose"], {
                                                            size: 14
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 479,
                                                            columnNumber: 141
                                                        }, this)
                                                    }, void 0, false, {
                                                        fileName: "[project]/components/pdf-editor.tsx",
                                                        lineNumber: 479,
                                                        columnNumber: 21
                                                    }, this)
                                                ]
                                            }, void 0, true, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 477,
                                                columnNumber: 19
                                            }, this)
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 475,
                                        columnNumber: 17
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "editor-scrollbar flex-1 space-y-2 overflow-y-auto p-2.5",
                                        children: pages.map((page, index)=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$components$2f$page$2d$thumbnail$2e$tsx__$5b$app$2d$client$5d$__$28$ecmascript$29$__["PageThumbnail"], {
                                                pdf: pdf,
                                                page: page,
                                                index: index,
                                                active: page.id === activePage?.id,
                                                onSelect: ()=>{
                                                    setActivePageId(page.id);
                                                    setSelectedId(null);
                                                },
                                                onDelete: ()=>deletePage(page.id),
                                                onRotate: ()=>rotatePage(page.id),
                                                onDragStart: ()=>setDragIndex(index),
                                                onDrop: ()=>{
                                                    if (dragIndex !== null) movePage(dragIndex, index);
                                                    setDragIndex(null);
                                                }
                                            }, page.id, false, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 484,
                                                columnNumber: 21
                                            }, this))
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 482,
                                        columnNumber: 17
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 474,
                                columnNumber: 15
                            }, this)
                        }, void 0, false, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 473,
                            columnNumber: 13
                        }, this)
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 471,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("main", {
                        className: "relative min-w-0 flex-1 overflow-hidden bg-[#17191d]",
                        children: [
                            !leftOpen && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "Show pages",
                                onClick: ()=>setLeftOpen(true),
                                className: "absolute left-3 top-3 z-20 grid h-8 w-8 place-items-center rounded-lg border border-white/8 bg-[#111318]/90 text-zinc-400 shadow-lg backdrop-blur hover:text-white",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$left$2d$open$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelLeftOpen$3e$__["PanelLeftOpen"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 493,
                                    columnNumber: 261
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 493,
                                columnNumber: 25
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "absolute left-1/2 top-3 z-20 flex -translate-x-1/2 items-center gap-1 rounded-xl border border-white/10 bg-[#111318]/92 p-1 shadow-xl backdrop-blur",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                        title: "Zoom out",
                                        className: "grid h-7 w-7 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white",
                                        onClick: ()=>setZoom((z)=>(0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["clamp"])(Number((z - 0.1).toFixed(2)), 0.25, 2.5)),
                                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$zoom$2d$out$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__ZoomOut$3e$__["ZoomOut"], {
                                            size: 14
                                        }, void 0, false, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 496,
                                            columnNumber: 220
                                        }, this)
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 496,
                                        columnNumber: 13
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                        className: "h-7 min-w-[58px] rounded-lg px-2 text-[11px] font-medium text-zinc-300 hover:bg-white/5",
                                        onClick: ()=>setZoom(1),
                                        children: [
                                            Math.round(zoom * 100),
                                            "%"
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 497,
                                        columnNumber: 13
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                        title: "Zoom in",
                                        className: "grid h-7 w-7 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white",
                                        onClick: ()=>setZoom((z)=>(0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["clamp"])(Number((z + 0.1).toFixed(2)), 0.25, 2.5)),
                                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$zoom$2d$in$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__ZoomIn$3e$__["ZoomIn"], {
                                            size: 14
                                        }, void 0, false, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 498,
                                            columnNumber: 219
                                        }, this)
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 498,
                                        columnNumber: 13
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 495,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "editor-scrollbar h-full overflow-auto px-16 pb-20 pt-20",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__["AnimatePresence"], {
                                    mode: "wait",
                                    children: activePage && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
                                        initial: {
                                            opacity: 0,
                                            y: 8
                                        },
                                        animate: {
                                            opacity: 1,
                                            y: 0
                                        },
                                        exit: {
                                            opacity: 0,
                                            y: -8
                                        },
                                        transition: {
                                            duration: 0.16
                                        },
                                        className: "mx-auto w-fit",
                                        children: [
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$components$2f$pdf$2d$page$2e$tsx__$5b$app$2d$client$5d$__$28$ecmascript$29$__["PdfPage"], {
                                                pdf: pdf,
                                                page: activePage,
                                                zoom: zoom,
                                                annotations: pageAnnotations,
                                                tool: tool,
                                                selectedId: selectedId,
                                                pendingImage: pendingImage,
                                                defaults: defaults,
                                                ocrResult: activeOcrResult,
                                                ocrSearch: ocrSearch,
                                                ocrSelectable: ocrSelectable,
                                                onCreate: (annotation)=>{
                                                    checkpoint();
                                                    setAnnotations((items)=>[
                                                            ...items,
                                                            annotation
                                                        ]);
                                                    setSelectedId(annotation.id);
                                                    setTool("select");
                                                },
                                                onSelect: setSelectedId,
                                                onPatch: patchAnnotation,
                                                onBeginMutation: checkpoint,
                                                onConsumeImage: ()=>{
                                                    setPendingImage(null);
                                                    setTool("select");
                                                },
                                                onOcrWordEdit: (wordId, text)=>activePage && patchOcrWord(activePage.id, wordId, text)
                                            }, void 0, false, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 505,
                                                columnNumber: 19
                                            }, this),
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                className: "mt-4 text-center text-[11px] text-zinc-600",
                                                children: [
                                                    activePage.label,
                                                    " · source page ",
                                                    activePage.sourceIndex + 1
                                                ]
                                            }, void 0, true, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 524,
                                                columnNumber: 19
                                            }, this)
                                        ]
                                    }, activePage.id, true, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 504,
                                        columnNumber: 17
                                    }, this)
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 502,
                                    columnNumber: 13
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 501,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "absolute bottom-4 left-1/2 z-20 flex -translate-x-1/2 items-center gap-1.5 rounded-xl border border-white/10 bg-[#111318]/94 px-2 py-1.5 shadow-xl backdrop-blur md:hidden",
                                children: tools.slice(0, 6).map(({ id, icon: Icon })=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                        onClick: ()=>{
                                            setTool(id);
                                            setOcrSelectable(false);
                                        },
                                        className: `grid h-8 w-8 place-items-center rounded-lg ${tool === id ? "bg-white text-black" : "text-zinc-400"}`,
                                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(Icon, {
                                            size: 15
                                        }, void 0, false, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 531,
                                            columnNumber: 249
                                        }, this)
                                    }, id, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 531,
                                        columnNumber: 60
                                    }, this))
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 530,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 492,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__["AnimatePresence"], {
                        initial: false,
                        children: rightOpen && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].aside, {
                            initial: {
                                width: 0,
                                opacity: 0
                            },
                            animate: {
                                width: 260,
                                opacity: 1
                            },
                            exit: {
                                width: 0,
                                opacity: 0
                            },
                            className: "relative z-20 shrink-0 overflow-hidden border-l border-white/8 bg-[#0f1115]",
                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "flex h-full w-[260px] flex-col",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "flex h-11 shrink-0 items-center justify-between border-b border-white/6 px-2",
                                        children: [
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                className: "flex items-center gap-1 rounded-lg bg-white/[0.025] p-0.5",
                                                children: [
                                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                        onClick: ()=>setRightPanel("properties"),
                                                        className: `rounded-md px-2 py-1.5 text-[11px] ${rightPanel === "properties" ? "bg-white/8 text-zinc-200" : "text-zinc-600 hover:text-zinc-300"}`,
                                                        children: "Properties"
                                                    }, void 0, false, {
                                                        fileName: "[project]/components/pdf-editor.tsx",
                                                        lineNumber: 541,
                                                        columnNumber: 21
                                                    }, this),
                                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                        onClick: ()=>setRightPanel("ocr"),
                                                        className: `flex items-center gap-1 rounded-md px-2 py-1.5 text-[11px] ${rightPanel === "ocr" ? "bg-blue-500/10 text-blue-300" : "text-zinc-600 hover:text-zinc-300"}`,
                                                        children: [
                                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$scan$2d$text$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__ScanText$3e$__["ScanText"], {
                                                                size: 12
                                                            }, void 0, false, {
                                                                fileName: "[project]/components/pdf-editor.tsx",
                                                                lineNumber: 542,
                                                                columnNumber: 234
                                                            }, this),
                                                            " OCR"
                                                        ]
                                                    }, void 0, true, {
                                                        fileName: "[project]/components/pdf-editor.tsx",
                                                        lineNumber: 542,
                                                        columnNumber: 21
                                                    }, this)
                                                ]
                                            }, void 0, true, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 540,
                                                columnNumber: 19
                                            }, this),
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                onClick: ()=>setRightOpen(false),
                                                className: "rounded-md p-1.5 text-zinc-500 hover:bg-white/5 hover:text-white",
                                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$right$2d$close$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelRightClose$3e$__["PanelRightClose"], {
                                                    size: 14
                                                }, void 0, false, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 544,
                                                    columnNumber: 140
                                                }, this)
                                            }, void 0, false, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 544,
                                                columnNumber: 19
                                            }, this)
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 539,
                                        columnNumber: 17
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "editor-scrollbar flex-1 overflow-y-auto p-3",
                                        children: rightPanel === "ocr" ? /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$components$2f$ocr$2d$panel$2e$tsx__$5b$app$2d$client$5d$__$28$ecmascript$29$__["OcrPanel"], {
                                            activePage: activePage,
                                            activeResult: activeOcrResult,
                                            language: ocrLanguage,
                                            onLanguageChange: setOcrLanguage,
                                            running: ocrRunning,
                                            progress: ocrProgress,
                                            recognizedCount: ocrResults.length,
                                            totalPages: pages.length,
                                            onRecognizePage: ()=>activePage && recognizePages([
                                                    activePage
                                                ]),
                                            onRecognizeAll: ()=>recognizePages(pages),
                                            search: ocrSearch,
                                            onSearchChange: setOcrSearch,
                                            searchHits: ocrSearchHits,
                                            onSelectPage: (pageId)=>{
                                                setActivePageId(pageId);
                                                setSelectedId(null);
                                            },
                                            selectable: ocrSelectable,
                                            onSelectableChange: (value)=>{
                                                setOcrSelectable(value);
                                                if (value) {
                                                    setTool("select");
                                                    setSelectedId(null);
                                                }
                                            },
                                            onCopyText: copyOcrText,
                                            onClearPage: ()=>activePage && clearOcrPage(activePage.id),
                                            onClearAll: clearAllOcr
                                        }, void 0, false, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 548,
                                            columnNumber: 21
                                        }, this) : selected ? /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                            className: "space-y-5",
                                            children: [
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                                                    children: [
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mb-2 flex items-center justify-between",
                                                            children: [
                                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                                                    className: "text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                                                                    children: "Selected"
                                                                }, void 0, false, {
                                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                                    lineNumber: 572,
                                                                    columnNumber: 81
                                                                }, this),
                                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                                                    className: "rounded-md bg-white/5 px-1.5 py-1 text-[10px] capitalize text-zinc-400",
                                                                    children: selected.type
                                                                }, void 0, false, {
                                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                                    lineNumber: 572,
                                                                    columnNumber: 179
                                                                }, this)
                                                            ]
                                                        }, void 0, true, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 572,
                                                            columnNumber: 25
                                                        }, this),
                                                        selected.type === "text" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("textarea", {
                                                            value: selected.text || "",
                                                            onFocus: checkpoint,
                                                            onChange: (e)=>patchAnnotation(selected.id, {
                                                                    text: e.target.value
                                                                }),
                                                            className: "min-h-24 w-full resize-y rounded-xl border border-white/8 bg-white/[0.025] p-2.5 text-xs leading-5 text-zinc-200 outline-none focus:border-blue-500/50"
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 573,
                                                            columnNumber: 54
                                                        }, this)
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 571,
                                                    columnNumber: 23
                                                }, this),
                                                selected.type !== "image" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyColor, {
                                                    value: selected.color,
                                                    onChange: (color)=>inspectorPatch({
                                                            color
                                                        })
                                                }, void 0, false, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 576,
                                                    columnNumber: 53
                                                }, this),
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
                                                    label: "Opacity",
                                                    value: Math.round(selected.opacity * 100),
                                                    min: 5,
                                                    max: 100,
                                                    suffix: "%",
                                                    onChange: (value)=>inspectorPatch({
                                                            opacity: value / 100
                                                        })
                                                }, void 0, false, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 577,
                                                    columnNumber: 23
                                                }, this),
                                                (selected.type === "rect" || selected.type === "ellipse" || selected.type === "draw") && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
                                                    label: "Stroke",
                                                    value: selected.strokeWidth,
                                                    min: 1,
                                                    max: 12,
                                                    suffix: "px",
                                                    onChange: (value)=>inspectorPatch({
                                                            strokeWidth: value
                                                        })
                                                }, void 0, false, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 578,
                                                    columnNumber: 113
                                                }, this),
                                                selected.type === "text" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
                                                    label: "Font size",
                                                    value: selected.fontSize,
                                                    min: 8,
                                                    max: 72,
                                                    suffix: "pt",
                                                    onChange: (value)=>inspectorPatch({
                                                            fontSize: value,
                                                            height: value * 1.6
                                                        })
                                                }, void 0, false, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 579,
                                                    columnNumber: 52
                                                }, this),
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                    className: "grid grid-cols-2 gap-2 border-t border-white/7 pt-4",
                                                    children: [
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(NumberField, {
                                                            label: "X",
                                                            value: selected.x,
                                                            onChange: (x)=>inspectorPatch({
                                                                    x
                                                                })
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 582,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(NumberField, {
                                                            label: "Y",
                                                            value: selected.y,
                                                            onChange: (y)=>inspectorPatch({
                                                                    y
                                                                })
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 583,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(NumberField, {
                                                            label: "W",
                                                            value: selected.width,
                                                            onChange: (width)=>inspectorPatch({
                                                                    width: Math.max(1, width)
                                                                })
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 584,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(NumberField, {
                                                            label: "H",
                                                            value: selected.height,
                                                            onChange: (height)=>inspectorPatch({
                                                                    height: Math.max(1, height)
                                                                })
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 585,
                                                            columnNumber: 25
                                                        }, this)
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 581,
                                                    columnNumber: 23
                                                }, this),
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                    onClick: deleteSelected,
                                                    className: "flex w-full items-center justify-center gap-2 rounded-xl border border-red-500/15 bg-red-500/[0.06] py-2 text-xs font-medium text-red-300 hover:bg-red-500/10",
                                                    children: [
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__["Trash2"], {
                                                            size: 14
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 587,
                                                            columnNumber: 226
                                                        }, this),
                                                        " Delete annotation"
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 587,
                                                    columnNumber: 23
                                                }, this)
                                            ]
                                        }, void 0, true, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 570,
                                            columnNumber: 21
                                        }, this) : /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                            className: "space-y-5",
                                            children: [
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                                                    children: [
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mb-3 text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                                                            children: "Tool defaults"
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 592,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyColor, {
                                                            value: defaults.color,
                                                            onChange: (color)=>setDefaults((d)=>({
                                                                        ...d,
                                                                        color
                                                                    }))
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 593,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mt-4",
                                                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
                                                                label: "Opacity",
                                                                value: Math.round(defaults.opacity * 100),
                                                                min: 10,
                                                                max: 100,
                                                                suffix: "%",
                                                                onChange: (value)=>setDefaults((d)=>({
                                                                            ...d,
                                                                            opacity: value / 100
                                                                        }))
                                                            }, void 0, false, {
                                                                fileName: "[project]/components/pdf-editor.tsx",
                                                                lineNumber: 594,
                                                                columnNumber: 47
                                                            }, this)
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 594,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mt-4",
                                                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
                                                                label: "Stroke",
                                                                value: defaults.strokeWidth,
                                                                min: 1,
                                                                max: 12,
                                                                suffix: "px",
                                                                onChange: (value)=>setDefaults((d)=>({
                                                                            ...d,
                                                                            strokeWidth: value
                                                                        }))
                                                            }, void 0, false, {
                                                                fileName: "[project]/components/pdf-editor.tsx",
                                                                lineNumber: 595,
                                                                columnNumber: 47
                                                            }, this)
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 595,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mt-4",
                                                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
                                                                label: "Font size",
                                                                value: defaults.fontSize,
                                                                min: 8,
                                                                max: 72,
                                                                suffix: "pt",
                                                                onChange: (value)=>setDefaults((d)=>({
                                                                            ...d,
                                                                            fontSize: value
                                                                        }))
                                                            }, void 0, false, {
                                                                fileName: "[project]/components/pdf-editor.tsx",
                                                                lineNumber: 596,
                                                                columnNumber: 47
                                                            }, this)
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 596,
                                                            columnNumber: 25
                                                        }, this)
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 591,
                                                    columnNumber: 23
                                                }, this),
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                                                    className: "border-t border-white/7 pt-4",
                                                    children: [
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mb-3 text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                                                            children: "Page"
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 599,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "grid grid-cols-2 gap-2",
                                                            children: [
                                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                                    onClick: ()=>activePage && rotatePage(activePage.id),
                                                                    className: "flex items-center justify-center gap-2 rounded-xl border border-white/8 bg-white/[0.025] py-2 text-xs text-zinc-300 hover:bg-white/5",
                                                                    children: [
                                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$rotate$2d$cw$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__RotateCw$3e$__["RotateCw"], {
                                                                            size: 14
                                                                        }, void 0, false, {
                                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                                            lineNumber: 601,
                                                                            columnNumber: 236
                                                                        }, this),
                                                                        " Rotate"
                                                                    ]
                                                                }, void 0, true, {
                                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                                    lineNumber: 601,
                                                                    columnNumber: 27
                                                                }, this),
                                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                                    onClick: duplicatePage,
                                                                    className: "flex items-center justify-center gap-2 rounded-xl border border-white/8 bg-white/[0.025] py-2 text-xs text-zinc-300 hover:bg-white/5",
                                                                    children: [
                                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$copy$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Copy$3e$__["Copy"], {
                                                                            size: 14
                                                                        }, void 0, false, {
                                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                                            lineNumber: 602,
                                                                            columnNumber: 204
                                                                        }, this),
                                                                        " Duplicate"
                                                                    ]
                                                                }, void 0, true, {
                                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                                    lineNumber: 602,
                                                                    columnNumber: 27
                                                                }, this)
                                                            ]
                                                        }, void 0, true, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 600,
                                                            columnNumber: 25
                                                        }, this)
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 598,
                                                    columnNumber: 23
                                                }, this),
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                    className: "rounded-xl border border-white/7 bg-white/[0.02] p-3 text-[11px] leading-5 text-zinc-500",
                                                    children: [
                                                        "Choose a tool above, then click or drag on the page. Press ",
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("b", {
                                                            className: "font-medium text-zinc-400",
                                                            children: "V"
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 605,
                                                            columnNumber: 188
                                                        }, this),
                                                        " to return to Select. Double-click text to edit it quickly."
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 605,
                                                    columnNumber: 23
                                                }, this)
                                            ]
                                        }, void 0, true, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 590,
                                            columnNumber: 21
                                        }, this)
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 546,
                                        columnNumber: 17
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 538,
                                columnNumber: 15
                            }, this)
                        }, void 0, false, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 537,
                            columnNumber: 13
                        }, this)
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 535,
                        columnNumber: 9
                    }, this),
                    !rightOpen && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                        title: "Show side panel",
                        onClick: ()=>setRightOpen(true),
                        className: "absolute right-3 top-[70px] z-30 grid h-8 w-8 place-items-center rounded-lg border border-white/8 bg-[#111318]/90 text-zinc-400 shadow-lg backdrop-blur hover:text-white",
                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$right$2d$open$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelRightOpen$3e$__["PanelRightOpen"], {
                            size: 15
                        }, void 0, false, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 614,
                            columnNumber: 272
                        }, this)
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 614,
                        columnNumber: 24
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 470,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                ref: fileInput,
                type: "file",
                accept: "application/pdf",
                className: "hidden",
                onChange: (e)=>{
                    const file = e.target.files?.[0];
                    if (file) openFile(file);
                    e.currentTarget.value = "";
                }
            }, void 0, false, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 617,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                ref: imageInput,
                type: "file",
                accept: "image/png,image/jpeg",
                className: "hidden",
                onChange: async (e)=>{
                    const file = e.target.files?.[0];
                    if (!file) return;
                    const dataUrl = await (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["fileToDataUrl"])(file);
                    setPendingImage(dataUrl);
                    setTool("image");
                    setSelectedId(null);
                    e.currentTarget.value = "";
                }
            }, void 0, false, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 618,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$components$2f$signature$2d$dialog$2e$tsx__$5b$app$2d$client$5d$__$28$ecmascript$29$__["SignatureDialog"], {
                open: signatureOpen,
                onClose: ()=>setSignatureOpen(false),
                onSave: (dataUrl)=>{
                    setSignatureOpen(false);
                    setPendingImage(dataUrl);
                    setTool("image");
                    setSelectedId(null);
                }
            }, void 0, false, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 620,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__["AnimatePresence"], {
                children: [
                    pendingImage && tool === "image" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
                        initial: {
                            opacity: 0,
                            y: 8
                        },
                        animate: {
                            opacity: 1,
                            y: 0
                        },
                        exit: {
                            opacity: 0,
                            y: 8
                        },
                        className: "pointer-events-none fixed bottom-5 left-1/2 z-40 -translate-x-1/2 rounded-xl border border-blue-500/25 bg-blue-500/15 px-3 py-2 text-xs text-blue-100 shadow-xl backdrop-blur",
                        children: "Click the page to place the image"
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 623,
                        columnNumber: 46
                    }, this),
                    error && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
                        initial: {
                            opacity: 0,
                            y: 8
                        },
                        animate: {
                            opacity: 1,
                            y: 0
                        },
                        exit: {
                            opacity: 0
                        },
                        className: "fixed bottom-5 right-5 z-50 max-w-sm rounded-xl border border-red-500/20 bg-[#241315] px-4 py-3 text-xs text-red-200 shadow-2xl",
                        children: [
                            error,
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                className: "ml-3 text-red-400",
                                onClick: ()=>setError(null),
                                children: "Dismiss"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 624,
                                columnNumber: 262
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 624,
                        columnNumber: 19
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 622,
                columnNumber: 7
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-editor.tsx",
        lineNumber: 440,
        columnNumber: 5
    }, this);
}
_s(PdfEditor, "qMCP7DLAJEDvQdP3EDTZox5tXPg=");
_c = PdfEditor;
function PropertyColor({ value, onChange }) {
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        children: [
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "mb-2 flex items-center justify-between text-[11px] text-zinc-500",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                        children: "Color"
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 633,
                        columnNumber: 89
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                        className: "font-mono text-[10px] uppercase",
                        children: value
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 633,
                        columnNumber: 107
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 633,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "flex gap-2",
                children: [
                    [
                        "#111827",
                        "#2563eb",
                        "#dc2626",
                        "#16a34a",
                        "#facc15",
                        "#a855f7"
                    ].map((color)=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                            "aria-label": `Use ${color}`,
                            onClick: ()=>onChange(color),
                            className: `h-6 flex-1 rounded-md border ${value === color ? "border-white ring-1 ring-white/40" : "border-white/10"}`,
                            style: {
                                background: color
                            }
                        }, color, false, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 635,
                            columnNumber: 92
                        }, this)),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("label", {
                        className: "relative grid h-6 w-7 shrink-0 cursor-pointer place-items-center overflow-hidden rounded-md border border-white/10 bg-white/5",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$plus$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Plus$3e$__["Plus"], {
                                size: 12,
                                className: "pointer-events-none absolute"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 636,
                                columnNumber: 154
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                                "aria-label": "Custom color",
                                type: "color",
                                value: value,
                                onChange: (e)=>onChange(e.target.value),
                                className: "absolute inset-0 h-10 w-10 cursor-pointer opacity-0"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 636,
                                columnNumber: 213
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 636,
                        columnNumber: 9
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 634,
                columnNumber: 7
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-editor.tsx",
        lineNumber: 632,
        columnNumber: 5
    }, this);
}
_c1 = PropertyColor;
function PropertyRange({ label, value, min, max, suffix, onChange }) {
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        children: [
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "mb-2 flex items-center justify-between text-[11px] text-zinc-500",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                        children: label
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 645,
                        columnNumber: 89
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                        children: [
                            Math.round(value),
                            suffix
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 645,
                        columnNumber: 109
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 645,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                type: "range",
                min: min,
                max: max,
                value: value,
                onChange: (e)=>onChange(Number(e.target.value)),
                className: "h-1.5 w-full cursor-pointer accent-blue-500"
            }, void 0, false, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 646,
                columnNumber: 7
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-editor.tsx",
        lineNumber: 644,
        columnNumber: 5
    }, this);
}
_c2 = PropertyRange;
function NumberField({ label, value, onChange }) {
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("label", {
        className: "flex items-center rounded-lg border border-white/8 bg-white/[0.025] px-2.5 py-2 text-[10px] text-zinc-600 focus-within:border-blue-500/40",
        children: [
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                className: "w-4",
                children: label
            }, void 0, false, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 654,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                type: "number",
                value: Math.round(value),
                onChange: (e)=>onChange(Number(e.target.value)),
                className: "min-w-0 flex-1 bg-transparent text-right text-xs text-zinc-300 outline-none"
            }, void 0, false, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 655,
                columnNumber: 7
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-editor.tsx",
        lineNumber: 653,
        columnNumber: 5
    }, this);
}
_c3 = NumberField;
var _c, _c1, _c2, _c3;
__turbopack_context__.k.register(_c, "PdfEditor");
__turbopack_context__.k.register(_c1, "PropertyColor");
__turbopack_context__.k.register(_c2, "PropertyRange");
__turbopack_context__.k.register(_c3, "NumberField");
if (typeof globalThis.$RefreshHelpers$ === 'object' && globalThis.$RefreshHelpers !== null) {
    __turbopack_context__.k.registerExports(__turbopack_context__.m, globalThis.$RefreshHelpers$);
}
}),
"[project]/components/pdf-page.tsx [app-client] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "PdfPage",
    ()=>PdfPage
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/compiled/react/jsx-dev-runtime.js [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/ocr.ts [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/utils.ts [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/compiled/react/index.js [app-client] (ecmascript)");
;
var _s = __turbopack_context__.k.signature(), _s1 = __turbopack_context__.k.signature(), _s2 = __turbopack_context__.k.signature(), _s3 = __turbopack_context__.k.signature();
"use client";
;
;
;
function PdfPage({ pdf, page, zoom, annotations, tool, selectedId, pendingImage, defaults, ocrResult, ocrSearch, ocrSelectable, onCreate, onSelect, onPatch, onBeginMutation, onConsumeImage, onOcrWordEdit }) {
    _s();
    const canvasRef = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useRef"])(null);
    const layerRef = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useRef"])(null);
    const [baseSize, setBaseSize] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])({
        width: 612,
        height: 792
    });
    const [draft, setDraft] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(null);
    const [editingWordId, setEditingWordId] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(null);
    const editingStartValue = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useRef"])("");
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useEffect"])({
        "PdfPage.useEffect": ()=>{
            let cancelled = false;
            let renderTask;
            ({
                "PdfPage.useEffect": async ()=>{
                    const proxy = await pdf.getPage(page.sourceIndex + 1);
                    const base = proxy.getViewport({
                        scale: 1,
                        rotation: page.rotation
                    });
                    const viewport = proxy.getViewport({
                        scale: zoom,
                        rotation: page.rotation
                    });
                    const canvas = canvasRef.current;
                    if (!canvas || cancelled) return;
                    setBaseSize({
                        width: base.width,
                        height: base.height
                    });
                    const ratio = Math.min(window.devicePixelRatio || 1, 2);
                    canvas.width = Math.floor(viewport.width * ratio);
                    canvas.height = Math.floor(viewport.height * ratio);
                    canvas.style.width = `${viewport.width}px`;
                    canvas.style.height = `${viewport.height}px`;
                    const ctx = canvas.getContext("2d", {
                        alpha: false
                    });
                    if (!ctx) return;
                    renderTask = proxy.render({
                        canvasContext: ctx,
                        viewport,
                        transform: ratio === 1 ? undefined : [
                            ratio,
                            0,
                            0,
                            ratio,
                            0,
                            0
                        ]
                    });
                    await renderTask.promise;
                }
            })["PdfPage.useEffect"]();
            return ({
                "PdfPage.useEffect": ()=>{
                    cancelled = true;
                    renderTask?.cancel?.();
                }
            })["PdfPage.useEffect"];
        }
    }["PdfPage.useEffect"], [
        pdf,
        page.sourceIndex,
        page.rotation,
        zoom
    ]);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useEffect"])({
        "PdfPage.useEffect": ()=>{
            if (!ocrSelectable) setEditingWordId(null);
        }
    }["PdfPage.useEffect"], [
        ocrSelectable
    ]);
    const pointFromEvent = (event)=>{
        const rect = layerRef.current.getBoundingClientRect();
        return {
            x: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["clamp"])((event.clientX - rect.left) / zoom, 0, baseSize.width),
            y: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["clamp"])((event.clientY - rect.top) / zoom, 0, baseSize.height)
        };
    };
    const draftBox = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useMemo"])({
        "PdfPage.useMemo[draftBox]": ()=>{
            if (!draft || draft.type === "draw") return null;
            return {
                x: Math.min(draft.start.x, draft.current.x),
                y: Math.min(draft.start.y, draft.current.y),
                width: Math.abs(draft.current.x - draft.start.x),
                height: Math.abs(draft.current.y - draft.start.y)
            };
        }
    }["PdfPage.useMemo[draftBox]"], [
        draft
    ]);
    const normalizedSearch = ocrSearch.trim().toLocaleLowerCase();
    const searchTerms = normalizedSearch.split(/\s+/).filter(Boolean);
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        className: "relative bg-white shadow-[0_24px_80px_rgba(0,0,0,.35)]",
        style: {
            width: baseSize.width * zoom,
            height: baseSize.height * zoom
        },
        children: [
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("canvas", {
                ref: canvasRef,
                className: "absolute inset-0 block"
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 110,
                columnNumber: 7
            }, this),
            ocrResult && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: `absolute inset-0 z-30 overflow-hidden ${ocrSelectable ? "cursor-text" : "pointer-events-none select-none"}`,
                "aria-label": "Editable recognized text layer",
                children: ocrResult.words.map((word)=>{
                    const wordValue = word.text.toLocaleLowerCase();
                    const match = searchTerms.length > 0 && searchTerms.some((term)=>wordValue.includes(term));
                    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(OcrWordView, {
                        word: word,
                        zoom: zoom,
                        editable: ocrSelectable,
                        editing: editingWordId === word.id,
                        match: match,
                        onStartEdit: ()=>{
                            if (!ocrSelectable) return;
                            editingStartValue.current = word.text;
                            onBeginMutation();
                            setEditingWordId(word.id);
                        },
                        onChange: (text)=>onOcrWordEdit(word.id, text),
                        onCommit: ()=>setEditingWordId(null),
                        onCancel: ()=>{
                            onOcrWordEdit(word.id, editingStartValue.current);
                            setEditingWordId(null);
                        }
                    }, word.id, false, {
                        fileName: "[project]/components/pdf-page.tsx",
                        lineNumber: 120,
                        columnNumber: 15
                    }, this);
                })
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 112,
                columnNumber: 9
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                ref: layerRef,
                className: `absolute inset-0 z-20 touch-none ${ocrSelectable ? "pointer-events-none" : ""} ${tool === "select" ? "cursor-default" : tool === "text" ? "cursor-text" : "cursor-crosshair"}`,
                onPointerDown: (event)=>{
                    if (event.button !== 0 || event.target !== event.currentTarget) return;
                    const p = pointFromEvent(event);
                    onSelect(null);
                    if (tool === "text") {
                        onCreate({
                            id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["uid"])("ann"),
                            pageId: page.id,
                            type: "text",
                            x: p.x,
                            y: p.y,
                            width: 180,
                            height: defaults.fontSize * 1.6,
                            color: defaults.color,
                            opacity: defaults.opacity,
                            strokeWidth: defaults.strokeWidth,
                            fontSize: defaults.fontSize,
                            text: "Double-click to edit"
                        });
                    } else if (tool === "image" && pendingImage) {
                        onCreate({
                            id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["uid"])("ann"),
                            pageId: page.id,
                            type: "image",
                            x: p.x,
                            y: p.y,
                            width: 180,
                            height: 100,
                            color: defaults.color,
                            opacity: defaults.opacity,
                            strokeWidth: defaults.strokeWidth,
                            fontSize: defaults.fontSize,
                            dataUrl: pendingImage
                        });
                        onConsumeImage();
                    } else if (tool === "highlight" || tool === "rect" || tool === "ellipse") {
                        event.currentTarget.setPointerCapture(event.pointerId);
                        setDraft({
                            type: tool,
                            start: p,
                            current: p
                        });
                    } else if (tool === "draw") {
                        event.currentTarget.setPointerCapture(event.pointerId);
                        setDraft({
                            type: "draw",
                            points: [
                                p
                            ]
                        });
                    }
                },
                onPointerMove: (event)=>{
                    if (!draft) return;
                    const p = pointFromEvent(event);
                    setDraft((current)=>{
                        if (!current) return null;
                        if (current.type === "draw") return {
                            ...current,
                            points: [
                                ...current.points,
                                p
                            ]
                        };
                        return {
                            ...current,
                            current: p
                        };
                    });
                },
                onPointerUp: ()=>{
                    if (!draft) return;
                    if (draft.type === "draw" && draft.points.length > 1) {
                        const xs = draft.points.map((p)=>p.x);
                        const ys = draft.points.map((p)=>p.y);
                        onCreate({
                            id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["uid"])("ann"),
                            pageId: page.id,
                            type: "draw",
                            x: Math.min(...xs),
                            y: Math.min(...ys),
                            width: Math.max(...xs) - Math.min(...xs),
                            height: Math.max(...ys) - Math.min(...ys),
                            color: defaults.color,
                            opacity: defaults.opacity,
                            strokeWidth: defaults.strokeWidth,
                            fontSize: defaults.fontSize,
                            points: draft.points
                        });
                    } else if (draft.type !== "draw") {
                        const b = {
                            x: Math.min(draft.start.x, draft.current.x),
                            y: Math.min(draft.start.y, draft.current.y),
                            width: Math.abs(draft.current.x - draft.start.x),
                            height: Math.abs(draft.current.y - draft.start.y)
                        };
                        if (b.width > 3 && b.height > 3) {
                            onCreate({
                                id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["uid"])("ann"),
                                pageId: page.id,
                                type: draft.type,
                                ...b,
                                color: draft.type === "highlight" ? "#facc15" : defaults.color,
                                opacity: draft.type === "highlight" ? 0.28 : defaults.opacity,
                                strokeWidth: defaults.strokeWidth,
                                fontSize: defaults.fontSize
                            });
                        }
                    }
                    setDraft(null);
                },
                children: [
                    annotations.map((annotation)=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(AnnotationView, {
                            annotation: annotation,
                            zoom: zoom,
                            selected: annotation.id === selectedId,
                            selectable: tool === "select" && !ocrSelectable,
                            onSelect: ()=>onSelect(annotation.id),
                            onPatch: (patch)=>onPatch(annotation.id, patch),
                            onBeginMutation: onBeginMutation
                        }, annotation.id, false, {
                            fileName: "[project]/components/pdf-page.tsx",
                            lineNumber: 206,
                            columnNumber: 11
                        }, this)),
                    draftBox && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "pointer-events-none absolute border border-blue-500 bg-blue-500/10",
                        style: {
                            left: draftBox.x * zoom,
                            top: draftBox.y * zoom,
                            width: draftBox.width * zoom,
                            height: draftBox.height * zoom,
                            borderRadius: draft.type === "ellipse" ? 999 : 2,
                            background: draft.type === "highlight" ? "rgba(250,204,21,.28)" : undefined
                        }
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-page.tsx",
                        lineNumber: 219,
                        columnNumber: 11
                    }, this),
                    draft?.type === "draw" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("svg", {
                        className: "pointer-events-none absolute inset-0 overflow-visible",
                        width: "100%",
                        height: "100%",
                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("polyline", {
                            points: draft.points.map((p)=>`${p.x * zoom},${p.y * zoom}`).join(" "),
                            fill: "none",
                            stroke: defaults.color,
                            strokeWidth: defaults.strokeWidth * zoom,
                            strokeLinecap: "round",
                            strokeLinejoin: "round"
                        }, void 0, false, {
                            fileName: "[project]/components/pdf-page.tsx",
                            lineNumber: 226,
                            columnNumber: 13
                        }, this)
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-page.tsx",
                        lineNumber: 225,
                        columnNumber: 11
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 144,
                columnNumber: 7
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-page.tsx",
        lineNumber: 109,
        columnNumber: 5
    }, this);
}
_s(PdfPage, "w/xiZrfIgHTMIQ4y3wH0z1GH6WU=");
_c = PdfPage;
function OcrWordView({ word, zoom, editable, editing, match, onStartEdit, onChange, onCommit, onCancel }) {
    _s1();
    const inputRef = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useRef"])(null);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useEffect"])({
        "OcrWordView.useEffect": ()=>{
            if (!editing) return;
            inputRef.current?.focus();
            inputRef.current?.select();
        }
    }["OcrWordView.useEffect"], [
        editing
    ]);
    const left = word.x * zoom;
    const top = word.y * zoom;
    const originalWidth = Math.max(2, word.width * zoom);
    const originalHeight = Math.max(2, word.height * zoom);
    const typography = word.typography;
    const metrics = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["measureOcrText"])(word.text || " ", typography);
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
    const textStyle = {
        fontFamily: typography.fontFamily,
        fontWeight: typography.fontWeight,
        fontStyle: typography.fontStyle,
        fontSize,
        lineHeight: 1,
        letterSpacing,
        color: foreground,
        whiteSpace: "nowrap",
        transform: `scaleX(${typography.scaleX})`,
        transformOrigin: "left top"
    };
    if (editing) {
        const editorWidth = Math.max(originalWidth, renderedWidth + 24);
        return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
            className: "absolute z-20",
            style: {
                left,
                top,
                width: Math.max(coverWidth, editorWidth),
                height: originalHeight
            },
            children: [
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                    "aria-hidden": "true",
                    className: "pointer-events-none absolute inset-y-0 left-0",
                    style: {
                        width: originalWidth,
                        backgroundColor: background
                    }
                }, void 0, false, {
                    fileName: "[project]/components/pdf-page.tsx",
                    lineNumber: 289,
                    columnNumber: 9
                }, this),
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                    ref: inputRef,
                    value: word.text,
                    "aria-label": `Edit OCR text: ${word.originalText}`,
                    className: "absolute z-20 border-0 bg-transparent p-0 outline-none ring-2 ring-blue-500/60 ring-offset-1",
                    style: {
                        ...textStyle,
                        left: 0,
                        top: glyphTop - top,
                        width: editorWidth / Math.max(0.01, typography.scaleX),
                        height: Math.max(18, glyphHeight),
                        caretColor: foreground
                    },
                    onChange: (event)=>onChange(event.target.value),
                    onBlur: onCommit,
                    onKeyDown: (event)=>{
                        if (event.key === "Enter") {
                            event.preventDefault();
                            onCommit();
                        }
                        if (event.key === "Escape") {
                            event.preventDefault();
                            onCancel();
                        }
                    }
                }, void 0, false, {
                    fileName: "[project]/components/pdf-page.tsx",
                    lineNumber: 294,
                    columnNumber: 9
                }, this)
            ]
        }, void 0, true, {
            fileName: "[project]/components/pdf-page.tsx",
            lineNumber: 285,
            columnNumber: 7
        }, this);
    }
    if (word.edited) {
        return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
            type: "button",
            title: editable ? `Edit “${word.text || word.originalText}” · ${typography.fontFamily.split(",")[0].replaceAll("\"", "")} · ${typography.fontSize.toFixed(1)} pt · ${typography.fontWeight}` : undefined,
            onClick: (event)=>{
                event.stopPropagation();
                if (editable) onStartEdit();
            },
            className: `absolute text-left ${editable ? "pointer-events-auto cursor-text hover:outline hover:outline-1 hover:outline-blue-400" : "pointer-events-none"} ${match ? "outline outline-2 outline-amber-400" : ""}`,
            style: {
                left,
                top,
                width: coverWidth,
                height: originalHeight,
                backgroundColor: background,
                overflow: "visible"
            },
            children: word.text && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                className: "absolute block",
                style: {
                    ...textStyle,
                    left: 0,
                    top: glyphTop - top,
                    width: Math.max(1, metrics.naturalWidth * zoom),
                    height: glyphHeight
                },
                children: word.text
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 328,
                columnNumber: 11
            }, this)
        }, void 0, false, {
            fileName: "[project]/components/pdf-page.tsx",
            lineNumber: 320,
            columnNumber: 7
        }, this);
    }
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
        type: "button",
        title: editable ? `${word.text} · ${typography.fontFamily.split(",")[0].replaceAll("\"", "")} · ${typography.fontSize.toFixed(1)} pt · weight ${typography.fontWeight} · ${Math.round(word.confidence)}% OCR` : undefined,
        onClick: (event)=>{
            event.stopPropagation();
            if (editable) onStartEdit();
        },
        className: `ocr-word absolute whitespace-nowrap text-transparent ${editable ? "pointer-events-auto cursor-text hover:bg-blue-400/10 hover:outline hover:outline-1 hover:outline-blue-400/70" : "pointer-events-none"} ${match ? "bg-amber-300/55 outline outline-1 outline-amber-500/30" : ""}`,
        style: {
            left,
            top,
            width: originalWidth,
            height: originalHeight,
            fontSize,
            lineHeight: `${originalHeight}px`
        },
        children: [
            word.text,
            " "
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-page.tsx",
        lineNumber: 346,
        columnNumber: 5
    }, this);
}
_s1(OcrWordView, "cBQ6FQ+sf5H+lvNONLKqtm4aeQ8=");
_c1 = OcrWordView;
function AnnotationView({ annotation, zoom, selected, selectable, onSelect, onPatch, onBeginMutation }) {
    _s2();
    const drag = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useRef"])(null);
    if (annotation.type === "draw" && annotation.points) {
        return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("svg", {
            className: "pointer-events-none absolute inset-0 overflow-visible",
            width: "100%",
            height: "100%",
            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("polyline", {
                points: annotation.points.map((p)=>`${p.x * zoom},${p.y * zoom}`).join(" "),
                fill: "none",
                stroke: annotation.color,
                opacity: annotation.opacity,
                strokeWidth: annotation.strokeWidth * zoom,
                strokeLinecap: "round",
                strokeLinejoin: "round",
                style: {
                    pointerEvents: selectable ? "stroke" : "none"
                },
                onPointerDown: (e)=>{
                    if (!selectable) return;
                    e.stopPropagation();
                    onSelect();
                }
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 371,
                columnNumber: 9
            }, this)
        }, void 0, false, {
            fileName: "[project]/components/pdf-page.tsx",
            lineNumber: 370,
            columnNumber: 7
        }, this);
    }
    const style = {
        left: annotation.x * zoom,
        top: annotation.y * zoom,
        width: Math.max(2, annotation.width * zoom),
        height: Math.max(2, annotation.height * zoom),
        opacity: annotation.opacity
    };
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        className: `absolute ${selectable ? "pointer-events-auto" : "pointer-events-none"} ${selected ? "ring-1 ring-blue-500 ring-offset-1 ring-offset-white" : ""}`,
        style: style,
        onDoubleClick: (event)=>{
            if (annotation.type !== "text") return;
            event.stopPropagation();
            const next = window.prompt("Edit text", annotation.text || "");
            if (next !== null) {
                onBeginMutation();
                onPatch({
                    text: next
                });
            }
        },
        onPointerDown: (event)=>{
            if (!selectable || event.button !== 0) return;
            event.stopPropagation();
            onSelect();
            onBeginMutation();
            drag.current = {
                x: annotation.x,
                y: annotation.y,
                startX: event.clientX,
                startY: event.clientY
            };
            event.currentTarget.setPointerCapture(event.pointerId);
        },
        onPointerMove: (event)=>{
            if (!drag.current) return;
            onPatch({
                x: drag.current.x + (event.clientX - drag.current.startX) / zoom,
                y: drag.current.y + (event.clientY - drag.current.startY) / zoom
            });
        },
        onPointerUp: ()=>{
            drag.current = null;
        },
        children: [
            annotation.type === "text" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "h-full w-full whitespace-pre-wrap leading-tight",
                style: {
                    color: annotation.color,
                    fontSize: annotation.fontSize * zoom
                },
                children: annotation.text
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 419,
                columnNumber: 9
            }, this),
            annotation.type === "highlight" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "h-full w-full",
                style: {
                    background: annotation.color
                }
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 421,
                columnNumber: 43
            }, this),
            annotation.type === "rect" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "h-full w-full",
                style: {
                    border: `${annotation.strokeWidth * zoom}px solid ${annotation.color}`
                }
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 422,
                columnNumber: 38
            }, this),
            annotation.type === "ellipse" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "h-full w-full rounded-full",
                style: {
                    border: `${annotation.strokeWidth * zoom}px solid ${annotation.color}`
                }
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 423,
                columnNumber: 41
            }, this),
            annotation.type === "image" && annotation.dataUrl && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("img", {
                src: annotation.dataUrl,
                alt: "Placed",
                className: "h-full w-full object-contain",
                draggable: false
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 424,
                columnNumber: 61
            }, this),
            selected && annotation.type !== "draw" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(ResizeHandle, {
                annotation: annotation,
                zoom: zoom,
                onBeginMutation: onBeginMutation,
                onPatch: onPatch
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 426,
                columnNumber: 9
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-page.tsx",
        lineNumber: 395,
        columnNumber: 5
    }, this);
}
_s2(AnnotationView, "gIddYogjP+VVdD1QmmHwmANJEG4=");
_c2 = AnnotationView;
function ResizeHandle({ annotation, zoom, onPatch, onBeginMutation }) {
    _s3();
    const drag = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useRef"])(null);
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
        "aria-label": "Resize annotation",
        className: "absolute -bottom-1.5 -right-1.5 h-3 w-3 cursor-nwse-resize rounded-sm border border-white bg-blue-500 shadow",
        onPointerDown: (event)=>{
            event.stopPropagation();
            onBeginMutation();
            drag.current = {
                width: annotation.width,
                height: annotation.height,
                startX: event.clientX,
                startY: event.clientY
            };
            event.currentTarget.setPointerCapture(event.pointerId);
        },
        onPointerMove: (event)=>{
            if (!drag.current) return;
            onPatch({
                width: Math.max(12, drag.current.width + (event.clientX - drag.current.startX) / zoom),
                height: Math.max(12, drag.current.height + (event.clientY - drag.current.startY) / zoom)
            });
        },
        onPointerUp: (event)=>{
            event.stopPropagation();
            drag.current = null;
        }
    }, void 0, false, {
        fileName: "[project]/components/pdf-page.tsx",
        lineNumber: 440,
        columnNumber: 5
    }, this);
}
_s3(ResizeHandle, "gIddYogjP+VVdD1QmmHwmANJEG4=");
_c3 = ResizeHandle;
var _c, _c1, _c2, _c3;
__turbopack_context__.k.register(_c, "PdfPage");
__turbopack_context__.k.register(_c1, "OcrWordView");
__turbopack_context__.k.register(_c2, "AnnotationView");
__turbopack_context__.k.register(_c3, "ResizeHandle");
if (typeof globalThis.$RefreshHelpers$ === 'object' && globalThis.$RefreshHelpers !== null) {
    __turbopack_context__.k.registerExports(__turbopack_context__.m, globalThis.$RefreshHelpers$);
}
}),
"[project]/components/signature-dialog.tsx [app-client] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "SignatureDialog",
    ()=>SignatureDialog
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/compiled/react/jsx-dev-runtime.js [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/framer-motion/dist/es/components/AnimatePresence/index.mjs [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$locals$3e$__ = __turbopack_context__.i("[project]/node_modules/motion/dist/es/react.mjs [app-client] (ecmascript) <locals>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$eraser$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Eraser$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/eraser.mjs [app-client] (ecmascript) <export default as Eraser>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pen$2d$line$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PenLine$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/pen-line.mjs [app-client] (ecmascript) <export default as PenLine>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$x$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__X$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/x.mjs [app-client] (ecmascript) <export default as X>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/compiled/react/index.js [app-client] (ecmascript)");
;
var _s = __turbopack_context__.k.signature();
"use client";
;
;
;
function SignatureDialog({ open, onClose, onSave }) {
    _s();
    const canvasRef = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useRef"])(null);
    const [drawing, setDrawing] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useState"])(false);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["useEffect"])({
        "SignatureDialog.useEffect": ()=>{
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
        }
    }["SignatureDialog.useEffect"], [
        open
    ]);
    const point = (event)=>{
        const rect = event.currentTarget.getBoundingClientRect();
        return {
            x: event.clientX - rect.left,
            y: event.clientY - rect.top
        };
    };
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__["AnimatePresence"], {
        children: open && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
            className: "fixed inset-0 z-50 grid place-items-center bg-black/65 p-5 backdrop-blur-sm",
            initial: {
                opacity: 0
            },
            animate: {
                opacity: 1
            },
            exit: {
                opacity: 0
            },
            onMouseDown: (e)=>e.target === e.currentTarget && onClose(),
            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
                initial: {
                    opacity: 0,
                    scale: 0.96,
                    y: 12
                },
                animate: {
                    opacity: 1,
                    scale: 1,
                    y: 0
                },
                exit: {
                    opacity: 0,
                    scale: 0.98,
                    y: 8
                },
                className: "w-full max-w-[580px] rounded-2xl border border-white/10 bg-[#15181e] p-4 shadow-2xl",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mb-4 flex items-center justify-between",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "flex items-center gap-2 text-sm font-semibold",
                                        children: [
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pen$2d$line$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PenLine$3e$__["PenLine"], {
                                                size: 16
                                            }, void 0, false, {
                                                fileName: "[project]/components/signature-dialog.tsx",
                                                lineNumber: 58,
                                                columnNumber: 80
                                            }, this),
                                            " Draw signature"
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/signature-dialog.tsx",
                                        lineNumber: 58,
                                        columnNumber: 17
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("p", {
                                        className: "mt-1 text-xs text-zinc-500",
                                        children: "Sign in the box, then place it on any page."
                                    }, void 0, false, {
                                        fileName: "[project]/components/signature-dialog.tsx",
                                        lineNumber: 59,
                                        columnNumber: 17
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/signature-dialog.tsx",
                                lineNumber: 57,
                                columnNumber: 15
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                className: "rounded-lg p-2 text-zinc-400 hover:bg-white/5 hover:text-white",
                                onClick: onClose,
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$x$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__X$3e$__["X"], {
                                    size: 17
                                }, void 0, false, {
                                    fileName: "[project]/components/signature-dialog.tsx",
                                    lineNumber: 61,
                                    columnNumber: 116
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/signature-dialog.tsx",
                                lineNumber: 61,
                                columnNumber: 15
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/signature-dialog.tsx",
                        lineNumber: 56,
                        columnNumber: 13
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "overflow-hidden rounded-xl border border-zinc-300 bg-white checkerboard",
                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("canvas", {
                            ref: canvasRef,
                            className: "block h-[180px] w-full touch-none bg-white/80",
                            onPointerDown: (event)=>{
                                setDrawing(true);
                                event.currentTarget.setPointerCapture(event.pointerId);
                                const p = point(event);
                                const ctx = event.currentTarget.getContext("2d");
                                ctx?.beginPath();
                                ctx?.moveTo(p.x, p.y);
                            },
                            onPointerMove: (event)=>{
                                if (!drawing) return;
                                const p = point(event);
                                const ctx = event.currentTarget.getContext("2d");
                                ctx?.lineTo(p.x, p.y);
                                ctx?.stroke();
                            },
                            onPointerUp: ()=>setDrawing(false),
                            onPointerCancel: ()=>setDrawing(false)
                        }, void 0, false, {
                            fileName: "[project]/components/signature-dialog.tsx",
                            lineNumber: 65,
                            columnNumber: 15
                        }, this)
                    }, void 0, false, {
                        fileName: "[project]/components/signature-dialog.tsx",
                        lineNumber: 64,
                        columnNumber: 13
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-4 flex items-center justify-between gap-3",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                className: "inline-flex items-center gap-2 rounded-xl border border-white/10 px-3 py-2 text-sm text-zinc-300 hover:bg-white/5",
                                onClick: ()=>{
                                    const canvas = canvasRef.current;
                                    const ctx = canvas?.getContext("2d");
                                    if (canvas && ctx) ctx.clearRect(0, 0, canvas.width, canvas.height);
                                },
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$eraser$2e$mjs__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__Eraser$3e$__["Eraser"], {
                                        size: 15
                                    }, void 0, false, {
                                        fileName: "[project]/components/signature-dialog.tsx",
                                        lineNumber: 96,
                                        columnNumber: 16
                                    }, this),
                                    " Clear"
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/signature-dialog.tsx",
                                lineNumber: 89,
                                columnNumber: 15
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "flex gap-2",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                        className: "rounded-xl px-4 py-2 text-sm text-zinc-400 hover:bg-white/5",
                                        onClick: onClose,
                                        children: "Cancel"
                                    }, void 0, false, {
                                        fileName: "[project]/components/signature-dialog.tsx",
                                        lineNumber: 98,
                                        columnNumber: 17
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$compiled$2f$react$2f$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                        className: "rounded-xl bg-white px-4 py-2 text-sm font-semibold text-black hover:bg-zinc-200",
                                        onClick: ()=>{
                                            const url = canvasRef.current?.toDataURL("image/png");
                                            if (url) onSave(url);
                                        },
                                        children: "Use signature"
                                    }, void 0, false, {
                                        fileName: "[project]/components/signature-dialog.tsx",
                                        lineNumber: 99,
                                        columnNumber: 17
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/signature-dialog.tsx",
                                lineNumber: 97,
                                columnNumber: 15
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/signature-dialog.tsx",
                        lineNumber: 88,
                        columnNumber: 13
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/signature-dialog.tsx",
                lineNumber: 50,
                columnNumber: 11
            }, this)
        }, void 0, false, {
            fileName: "[project]/components/signature-dialog.tsx",
            lineNumber: 43,
            columnNumber: 9
        }, this)
    }, void 0, false, {
        fileName: "[project]/components/signature-dialog.tsx",
        lineNumber: 41,
        columnNumber: 5
    }, this);
}
_s(SignatureDialog, "0vAuOkhaGZiwdfsbCbXuHFcpJ5M=");
_c = SignatureDialog;
var _c;
__turbopack_context__.k.register(_c, "SignatureDialog");
if (typeof globalThis.$RefreshHelpers$ === 'object' && globalThis.$RefreshHelpers !== null) {
    __turbopack_context__.k.registerExports(__turbopack_context__.m, globalThis.$RefreshHelpers$);
}
}),
"[project]/lib/export-pdf.ts [app-client] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "exportEditedPdf",
    ()=>exportEditedPdf
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$index$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$locals$3e$__ = __turbopack_context__.i("[project]/node_modules/pdf-lib/es/index.js [app-client] (ecmascript) <locals>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$rotations$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/pdf-lib/es/api/rotations.js [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$PDFDocument$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PDFDocument$3e$__ = __turbopack_context__.i("[project]/node_modules/pdf-lib/es/api/PDFDocument.js [app-client] (ecmascript) <export default as PDFDocument>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$colors$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/pdf-lib/es/api/colors.js [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$StandardFonts$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/pdf-lib/es/api/StandardFonts.js [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/ocr.ts [app-client] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/utils.ts [app-client] (ecmascript)");
;
;
;
function dataUrlBytes(dataUrl) {
    const [meta, payload] = dataUrl.split(",");
    const binary = atob(payload);
    const bytes = new Uint8Array(binary.length);
    for(let i = 0; i < binary.length; i++)bytes[i] = binary.charCodeAt(i);
    return {
        bytes,
        isJpeg: /image\/jpe?g/i.test(meta)
    };
}
function drawTrackedText(context, text, baselineY, letterSpacing) {
    let cursor = 0;
    const chars = Array.from(text);
    chars.forEach((character, index)=>{
        context.fillText(character, cursor, baselineY);
        cursor += context.measureText(character).width;
        if (index < chars.length - 1) cursor += letterSpacing;
    });
}
/**
 * Renders visual OCR replacements with the exact same browser font model used
 * by the live editor. Exporting the replacement as a transparent raster avoids
 * silently switching the edited word to Helvetica at save time.
 */ function renderOcrReplacement(word) {
    const text = word.text;
    const typography = word.typography;
    const metrics = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["measureOcrText"])(text || " ", typography);
    const rasterScale = 4;
    const padding = Math.max(2, typography.fontSize * 0.12);
    const width = Math.max(1, metrics.width);
    const height = Math.max(1, metrics.ascent + metrics.descent);
    const canvas = document.createElement("canvas");
    canvas.width = Math.max(1, Math.ceil((width + padding * 2) * rasterScale));
    canvas.height = Math.max(1, Math.ceil((height + padding * 2) * rasterScale));
    const context = canvas.getContext("2d", {
        alpha: true
    });
    if (!context) throw new Error("Could not create OCR replacement canvas.");
    const fg = word.textColor || "#111111";
    context.clearRect(0, 0, canvas.width, canvas.height);
    context.fillStyle = fg;
    context.textBaseline = "alphabetic";
    context.font = `${typography.fontStyle} ${typography.fontWeight} ${typography.fontSize * rasterScale}px ${typography.fontFamily}`;
    context.save();
    context.translate(padding * rasterScale, padding * rasterScale);
    context.scale(typography.scaleX, 1);
    drawTrackedText(context, text, metrics.ascent * rasterScale, typography.letterSpacing * rasterScale);
    context.restore();
    return {
        dataUrl: canvas.toDataURL("image/png"),
        x: word.x - padding,
        y: typography.baselineY - metrics.ascent - padding,
        width: width + padding * 2,
        height: height + padding * 2,
        visualWidth: width
    };
}
async function exportEditedPdf({ sourceBytes, pdfJsDocument, pages, annotations, ocrResults = [] }) {
    const source = await __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$PDFDocument$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PDFDocument$3e$__["PDFDocument"].load(sourceBytes, {
        ignoreEncryption: true
    });
    const output = await __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$PDFDocument$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__$3c$export__default__as__PDFDocument$3e$__["PDFDocument"].create();
    const helvetica = await output.embedFont(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$StandardFonts$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["StandardFonts"].Helvetica);
    const copied = await output.copyPages(source, pages.map((page)=>page.sourceIndex));
    for(let index = 0; index < copied.length; index++){
        const targetPage = copied[index];
        const editorPage = pages[index];
        targetPage.setRotation((0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$rotations$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["degrees"])(editorPage.rotation));
        const sourceProxy = await pdfJsDocument.getPage(editorPage.sourceIndex + 1);
        const viewport = sourceProxy.getViewport({
            scale: 1,
            rotation: editorPage.rotation
        });
        const pageAnnotations = annotations.filter((annotation)=>annotation.pageId === editorPage.id);
        const toPdf = (x, y)=>viewport.convertToPdfPoint(x, y);
        const box = (annotation)=>{
            const p1 = toPdf(annotation.x, annotation.y);
            const p2 = toPdf(annotation.x + annotation.width, annotation.y + annotation.height);
            return {
                x: Math.min(p1[0], p2[0]),
                y: Math.min(p1[1], p2[1]),
                width: Math.abs(p2[0] - p1[0]),
                height: Math.abs(p2[1] - p1[1])
            };
        };
        const ocrResult = ocrResults.find((result)=>result.pageId === editorPage.id);
        if (ocrResult) {
            for (const word of ocrResult.words){
                const text = word.text.trim();
                const a = toPdf(word.x, word.y);
                // Never erase neighboring scan content just because a replacement is longer.
                // The visual replacement may overflow its original box, but the cleanup patch
                // is restricted to the pixels occupied by the original OCR word.
                const coverWidth = word.width;
                const b = toPdf(word.x + coverWidth, word.y + word.height);
                const wordBox = {
                    x: Math.min(a[0], b[0]),
                    y: Math.min(a[1], b[1]),
                    width: Math.abs(b[0] - a[0]),
                    height: Math.abs(b[1] - a[1])
                };
                if (word.edited) {
                    const bg = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["hexToRgb01"])(word.backgroundColor || "#ffffff");
                    // Keep the cover tight to the original ink box. The old code added a
                    // large fixed margin that visibly erased neighboring scan detail.
                    targetPage.drawRectangle({
                        x: wordBox.x - 0.2,
                        y: wordBox.y - 0.2,
                        width: wordBox.width + 0.4,
                        height: wordBox.height + 0.4,
                        color: (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$colors$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["rgb"])(bg.r, bg.g, bg.b)
                    });
                    if (!text) continue;
                    const replacement = renderOcrReplacement(word);
                    const imageData = dataUrlBytes(replacement.dataUrl);
                    const image = await output.embedPng(imageData.bytes);
                    const topLeft = toPdf(replacement.x, replacement.y);
                    const bottomRight = toPdf(replacement.x + replacement.width, replacement.y + replacement.height);
                    const imageBox = {
                        x: Math.min(topLeft[0], bottomRight[0]),
                        y: Math.min(topLeft[1], bottomRight[1]),
                        width: Math.abs(bottomRight[0] - topLeft[0]),
                        height: Math.abs(bottomRight[1] - topLeft[1])
                    };
                    targetPage.drawImage(image, imageBox);
                    // Preserve searchability separately from the visual replacement.
                    // This invisible layer is not used for appearance.
                    try {
                        const [searchX, searchY] = toPdf(word.x, word.typography.baselineY);
                        targetPage.drawText(text, {
                            x: searchX,
                            y: searchY,
                            size: Math.max(3, word.typography.fontSize),
                            font: helvetica,
                            opacity: 0
                        });
                    } catch  {
                    // Standard PDF fonts cannot encode every language; the visible
                    // replacement remains intact even when searchable text is skipped.
                    }
                    continue;
                }
                if (!text) continue;
                const [x, y] = toPdf(word.x, word.typography.baselineY);
                try {
                    targetPage.drawText(text, {
                        x,
                        y,
                        size: Math.max(3, word.typography.fontSize),
                        font: helvetica,
                        opacity: 0
                    });
                } catch  {
                // Standard PDF fonts cannot encode every OCR language. Keep export
                // working and skip unsupported searchable glyphs.
                }
            }
        }
        for (const annotation of pageAnnotations){
            const c = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$client$5d$__$28$ecmascript$29$__["hexToRgb01"])(annotation.color);
            const color = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$colors$2e$js__$5b$app$2d$client$5d$__$28$ecmascript$29$__["rgb"])(c.r, c.g, c.b);
            if (annotation.type === "text") {
                const [x, y] = toPdf(annotation.x, annotation.y + annotation.fontSize);
                targetPage.drawText(annotation.text || "Text", {
                    x,
                    y,
                    size: annotation.fontSize,
                    font: helvetica,
                    color,
                    opacity: annotation.opacity,
                    maxWidth: Math.max(20, annotation.width)
                });
            } else if (annotation.type === "highlight") {
                const b = box(annotation);
                targetPage.drawRectangle({
                    ...b,
                    color,
                    opacity: annotation.opacity
                });
            } else if (annotation.type === "rect") {
                const b = box(annotation);
                targetPage.drawRectangle({
                    ...b,
                    borderColor: color,
                    borderWidth: annotation.strokeWidth,
                    borderOpacity: annotation.opacity
                });
            } else if (annotation.type === "ellipse") {
                const b = box(annotation);
                targetPage.drawEllipse({
                    x: b.x + b.width / 2,
                    y: b.y + b.height / 2,
                    xScale: b.width / 2,
                    yScale: b.height / 2,
                    borderColor: color,
                    borderWidth: annotation.strokeWidth,
                    borderOpacity: annotation.opacity
                });
            } else if (annotation.type === "draw" && annotation.points && annotation.points.length > 1) {
                for(let i = 1; i < annotation.points.length; i++){
                    const a = annotation.points[i - 1];
                    const b = annotation.points[i];
                    const start = toPdf(a.x, a.y);
                    const end = toPdf(b.x, b.y);
                    targetPage.drawLine({
                        start: {
                            x: start[0],
                            y: start[1]
                        },
                        end: {
                            x: end[0],
                            y: end[1]
                        },
                        thickness: annotation.strokeWidth,
                        color,
                        opacity: annotation.opacity
                    });
                }
            } else if (annotation.type === "image" && annotation.dataUrl) {
                const imageData = dataUrlBytes(annotation.dataUrl);
                const embedded = imageData.isJpeg ? await output.embedJpg(imageData.bytes) : await output.embedPng(imageData.bytes);
                const b = box(annotation);
                targetPage.drawImage(embedded, {
                    ...b,
                    opacity: annotation.opacity
                });
            }
        }
        output.addPage(targetPage);
    }
    return await output.save();
}
if (typeof globalThis.$RefreshHelpers$ === 'object' && globalThis.$RefreshHelpers !== null) {
    __turbopack_context__.k.registerExports(__turbopack_context__.m, globalThis.$RefreshHelpers$);
}
}),
"[project]/lib/ocr.ts [app-client] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "OCR_LANGUAGES",
    ()=>OCR_LANGUAGES,
    "OCR_RENDER_SCALE",
    ()=>OCR_RENDER_SCALE,
    "makeOcrResult",
    ()=>makeOcrResult,
    "measureOcrText",
    ()=>measureOcrText,
    "ocrCssFont",
    ()=>ocrCssFont,
    "ocrTextFromWords",
    ()=>ocrTextFromWords,
    "parseBlockWords",
    ()=>parseBlockWords,
    "parseTsvWords",
    ()=>parseTsvWords,
    "renderPageForOcr",
    ()=>renderPageForOcr
]);
const OCR_RENDER_SCALE = 2.5;
const OCR_LANGUAGES = [
    {
        code: "eng",
        label: "English"
    },
    {
        code: "spa",
        label: "Spanish"
    },
    {
        code: "fra",
        label: "French"
    },
    {
        code: "deu",
        label: "German"
    },
    {
        code: "ita",
        label: "Italian"
    },
    {
        code: "por",
        label: "Portuguese"
    },
    {
        code: "nld",
        label: "Dutch"
    },
    {
        code: "pol",
        label: "Polish"
    },
    {
        code: "rus",
        label: "Russian"
    },
    {
        code: "ukr",
        label: "Ukrainian"
    },
    {
        code: "ara",
        label: "Arabic"
    },
    {
        code: "hin",
        label: "Hindi"
    },
    {
        code: "jpn",
        label: "Japanese"
    },
    {
        code: "kor",
        label: "Korean"
    },
    {
        code: "chi_sim",
        label: "Chinese (Simplified)"
    },
    {
        code: "chi_tra",
        label: "Chinese (Traditional)"
    }
];
const FONT_CANDIDATES = [
    {
        family: 'Arial, Helvetica, sans-serif',
        kind: "sans"
    },
    {
        family: '"Calibri", "Segoe UI", Arial, sans-serif',
        kind: "sans"
    },
    {
        family: '"Segoe UI", Arial, sans-serif',
        kind: "sans"
    },
    {
        family: 'Verdana, Arial, sans-serif',
        kind: "sans"
    },
    {
        family: 'Tahoma, Arial, sans-serif',
        kind: "sans"
    },
    {
        family: '"Trebuchet MS", Arial, sans-serif',
        kind: "sans"
    },
    {
        family: '"Times New Roman", Times, serif',
        kind: "serif"
    },
    {
        family: 'Georgia, "Times New Roman", serif',
        kind: "serif"
    },
    {
        family: 'Cambria, Georgia, "Times New Roman", serif',
        kind: "serif"
    },
    {
        family: 'Garamond, Georgia, "Times New Roman", serif',
        kind: "serif"
    },
    {
        family: '"Courier New", Courier, monospace',
        kind: "mono"
    }
];
let measureCanvas = null;
function measureContext() {
    if (typeof document === "undefined") return null;
    if (!measureCanvas) measureCanvas = document.createElement("canvas");
    return measureCanvas.getContext("2d");
}
async function renderPageForOcr(pdf, page) {
    const proxy = await pdf.getPage(page.sourceIndex + 1);
    const base = proxy.getViewport({
        scale: 1,
        rotation: page.rotation
    });
    const viewport = proxy.getViewport({
        scale: OCR_RENDER_SCALE,
        rotation: page.rotation
    });
    const canvas = document.createElement("canvas");
    canvas.width = Math.max(1, Math.ceil(viewport.width));
    canvas.height = Math.max(1, Math.ceil(viewport.height));
    const context = canvas.getContext("2d", {
        alpha: false,
        willReadFrequently: true
    });
    if (!context) throw new Error("Could not create an OCR rendering canvas.");
    context.fillStyle = "#ffffff";
    context.fillRect(0, 0, canvas.width, canvas.height);
    await proxy.render({
        canvasContext: context,
        viewport
    }).promise;
    return {
        canvas,
        baseWidth: base.width,
        baseHeight: base.height
    };
}
function clamp(value, min, max) {
    return Math.min(max, Math.max(min, value));
}
function median(values) {
    if (!values.length) return 0;
    const sorted = [
        ...values
    ].sort((a, b)=>a - b);
    const middle = Math.floor(sorted.length / 2);
    return sorted.length % 2 ? sorted[middle] : (sorted[middle - 1] + sorted[middle]) / 2;
}
function rgbHex(r, g, b) {
    return `#${[
        r,
        g,
        b
    ].map((value)=>clamp(Math.round(value), 0, 255).toString(16).padStart(2, "0")).join("")}`;
}
function getPixel(context, canvas, rawX, rawY) {
    const x = clamp(Math.round(rawX), 0, canvas.width - 1);
    const y = clamp(Math.round(rawY), 0, canvas.height - 1);
    const pixel = context.getImageData(x, y, 1, 1).data;
    return [
        pixel[0],
        pixel[1],
        pixel[2]
    ];
}
/**
 * Samples a ring around the OCR box instead of a few corner pixels. This is
 * much less likely to mistake an antialiased glyph edge for the page color.
 */ function sampleAppearance(canvas, left, top, width, height) {
    if (!canvas) return {
        backgroundColor: "#ffffff",
        textColor: "#111111",
        inkCoverage: 0.22
    };
    const context = canvas.getContext("2d", {
        willReadFrequently: true
    });
    if (!context) return {
        backgroundColor: "#ffffff",
        textColor: "#111111",
        inkCoverage: 0.22
    };
    const margin = Math.max(3, Math.min(8, Math.round(height * 0.18)));
    const ring = [];
    const stepsX = Math.max(5, Math.min(17, Math.round(width / 8)));
    const stepsY = Math.max(3, Math.min(9, Math.round(height / 6)));
    for(let i = 0; i <= stepsX; i++){
        const x = left + width * i / Math.max(1, stepsX);
        ring.push(getPixel(context, canvas, x, top - margin));
        ring.push(getPixel(context, canvas, x, top + height + margin));
    }
    for(let i = 0; i <= stepsY; i++){
        const y = top + height * i / Math.max(1, stepsY);
        ring.push(getPixel(context, canvas, left - margin, y));
        ring.push(getPixel(context, canvas, left + width + margin, y));
    }
    const bgR = median(ring.map((p)=>p[0]));
    const bgG = median(ring.map((p)=>p[1]));
    const bgB = median(ring.map((p)=>p[2]));
    const inside = [];
    const gridX = Math.max(5, Math.min(28, Math.round(width / 3)));
    const gridY = Math.max(4, Math.min(18, Math.round(height / 3)));
    for(let gy = 0; gy < gridY; gy++){
        for(let gx = 0; gx < gridX; gx++){
            const [r, g, b] = getPixel(context, canvas, left + (gx + 0.5) * width / gridX, top + (gy + 0.5) * height / gridY);
            inside.push({
                r,
                g,
                b,
                distance: Math.hypot(r - bgR, g - bgG, b - bgB)
            });
        }
    }
    const distances = inside.map((p)=>p.distance);
    const adaptiveThreshold = Math.max(28, median(distances) * 1.6);
    const ink = inside.filter((p)=>p.distance >= adaptiveThreshold).sort((a, b)=>b.distance - a.distance);
    const strongest = ink.slice(0, Math.max(1, Math.ceil(ink.length * 0.55)));
    const textR = strongest.length ? median(strongest.map((p)=>p.r)) : (bgR + bgG + bgB) / 3 > 140 ? 20 : 240;
    const textG = strongest.length ? median(strongest.map((p)=>p.g)) : textR;
    const textB = strongest.length ? median(strongest.map((p)=>p.b)) : textR;
    return {
        backgroundColor: rgbHex(bgR, bgG, bgB),
        textColor: rgbHex(textR, textG, textB),
        inkCoverage: ink.length / Math.max(1, inside.length)
    };
}
function typographyFontString(typography, size = typography.fontSize) {
    return `${typography.fontStyle} ${typography.fontWeight} ${Math.max(1, size)}px ${typography.fontFamily}`;
}
function ocrCssFont(typography, size = typography.fontSize) {
    return typographyFontString(typography, size);
}
function textMetrics(text, fontFamily, fontWeight, fontStyle, fontSize) {
    const context = measureContext();
    if (!context) {
        return {
            width: Math.max(1, text.length) * fontSize * 0.52,
            ascent: fontSize * 0.78,
            descent: fontSize * 0.2
        };
    }
    context.font = `${fontStyle} ${fontWeight} ${fontSize}px ${fontFamily}`;
    const metrics = context.measureText(text || "M");
    const ascent = metrics.actualBoundingBoxAscent || fontSize * 0.78;
    const descent = metrics.actualBoundingBoxDescent || fontSize * 0.2;
    return {
        width: metrics.width,
        ascent,
        descent
    };
}
function measureOcrText(text, typography) {
    const metrics = textMetrics(text || " ", typography.fontFamily, typography.fontWeight, typography.fontStyle, typography.fontSize);
    const spacing = Math.max(0, text.length - 1) * typography.letterSpacing;
    const naturalWidth = Math.max(1, metrics.width + spacing);
    return {
        naturalWidth,
        width: naturalWidth * typography.scaleX,
        ascent: metrics.ascent,
        descent: metrics.descent,
        height: metrics.ascent + metrics.descent
    };
}
function normalizedFontName(raw) {
    return (raw || "").replace(/[_-]+/g, " ").replace(/\s+/g, " ").trim();
}
function fontStyleFromName(normalized) {
    const lower = normalized.toLocaleLowerCase();
    const fontWeight = /black|heavy|extra\s*bold|bold/.test(lower) ? 700 : /semi\s*bold|demi/.test(lower) ? 600 : /medium/.test(lower) ? 500 : 400;
    const fontStyle = /italic|oblique/.test(lower) ? "italic" : "normal";
    return {
        fontWeight,
        fontStyle
    };
}
function stripStyleTokens(normalized) {
    return normalized.replace(/\b(regular|roman|book|normal|medium|semi\s*bold|semibold|demi|extra\s*bold|extrabold|bold|black|heavy|italic|oblique)\b/gi, " ").replace(/\s+/g, " ").trim();
}
function quotedFamily(name) {
    return `"${name.replace(/"/g, "")}"`;
}
function fontFromTesseract(raw) {
    const normalized = normalizedFontName(raw);
    if (!normalized) return null;
    const lower = normalized.toLocaleLowerCase();
    const { fontWeight, fontStyle } = fontStyleFromName(normalized);
    if (/courier|mono|typewriter/.test(lower)) return {
        fontFamily: '"Courier New", Courier, monospace',
        fontWeight,
        fontStyle
    };
    if (/times/.test(lower)) return {
        fontFamily: '"Times New Roman", Times, serif',
        fontWeight,
        fontStyle
    };
    if (/cambria/.test(lower)) return {
        fontFamily: 'Cambria, Georgia, "Times New Roman", serif',
        fontWeight,
        fontStyle
    };
    if (/georgia/.test(lower)) return {
        fontFamily: 'Georgia, "Times New Roman", serif',
        fontWeight,
        fontStyle
    };
    if (/garamond/.test(lower)) return {
        fontFamily: 'Garamond, Georgia, "Times New Roman", serif',
        fontWeight,
        fontStyle
    };
    if (/baskerville/.test(lower)) return {
        fontFamily: 'Baskerville, Georgia, "Times New Roman", serif',
        fontWeight,
        fontStyle
    };
    if (/palatino/.test(lower)) return {
        fontFamily: '"Palatino Linotype", Palatino, Georgia, serif',
        fontWeight,
        fontStyle
    };
    if (/bookman/.test(lower)) return {
        fontFamily: '"Bookman Old Style", Georgia, serif',
        fontWeight,
        fontStyle
    };
    if (/verdana/.test(lower)) return {
        fontFamily: 'Verdana, Arial, sans-serif',
        fontWeight,
        fontStyle
    };
    if (/tahoma/.test(lower)) return {
        fontFamily: 'Tahoma, Arial, sans-serif',
        fontWeight,
        fontStyle
    };
    if (/trebuchet/.test(lower)) return {
        fontFamily: '"Trebuchet MS", Arial, sans-serif',
        fontWeight,
        fontStyle
    };
    if (/calibri/.test(lower)) return {
        fontFamily: 'Calibri, "Segoe UI", Arial, sans-serif',
        fontWeight,
        fontStyle
    };
    if (/segoe/.test(lower)) return {
        fontFamily: '"Segoe UI", Arial, sans-serif',
        fontWeight,
        fontStyle
    };
    if (/roboto/.test(lower)) return {
        fontFamily: 'Roboto, Arial, sans-serif',
        fontWeight,
        fontStyle
    };
    if (/open\s+sans/.test(lower)) return {
        fontFamily: '"Open Sans", Arial, sans-serif',
        fontWeight,
        fontStyle
    };
    if (/noto\s+sans/.test(lower)) return {
        fontFamily: '"Noto Sans", Arial, sans-serif',
        fontWeight,
        fontStyle
    };
    if (/arial/.test(lower)) return {
        fontFamily: 'Arial, Helvetica, sans-serif',
        fontWeight,
        fontStyle
    };
    if (/helvetica/.test(lower)) return {
        fontFamily: 'Helvetica, Arial, sans-serif',
        fontWeight,
        fontStyle
    };
    // Tesseract sometimes returns a usable family name that is not in our map.
    // Preserve it rather than silently replacing it with Arial. A generic stack
    // remains as a fallback if the font is not installed on the user's system.
    const family = stripStyleTokens(normalized);
    if (family && !/^serif$|^sans$|^font$/i.test(family)) {
        const generic = /serif/i.test(normalized) ? "serif" : "sans-serif";
        return {
            fontFamily: `${quotedFamily(family)}, ${generic}`,
            fontWeight,
            fontStyle
        };
    }
    if (/serif/.test(lower)) return {
        fontFamily: '"Times New Roman", Times, serif',
        fontWeight,
        fontStyle
    };
    if (/sans/.test(lower)) return {
        fontFamily: 'Arial, Helvetica, sans-serif',
        fontWeight,
        fontStyle
    };
    return null;
}
function chooseVisualWeight(coverageValues) {
    // Be deliberately conservative. Coverage varies a lot with letters such as
    // "m" vs "i"; guessing 500/600 produced a visibly wrong pasted-label look.
    // Use bold only when a line has consistently high ink density.
    const values = coverageValues.filter(Number.isFinite);
    if (!values.length) return 400;
    const coverage = median(values);
    const strong = values.filter((value)=>value >= 0.39).length / values.length;
    return coverage >= 0.36 && strong >= 0.45 ? 700 : 400;
}
function representativeWords(words) {
    return words.filter((word)=>(word.text || "").replace(/[^\p{L}\p{N}]/gu, "").length >= 2 && word.bbox).sort((a, b)=>(b.text?.length || 0) - (a.text?.length || 0)).slice(0, 4);
}
function chooseVisualFont(words, weight, style) {
    const reps = representativeWords(words);
    if (!reps.length) return 'Arial, Helvetica, sans-serif';
    let bestFamily = FONT_CANDIDATES[0].family;
    let bestScore = Number.POSITIVE_INFINITY;
    for (const candidate of FONT_CANDIDATES){
        const scores = [];
        for (const word of reps){
            const text = word.text || "";
            const box = word.bbox;
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
function inferLineTypography({ line, canvas, scaleX, scaleY }) {
    const words = line.words || [];
    const appearances = words.filter((word)=>word.bbox).slice(0, 12).map((word)=>{
        const b = word.bbox;
        return sampleAppearance(canvas, b.x0, b.y0, b.x1 - b.x0, b.y1 - b.y0);
    });
    const tesseractStyle = words.map((word)=>fontFromTesseract(word.font_name)).find(Boolean) || null;
    const fontWeight = tesseractStyle?.fontWeight ?? chooseVisualWeight(appearances.map((item)=>item.inkCoverage));
    const fontStyle = tesseractStyle?.fontStyle ?? "normal";
    const fontFamily = tesseractStyle?.fontFamily ?? chooseVisualFont(words, fontWeight, fontStyle);
    const rowHeightImage = Number(line.rowAttributes?.rowHeight);
    const measuredLineHeight = Math.max(1, ((line.bbox?.y1 || 0) - (line.bbox?.y0 || 0)) * scaleY);
    const rowHeight = Number.isFinite(rowHeightImage) && rowHeightImage > 0 ? rowHeightImage * scaleY : measuredLineHeight;
    // Tesseract's rowHeight is x-height + ascenders - descenders. Tesseract itself
    // uses this row metric to derive point size; individual word boxes are not a
    // stable font-size metric because "ace" and "Hgj" naturally have different
    // visible heights in the same font. Since our OCR canvas is rendered directly
    // from PDF points, converting rowHeight back to page coordinates gives the
    // correct primary size estimate for the fixed-layout overlay.
    let fontSize = rowHeight;
    // Keep a word-bbox estimate only as a guard for malformed/missing row metrics.
    // It must never drive ordinary lines, which was the source of size jitter.
    const bboxSizes = [];
    for (const word of representativeWords(words)){
        const b = word.bbox;
        const targetHeight = Math.max(1, (b.y1 - b.y0) * scaleY);
        const metrics100 = textMetrics(word.text || "M", fontFamily, fontWeight, fontStyle, 100);
        const measuredHeight = Math.max(1, metrics100.ascent + metrics100.descent);
        bboxSizes.push(targetHeight / measuredHeight * 100);
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
        source: tesseractStyle ? "tesseract" : "visual"
    };
}
function lineBaselineAt(line, xImage, scaleY) {
    const baseline = line.baseline;
    const x0 = Number(baseline?.x0);
    const x1 = Number(baseline?.x1);
    const y0 = Number(baseline?.y0);
    const y1 = Number(baseline?.y1);
    if ([
        x0,
        x1,
        y0,
        y1
    ].every(Number.isFinite) && Math.abs(x1 - x0) > 0.001) {
        const t = (xImage - x0) / (x1 - x0);
        return (y0 + (y1 - y0) * t) * scaleY;
    }
    if (Number.isFinite(y0)) return y0 * scaleY;
    return null;
}
function makeTypographyForWord({ line, word, lineStyle, scaleX, scaleY }) {
    const b = word.bbox;
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
    const baselineY = baseline ?? b.y1 * scaleY - Math.max(0, metrics.descent * 0.12);
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
        source: lineStyle.source
    };
}
function parseBlockWords({ blocks, pageId, canvasWidth, canvasHeight, baseWidth, baseHeight, canvas }) {
    if (!blocks?.length) return [];
    const scaleX = baseWidth / Math.max(1, canvasWidth);
    const scaleY = baseHeight / Math.max(1, canvasHeight);
    const output = [];
    let wordIndex = 0;
    blocks.forEach((block, blockIndex)=>{
        block.paragraphs?.forEach((paragraph, paragraphIndex)=>{
            paragraph.lines?.forEach((line, lineIndex)=>{
                const words = (line.words || []).filter((word)=>word.bbox && (word.text || "").trim());
                if (!words.length) return;
                const lineStyle = inferLineTypography({
                    line: {
                        ...line,
                        words
                    },
                    canvas,
                    scaleX,
                    scaleY
                });
                const lineKey = `${blockIndex}:${paragraphIndex}:${lineIndex}`;
                words.forEach((word)=>{
                    const b = word.bbox;
                    const left = b.x0;
                    const top = b.y0;
                    const width = Math.max(1, b.x1 - b.x0);
                    const height = Math.max(1, b.y1 - b.y0);
                    const appearance = sampleAppearance(canvas, left, top, width, height);
                    output.push({
                        id: `ocr_${pageId}_${wordIndex++}`,
                        pageId,
                        text: (word.text || "").trim(),
                        originalText: (word.text || "").trim(),
                        edited: false,
                        confidence: Number.isFinite(Number(word.confidence)) ? Number(word.confidence) : 0,
                        x: left * scaleX,
                        y: top * scaleY,
                        width: width * scaleX,
                        height: height * scaleY,
                        lineKey,
                        backgroundColor: appearance.backgroundColor,
                        textColor: appearance.textColor,
                        typography: makeTypographyForWord({
                            line,
                            word,
                            lineStyle,
                            scaleX,
                            scaleY
                        })
                    });
                });
            });
        });
    });
    return output;
}
function parseTsvWords({ tsv, pageId, canvasWidth, canvasHeight, baseWidth, baseHeight, canvas }) {
    if (!tsv) return [];
    const scaleX = baseWidth / Math.max(1, canvasWidth);
    const scaleY = baseHeight / Math.max(1, canvasHeight);
    const lines = tsv.split(/\r?\n/);
    const raw = [];
    for(let index = 1; index < lines.length; index++){
        const columns = lines[index].split("\t");
        if (columns.length < 12 || columns[0] !== "5") continue;
        const text = columns.slice(11).join("\t").trim();
        if (!text) continue;
        const left = Number(columns[6]);
        const top = Number(columns[7]);
        const width = Number(columns[8]);
        const height = Number(columns[9]);
        const confidence = Number(columns[10]);
        if (![
            left,
            top,
            width,
            height
        ].every(Number.isFinite) || width <= 0 || height <= 0) continue;
        raw.push({
            index,
            text,
            left,
            top,
            width,
            height,
            confidence,
            lineKey: `${columns[2] || 0}:${columns[3] || 0}:${columns[4] || 0}`,
            appearance: sampleAppearance(canvas, left, top, width, height)
        });
    }
    const byLine = new Map();
    raw.forEach((word)=>{
        if (!byLine.has(word.lineKey)) byLine.set(word.lineKey, []);
        byLine.get(word.lineKey).push(word);
    });
    return raw.map((word)=>{
        const lineWords = byLine.get(word.lineKey) || [
            word
        ];
        const lineHeight = median(lineWords.map((item)=>item.height)) * scaleY * 1.15;
        const fontWeight = chooseVisualWeight(lineWords.map((item)=>item.appearance.inkCoverage));
        const fontFamily = 'Arial, Helvetica, sans-serif';
        const fontSize = Math.max(4, median(lineWords.map((item)=>item.height * scaleY)) * 1.03);
        const metrics = textMetrics(word.text, fontFamily, fontWeight, "normal", fontSize);
        const targetWidth = word.width * scaleX;
        const charGaps = Math.max(0, word.text.length - 1);
        const letterSpacing = charGaps ? clamp((targetWidth - metrics.width) / charGaps, -fontSize * 0.05, fontSize * 0.08) : 0;
        const scaleCorrection = targetWidth / Math.max(1, metrics.width + charGaps * letterSpacing);
        return {
            id: `ocr_${pageId}_${word.index}`,
            pageId,
            text: word.text,
            originalText: word.text,
            edited: false,
            confidence: Number.isFinite(word.confidence) ? word.confidence : 0,
            x: word.left * scaleX,
            y: word.top * scaleY,
            width: targetWidth,
            height: word.height * scaleY,
            lineKey: word.lineKey,
            backgroundColor: word.appearance.backgroundColor,
            textColor: word.appearance.textColor,
            typography: {
                fontFamily,
                fontWeight,
                fontStyle: "normal",
                fontSize,
                lineHeight,
                baselineY: (word.top + word.height) * scaleY - metrics.descent * 0.12,
                ascent: metrics.ascent,
                descent: metrics.descent,
                letterSpacing,
                scaleX: clamp(scaleCorrection, 0.94, 1.06),
                source: "fallback"
            }
        };
    });
}
function ocrTextFromWords(words) {
    const lineOrder = [];
    const lines = new Map();
    for (const word of words){
        if (!lines.has(word.lineKey)) {
            lines.set(word.lineKey, []);
            lineOrder.push(word.lineKey);
        }
        lines.get(word.lineKey).push(word);
    }
    return lineOrder.map((key)=>lines.get(key).sort((a, b)=>a.x - b.x).map((word)=>word.text).filter(Boolean).join(" ")).filter(Boolean).join("\n");
}
function makeOcrResult({ page, language, text, words }) {
    return {
        pageId: page.id,
        language,
        text: text.trim() || ocrTextFromWords(words),
        words,
        recognizedAt: Date.now()
    };
}
if (typeof globalThis.$RefreshHelpers$ === 'object' && globalThis.$RefreshHelpers !== null) {
    __turbopack_context__.k.registerExports(__turbopack_context__.m, globalThis.$RefreshHelpers$);
}
}),
"[project]/lib/utils.ts [app-client] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "clamp",
    ()=>clamp,
    "downloadBlob",
    ()=>downloadBlob,
    "fileToDataUrl",
    ()=>fileToDataUrl,
    "hexToRgb01",
    ()=>hexToRgb01,
    "uid",
    ()=>uid
]);
function uid(prefix = "id") {
    return `${prefix}_${crypto.randomUUID()}`;
}
function clamp(value, min, max) {
    return Math.min(max, Math.max(min, value));
}
function hexToRgb01(hex) {
    const normalized = hex.replace("#", "");
    const value = normalized.length === 3 ? normalized.split("").map((c)=>c + c).join("") : normalized.padEnd(6, "0").slice(0, 6);
    return {
        r: parseInt(value.slice(0, 2), 16) / 255,
        g: parseInt(value.slice(2, 4), 16) / 255,
        b: parseInt(value.slice(4, 6), 16) / 255
    };
}
function downloadBlob(data, filename) {
    const blob = new Blob([
        data
    ], {
        type: "application/pdf"
    });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = filename;
    a.click();
    setTimeout(()=>URL.revokeObjectURL(url), 2000);
}
async function fileToDataUrl(file) {
    return await new Promise((resolve, reject)=>{
        const reader = new FileReader();
        reader.onload = ()=>resolve(String(reader.result));
        reader.onerror = ()=>reject(reader.error);
        reader.readAsDataURL(file);
    });
}
if (typeof globalThis.$RefreshHelpers$ === 'object' && globalThis.$RefreshHelpers !== null) {
    __turbopack_context__.k.registerExports(__turbopack_context__.m, globalThis.$RefreshHelpers$);
}
}),
]);

//# sourceMappingURL=_1oxiz3p._.js.map