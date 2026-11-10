module.exports = [
"[project]/components/ocr-panel.tsx [app-ssr] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "OcrPanel",
    ()=>OcrPanel
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/server/route-modules/app-page/vendored/ssr/react-jsx-dev-runtime.js [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$copy$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Copy$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/copy.mjs [app-ssr] (ecmascript) <export default as Copy>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$loader$2d$circle$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__LoaderCircle$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/loader-circle.mjs [app-ssr] (ecmascript) <export default as LoaderCircle>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pencil$2d$line$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PencilLine$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/pencil-line.mjs [app-ssr] (ecmascript) <export default as PencilLine>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$scan$2d$text$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__ScanText$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/scan-text.mjs [app-ssr] (ecmascript) <export default as ScanText>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$search$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Search$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/search.mjs [app-ssr] (ecmascript) <export default as Search>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/trash.mjs [app-ssr] (ecmascript) <export default as Trash2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/ocr.ts [app-ssr] (ecmascript)");
"use client";
;
;
;
function OcrPanel({ activePage, activeResult, language, onLanguageChange, running, progress, recognizedCount, totalPages, onRecognizePage, onRecognizeAll, search, onSearchChange, searchHits, onSelectPage, selectable, onSelectableChange, onCopyText, onClearPage, onClearAll }) {
    const scanWords = activeResult?.words.filter((word)=>word.source === "scan-ocr") ?? [];
    const nativeWords = activeResult?.words.filter((word)=>word.source === "native-pdf") ?? [];
    const averageConfidence = scanWords.length ? Math.round(scanWords.reduce((sum, word)=>sum + word.confidence, 0) / scanWords.length) : null;
    const totalMatches = searchHits.reduce((sum, item)=>sum + item.count, 0);
    const editedCount = activeResult?.words.filter((word)=>word.edited).length ?? 0;
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        className: "space-y-5",
        children: [
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mb-2 text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                        children: "Editable text"
                    }, void 0, false, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 59,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("label", {
                        className: "block text-[11px] text-zinc-500",
                        children: [
                            "Language",
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("select", {
                                value: language,
                                disabled: running,
                                onChange: (event)=>onLanguageChange(event.target.value),
                                className: "mt-2 w-full rounded-xl border border-white/8 bg-[#15171c] px-2.5 py-2 text-xs text-zinc-200 outline-none focus:border-blue-500/50 disabled:opacity-50",
                                children: __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["OCR_LANGUAGES"].map((item)=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("option", {
                                        value: item.code,
                                        children: item.label
                                    }, item.code, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 68,
                                        columnNumber: 42
                                    }, this))
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 62,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 60,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-3 grid grid-cols-2 gap-2",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                disabled: running || !activePage,
                                onClick: onRecognizePage,
                                className: "flex items-center justify-center gap-2 rounded-xl bg-blue-600 px-2 py-2 text-xs font-semibold text-white hover:bg-blue-500 disabled:opacity-45",
                                children: [
                                    running ? /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$loader$2d$circle$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__LoaderCircle$3e$__["LoaderCircle"], {
                                        size: 14,
                                        className: "animate-spin"
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 77,
                                        columnNumber: 24
                                    }, this) : /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$scan$2d$text$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__ScanText$3e$__["ScanText"], {
                                        size: 14
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 77,
                                        columnNumber: 78
                                    }, this),
                                    "Prepare page"
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 72,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                disabled: running || totalPages === 0,
                                onClick: onRecognizeAll,
                                className: "rounded-xl border border-white/8 bg-white/[0.025] px-2 py-2 text-xs text-zinc-300 hover:bg-white/5 disabled:opacity-45",
                                children: "Prepare all"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 80,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 71,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-3 text-[10px] text-zinc-600",
                        children: [
                            recognizedCount,
                            "/",
                            totalPages,
                            " pages prepared"
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 88,
                        columnNumber: 9
                    }, this),
                    running && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-3 rounded-xl border border-blue-500/15 bg-blue-500/[0.05] p-3",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "mb-2 flex items-center justify-between gap-2 text-[10px] text-blue-200",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                        className: "truncate",
                                        children: progress.pageLabel || "Preparing text"
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 92,
                                        columnNumber: 15
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                        children: [
                                            Math.round(progress.progress * 100),
                                            "%"
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 93,
                                        columnNumber: 15
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 91,
                                columnNumber: 13
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "h-1.5 overflow-hidden rounded-full bg-white/8",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "h-full bg-blue-500 transition-[width]",
                                    style: {
                                        width: `${Math.round(progress.progress * 100)}%`
                                    }
                                }, void 0, false, {
                                    fileName: "[project]/components/ocr-panel.tsx",
                                    lineNumber: 95,
                                    columnNumber: 76
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 95,
                                columnNumber: 13
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "mt-2 truncate text-[10px] capitalize text-zinc-500",
                                children: progress.status || "Starting"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 96,
                                columnNumber: 13
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 90,
                        columnNumber: 11
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 58,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                className: "border-t border-white/7 pt-4",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mb-2 flex items-center justify-between",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                className: "text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                                children: "Search text"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 103,
                                columnNumber: 11
                            }, this),
                            search && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                className: "text-[10px] text-zinc-500",
                                children: [
                                    totalMatches,
                                    " match",
                                    totalMatches === 1 ? "" : "es"
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 104,
                                columnNumber: 22
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 102,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "relative",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$search$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Search$3e$__["Search"], {
                                size: 13,
                                className: "pointer-events-none absolute left-2.5 top-2.5 text-zinc-600"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 107,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                                value: search,
                                onChange: (event)=>onSearchChange(event.target.value),
                                placeholder: "Search editable text",
                                className: "w-full rounded-xl border border-white/8 bg-white/[0.025] py-2 pl-8 pr-2.5 text-xs text-zinc-200 outline-none placeholder:text-zinc-700 focus:border-blue-500/50"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 108,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 106,
                        columnNumber: 9
                    }, this),
                    search && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-2 max-h-32 space-y-1 overflow-y-auto",
                        children: searchHits.length ? searchHits.map((hit)=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                onClick: ()=>onSelectPage(hit.pageId),
                                className: "flex w-full items-center justify-between rounded-lg px-2 py-1.5 text-left text-[11px] text-zinc-400 hover:bg-white/5 hover:text-zinc-200",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                        className: "truncate",
                                        children: hit.label
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 119,
                                        columnNumber: 17
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                        className: "ml-2 rounded bg-white/5 px-1.5 py-0.5 text-[10px]",
                                        children: hit.count
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 119,
                                        columnNumber: 62
                                    }, this)
                                ]
                            }, hit.pageId, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 118,
                                columnNumber: 15
                            }, this)) : /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "px-2 py-2 text-[10px] text-zinc-600",
                            children: "No matches."
                        }, void 0, false, {
                            fileName: "[project]/components/ocr-panel.tsx",
                            lineNumber: 121,
                            columnNumber: 18
                        }, this)
                    }, void 0, false, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 116,
                        columnNumber: 11
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 101,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                className: "border-t border-white/7 pt-4",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                        disabled: !activeResult,
                        onClick: ()=>onSelectableChange(!selectable),
                        className: `flex w-full items-center justify-between rounded-xl border px-3 py-2 text-xs transition disabled:opacity-40 ${selectable ? "border-blue-500/30 bg-blue-500/10 text-blue-200" : "border-white/8 bg-white/[0.025] text-zinc-300 hover:bg-white/5"}`,
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                className: "flex items-center gap-2",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pencil$2d$line$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PencilLine$3e$__["PencilLine"], {
                                        size: 14
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 132,
                                        columnNumber: 53
                                    }, this),
                                    " Edit text on page"
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 132,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                className: "text-[10px]",
                                children: selectable ? "On" : "Off"
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 133,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 127,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-2 text-[10px] leading-4 text-zinc-600",
                        children: "Turn this on, then click a native PDF text run or a reconstructed scan line directly on the page. Native text reuses PDF font geometry; scans repair the original pixels and redraw the whole line instead of pasting a word label."
                    }, void 0, false, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 135,
                        columnNumber: 9
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 126,
                columnNumber: 7
            }, this),
            activeResult ? /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                className: "border-t border-white/7 pt-4",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mb-2 flex items-center justify-between",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                                        children: "Current page"
                                    }, void 0, false, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 142,
                                        columnNumber: 15
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "mt-1 text-[10px] text-zinc-600",
                                        children: [
                                            activeResult.mode === "native" && `${nativeWords.length} native text blocks`,
                                            activeResult.mode === "scan" && `${scanWords.length} reconstructed scan lines`,
                                            activeResult.mode === "mixed" && `${nativeWords.length} native blocks + ${scanWords.length} scan lines`,
                                            averageConfidence !== null ? ` · ${averageConfidence}% scan confidence` : "",
                                            editedCount ? ` · ${editedCount} edited` : ""
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/ocr-panel.tsx",
                                        lineNumber: 143,
                                        columnNumber: 15
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 141,
                                columnNumber: 13
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "Copy editable text",
                                onClick: onCopyText,
                                className: "rounded-lg p-2 text-zinc-500 hover:bg-white/5 hover:text-white",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$copy$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Copy$3e$__["Copy"], {
                                    size: 14
                                }, void 0, false, {
                                    fileName: "[project]/components/ocr-panel.tsx",
                                    lineNumber: 151,
                                    columnNumber: 144
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 151,
                                columnNumber: 13
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 140,
                        columnNumber: 11
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("textarea", {
                        readOnly: true,
                        value: activeResult.text,
                        className: "h-36 w-full resize-y rounded-xl border border-white/8 bg-white/[0.025] p-2.5 text-[11px] leading-5 text-zinc-400 outline-none"
                    }, void 0, false, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 153,
                        columnNumber: 11
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                        onClick: onClearPage,
                        className: "mt-2 flex w-full items-center justify-center gap-2 rounded-xl border border-red-500/15 bg-red-500/[0.04] py-2 text-[11px] text-red-300 hover:bg-red-500/10",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__["Trash2"], {
                                size: 13
                            }, void 0, false, {
                                fileName: "[project]/components/ocr-panel.tsx",
                                lineNumber: 154,
                                columnNumber: 208
                            }, this),
                            " Clear editable text on this page"
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/ocr-panel.tsx",
                        lineNumber: 154,
                        columnNumber: 11
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 139,
                columnNumber: 9
            }, this) : /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "rounded-xl border border-white/7 bg-white/[0.02] p-3 text-[11px] leading-5 text-zinc-500",
                children: [
                    "No editable text model on ",
                    activePage?.label || "this page",
                    ". Prepare the page: real PDF text is used directly when available; scanned pages fall back to OCR reconstruction."
                ]
            }, void 0, true, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 157,
                columnNumber: 9
            }, this),
            recognizedCount > 0 && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                onClick: onClearAll,
                className: "w-full py-1 text-[10px] text-zinc-600 hover:text-red-300",
                children: "Clear editable text from all pages"
            }, void 0, false, {
                fileName: "[project]/components/ocr-panel.tsx",
                lineNumber: 160,
                columnNumber: 31
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/ocr-panel.tsx",
        lineNumber: 57,
        columnNumber: 5
    }, this);
}
}),
"[project]/components/page-thumbnail.tsx [app-ssr] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "PageThumbnail",
    ()=>PageThumbnail
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/server/route-modules/app-page/vendored/ssr/react-jsx-dev-runtime.js [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$grip$2d$vertical$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__GripVertical$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/grip-vertical.mjs [app-ssr] (ecmascript) <export default as GripVertical>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$rotate$2d$cw$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__RotateCw$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/rotate-cw.mjs [app-ssr] (ecmascript) <export default as RotateCw>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/trash.mjs [app-ssr] (ecmascript) <export default as Trash2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/server/route-modules/app-page/vendored/ssr/react.js [app-ssr] (ecmascript)");
"use client";
;
;
;
function PageThumbnail({ pdf, page, index, active, onSelect, onDelete, onRotate, onDragStart, onDrop }) {
    const ref = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRef"])(null);
    const rootRef = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRef"])(null);
    const [visible, setVisible] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(active);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useEffect"])(()=>{
        if (active) {
            setVisible(true);
            return;
        }
        const node = rootRef.current;
        if (!node || typeof IntersectionObserver === "undefined") {
            setVisible(true);
            return;
        }
        const observer = new IntersectionObserver((entries)=>{
            if (entries.some((entry)=>entry.isIntersecting)) {
                setVisible(true);
                observer.disconnect();
            }
        }, {
            rootMargin: "320px 0px"
        });
        observer.observe(node);
        return ()=>observer.disconnect();
    }, [
        active
    ]);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useEffect"])(()=>{
        if (!visible) return;
        let cancelled = false;
        let renderTask;
        (async ()=>{
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
        })().catch((error)=>{
            if (!cancelled && error?.name !== "RenderingCancelledException") console.error(error);
        });
        return ()=>{
            cancelled = true;
            renderTask?.cancel?.();
        };
    }, [
        pdf,
        page.sourceIndex,
        page.rotation,
        visible
    ]);
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        ref: rootRef,
        draggable: true,
        onDragStart: onDragStart,
        onDragOver: (e)=>e.preventDefault(),
        onDrop: (e)=>{
            e.preventDefault();
            onDrop();
        },
        onClick: onSelect,
        className: `group relative cursor-pointer rounded-xl border p-2 transition ${active ? "border-blue-500/80 bg-blue-500/10" : "border-white/8 bg-white/[0.025] hover:border-white/15 hover:bg-white/[0.045]"}`,
        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
            className: "flex items-start gap-2",
            children: [
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$grip$2d$vertical$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__GripVertical$3e$__["GripVertical"], {
                    size: 14,
                    className: "mt-1 shrink-0 text-zinc-600 group-hover:text-zinc-400"
                }, void 0, false, {
                    fileName: "[project]/components/page-thumbnail.tsx",
                    lineNumber: 92,
                    columnNumber: 9
                }, this),
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                    className: "min-w-0 flex-1",
                    children: [
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "flex min-h-[118px] items-center justify-center overflow-hidden rounded-md bg-zinc-800 p-1 shadow-inner",
                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("canvas", {
                                ref: ref,
                                className: "max-h-[126px] max-w-full bg-white shadow"
                            }, void 0, false, {
                                fileName: "[project]/components/page-thumbnail.tsx",
                                lineNumber: 95,
                                columnNumber: 13
                            }, this)
                        }, void 0, false, {
                            fileName: "[project]/components/page-thumbnail.tsx",
                            lineNumber: 94,
                            columnNumber: 11
                        }, this),
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "mt-2 flex items-center justify-between",
                            children: [
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                    className: "text-[11px] font-medium text-zinc-400",
                                    children: [
                                        "Page ",
                                        index + 1
                                    ]
                                }, void 0, true, {
                                    fileName: "[project]/components/page-thumbnail.tsx",
                                    lineNumber: 98,
                                    columnNumber: 13
                                }, this),
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "flex opacity-0 transition group-hover:opacity-100",
                                    children: [
                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                            className: "rounded p-1 text-zinc-500 hover:bg-white/10 hover:text-white",
                                            onClick: (e)=>{
                                                e.stopPropagation();
                                                onRotate();
                                            },
                                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$rotate$2d$cw$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__RotateCw$3e$__["RotateCw"], {
                                                size: 13
                                            }, void 0, false, {
                                                fileName: "[project]/components/page-thumbnail.tsx",
                                                lineNumber: 100,
                                                columnNumber: 150
                                            }, this)
                                        }, void 0, false, {
                                            fileName: "[project]/components/page-thumbnail.tsx",
                                            lineNumber: 100,
                                            columnNumber: 15
                                        }, this),
                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                            className: "rounded p-1 text-zinc-500 hover:bg-red-500/10 hover:text-red-300",
                                            onClick: (e)=>{
                                                e.stopPropagation();
                                                onDelete();
                                            },
                                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__["Trash2"], {
                                                size: 13
                                            }, void 0, false, {
                                                fileName: "[project]/components/page-thumbnail.tsx",
                                                lineNumber: 101,
                                                columnNumber: 154
                                            }, this)
                                        }, void 0, false, {
                                            fileName: "[project]/components/page-thumbnail.tsx",
                                            lineNumber: 101,
                                            columnNumber: 15
                                        }, this)
                                    ]
                                }, void 0, true, {
                                    fileName: "[project]/components/page-thumbnail.tsx",
                                    lineNumber: 99,
                                    columnNumber: 13
                                }, this)
                            ]
                        }, void 0, true, {
                            fileName: "[project]/components/page-thumbnail.tsx",
                            lineNumber: 97,
                            columnNumber: 11
                        }, this)
                    ]
                }, void 0, true, {
                    fileName: "[project]/components/page-thumbnail.tsx",
                    lineNumber: 93,
                    columnNumber: 9
                }, this)
            ]
        }, void 0, true, {
            fileName: "[project]/components/page-thumbnail.tsx",
            lineNumber: 91,
            columnNumber: 7
        }, this)
    }, void 0, false, {
        fileName: "[project]/components/page-thumbnail.tsx",
        lineNumber: 82,
        columnNumber: 5
    }, this);
}
}),
"[project]/components/pdf-editor.tsx [app-ssr] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "PdfEditor",
    ()=>PdfEditor
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/server/route-modules/app-page/vendored/ssr/react-jsx-dev-runtime.js [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/framer-motion/dist/es/components/AnimatePresence/index.mjs [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$locals$3e$__ = __turbopack_context__.i("[project]/node_modules/motion/dist/es/react.mjs [app-ssr] (ecmascript) <locals>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$circle$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Circle$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/circle.mjs [app-ssr] (ecmascript) <export default as Circle>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$copy$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Copy$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/copy.mjs [app-ssr] (ecmascript) <export default as Copy>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$download$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Download$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/download.mjs [app-ssr] (ecmascript) <export default as Download>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$file$2d$plus$2d$corner$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__FilePlus2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/file-plus-corner.mjs [app-ssr] (ecmascript) <export default as FilePlus2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$highlighter$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Highlighter$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/highlighter.mjs [app-ssr] (ecmascript) <export default as Highlighter>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$image$2d$plus$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__ImagePlus$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/image-plus.mjs [app-ssr] (ecmascript) <export default as ImagePlus>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$loader$2d$circle$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__LoaderCircle$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/loader-circle.mjs [app-ssr] (ecmascript) <export default as LoaderCircle>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$mouse$2d$pointer$2d$2$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__MousePointer2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/mouse-pointer-2.mjs [app-ssr] (ecmascript) <export default as MousePointer2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$left$2d$close$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelLeftClose$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/panel-left-close.mjs [app-ssr] (ecmascript) <export default as PanelLeftClose>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$left$2d$open$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelLeftOpen$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/panel-left-open.mjs [app-ssr] (ecmascript) <export default as PanelLeftOpen>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$right$2d$close$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelRightClose$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/panel-right-close.mjs [app-ssr] (ecmascript) <export default as PanelRightClose>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$right$2d$open$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelRightOpen$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/panel-right-open.mjs [app-ssr] (ecmascript) <export default as PanelRightOpen>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pen$2d$line$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PenLine$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/pen-line.mjs [app-ssr] (ecmascript) <export default as PenLine>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pencil$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Pencil$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/pencil.mjs [app-ssr] (ecmascript) <export default as Pencil>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$plus$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Plus$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/plus.mjs [app-ssr] (ecmascript) <export default as Plus>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$redo$2d$2$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Redo2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/redo-2.mjs [app-ssr] (ecmascript) <export default as Redo2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$rotate$2d$cw$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__RotateCw$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/rotate-cw.mjs [app-ssr] (ecmascript) <export default as RotateCw>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$scan$2d$text$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__ScanText$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/scan-text.mjs [app-ssr] (ecmascript) <export default as ScanText>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$square$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Square$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/square.mjs [app-ssr] (ecmascript) <export default as Square>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/trash.mjs [app-ssr] (ecmascript) <export default as Trash2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$type$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Type$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/type.mjs [app-ssr] (ecmascript) <export default as Type>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$undo$2d$2$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Undo2$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/undo-2.mjs [app-ssr] (ecmascript) <export default as Undo2>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$upload$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Upload$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/upload.mjs [app-ssr] (ecmascript) <export default as Upload>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$zoom$2d$in$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__ZoomIn$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/zoom-in.mjs [app-ssr] (ecmascript) <export default as ZoomIn>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$zoom$2d$out$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__ZoomOut$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/zoom-out.mjs [app-ssr] (ecmascript) <export default as ZoomOut>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/server/route-modules/app-page/vendored/ssr/react.js [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$components$2f$pdf$2d$page$2e$tsx__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/components/pdf-page.tsx [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$components$2f$page$2d$thumbnail$2e$tsx__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/components/page-thumbnail.tsx [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$components$2f$ocr$2d$panel$2e$tsx__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/components/ocr-panel.tsx [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$components$2f$signature$2d$dialog$2e$tsx__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/components/signature-dialog.tsx [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$export$2d$pdf$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/export-pdf.ts [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/ocr.ts [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$native$2d$text$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/native-text.ts [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/utils.ts [app-ssr] (ecmascript)");
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
;
;
function yieldToBrowser() {
    return new Promise((resolve)=>window.setTimeout(resolve, 0));
}
function overlapArea(a, b) {
    const left = Math.max(a.x, b.x);
    const top = Math.max(a.y, b.y);
    const right = Math.min(a.x + a.width, b.x + b.width);
    const bottom = Math.min(a.y + a.height, b.y + b.height);
    return Math.max(0, right - left) * Math.max(0, bottom - top);
}
function mergeMixedText(nativeResult, scanResult) {
    const scanOnly = scanResult.words.filter((scan)=>{
        const area = Math.max(1, scan.width * scan.height);
        const covered = nativeResult.words.reduce((sum, native)=>sum + overlapArea(scan, native), 0);
        // OCR over real PDF text is a duplicate, not a separate editable object.
        return covered / area < 0.18 && scan.confidence >= 45;
    });
    const words = [
        ...nativeResult.words,
        ...scanOnly
    ].sort((a, b)=>Math.abs(a.y - b.y) > 2 ? a.y - b.y : a.x - b.x);
    return {
        ...scanResult,
        mode: "mixed",
        text: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["ocrTextFromWords"])(words),
        words
    };
}
const tools = [
    {
        id: "select",
        label: "Select",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$mouse$2d$pointer$2d$2$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__MousePointer2$3e$__["MousePointer2"],
        shortcut: "V"
    },
    {
        id: "text",
        label: "Text",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$type$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Type$3e$__["Type"],
        shortcut: "T"
    },
    {
        id: "highlight",
        label: "Highlight",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$highlighter$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Highlighter$3e$__["Highlighter"],
        shortcut: "H"
    },
    {
        id: "rect",
        label: "Rectangle",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$square$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Square$3e$__["Square"],
        shortcut: "R"
    },
    {
        id: "ellipse",
        label: "Ellipse",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$circle$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Circle$3e$__["Circle"],
        shortcut: "O"
    },
    {
        id: "draw",
        label: "Draw",
        icon: __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pencil$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Pencil$3e$__["Pencil"],
        shortcut: "P"
    }
];
function PdfEditor() {
    const [pdf, setPdf] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(null);
    const [sourceBytes, setSourceBytes] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(null);
    const [filename, setFilename] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])("document.pdf");
    const [pages, setPages] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])([]);
    const [annotations, setAnnotations] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])([]);
    const [activePageId, setActivePageId] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(null);
    const [selectedId, setSelectedId] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(null);
    const [tool, setTool] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])("select");
    const [zoom, setZoom] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(0.95);
    const [leftOpen, setLeftOpen] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(true);
    const [rightOpen, setRightOpen] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(true);
    const [past, setPast] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])([]);
    const [future, setFuture] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])([]);
    const [dragIndex, setDragIndex] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(null);
    const [loading, setLoading] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(false);
    const [exporting, setExporting] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(false);
    const [error, setError] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(null);
    const [signatureOpen, setSignatureOpen] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(false);
    const [pendingImage, setPendingImage] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(null);
    const [defaults, setDefaults] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])({
        color: "#2563eb",
        opacity: 1,
        strokeWidth: 2,
        fontSize: 18
    });
    const [rightPanel, setRightPanel] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])("properties");
    const [ocrResults, setOcrResults] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])([]);
    const [ocrLanguage, setOcrLanguage] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])("eng");
    const [ocrRunning, setOcrRunning] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(false);
    const [ocrProgress, setOcrProgress] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])({
        progress: 0,
        status: "",
        pageLabel: ""
    });
    const [ocrSearch, setOcrSearch] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])("");
    const [ocrSelectable, setOcrSelectable] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(false);
    const fileInput = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRef"])(null);
    const imageInput = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRef"])(null);
    const activePage = pages.find((page)=>page.id === activePageId) ?? pages[0] ?? null;
    const selected = annotations.find((annotation)=>annotation.id === selectedId) ?? null;
    const pageAnnotations = activePage ? annotations.filter((annotation)=>annotation.pageId === activePage.id) : [];
    const activeOcrResult = activePage ? ocrResults.find((result)=>result.pageId === activePage.id) ?? null : null;
    const normalizedOcrSearch = ocrSearch.trim().toLocaleLowerCase();
    const ocrSearchTerms = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useMemo"])(()=>normalizedOcrSearch.split(/\s+/).filter(Boolean), [
        normalizedOcrSearch
    ]);
    const ocrSearchHits = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useMemo"])(()=>{
        if (!ocrSearchTerms.length) return [];
        return pages.flatMap((page)=>{
            const result = ocrResults.find((item)=>item.pageId === page.id);
            if (!result) return [];
            const count = result.words.filter((word)=>{
                const value = word.text.toLocaleLowerCase();
                return ocrSearchTerms.some((term)=>value.includes(term));
            }).length;
            return count ? [
                {
                    pageId: page.id,
                    label: page.label,
                    count
                }
            ] : [];
        });
    }, [
        ocrSearchTerms,
        ocrResults,
        pages
    ]);
    const snapshot = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(()=>({
            // Editor updates are immutable, so undo can retain structural references.
            // Deep-cloning OCR results here copied every PNG repair patch on each edit
            // and became another major source of main-thread stalls.
            pages,
            annotations,
            ocrResults
        }), [
        pages,
        annotations,
        ocrResults
    ]);
    const checkpoint = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(()=>{
        const current = snapshot();
        setPast((items)=>[
                ...items.slice(-49),
                current
            ]);
        setFuture([]);
    }, [
        snapshot
    ]);
    const undo = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(()=>{
        if (!past.length) return;
        const previous = past[past.length - 1];
        setPast((items)=>items.slice(0, -1));
        setFuture((items)=>[
                snapshot(),
                ...items
            ].slice(0, 50));
        setPages(previous.pages);
        setAnnotations(previous.annotations);
        setOcrResults(previous.ocrResults);
        setSelectedId(null);
    }, [
        past,
        snapshot
    ]);
    const redo = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(()=>{
        if (!future.length) return;
        const next = future[0];
        setFuture((items)=>items.slice(1));
        setPast((items)=>[
                ...items.slice(-49),
                snapshot()
            ]);
        setPages(next.pages);
        setAnnotations(next.annotations);
        setOcrResults(next.ocrResults);
        setSelectedId(null);
    }, [
        future,
        snapshot
    ]);
    const openFile = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(async (file)=>{
        if (!file || file.type !== "application/pdf") {
            setError("Choose a PDF file.");
            return;
        }
        setLoading(true);
        setError(null);
        try {
            const bytes = new Uint8Array(await file.arrayBuffer());
            const pdfjs = await __turbopack_context__.A("[project]/node_modules/pdfjs-dist/build/pdf.mjs [app-ssr] (ecmascript, async loader)");
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
                    id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["uid"])("page"),
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
    }, []);
    const patchAnnotation = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])((id, patch)=>{
        setAnnotations((items)=>items.map((item)=>item.id === id ? {
                    ...item,
                    ...patch
                } : item));
    }, []);
    const deleteSelected = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(()=>{
        if (!selectedId) return;
        checkpoint();
        setAnnotations((items)=>items.filter((item)=>item.id !== selectedId));
        setSelectedId(null);
    }, [
        selectedId,
        checkpoint
    ]);
    const rotatePage = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(async (pageId)=>{
        const page = pages.find((item)=>item.id === pageId);
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
        const transformPoint = (x, y)=>{
            const [pdfX, pdfY] = oldViewport.convertToPdfPoint(x, y);
            const [nextX, nextY] = newViewport.convertToViewportPoint(pdfX, pdfY);
            return {
                x: nextX,
                y: nextY
            };
        };
        setPages((items)=>items.map((item)=>item.id === pageId ? {
                    ...item,
                    rotation: nextRotation
                } : item));
        setAnnotations((items)=>items.map((annotation)=>{
                if (annotation.pageId !== pageId) return annotation;
                if (annotation.type === "draw" && annotation.points) {
                    const points = annotation.points.map((point)=>transformPoint(point.x, point.y));
                    const xs = points.map((point)=>point.x);
                    const ys = points.map((point)=>point.y);
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
            }));
        setOcrResults((items)=>items.filter((result)=>result.pageId !== pageId));
    }, [
        pages,
        pdf,
        checkpoint
    ]);
    const deletePage = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])((pageId)=>{
        if (pages.length <= 1) return;
        checkpoint();
        const index = pages.findIndex((page)=>page.id === pageId);
        const next = pages.filter((page)=>page.id !== pageId);
        setPages(next);
        setAnnotations((items)=>items.filter((item)=>item.pageId !== pageId));
        setOcrResults((items)=>items.filter((item)=>item.pageId !== pageId));
        if (activePageId === pageId) setActivePageId(next[Math.min(index, next.length - 1)]?.id ?? null);
        setSelectedId(null);
    }, [
        pages,
        checkpoint,
        activePageId
    ]);
    const duplicatePage = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(()=>{
        if (!activePage) return;
        checkpoint();
        const copyId = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["uid"])("page");
        const pageCopy = {
            ...activePage,
            id: copyId,
            label: `${activePage.label} copy`
        };
        const index = pages.findIndex((page)=>page.id === activePage.id);
        setPages((items)=>[
                ...items.slice(0, index + 1),
                pageCopy,
                ...items.slice(index + 1)
            ]);
        const copiedAnnotations = annotations.filter((annotation)=>annotation.pageId === activePage.id).map((annotation)=>({
                ...structuredClone(annotation),
                id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["uid"])("ann"),
                pageId: copyId
            }));
        setAnnotations((items)=>[
                ...items,
                ...copiedAnnotations
            ]);
        const sourceOcr = ocrResults.find((result)=>result.pageId === activePage.id);
        if (sourceOcr) {
            setOcrResults((items)=>[
                    ...items,
                    {
                        ...structuredClone(sourceOcr),
                        pageId: copyId,
                        words: sourceOcr.words.map((word, index)=>({
                                ...word,
                                id: `ocr_${copyId}_${index}`,
                                pageId: copyId
                            }))
                    }
                ]);
        }
        setActivePageId(copyId);
    }, [
        activePage,
        pages,
        annotations,
        ocrResults,
        checkpoint
    ]);
    const movePage = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])((from, to)=>{
        if (from === to) return;
        checkpoint();
        setPages((items)=>{
            const next = [
                ...items
            ];
            const [moved] = next.splice(from, 1);
            next.splice(to, 0, moved);
            return next;
        });
    }, [
        checkpoint
    ]);
    const recognizePages = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(async (targetPages)=>{
        if (!pdf || !targetPages.length || ocrRunning) return;
        checkpoint();
        setOcrRunning(true);
        setError(null);
        setOcrSelectable(false);
        let worker = null;
        let pageCursor = 0;
        let lastProgressPaint = 0;
        try {
            for(let index = 0; index < targetPages.length; index++){
                pageCursor = index;
                const page = targetPages[index];
                setOcrProgress({
                    progress: index / targetPages.length,
                    status: "Inspecting PDF text",
                    pageLabel: page.label
                });
                await yieldToBrowser();
                // First choice: actual PDF text. This preserves the PDF's own embedded
                // font/metrics and avoids OCR on text that already exists as real content.
                const inspection = await (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$native$2d$text$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["inspectPageTextMode"])(pdf, page);
                const nativeResult = inspection.mode === "native" ? await (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$native$2d$text$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["extractNativeEditableText"])({
                    pdf,
                    page
                }) : null;
                if (nativeResult?.words.length && !inspection.hasRasterImages) {
                    setOcrResults((items)=>[
                            ...items.filter((item)=>item.pageId !== page.id),
                            nativeResult
                        ]);
                    setOcrProgress({
                        progress: (index + 1) / targetPages.length,
                        status: `${nativeResult.words.length} native text blocks · OCR skipped`,
                        pageLabel: page.label
                    });
                    await yieldToBrowser();
                    continue;
                }
                // Scan/mixed path: OCR is semantic/layout analysis only. On mixed pages
                // we later discard OCR regions already covered by real PDF text.
                if (!worker) {
                    const { createWorker } = await __turbopack_context__.A("[project]/node_modules/tesseract.js/src/index.js [app-ssr] (ecmascript, async loader)");
                    worker = await createWorker(ocrLanguage, 1, {
                        logger: (message)=>{
                            const now = performance.now();
                            const complete = typeof message.progress === "number" && message.progress >= 1;
                            if (!complete && now - lastProgressPaint < 90) return;
                            lastProgressPaint = now;
                            const withinPage = typeof message.progress === "number" ? message.progress : 0;
                            const overall = (pageCursor + withinPage) / targetPages.length;
                            setOcrProgress((current)=>({
                                    ...current,
                                    progress: Math.min(0.99, overall),
                                    status: message.status || current.status || "Reconstructing scanned text"
                                }));
                        }
                    });
                    await worker.setParameters?.({
                        hocr_font_info: "1",
                        preserve_interword_spaces: "1"
                    });
                }
                setOcrProgress({
                    progress: index / targetPages.length,
                    status: "Rendering scan",
                    pageLabel: page.label
                });
                const rendered = await (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["renderPageForOcr"])(pdf, page);
                const response = await worker.recognize(rendered.canvas, {}, {
                    text: true,
                    blocks: true,
                    tsv: true
                });
                const structuredLines = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["parseBlockWords"])({
                    blocks: response.data.blocks,
                    pageId: page.id,
                    canvasWidth: rendered.canvas.width,
                    canvasHeight: rendered.canvas.height,
                    baseWidth: rendered.baseWidth,
                    baseHeight: rendered.baseHeight,
                    canvas: rendered.canvas
                });
                const lines = structuredLines.length ? structuredLines : (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["parseTsvWords"])({
                    tsv: response.data.tsv || "",
                    pageId: page.id,
                    canvasWidth: rendered.canvas.width,
                    canvasHeight: rendered.canvas.height,
                    baseWidth: rendered.baseWidth,
                    baseHeight: rendered.baseHeight,
                    canvas: rendered.canvas
                });
                const scanResult = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["makeOcrResult"])({
                    page,
                    language: ocrLanguage,
                    text: response.data.text || "",
                    words: lines
                });
                const result = nativeResult?.words.length ? mergeMixedText(nativeResult, scanResult) : scanResult;
                setOcrResults((items)=>[
                        ...items.filter((item)=>item.pageId !== page.id),
                        result
                    ]);
                const scanCount = result.words.filter((word)=>word.source === "scan-ocr").length;
                const nativeCount = result.words.filter((word)=>word.source === "native-pdf").length;
                setOcrProgress({
                    progress: (index + 1) / targetPages.length,
                    status: result.mode === "mixed" ? `${nativeCount} native blocks + ${scanCount} reconstructed scan lines` : `${scanCount} editable scan lines reconstructed`,
                    pageLabel: page.label
                });
                await yieldToBrowser();
            }
            setOcrSelectable(true);
        } catch (cause) {
            console.error(cause);
            setError("Text preparation failed. Native PDF text is handled locally; scanned pages may also need the OCR language model.");
        } finally{
            try {
                await worker?.terminate?.();
            } catch  {}
            setOcrRunning(false);
        }
    }, [
        pdf,
        ocrLanguage,
        ocrRunning,
        checkpoint
    ]);
    const clearOcrPage = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])((pageId)=>{
        checkpoint();
        setOcrResults((items)=>items.filter((item)=>item.pageId !== pageId));
        setOcrSelectable(false);
    }, [
        checkpoint
    ]);
    const clearAllOcr = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(()=>{
        if (!ocrResults.length) return;
        checkpoint();
        setOcrResults([]);
        setOcrSelectable(false);
    }, [
        ocrResults.length,
        checkpoint
    ]);
    const patchOcrWord = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])((pageId, wordId, patch)=>{
        setOcrResults((items)=>items.map((result)=>{
                if (result.pageId !== pageId) return result;
                const words = result.words.map((word)=>{
                    if (word.id !== wordId) return word;
                    const next = {
                        ...word,
                        ...patch
                    };
                    return {
                        ...next,
                        edited: next.text !== next.originalText
                    };
                });
                return {
                    ...result,
                    words,
                    text: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["ocrTextFromWords"])(words)
                };
            }));
    }, []);
    const copyOcrText = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(async ()=>{
        if (!activeOcrResult?.text) return;
        try {
            await navigator.clipboard.writeText(activeOcrResult.text);
        } catch  {
            setError("Could not copy OCR text to the clipboard.");
        }
    }, [
        activeOcrResult
    ]);
    const exportPdf = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useCallback"])(async ()=>{
        if (!pdf || !sourceBytes || !pages.length) return;
        setExporting(true);
        setError(null);
        try {
            const bytes = await (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$export$2d$pdf$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["exportEditedPdf"])({
                sourceBytes,
                pdfJsDocument: pdf,
                pages,
                annotations,
                ocrResults
            });
            const base = filename.replace(/\.pdf$/i, "") || "document";
            (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["downloadBlob"])(bytes, `${base}-edited.pdf`);
        } catch (cause) {
            console.error(cause);
            setError("Export failed. Try removing a problematic image or reopening the PDF.");
        } finally{
            setExporting(false);
        }
    }, [
        pdf,
        sourceBytes,
        pages,
        annotations,
        ocrResults,
        filename
    ]);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useEffect"])(()=>{
        const onKey = (event)=>{
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
                const found = tools.find((item)=>item.shortcut?.toLowerCase() === key);
                if (found) setTool(found.id);
            }
        };
        window.addEventListener("keydown", onKey);
        return ()=>window.removeEventListener("keydown", onKey);
    }, [
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
        return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
            className: "relative flex h-dvh items-center justify-center overflow-hidden bg-[#090a0c] p-6",
            onDragOver: (e)=>e.preventDefault(),
            onDrop: (e)=>{
                e.preventDefault();
                const file = e.dataTransfer.files?.[0];
                if (file) openFile(file);
            },
            children: [
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                    className: "pointer-events-none absolute inset-0 opacity-50 [background-image:radial-gradient(circle_at_50%_0%,rgba(59,130,246,.16),transparent_32%),linear-gradient(rgba(255,255,255,.025)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,.025)_1px,transparent_1px)] [background-size:auto,32px_32px,32px_32px]"
                }, void 0, false, {
                    fileName: "[project]/components/pdf-editor.tsx",
                    lineNumber: 485,
                    columnNumber: 9
                }, this),
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
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
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "mb-8 flex items-center gap-3",
                            children: [
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "grid h-10 w-10 place-items-center rounded-xl bg-blue-600 shadow-lg shadow-blue-600/20",
                                    children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$file$2d$plus$2d$corner$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__FilePlus2$3e$__["FilePlus2"], {
                                        size: 20
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 488,
                                        columnNumber: 116
                                    }, this)
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 488,
                                    columnNumber: 13
                                }, this),
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    children: [
                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("h1", {
                                            className: "text-lg font-semibold tracking-tight",
                                            children: "PDF Studio"
                                        }, void 0, false, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 489,
                                            columnNumber: 18
                                        }, this),
                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("p", {
                                            className: "text-xs text-zinc-500",
                                            children: "Private, browser-first PDF editing"
                                        }, void 0, false, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 489,
                                            columnNumber: 86
                                        }, this)
                                    ]
                                }, void 0, true, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 489,
                                    columnNumber: 13
                                }, this)
                            ]
                        }, void 0, true, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 487,
                            columnNumber: 11
                        }, this),
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                            className: "group flex min-h-[260px] w-full flex-col items-center justify-center rounded-2xl border border-dashed border-white/15 bg-white/[0.025] px-8 transition hover:border-blue-500/50 hover:bg-blue-500/[0.04]",
                            onClick: ()=>fileInput.current?.click(),
                            children: [
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "mb-4 grid h-14 w-14 place-items-center rounded-2xl border border-white/10 bg-white/[0.04] text-zinc-300 transition group-hover:scale-105 group-hover:text-white",
                                    children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$upload$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Upload$3e$__["Upload"], {
                                        size: 24
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 495,
                                        columnNumber: 190
                                    }, this)
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 495,
                                    columnNumber: 13
                                }, this),
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "text-sm font-medium",
                                    children: "Drop a PDF here or click to open"
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 496,
                                    columnNumber: 13
                                }, this),
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                    className: "mt-2 max-w-sm text-center text-xs leading-5 text-zinc-500",
                                    children: "The document stays in your browser. Edit pages, add text, markup, drawings, images and signatures, then export a new PDF."
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 497,
                                    columnNumber: 13
                                }, this)
                            ]
                        }, void 0, true, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 491,
                            columnNumber: 11
                        }, this),
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
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
                            lineNumber: 499,
                            columnNumber: 11
                        }, this),
                        loading && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "mt-4 flex items-center justify-center gap-2 text-xs text-zinc-400",
                            children: [
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$loader$2d$circle$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__LoaderCircle$3e$__["LoaderCircle"], {
                                    size: 14,
                                    className: "animate-spin"
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 500,
                                    columnNumber: 106
                                }, this),
                                " Opening PDF…"
                            ]
                        }, void 0, true, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 500,
                            columnNumber: 23
                        }, this),
                        error && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "mt-4 rounded-xl border border-red-500/20 bg-red-500/10 p-3 text-xs text-red-300",
                            children: error
                        }, void 0, false, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 501,
                            columnNumber: 21
                        }, this),
                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                            className: "mt-5 flex items-center justify-between text-[11px] text-zinc-600",
                            children: [
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                    children: "Next.js · Tailwind · Motion"
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 502,
                                    columnNumber: 93
                                }, this),
                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                    children: "PDF.js + pdf-lib"
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 502,
                                    columnNumber: 133
                                }, this)
                            ]
                        }, void 0, true, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 502,
                            columnNumber: 11
                        }, this)
                    ]
                }, void 0, true, {
                    fileName: "[project]/components/pdf-editor.tsx",
                    lineNumber: 486,
                    columnNumber: 9
                }, this)
            ]
        }, void 0, true, {
            fileName: "[project]/components/pdf-editor.tsx",
            lineNumber: 480,
            columnNumber: 7
        }, this);
    }
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
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
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("header", {
                className: "z-30 flex h-14 shrink-0 items-center border-b border-white/8 bg-[#0f1115]/95 px-3 backdrop-blur-xl",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "flex min-w-0 items-center gap-2",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                className: "grid h-8 w-8 place-items-center rounded-lg bg-blue-600",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$file$2d$plus$2d$corner$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__FilePlus2$3e$__["FilePlus2"], {
                                    size: 16
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 512,
                                    columnNumber: 86
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 512,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "min-w-0",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "max-w-[240px] truncate text-sm font-medium",
                                        children: filename
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 514,
                                        columnNumber: 13
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "text-[10px] text-zinc-600",
                                        children: [
                                            pages.length,
                                            " page",
                                            pages.length === 1 ? "" : "s",
                                            " · local editing"
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 515,
                                        columnNumber: 13
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 513,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 511,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mx-auto hidden items-center gap-1 rounded-xl border border-white/8 bg-white/[0.025] p-1 md:flex",
                        children: [
                            tools.map(({ id, label, icon: Icon, shortcut })=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                    title: `${label}${shortcut ? ` (${shortcut})` : ""}`,
                                    onClick: ()=>{
                                        setTool(id);
                                        setPendingImage(null);
                                        setOcrSelectable(false);
                                    },
                                    className: `grid h-8 w-8 place-items-center rounded-lg transition ${tool === id ? "bg-white text-black shadow" : "text-zinc-500 hover:bg-white/5 hover:text-zinc-200"}`,
                                    children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(Icon, {
                                        size: 15
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 521,
                                        columnNumber: 334
                                    }, this)
                                }, id, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 521,
                                    columnNumber: 13
                                }, this)),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "mx-1 h-5 w-px bg-white/8"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 523,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "Insert image",
                                onClick: ()=>imageInput.current?.click(),
                                className: `grid h-8 w-8 place-items-center rounded-lg text-zinc-500 transition hover:bg-white/5 hover:text-zinc-200 ${tool === "image" && pendingImage ? "bg-white text-black" : ""}`,
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$image$2d$plus$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__ImagePlus$3e$__["ImagePlus"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 524,
                                    columnNumber: 268
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 524,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "Signature",
                                onClick: ()=>setSignatureOpen(true),
                                className: "grid h-8 w-8 place-items-center rounded-lg text-zinc-500 transition hover:bg-white/5 hover:text-zinc-200",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pen$2d$line$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PenLine$3e$__["PenLine"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 525,
                                    columnNumber: 193
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 525,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "mx-1 h-5 w-px bg-white/8"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 526,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "Text preparation",
                                onClick: ()=>{
                                    setRightPanel("ocr");
                                    setRightOpen(true);
                                    setSelectedId(null);
                                },
                                className: `grid h-8 w-8 place-items-center rounded-lg transition ${rightOpen && rightPanel === "ocr" ? "bg-blue-500/15 text-blue-300" : "text-zinc-500 hover:bg-white/5 hover:text-zinc-200"}`,
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$scan$2d$text$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__ScanText$3e$__["ScanText"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 527,
                                    columnNumber: 320
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 527,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 519,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "ml-auto flex items-center gap-1.5",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                disabled: !past.length,
                                title: "Undo",
                                className: "grid h-8 w-8 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white disabled:opacity-30",
                                onClick: undo,
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$undo$2d$2$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Undo2$3e$__["Undo2"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 531,
                                    columnNumber: 194
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 531,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                disabled: !future.length,
                                title: "Redo",
                                className: "grid h-8 w-8 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white disabled:opacity-30",
                                onClick: redo,
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$redo$2d$2$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Redo2$3e$__["Redo2"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 532,
                                    columnNumber: 196
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 532,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "mx-1 h-5 w-px bg-white/8"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 533,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "Open another PDF",
                                className: "hidden h-8 items-center gap-2 rounded-lg px-2.5 text-xs text-zinc-400 hover:bg-white/5 hover:text-white sm:flex",
                                onClick: ()=>fileInput.current?.click(),
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$upload$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Upload$3e$__["Upload"], {
                                        size: 14
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 534,
                                        columnNumber: 211
                                    }, this),
                                    " Open"
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 534,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                disabled: exporting,
                                onClick: exportPdf,
                                className: "flex h-8 items-center gap-2 rounded-lg bg-white px-3 text-xs font-semibold text-black transition hover:bg-zinc-200 disabled:opacity-60",
                                children: [
                                    exporting ? /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$loader$2d$circle$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__LoaderCircle$3e$__["LoaderCircle"], {
                                        size: 14,
                                        className: "animate-spin"
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 535,
                                        columnNumber: 220
                                    }, this) : /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$download$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Download$3e$__["Download"], {
                                        size: 14
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 535,
                                        columnNumber: 274
                                    }, this),
                                    " Export"
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 535,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 530,
                        columnNumber: 9
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 510,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "flex min-h-0 flex-1",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["AnimatePresence"], {
                        initial: false,
                        children: leftOpen && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].aside, {
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
                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "flex h-full w-[220px] flex-col",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "flex h-11 shrink-0 items-center justify-between border-b border-white/6 px-3",
                                        children: [
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                                className: "text-xs font-semibold text-zinc-300",
                                                children: "Pages"
                                            }, void 0, false, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 545,
                                                columnNumber: 19
                                            }, this),
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                className: "flex gap-1",
                                                children: [
                                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                        title: "Duplicate current page",
                                                        onClick: duplicatePage,
                                                        className: "rounded-md p-1.5 text-zinc-500 hover:bg-white/5 hover:text-white",
                                                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$copy$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Copy$3e$__["Copy"], {
                                                            size: 14
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 547,
                                                            columnNumber: 161
                                                        }, this)
                                                    }, void 0, false, {
                                                        fileName: "[project]/components/pdf-editor.tsx",
                                                        lineNumber: 547,
                                                        columnNumber: 21
                                                    }, this),
                                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                        onClick: ()=>setLeftOpen(false),
                                                        className: "rounded-md p-1.5 text-zinc-500 hover:bg-white/5 hover:text-white",
                                                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$left$2d$close$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelLeftClose$3e$__["PanelLeftClose"], {
                                                            size: 14
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 548,
                                                            columnNumber: 141
                                                        }, this)
                                                    }, void 0, false, {
                                                        fileName: "[project]/components/pdf-editor.tsx",
                                                        lineNumber: 548,
                                                        columnNumber: 21
                                                    }, this)
                                                ]
                                            }, void 0, true, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 546,
                                                columnNumber: 19
                                            }, this)
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 544,
                                        columnNumber: 17
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "editor-scrollbar flex-1 space-y-2 overflow-y-auto p-2.5",
                                        children: pages.map((page, index)=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$components$2f$page$2d$thumbnail$2e$tsx__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["PageThumbnail"], {
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
                                                lineNumber: 553,
                                                columnNumber: 21
                                            }, this))
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 551,
                                        columnNumber: 17
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 543,
                                columnNumber: 15
                            }, this)
                        }, void 0, false, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 542,
                            columnNumber: 13
                        }, this)
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 540,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("main", {
                        className: "relative min-w-0 flex-1 overflow-hidden bg-[#17191d]",
                        children: [
                            !leftOpen && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                title: "Show pages",
                                onClick: ()=>setLeftOpen(true),
                                className: "absolute left-3 top-3 z-20 grid h-8 w-8 place-items-center rounded-lg border border-white/8 bg-[#111318]/90 text-zinc-400 shadow-lg backdrop-blur hover:text-white",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$left$2d$open$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelLeftOpen$3e$__["PanelLeftOpen"], {
                                    size: 15
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 562,
                                    columnNumber: 261
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 562,
                                columnNumber: 25
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "absolute left-1/2 top-3 z-20 flex -translate-x-1/2 items-center gap-1 rounded-xl border border-white/10 bg-[#111318]/92 p-1 shadow-xl backdrop-blur",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                        title: "Zoom out",
                                        className: "grid h-7 w-7 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white",
                                        onClick: ()=>setZoom((z)=>(0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["clamp"])(Number((z - 0.1).toFixed(2)), 0.25, 2.5)),
                                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$zoom$2d$out$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__ZoomOut$3e$__["ZoomOut"], {
                                            size: 14
                                        }, void 0, false, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 565,
                                            columnNumber: 220
                                        }, this)
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 565,
                                        columnNumber: 13
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                        className: "h-7 min-w-[58px] rounded-lg px-2 text-[11px] font-medium text-zinc-300 hover:bg-white/5",
                                        onClick: ()=>setZoom(1),
                                        children: [
                                            Math.round(zoom * 100),
                                            "%"
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 566,
                                        columnNumber: 13
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                        title: "Zoom in",
                                        className: "grid h-7 w-7 place-items-center rounded-lg text-zinc-500 hover:bg-white/5 hover:text-white",
                                        onClick: ()=>setZoom((z)=>(0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["clamp"])(Number((z + 0.1).toFixed(2)), 0.25, 2.5)),
                                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$zoom$2d$in$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__ZoomIn$3e$__["ZoomIn"], {
                                            size: 14
                                        }, void 0, false, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 567,
                                            columnNumber: 219
                                        }, this)
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 567,
                                        columnNumber: 13
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 564,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "editor-scrollbar h-full overflow-auto px-16 pb-20 pt-20",
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["AnimatePresence"], {
                                    mode: "wait",
                                    children: activePage && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
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
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$components$2f$pdf$2d$page$2e$tsx__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["PdfPage"], {
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
                                                onOcrWordPatch: (wordId, patch)=>activePage && patchOcrWord(activePage.id, wordId, patch)
                                            }, void 0, false, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 574,
                                                columnNumber: 19
                                            }, this),
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                className: "mt-4 text-center text-[11px] text-zinc-600",
                                                children: [
                                                    activePage.label,
                                                    " · source page ",
                                                    activePage.sourceIndex + 1
                                                ]
                                            }, void 0, true, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 593,
                                                columnNumber: 19
                                            }, this)
                                        ]
                                    }, activePage.id, true, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 573,
                                        columnNumber: 17
                                    }, this)
                                }, void 0, false, {
                                    fileName: "[project]/components/pdf-editor.tsx",
                                    lineNumber: 571,
                                    columnNumber: 13
                                }, this)
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 570,
                                columnNumber: 11
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "absolute bottom-4 left-1/2 z-20 flex -translate-x-1/2 items-center gap-1.5 rounded-xl border border-white/10 bg-[#111318]/94 px-2 py-1.5 shadow-xl backdrop-blur md:hidden",
                                children: tools.slice(0, 6).map(({ id, icon: Icon })=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                        onClick: ()=>{
                                            setTool(id);
                                            setOcrSelectable(false);
                                        },
                                        className: `grid h-8 w-8 place-items-center rounded-lg ${tool === id ? "bg-white text-black" : "text-zinc-400"}`,
                                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(Icon, {
                                            size: 15
                                        }, void 0, false, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 600,
                                            columnNumber: 249
                                        }, this)
                                    }, id, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 600,
                                        columnNumber: 60
                                    }, this))
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 599,
                                columnNumber: 11
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 561,
                        columnNumber: 9
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["AnimatePresence"], {
                        initial: false,
                        children: rightOpen && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].aside, {
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
                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "flex h-full w-[260px] flex-col",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "flex h-11 shrink-0 items-center justify-between border-b border-white/6 px-2",
                                        children: [
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                className: "flex items-center gap-1 rounded-lg bg-white/[0.025] p-0.5",
                                                children: [
                                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                        onClick: ()=>setRightPanel("properties"),
                                                        className: `rounded-md px-2 py-1.5 text-[11px] ${rightPanel === "properties" ? "bg-white/8 text-zinc-200" : "text-zinc-600 hover:text-zinc-300"}`,
                                                        children: "Properties"
                                                    }, void 0, false, {
                                                        fileName: "[project]/components/pdf-editor.tsx",
                                                        lineNumber: 610,
                                                        columnNumber: 21
                                                    }, this),
                                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                        onClick: ()=>setRightPanel("ocr"),
                                                        className: `flex items-center gap-1 rounded-md px-2 py-1.5 text-[11px] ${rightPanel === "ocr" ? "bg-blue-500/10 text-blue-300" : "text-zinc-600 hover:text-zinc-300"}`,
                                                        children: [
                                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$scan$2d$text$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__ScanText$3e$__["ScanText"], {
                                                                size: 12
                                                            }, void 0, false, {
                                                                fileName: "[project]/components/pdf-editor.tsx",
                                                                lineNumber: 611,
                                                                columnNumber: 234
                                                            }, this),
                                                            " Text"
                                                        ]
                                                    }, void 0, true, {
                                                        fileName: "[project]/components/pdf-editor.tsx",
                                                        lineNumber: 611,
                                                        columnNumber: 21
                                                    }, this)
                                                ]
                                            }, void 0, true, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 609,
                                                columnNumber: 19
                                            }, this),
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                onClick: ()=>setRightOpen(false),
                                                className: "rounded-md p-1.5 text-zinc-500 hover:bg-white/5 hover:text-white",
                                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$right$2d$close$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelRightClose$3e$__["PanelRightClose"], {
                                                    size: 14
                                                }, void 0, false, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 613,
                                                    columnNumber: 140
                                                }, this)
                                            }, void 0, false, {
                                                fileName: "[project]/components/pdf-editor.tsx",
                                                lineNumber: 613,
                                                columnNumber: 19
                                            }, this)
                                        ]
                                    }, void 0, true, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 608,
                                        columnNumber: 17
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "editor-scrollbar flex-1 overflow-y-auto p-3",
                                        children: rightPanel === "ocr" ? /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$components$2f$ocr$2d$panel$2e$tsx__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["OcrPanel"], {
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
                                            lineNumber: 617,
                                            columnNumber: 21
                                        }, this) : selected ? /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                            className: "space-y-5",
                                            children: [
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                                                    children: [
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mb-2 flex items-center justify-between",
                                                            children: [
                                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                                                    className: "text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                                                                    children: "Selected"
                                                                }, void 0, false, {
                                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                                    lineNumber: 641,
                                                                    columnNumber: 81
                                                                }, this),
                                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                                                                    className: "rounded-md bg-white/5 px-1.5 py-1 text-[10px] capitalize text-zinc-400",
                                                                    children: selected.type
                                                                }, void 0, false, {
                                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                                    lineNumber: 641,
                                                                    columnNumber: 179
                                                                }, this)
                                                            ]
                                                        }, void 0, true, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 641,
                                                            columnNumber: 25
                                                        }, this),
                                                        selected.type === "text" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("textarea", {
                                                            value: selected.text || "",
                                                            onFocus: checkpoint,
                                                            onChange: (e)=>patchAnnotation(selected.id, {
                                                                    text: e.target.value
                                                                }),
                                                            className: "min-h-24 w-full resize-y rounded-xl border border-white/8 bg-white/[0.025] p-2.5 text-xs leading-5 text-zinc-200 outline-none focus:border-blue-500/50"
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 642,
                                                            columnNumber: 54
                                                        }, this)
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 640,
                                                    columnNumber: 23
                                                }, this),
                                                selected.type !== "image" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyColor, {
                                                    value: selected.color,
                                                    onChange: (color)=>inspectorPatch({
                                                            color
                                                        })
                                                }, void 0, false, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 645,
                                                    columnNumber: 53
                                                }, this),
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
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
                                                    lineNumber: 646,
                                                    columnNumber: 23
                                                }, this),
                                                (selected.type === "rect" || selected.type === "ellipse" || selected.type === "draw") && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
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
                                                    lineNumber: 647,
                                                    columnNumber: 113
                                                }, this),
                                                selected.type === "text" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
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
                                                    lineNumber: 648,
                                                    columnNumber: 52
                                                }, this),
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                    className: "grid grid-cols-2 gap-2 border-t border-white/7 pt-4",
                                                    children: [
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(NumberField, {
                                                            label: "X",
                                                            value: selected.x,
                                                            onChange: (x)=>inspectorPatch({
                                                                    x
                                                                })
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 651,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(NumberField, {
                                                            label: "Y",
                                                            value: selected.y,
                                                            onChange: (y)=>inspectorPatch({
                                                                    y
                                                                })
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 652,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(NumberField, {
                                                            label: "W",
                                                            value: selected.width,
                                                            onChange: (width)=>inspectorPatch({
                                                                    width: Math.max(1, width)
                                                                })
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 653,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(NumberField, {
                                                            label: "H",
                                                            value: selected.height,
                                                            onChange: (height)=>inspectorPatch({
                                                                    height: Math.max(1, height)
                                                                })
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 654,
                                                            columnNumber: 25
                                                        }, this)
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 650,
                                                    columnNumber: 23
                                                }, this),
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                    onClick: deleteSelected,
                                                    className: "flex w-full items-center justify-center gap-2 rounded-xl border border-red-500/15 bg-red-500/[0.06] py-2 text-xs font-medium text-red-300 hover:bg-red-500/10",
                                                    children: [
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$trash$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Trash2$3e$__["Trash2"], {
                                                            size: 14
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 656,
                                                            columnNumber: 226
                                                        }, this),
                                                        " Delete annotation"
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 656,
                                                    columnNumber: 23
                                                }, this)
                                            ]
                                        }, void 0, true, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 639,
                                            columnNumber: 21
                                        }, this) : /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                            className: "space-y-5",
                                            children: [
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                                                    children: [
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mb-3 text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                                                            children: "Tool defaults"
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 661,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyColor, {
                                                            value: defaults.color,
                                                            onChange: (color)=>setDefaults((d)=>({
                                                                        ...d,
                                                                        color
                                                                    }))
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 662,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mt-4",
                                                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
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
                                                                lineNumber: 663,
                                                                columnNumber: 47
                                                            }, this)
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 663,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mt-4",
                                                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
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
                                                                lineNumber: 664,
                                                                columnNumber: 47
                                                            }, this)
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 664,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mt-4",
                                                            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(PropertyRange, {
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
                                                                lineNumber: 665,
                                                                columnNumber: 47
                                                            }, this)
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 665,
                                                            columnNumber: 25
                                                        }, this)
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 660,
                                                    columnNumber: 23
                                                }, this),
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("section", {
                                                    className: "border-t border-white/7 pt-4",
                                                    children: [
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "mb-3 text-[11px] font-semibold uppercase tracking-wider text-zinc-600",
                                                            children: "Page"
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 668,
                                                            columnNumber: 25
                                                        }, this),
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                            className: "grid grid-cols-2 gap-2",
                                                            children: [
                                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                                    onClick: ()=>activePage && rotatePage(activePage.id),
                                                                    className: "flex items-center justify-center gap-2 rounded-xl border border-white/8 bg-white/[0.025] py-2 text-xs text-zinc-300 hover:bg-white/5",
                                                                    children: [
                                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$rotate$2d$cw$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__RotateCw$3e$__["RotateCw"], {
                                                                            size: 14
                                                                        }, void 0, false, {
                                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                                            lineNumber: 670,
                                                                            columnNumber: 236
                                                                        }, this),
                                                                        " Rotate"
                                                                    ]
                                                                }, void 0, true, {
                                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                                    lineNumber: 670,
                                                                    columnNumber: 27
                                                                }, this),
                                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                                                    onClick: duplicatePage,
                                                                    className: "flex items-center justify-center gap-2 rounded-xl border border-white/8 bg-white/[0.025] py-2 text-xs text-zinc-300 hover:bg-white/5",
                                                                    children: [
                                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$copy$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Copy$3e$__["Copy"], {
                                                                            size: 14
                                                                        }, void 0, false, {
                                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                                            lineNumber: 671,
                                                                            columnNumber: 204
                                                                        }, this),
                                                                        " Duplicate"
                                                                    ]
                                                                }, void 0, true, {
                                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                                    lineNumber: 671,
                                                                    columnNumber: 27
                                                                }, this)
                                                            ]
                                                        }, void 0, true, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 669,
                                                            columnNumber: 25
                                                        }, this)
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 667,
                                                    columnNumber: 23
                                                }, this),
                                                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                                    className: "rounded-xl border border-white/7 bg-white/[0.02] p-3 text-[11px] leading-5 text-zinc-500",
                                                    children: [
                                                        "Choose a tool above, then click or drag on the page. Press ",
                                                        /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("b", {
                                                            className: "font-medium text-zinc-400",
                                                            children: "V"
                                                        }, void 0, false, {
                                                            fileName: "[project]/components/pdf-editor.tsx",
                                                            lineNumber: 674,
                                                            columnNumber: 188
                                                        }, this),
                                                        " to return to Select. Double-click text to edit it quickly."
                                                    ]
                                                }, void 0, true, {
                                                    fileName: "[project]/components/pdf-editor.tsx",
                                                    lineNumber: 674,
                                                    columnNumber: 23
                                                }, this)
                                            ]
                                        }, void 0, true, {
                                            fileName: "[project]/components/pdf-editor.tsx",
                                            lineNumber: 659,
                                            columnNumber: 21
                                        }, this)
                                    }, void 0, false, {
                                        fileName: "[project]/components/pdf-editor.tsx",
                                        lineNumber: 615,
                                        columnNumber: 17
                                    }, this)
                                ]
                            }, void 0, true, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 607,
                                columnNumber: 15
                            }, this)
                        }, void 0, false, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 606,
                            columnNumber: 13
                        }, this)
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 604,
                        columnNumber: 9
                    }, this),
                    !rightOpen && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                        title: "Show side panel",
                        onClick: ()=>setRightOpen(true),
                        className: "absolute right-3 top-[70px] z-30 grid h-8 w-8 place-items-center rounded-lg border border-white/8 bg-[#111318]/90 text-zinc-400 shadow-lg backdrop-blur hover:text-white",
                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$panel$2d$right$2d$open$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PanelRightOpen$3e$__["PanelRightOpen"], {
                            size: 15
                        }, void 0, false, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 683,
                            columnNumber: 272
                        }, this)
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 683,
                        columnNumber: 24
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 539,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
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
                lineNumber: 686,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                ref: imageInput,
                type: "file",
                accept: "image/png,image/jpeg",
                className: "hidden",
                onChange: async (e)=>{
                    const file = e.target.files?.[0];
                    if (!file) return;
                    const dataUrl = await (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["fileToDataUrl"])(file);
                    setPendingImage(dataUrl);
                    setTool("image");
                    setSelectedId(null);
                    e.currentTarget.value = "";
                }
            }, void 0, false, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 687,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$components$2f$signature$2d$dialog$2e$tsx__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["SignatureDialog"], {
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
                lineNumber: 689,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["AnimatePresence"], {
                children: [
                    pendingImage && tool === "image" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
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
                        lineNumber: 692,
                        columnNumber: 46
                    }, this),
                    error && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
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
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                className: "ml-3 text-red-400",
                                onClick: ()=>setError(null),
                                children: "Dismiss"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 693,
                                columnNumber: 262
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 693,
                        columnNumber: 19
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 691,
                columnNumber: 7
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-editor.tsx",
        lineNumber: 509,
        columnNumber: 5
    }, this);
}
function PropertyColor({ value, onChange }) {
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        children: [
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "mb-2 flex items-center justify-between text-[11px] text-zinc-500",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                        children: "Color"
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 702,
                        columnNumber: 89
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                        className: "font-mono text-[10px] uppercase",
                        children: value
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 702,
                        columnNumber: 107
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 702,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "flex gap-2",
                children: [
                    [
                        "#111827",
                        "#2563eb",
                        "#dc2626",
                        "#16a34a",
                        "#facc15",
                        "#a855f7"
                    ].map((color)=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                            "aria-label": `Use ${color}`,
                            onClick: ()=>onChange(color),
                            className: `h-6 flex-1 rounded-md border ${value === color ? "border-white ring-1 ring-white/40" : "border-white/10"}`,
                            style: {
                                background: color
                            }
                        }, color, false, {
                            fileName: "[project]/components/pdf-editor.tsx",
                            lineNumber: 704,
                            columnNumber: 92
                        }, this)),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("label", {
                        className: "relative grid h-6 w-7 shrink-0 cursor-pointer place-items-center overflow-hidden rounded-md border border-white/10 bg-white/5",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$plus$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Plus$3e$__["Plus"], {
                                size: 12,
                                className: "pointer-events-none absolute"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 705,
                                columnNumber: 154
                            }, this),
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                                "aria-label": "Custom color",
                                type: "color",
                                value: value,
                                onChange: (e)=>onChange(e.target.value),
                                className: "absolute inset-0 h-10 w-10 cursor-pointer opacity-0"
                            }, void 0, false, {
                                fileName: "[project]/components/pdf-editor.tsx",
                                lineNumber: 705,
                                columnNumber: 213
                            }, this)
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 705,
                        columnNumber: 9
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 703,
                columnNumber: 7
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-editor.tsx",
        lineNumber: 701,
        columnNumber: 5
    }, this);
}
function PropertyRange({ label, value, min, max, suffix, onChange }) {
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        children: [
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "mb-2 flex items-center justify-between text-[11px] text-zinc-500",
                children: [
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                        children: label
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 714,
                        columnNumber: 89
                    }, this),
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                        children: [
                            Math.round(value),
                            suffix
                        ]
                    }, void 0, true, {
                        fileName: "[project]/components/pdf-editor.tsx",
                        lineNumber: 714,
                        columnNumber: 109
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 714,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                type: "range",
                min: min,
                max: max,
                value: value,
                onChange: (e)=>onChange(Number(e.target.value)),
                className: "h-1.5 w-full cursor-pointer accent-blue-500"
            }, void 0, false, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 715,
                columnNumber: 7
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-editor.tsx",
        lineNumber: 713,
        columnNumber: 5
    }, this);
}
function NumberField({ label, value, onChange }) {
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("label", {
        className: "flex items-center rounded-lg border border-white/8 bg-white/[0.025] px-2.5 py-2 text-[10px] text-zinc-600 focus-within:border-blue-500/40",
        children: [
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                className: "w-4",
                children: label
            }, void 0, false, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 723,
                columnNumber: 7
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("input", {
                type: "number",
                value: Math.round(value),
                onChange: (e)=>onChange(Number(e.target.value)),
                className: "min-w-0 flex-1 bg-transparent text-right text-xs text-zinc-300 outline-none"
            }, void 0, false, {
                fileName: "[project]/components/pdf-editor.tsx",
                lineNumber: 724,
                columnNumber: 7
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-editor.tsx",
        lineNumber: 722,
        columnNumber: 5
    }, this);
}
}),
"[project]/components/pdf-page.tsx [app-ssr] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "PdfPage",
    ()=>PdfPage
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/server/route-modules/app-page/vendored/ssr/react-jsx-dev-runtime.js [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/ocr.ts [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$text$2d$pixels$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/text-pixels.ts [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/utils.ts [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/server/route-modules/app-page/vendored/ssr/react.js [app-ssr] (ecmascript)");
"use client";
;
;
;
;
;
function PdfPage({ pdf, page, zoom, annotations, tool, selectedId, pendingImage, defaults, ocrResult, ocrSearch, ocrSelectable, onCreate, onSelect, onPatch, onBeginMutation, onConsumeImage, onOcrWordPatch }) {
    const canvasRef = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRef"])(null);
    const layerRef = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRef"])(null);
    const [baseSize, setBaseSize] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])({
        width: 612,
        height: 792
    });
    const [draft, setDraft] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(null);
    const [editingWordId, setEditingWordId] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(null);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useEffect"])(()=>{
        let cancelled = false;
        let renderTask;
        (async ()=>{
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
        })();
        return ()=>{
            cancelled = true;
            renderTask?.cancel?.();
        };
    }, [
        pdf,
        page.sourceIndex,
        page.rotation,
        zoom
    ]);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useEffect"])(()=>{
        if (!ocrSelectable) setEditingWordId(null);
    }, [
        ocrSelectable
    ]);
    const pointFromEvent = (event)=>{
        const rect = layerRef.current.getBoundingClientRect();
        return {
            x: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["clamp"])((event.clientX - rect.left) / zoom, 0, baseSize.width),
            y: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["clamp"])((event.clientY - rect.top) / zoom, 0, baseSize.height)
        };
    };
    const draftBox = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useMemo"])(()=>{
        if (!draft || draft.type === "draw") return null;
        return {
            x: Math.min(draft.start.x, draft.current.x),
            y: Math.min(draft.start.y, draft.current.y),
            width: Math.abs(draft.current.x - draft.start.x),
            height: Math.abs(draft.current.y - draft.start.y)
        };
    }, [
        draft
    ]);
    const normalizedSearch = ocrSearch.trim().toLocaleLowerCase();
    const searchTerms = normalizedSearch.split(/\s+/).filter(Boolean);
    const prepareWordVisual = (word)=>{
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
        const appearance = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$text$2d$pixels$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["sampleTextAppearance"])(canvas, left, top, width, height);
        const patch = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$text$2d$pixels$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["synthesizeBackgroundPatch"])(canvas, left, top, width, height, Math.max(3, Math.round(height * 0.12)));
        onOcrWordPatch(word.id, {
            backgroundColor: appearance.backgroundColor,
            textColor: appearance.textColor,
            backgroundPatch: patch ? {
                dataUrl: patch.dataUrl,
                x: patch.x / scaleX,
                y: patch.y / scaleY,
                width: patch.width / scaleX,
                height: patch.height / scaleY
            } : undefined
        });
    };
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
        className: "relative bg-white shadow-[0_24px_80px_rgba(0,0,0,.35)]",
        style: {
            width: baseSize.width * zoom,
            height: baseSize.height * zoom
        },
        children: [
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("canvas", {
                ref: canvasRef,
                className: "absolute inset-0 block"
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 145,
                columnNumber: 7
            }, this),
            ocrResult && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: `absolute inset-0 z-30 overflow-hidden ${ocrSelectable ? "cursor-text" : "pointer-events-none select-none"}`,
                "aria-label": "Editable recognized text layer",
                children: ocrResult.words.map((word)=>{
                    const wordValue = word.text.toLocaleLowerCase();
                    const match = searchTerms.length > 0 && searchTerms.some((term)=>wordValue.includes(term));
                    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(OcrWordView, {
                        word: word,
                        zoom: zoom,
                        editable: ocrSelectable,
                        editing: editingWordId === word.id,
                        match: match,
                        onStartEdit: ()=>{
                            if (!ocrSelectable) return;
                            onBeginMutation();
                            setEditingWordId(word.id);
                            // Let the editable surface paint first, then synthesize a
                            // cleanup patch for this one line from the existing page canvas.
                            // Preparation no longer precomputes patches for every line.
                            requestAnimationFrame(()=>prepareWordVisual(word));
                        },
                        onCommit: (text)=>{
                            onOcrWordPatch(word.id, {
                                text
                            });
                            setEditingWordId(null);
                        },
                        onCancel: ()=>setEditingWordId(null)
                    }, word.id, false, {
                        fileName: "[project]/components/pdf-page.tsx",
                        lineNumber: 155,
                        columnNumber: 15
                    }, this);
                })
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 147,
                columnNumber: 9
            }, this),
            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                ref: layerRef,
                className: `absolute inset-0 z-20 touch-none ${ocrSelectable ? "pointer-events-none" : ""} ${tool === "select" ? "cursor-default" : tool === "text" ? "cursor-text" : "cursor-crosshair"}`,
                onPointerDown: (event)=>{
                    if (event.button !== 0 || event.target !== event.currentTarget) return;
                    const p = pointFromEvent(event);
                    onSelect(null);
                    if (tool === "text") {
                        onCreate({
                            id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["uid"])("ann"),
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
                            id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["uid"])("ann"),
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
                            id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["uid"])("ann"),
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
                                id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["uid"])("ann"),
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
                    annotations.map((annotation)=>/*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(AnnotationView, {
                            annotation: annotation,
                            zoom: zoom,
                            selected: annotation.id === selectedId,
                            selectable: tool === "select" && !ocrSelectable,
                            onSelect: ()=>onSelect(annotation.id),
                            onPatch: (patch)=>onPatch(annotation.id, patch),
                            onBeginMutation: onBeginMutation
                        }, annotation.id, false, {
                            fileName: "[project]/components/pdf-page.tsx",
                            lineNumber: 243,
                            columnNumber: 11
                        }, this)),
                    draftBox && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
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
                        lineNumber: 256,
                        columnNumber: 11
                    }, this),
                    draft?.type === "draw" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("svg", {
                        className: "pointer-events-none absolute inset-0 overflow-visible",
                        width: "100%",
                        height: "100%",
                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("polyline", {
                            points: draft.points.map((p)=>`${p.x * zoom},${p.y * zoom}`).join(" "),
                            fill: "none",
                            stroke: defaults.color,
                            strokeWidth: defaults.strokeWidth * zoom,
                            strokeLinecap: "round",
                            strokeLinejoin: "round"
                        }, void 0, false, {
                            fileName: "[project]/components/pdf-page.tsx",
                            lineNumber: 263,
                            columnNumber: 13
                        }, this)
                    }, void 0, false, {
                        fileName: "[project]/components/pdf-page.tsx",
                        lineNumber: 262,
                        columnNumber: 11
                    }, this)
                ]
            }, void 0, true, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 181,
                columnNumber: 7
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-page.tsx",
        lineNumber: 144,
        columnNumber: 5
    }, this);
}
function OcrWordView({ word, zoom, editable, editing, match, onStartEdit, onCommit, onCancel }) {
    const editorRef = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRef"])(null);
    const draftText = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRef"])(word.text);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useEffect"])(()=>{
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
    }, [
        editing
    ]);
    const left = word.x * zoom;
    const top = word.y * zoom;
    const originalWidth = Math.max(2, word.width * zoom);
    const originalHeight = Math.max(2, word.height * zoom);
    const typography = word.typography;
    const metrics = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["measureOcrText"])(word.text || " ", typography);
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
        backgroundRepeat: "no-repeat"
    } : null;
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
        return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
            className: "absolute z-20",
            style: {
                left,
                top,
                width: Math.max(coverWidth, editorWidth),
                height: originalHeight
            },
            children: [
                repair ? /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                    "aria-hidden": "true",
                    className: "pointer-events-none absolute",
                    style: repair
                }, void 0, false, {
                    fileName: "[project]/components/pdf-page.tsx",
                    lineNumber: 344,
                    columnNumber: 11
                }, this) : /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                    "aria-hidden": "true",
                    className: "pointer-events-none absolute inset-y-0 left-0",
                    style: {
                        width: originalWidth,
                        backgroundColor: background
                    }
                }, void 0, false, {
                    fileName: "[project]/components/pdf-page.tsx",
                    lineNumber: 346,
                    columnNumber: 11
                }, this),
                /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                    ref: editorRef,
                    contentEditable: true,
                    suppressContentEditableWarning: true,
                    role: "textbox",
                    "aria-label": `Edit ${word.source === "native-pdf" ? "PDF" : "scanned"} text: ${word.originalText}`,
                    className: "absolute z-20 m-0 border-0 bg-transparent p-0 outline-none ring-2 ring-blue-500/60 ring-offset-1",
                    style: {
                        ...textStyle,
                        left: 0,
                        top: glyphTop - top,
                        minWidth: editorWidth / Math.max(0.01, typography.scaleX),
                        height: Math.max(18, glyphHeight),
                        caretColor: foreground,
                        overflow: "visible"
                    },
                    onInput: (event)=>{
                        draftText.current = event.currentTarget.textContent || "";
                    },
                    onBlur: ()=>onCommit(draftText.current),
                    onKeyDown: (event)=>{
                        if (event.key === "Enter") {
                            event.preventDefault();
                            onCommit(draftText.current);
                        }
                        if (event.key === "Escape") {
                            event.preventDefault();
                            onCancel();
                        }
                    }
                }, void 0, false, {
                    fileName: "[project]/components/pdf-page.tsx",
                    lineNumber: 348,
                    columnNumber: 9
                }, this)
            ]
        }, void 0, true, {
            fileName: "[project]/components/pdf-page.tsx",
            lineNumber: 339,
            columnNumber: 7
        }, this);
    }
    if (word.edited) {
        return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
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
                backgroundColor: repair ? "transparent" : background,
                overflow: "visible"
            },
            children: [
                repair && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
                    "aria-hidden": "true",
                    className: "pointer-events-none absolute",
                    style: repair
                }, void 0, false, {
                    fileName: "[project]/components/pdf-page.tsx",
                    lineNumber: 384,
                    columnNumber: 20
                }, this),
                word.text && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("span", {
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
                    lineNumber: 386,
                    columnNumber: 11
                }, this)
            ]
        }, void 0, true, {
            fileName: "[project]/components/pdf-page.tsx",
            lineNumber: 377,
            columnNumber: 7
        }, this);
    }
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
        type: "button",
        title: editable ? `${word.text} · ${word.source === "native-pdf" ? "native PDF" : `${Math.round(word.confidence)}% OCR`} · ${typography.fontFamily.split(",")[0].replaceAll("\"", "")} · ${typography.fontSize.toFixed(1)} pt · weight ${typography.fontWeight}` : undefined,
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
        lineNumber: 404,
        columnNumber: 5
    }, this);
}
function AnnotationView({ annotation, zoom, selected, selectable, onSelect, onPatch, onBeginMutation }) {
    const drag = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRef"])(null);
    if (annotation.type === "draw" && annotation.points) {
        return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("svg", {
            className: "pointer-events-none absolute inset-0 overflow-visible",
            width: "100%",
            height: "100%",
            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("polyline", {
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
                lineNumber: 429,
                columnNumber: 9
            }, this)
        }, void 0, false, {
            fileName: "[project]/components/pdf-page.tsx",
            lineNumber: 428,
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
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
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
            annotation.type === "text" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "h-full w-full whitespace-pre-wrap leading-tight",
                style: {
                    color: annotation.color,
                    fontSize: annotation.fontSize * zoom
                },
                children: annotation.text
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 477,
                columnNumber: 9
            }, this),
            annotation.type === "highlight" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "h-full w-full",
                style: {
                    background: annotation.color
                }
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 479,
                columnNumber: 43
            }, this),
            annotation.type === "rect" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "h-full w-full",
                style: {
                    border: `${annotation.strokeWidth * zoom}px solid ${annotation.color}`
                }
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 480,
                columnNumber: 38
            }, this),
            annotation.type === "ellipse" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                className: "h-full w-full rounded-full",
                style: {
                    border: `${annotation.strokeWidth * zoom}px solid ${annotation.color}`
                }
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 481,
                columnNumber: 41
            }, this),
            annotation.type === "image" && annotation.dataUrl && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("img", {
                src: annotation.dataUrl,
                alt: "Placed",
                className: "h-full w-full object-contain",
                draggable: false
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 482,
                columnNumber: 61
            }, this),
            selected && annotation.type !== "draw" && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(ResizeHandle, {
                annotation: annotation,
                zoom: zoom,
                onBeginMutation: onBeginMutation,
                onPatch: onPatch
            }, void 0, false, {
                fileName: "[project]/components/pdf-page.tsx",
                lineNumber: 484,
                columnNumber: 9
            }, this)
        ]
    }, void 0, true, {
        fileName: "[project]/components/pdf-page.tsx",
        lineNumber: 453,
        columnNumber: 5
    }, this);
}
function ResizeHandle({ annotation, zoom, onPatch, onBeginMutation }) {
    const drag = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRef"])(null);
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
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
        lineNumber: 498,
        columnNumber: 5
    }, this);
}
}),
"[project]/components/signature-dialog.tsx [app-ssr] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "SignatureDialog",
    ()=>SignatureDialog
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/server/route-modules/app-page/vendored/ssr/react-jsx-dev-runtime.js [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/framer-motion/dist/es/components/AnimatePresence/index.mjs [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$locals$3e$__ = __turbopack_context__.i("[project]/node_modules/motion/dist/es/react.mjs [app-ssr] (ecmascript) <locals>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$eraser$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Eraser$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/eraser.mjs [app-ssr] (ecmascript) <export default as Eraser>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pen$2d$line$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PenLine$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/pen-line.mjs [app-ssr] (ecmascript) <export default as PenLine>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$x$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__X$3e$__ = __turbopack_context__.i("[project]/node_modules/lucide-react/dist/esm/icons/x.mjs [app-ssr] (ecmascript) <export default as X>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/next/dist/server/route-modules/app-page/vendored/ssr/react.js [app-ssr] (ecmascript)");
"use client";
;
;
;
;
function SignatureDialog({ open, onClose, onSave }) {
    const canvasRef = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useRef"])(null);
    const [drawing, setDrawing] = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useState"])(false);
    (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["useEffect"])(()=>{
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
    }, [
        open
    ]);
    const point = (event)=>{
        const rect = event.currentTarget.getBoundingClientRect();
        return {
            x: event.clientX - rect.left,
            y: event.clientY - rect.top
        };
    };
    return /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$framer$2d$motion$2f$dist$2f$es$2f$components$2f$AnimatePresence$2f$index$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["AnimatePresence"], {
        children: open && /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
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
            children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$motion$2f$dist$2f$es$2f$react$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$locals$3e$__["motion"].div, {
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
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mb-4 flex items-center justify-between",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                        className: "flex items-center gap-2 text-sm font-semibold",
                                        children: [
                                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$pen$2d$line$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PenLine$3e$__["PenLine"], {
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
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("p", {
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
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                className: "rounded-lg p-2 text-zinc-400 hover:bg-white/5 hover:text-white",
                                onClick: onClose,
                                children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$x$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__X$3e$__["X"], {
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
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "overflow-hidden rounded-xl border border-zinc-300 bg-white checkerboard",
                        children: /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("canvas", {
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
                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                        className: "mt-4 flex items-center justify-between gap-3",
                        children: [
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                className: "inline-flex items-center gap-2 rounded-xl border border-white/10 px-3 py-2 text-sm text-zinc-300 hover:bg-white/5",
                                onClick: ()=>{
                                    const canvas = canvasRef.current;
                                    const ctx = canvas?.getContext("2d");
                                    if (canvas && ctx) ctx.clearRect(0, 0, canvas.width, canvas.height);
                                },
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$lucide$2d$react$2f$dist$2f$esm$2f$icons$2f$eraser$2e$mjs__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__Eraser$3e$__["Eraser"], {
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
                            /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("div", {
                                className: "flex gap-2",
                                children: [
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
                                        className: "rounded-xl px-4 py-2 text-sm text-zinc-400 hover:bg-white/5",
                                        onClick: onClose,
                                        children: "Cancel"
                                    }, void 0, false, {
                                        fileName: "[project]/components/signature-dialog.tsx",
                                        lineNumber: 98,
                                        columnNumber: 17
                                    }, this),
                                    /*#__PURE__*/ (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$next$2f$dist$2f$server$2f$route$2d$modules$2f$app$2d$page$2f$vendored$2f$ssr$2f$react$2d$jsx$2d$dev$2d$runtime$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["jsxDEV"])("button", {
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
}),
"[project]/lib/export-pdf.ts [app-ssr] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "exportEditedPdf",
    ()=>exportEditedPdf
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$index$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$locals$3e$__ = __turbopack_context__.i("[project]/node_modules/pdf-lib/es/index.js [app-ssr] (ecmascript) <locals>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$rotations$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/pdf-lib/es/api/rotations.js [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$PDFDocument$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PDFDocument$3e$__ = __turbopack_context__.i("[project]/node_modules/pdf-lib/es/api/PDFDocument.js [app-ssr] (ecmascript) <export default as PDFDocument>");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$colors$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/pdf-lib/es/api/colors.js [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$StandardFonts$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/node_modules/pdf-lib/es/api/StandardFonts.js [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/ocr.ts [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/utils.ts [app-ssr] (ecmascript)");
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
    const metrics = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["measureOcrText"])(text || " ", typography);
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
    const source = await __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$PDFDocument$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PDFDocument$3e$__["PDFDocument"].load(sourceBytes, {
        ignoreEncryption: true
    });
    const output = await __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$PDFDocument$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__$3c$export__default__as__PDFDocument$3e$__["PDFDocument"].create();
    const helvetica = await output.embedFont(__TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$StandardFonts$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["StandardFonts"].Helvetica);
    const copied = await output.copyPages(source, pages.map((page)=>page.sourceIndex));
    for(let index = 0; index < copied.length; index++){
        const targetPage = copied[index];
        const editorPage = pages[index];
        targetPage.setRotation((0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$rotations$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["degrees"])(editorPage.rotation));
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
                    // Scans are images, so repair the original pixels before drawing new
                    // text. A locally synthesized PNG patch preserves gradients, rules and
                    // paper tone much better than a flat white/solid rectangle.
                    if (word.backgroundPatch?.dataUrl) {
                        const patchData = dataUrlBytes(word.backgroundPatch.dataUrl);
                        const patchImage = await output.embedPng(patchData.bytes);
                        const patchTopLeft = toPdf(word.backgroundPatch.x, word.backgroundPatch.y);
                        const patchBottomRight = toPdf(word.backgroundPatch.x + word.backgroundPatch.width, word.backgroundPatch.y + word.backgroundPatch.height);
                        targetPage.drawImage(patchImage, {
                            x: Math.min(patchTopLeft[0], patchBottomRight[0]),
                            y: Math.min(patchTopLeft[1], patchBottomRight[1]),
                            width: Math.abs(patchBottomRight[0] - patchTopLeft[0]),
                            height: Math.abs(patchBottomRight[1] - patchTopLeft[1])
                        });
                    } else {
                        const bg = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["hexToRgb01"])(word.backgroundColor || "#ffffff");
                        targetPage.drawRectangle({
                            x: wordBox.x - 0.2,
                            y: wordBox.y - 0.2,
                            width: wordBox.width + 0.4,
                            height: wordBox.height + 0.4,
                            color: (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$colors$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["rgb"])(bg.r, bg.g, bg.b)
                        });
                    }
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
            const c = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["hexToRgb01"])(annotation.color);
            const color = (0, __TURBOPACK__imported__module__$5b$project$5d2f$node_modules$2f$pdf$2d$lib$2f$es$2f$api$2f$colors$2e$js__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["rgb"])(c.r, c.g, c.b);
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
}),
"[project]/lib/native-text.ts [app-ssr] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "extractNativeEditableText",
    ()=>extractNativeEditableText,
    "inspectPageTextMode",
    ()=>inspectPageTextMode
]);
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/ocr.ts [app-ssr] (ecmascript)");
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/utils.ts [app-ssr] (ecmascript)");
;
;
function multiplyTransform(a, b) {
    return [
        a[0] * b[0] + a[2] * b[1],
        a[1] * b[0] + a[3] * b[1],
        a[0] * b[2] + a[2] * b[3],
        a[1] * b[2] + a[3] * b[3],
        a[0] * b[4] + a[2] * b[5] + a[4],
        a[1] * b[4] + a[3] * b[5] + a[5]
    ];
}
function clamp(value, min, max) {
    return Math.min(max, Math.max(min, value));
}
function weightFromFont(font) {
    const raw = `${font?.cssFontInfo?.fontWeight || ""} ${font?.name || ""} ${font?.fallbackName || ""}`.toLowerCase();
    const numeric = Number.parseInt(String(font?.cssFontInfo?.fontWeight || ""), 10);
    if (numeric >= 650 || /bold|black|heavy/.test(raw)) return 700;
    if (numeric >= 550 || /semi|demi/.test(raw)) return 600;
    if (numeric >= 450 || /medium/.test(raw)) return 500;
    return 400;
}
function styleFromFont(font) {
    const raw = `${font?.cssFontInfo?.italicAngle || ""} ${font?.name || ""}`.toLowerCase();
    const angle = Number(font?.cssFontInfo?.italicAngle);
    const hasItalicAngle = Number.isFinite(angle) && angle !== 0;
    return hasItalicAngle || /italic|oblique/.test(raw) ? "italic" : "normal";
}
function getFontObject(proxy, fontName) {
    try {
        return proxy.commonObjs?.get?.(fontName) || null;
    } catch  {
        return null;
    }
}
function isTextShowOp(fn, OPS) {
    return fn === OPS.showText || fn === OPS.showSpacedText || fn === OPS.nextLineShowText || fn === OPS.nextLineSetSpacingShowText;
}
async function inspectPageTextMode(pdf, page) {
    const proxy = await pdf.getPage(page.sourceIndex + 1);
    const textContent = await proxy.getTextContent();
    const items = (textContent.items || []).filter((item)=>typeof item?.str === "string");
    const characterCount = items.reduce((sum, item)=>sum + item.str.trim().length, 0);
    if (characterCount < 4) return {
        mode: "scan",
        characterCount,
        textContent,
        proxy
    };
    let visibleShows = 0;
    let invisibleShows = 0;
    let imagePaintOps = 0;
    try {
        const pdfjs = await __turbopack_context__.A("[project]/node_modules/pdfjs-dist/build/pdf.mjs [app-ssr] (ecmascript, async loader)");
        const OPS = pdfjs.OPS;
        const opList = await proxy.getOperatorList();
        let renderMode = 0;
        for(let i = 0; i < opList.fnArray.length; i++){
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
    } catch  {
        // If operator inspection fails, ordinary text content is still a better
        // signal than OCR for digitally generated PDFs.
        visibleShows = Math.max(1, items.length);
    }
    const mode = invisibleShows > visibleShows * 1.25 ? "scan" : "native";
    return {
        mode,
        characterCount,
        visibleShows,
        invisibleShows,
        imagePaintOps,
        hasRasterImages: imagePaintOps > 0,
        textContent,
        proxy
    };
}
function mergeRuns(runs) {
    const merged = [];
    for (const run of runs){
        const previous = merged[merged.length - 1];
        const sameLine = previous && Math.abs(previous.baselineY - run.baselineY) <= Math.max(1.5, run.fontSize * 0.12);
        const sameFont = previous && previous.nativeFontName === run.nativeFontName && Math.abs(previous.fontSize - run.fontSize) <= 0.7;
        const gap = previous ? run.x - (previous.x + previous.width) : Number.POSITIVE_INFINITY;
        if (previous && sameLine && sameFont && !previous.hasEOL && gap > -run.fontSize * 0.2 && gap < run.fontSize * 1.4) {
            const needsSpace = gap > run.fontSize * 0.16 && !previous.item.str.endsWith(" ") && !run.item.str.startsWith(" ");
            previous.item = {
                ...previous.item,
                str: `${previous.item.str}${needsSpace ? " " : ""}${run.item.str}`
            };
            previous.width = Math.max(previous.width, run.x + run.width - previous.x);
            previous.y = Math.min(previous.y, run.y);
            previous.height = Math.max(previous.height, run.y + run.height - previous.y);
            previous.hasEOL = run.hasEOL;
        } else {
            merged.push({
                ...run,
                item: {
                    ...run.item
                }
            });
        }
    }
    return merged;
}
async function extractNativeEditableText({ pdf, page }) {
    const inspection = await inspectPageTextMode(pdf, page);
    if (inspection.mode !== "native") return null;
    const proxy = inspection.proxy;
    // Rendering/getOperatorList ensures PDF.js has loaded embedded fonts into its
    // common object store and browser FontFace set before we reuse them.
    try {
        await proxy.getOperatorList();
    } catch  {}
    const base = proxy.getViewport({
        scale: 1,
        rotation: page.rotation
    });
    const textContent = inspection.textContent;
    const styles = textContent.styles || {};
    const rawRuns = [];
    for (const raw of textContent.items || []){
        if (typeof raw?.str !== "string" || !raw.str.trim()) continue;
        const item = raw;
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
        const family = loadedName ? `"${loadedName}", ${style.fontFamily || "sans-serif"}` : style.fontFamily || "sans-serif";
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
            hasEOL: Boolean(item.hasEOL)
        });
    }
    const merged = mergeRuns(rawRuns);
    const words = merged.map((run, index)=>{
        const typographyBase = {
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
            source: "native"
        };
        const measured = (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$ocr$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["measureOcrText"])(run.item.str, typographyBase);
        const scaleCorrection = run.width / Math.max(1, measured.naturalWidth);
        const typography = {
            ...typographyBase,
            scaleX: clamp(scaleCorrection, 0.9, 1.1)
        };
        return {
            id: (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$utils$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["uid"])("native"),
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
            source: "native-pdf",
            nativeFontName: run.nativeFontName,
            // Appearance and cleanup pixels are sampled lazily from the already-rendered
            // page canvas only when this run is actually edited.
            backgroundColor: "#ffffff",
            textColor: "#111111",
            typography
        };
    });
    return {
        pageId: page.id,
        language: "native",
        mode: "native",
        text: words.map((word)=>word.text).join(" "),
        words,
        recognizedAt: Date.now()
    };
}
}),
"[project]/lib/ocr.ts [app-ssr] (ecmascript)", ((__turbopack_context__) => {
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
var __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$text$2d$pixels$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__ = __turbopack_context__.i("[project]/lib/text-pixels.ts [app-ssr] (ecmascript)");
;
const OCR_RENDER_SCALE = 2.2;
const OCR_MAX_PIXELS = 4_500_000;
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
    const pageArea = Math.max(1, base.width * base.height);
    const pixelCappedScale = Math.sqrt(OCR_MAX_PIXELS / pageArea);
    const scale = Math.max(1, Math.min(OCR_RENDER_SCALE, pixelCappedScale));
    const viewport = proxy.getViewport({
        scale,
        rotation: page.rotation
    });
    const canvas = document.createElement("canvas");
    canvas.width = Math.max(1, Math.ceil(viewport.width));
    canvas.height = Math.max(1, Math.ceil(viewport.height));
    const context = canvas.getContext("2d", {
        alpha: false
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
        baseHeight: base.height,
        scale
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
function sampleAppearance(canvas, left, top, width, height) {
    return (0, __TURBOPACK__imported__module__$5b$project$5d2f$lib$2f$text$2d$pixels$2e$ts__$5b$app$2d$ssr$5d$__$28$ecmascript$29$__["sampleTextAppearance"])(canvas, left, top, width, height);
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
    // Tesseract's font metadata is cheap to consume. Avoid probing many raster
    // word boxes here; appearance is sampled once for the final editable line.
    const tesseractStyle = words.map((word)=>fontFromTesseract(word.font_name)).find(Boolean) || null;
    const fontWeight = tesseractStyle?.fontWeight ?? 400;
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
    let lineCounter = 0;
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
                const boxes = words.map((word)=>word.bbox);
                const box = line.bbox || {
                    x0: Math.min(...boxes.map((b)=>b.x0)),
                    y0: Math.min(...boxes.map((b)=>b.y0)),
                    x1: Math.max(...boxes.map((b)=>b.x1)),
                    y1: Math.max(...boxes.map((b)=>b.y1))
                };
                const text = (line.text || words.map((word)=>(word.text || "").trim()).join(" ")).trim();
                if (!text) return;
                const width = Math.max(1, box.x1 - box.x0);
                const height = Math.max(1, box.y1 - box.y0);
                const appearance = sampleAppearance(canvas, box.x0, box.y0, width, height);
                const syntheticWord = {
                    text,
                    bbox: box,
                    confidence: median(words.map((word)=>Number(word.confidence) || 0)),
                    font_name: words.map((word)=>word.font_name).find(Boolean)
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
                    typography: makeTypographyForWord({
                        line,
                        word: syntheticWord,
                        lineStyle,
                        scaleX,
                        scaleY
                    })
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
            text,
            left,
            top,
            width,
            height,
            confidence,
            lineKey: `${columns[2] || 0}:${columns[3] || 0}:${columns[4] || 0}`
        });
    }
    const byLine = new Map();
    raw.forEach((word)=>{
        if (!byLine.has(word.lineKey)) byLine.set(word.lineKey, []);
        byLine.get(word.lineKey).push(word);
    });
    return Array.from(byLine.entries()).map(([lineKey, lineWords], lineIndex)=>{
        lineWords.sort((a, b)=>a.left - b.left);
        const left = Math.min(...lineWords.map((word)=>word.left));
        const top = Math.min(...lineWords.map((word)=>word.top));
        const right = Math.max(...lineWords.map((word)=>word.left + word.width));
        const bottom = Math.max(...lineWords.map((word)=>word.top + word.height));
        const width = right - left;
        const height = bottom - top;
        const text = lineWords.map((word)=>word.text).join(" ");
        const appearance = sampleAppearance(canvas, left, top, width, height);
        const fontWeight = 400;
        const fontFamily = 'Arial, Helvetica, sans-serif';
        const fontSize = Math.max(4, median(lineWords.map((item)=>item.height * scaleY)) * 1.03);
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
            confidence: median(lineWords.map((word)=>Number.isFinite(word.confidence) ? word.confidence : 0)),
            x: left * scaleX,
            y: top * scaleY,
            width: targetWidth,
            height: height * scaleY,
            lineKey,
            source: "scan-ocr",
            backgroundColor: appearance.backgroundColor,
            textColor: appearance.textColor,
            typography: {
                fontFamily,
                fontWeight,
                fontStyle: "normal",
                fontSize,
                lineHeight: Math.max(height * scaleY, fontSize),
                baselineY: bottom * scaleY - metrics.descent * 0.12,
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
        mode: "scan",
        text: text.trim() || ocrTextFromWords(words),
        words,
        recognizedAt: Date.now()
    };
}
}),
"[project]/lib/text-pixels.ts [app-ssr] (ecmascript)", ((__turbopack_context__) => {
"use strict";

__turbopack_context__.s([
    "sampleTextAppearance",
    ()=>sampleTextAppearance,
    "synthesizeBackgroundPatch",
    ()=>synthesizeBackgroundPatch
]);
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
/**
 * Read one local rectangle from the canvas and then sample it from JS memory.
 * The previous implementation called getImageData(x, y, 1, 1) for every
 * sampled pixel and, during patch synthesis, up to four times per output pixel.
 * Canvas readbacks are synchronous; that pattern can block Chromium for seconds.
 */ function readRegion(context, canvas, left, top, right, bottom) {
    const x0 = clamp(Math.floor(left), 0, Math.max(0, canvas.width - 1));
    const y0 = clamp(Math.floor(top), 0, Math.max(0, canvas.height - 1));
    const x1 = clamp(Math.ceil(right), x0 + 1, canvas.width);
    const y1 = clamp(Math.ceil(bottom), y0 + 1, canvas.height);
    const width = Math.max(1, x1 - x0);
    const height = Math.max(1, y1 - y0);
    try {
        const image = context.getImageData(x0, y0, width, height);
        return {
            data: image.data,
            width,
            height,
            x: x0,
            y: y0
        };
    } catch  {
        return null;
    }
}
function pixel(region, canvasX, canvasY) {
    const x = clamp(Math.round(canvasX - region.x), 0, region.width - 1);
    const y = clamp(Math.round(canvasY - region.y), 0, region.height - 1);
    const index = (y * region.width + x) * 4;
    return [
        region.data[index],
        region.data[index + 1],
        region.data[index + 2],
        region.data[index + 3]
    ];
}
function sampleTextAppearance(canvas, left, top, width, height) {
    if (!canvas) return {
        backgroundColor: "#ffffff",
        textColor: "#111111",
        inkCoverage: 0.22
    };
    // Do not request willReadFrequently on the visible PDF canvas. That hint can
    // force a software-backed canvas. We only perform one bounded read here.
    const context = canvas.getContext("2d");
    if (!context) return {
        backgroundColor: "#ffffff",
        textColor: "#111111",
        inkCoverage: 0.22
    };
    const margin = Math.max(3, Math.min(10, Math.round(height * 0.2)));
    const region = readRegion(context, canvas, left - margin - 1, top - margin - 1, left + width + margin + 1, top + height + margin + 1);
    if (!region) return {
        backgroundColor: "#ffffff",
        textColor: "#111111",
        inkCoverage: 0.22
    };
    const ring = [];
    const stepsX = Math.max(6, Math.min(24, Math.round(width / 7)));
    const stepsY = Math.max(4, Math.min(12, Math.round(height / 5)));
    for(let i = 0; i <= stepsX; i++){
        const x = left + width * i / Math.max(1, stepsX);
        ring.push(pixel(region, x, top - margin));
        ring.push(pixel(region, x, top + height + margin));
    }
    for(let i = 0; i <= stepsY; i++){
        const y = top + height * i / Math.max(1, stepsY);
        ring.push(pixel(region, left - margin, y));
        ring.push(pixel(region, left + width + margin, y));
    }
    const bgR = median(ring.map((p)=>p[0]));
    const bgG = median(ring.map((p)=>p[1]));
    const bgB = median(ring.map((p)=>p[2]));
    const inside = [];
    const gridX = Math.max(6, Math.min(34, Math.round(width / 3)));
    const gridY = Math.max(5, Math.min(22, Math.round(height / 3)));
    for(let gy = 0; gy < gridY; gy++){
        for(let gx = 0; gx < gridX; gx++){
            const [r, g, b] = pixel(region, left + (gx + 0.5) * width / gridX, top + (gy + 0.5) * height / gridY);
            inside.push({
                r,
                g,
                b,
                distance: Math.hypot(r - bgR, g - bgG, b - bgB)
            });
        }
    }
    const distances = inside.map((p)=>p.distance);
    const adaptiveThreshold = Math.max(26, median(distances) * 1.55);
    const ink = inside.filter((p)=>p.distance >= adaptiveThreshold).sort((a, b)=>b.distance - a.distance);
    const strongest = ink.slice(0, Math.max(1, Math.ceil(ink.length * 0.5)));
    const lightBackground = (bgR + bgG + bgB) / 3 > 140;
    const textR = strongest.length ? median(strongest.map((p)=>p.r)) : lightBackground ? 20 : 240;
    const textG = strongest.length ? median(strongest.map((p)=>p.g)) : textR;
    const textB = strongest.length ? median(strongest.map((p)=>p.b)) : textR;
    return {
        backgroundColor: rgbHex(bgR, bgG, bgB),
        textColor: rgbHex(textR, textG, textB),
        inkCoverage: ink.length / Math.max(1, inside.length)
    };
}
function synthesizeBackgroundPatch(canvas, left, top, width, height, padding = 3) {
    const source = canvas.getContext("2d");
    if (!source) return null;
    const x0 = clamp(Math.floor(left - padding), 0, Math.max(0, canvas.width - 1));
    const y0 = clamp(Math.floor(top - padding), 0, Math.max(0, canvas.height - 1));
    const x1 = clamp(Math.ceil(left + width + padding), x0 + 1, canvas.width);
    const y1 = clamp(Math.ceil(top + height + padding), y0 + 1, canvas.height);
    const outWidth = Math.max(1, x1 - x0);
    const outHeight = Math.max(1, y1 - y0);
    const region = readRegion(source, canvas, x0, y0, x1, y1);
    if (!region) return null;
    const out = document.createElement("canvas");
    out.width = outWidth;
    out.height = outHeight;
    const ctx = out.getContext("2d", {
        alpha: false
    });
    if (!ctx) return null;
    // Start with the original local pixels; only the text interior is repaired.
    const image = new ImageData(new Uint8ClampedArray(region.data), outWidth, outHeight);
    const insideLeft = left - x0;
    const insideTop = top - y0;
    const insideRight = insideLeft + width;
    const insideBottom = insideTop + height;
    const topSampleY = top - Math.max(2, padding);
    const bottomSampleY = top + height + Math.max(2, padding);
    const leftSampleX = left - Math.max(2, padding);
    const rightSampleX = left + width + Math.max(2, padding);
    for(let oy = Math.max(0, Math.floor(insideTop)); oy <= Math.min(outHeight - 1, Math.ceil(insideBottom)); oy++){
        for(let ox = Math.max(0, Math.floor(insideLeft)); ox <= Math.min(outWidth - 1, Math.ceil(insideRight)); ox++){
            const sx = x0 + ox;
            const sy = y0 + oy;
            const t = pixel(region, sx, topSampleY);
            const b = pixel(region, sx, bottomSampleY);
            const l = pixel(region, leftSampleX, sy);
            const r = pixel(region, rightSampleX, sy);
            const dTop = Math.max(1, oy - insideTop + 1);
            const dBottom = Math.max(1, insideBottom - oy + 1);
            const dLeft = Math.max(1, ox - insideLeft + 1);
            const dRight = Math.max(1, insideRight - ox + 1);
            const wt = 1 / dTop;
            const wb = 1 / dBottom;
            const wl = 1 / dLeft;
            const wr = 1 / dRight;
            const total = wt + wb + wl + wr;
            const index = (oy * outWidth + ox) * 4;
            image.data[index] = (t[0] * wt + b[0] * wb + l[0] * wl + r[0] * wr) / total;
            image.data[index + 1] = (t[1] * wt + b[1] * wb + l[1] * wl + r[1] * wr) / total;
            image.data[index + 2] = (t[2] * wt + b[2] * wb + l[2] * wl + r[2] * wr) / total;
            image.data[index + 3] = 255;
        }
    }
    ctx.putImageData(image, 0, 0);
    return {
        dataUrl: out.toDataURL("image/png"),
        x: x0,
        y: y0,
        width: outWidth,
        height: outHeight
    };
}
}),
"[project]/lib/utils.ts [app-ssr] (ecmascript)", ((__turbopack_context__) => {
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
}),
];

//# sourceMappingURL=_0sm_c0l._.js.map