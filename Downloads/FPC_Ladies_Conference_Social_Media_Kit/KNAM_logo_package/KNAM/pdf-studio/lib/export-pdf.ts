import { degrees, PDFDocument, rgb, StandardFonts } from "pdf-lib";
import type { Annotation, EditorPage, OcrPageResult, OcrWord } from "@/lib/types";
import { measureOcrText } from "@/lib/ocr";
import { hexToRgb01 } from "@/lib/utils";

type PdfJsDoc = {
  getPage: (pageNumber: number) => Promise<{
    getViewport: (options: { scale: number; rotation: number }) => {
      convertToPdfPoint: (x: number, y: number) => [number, number];
    };
  }>;
};

function dataUrlBytes(dataUrl: string) {
  const [meta, payload] = dataUrl.split(",");
  const binary = atob(payload);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
  return { bytes, isJpeg: /image\/jpe?g/i.test(meta) };
}


function drawTrackedText(
  context: CanvasRenderingContext2D,
  text: string,
  baselineY: number,
  letterSpacing: number,
) {
  let cursor = 0;
  const chars = Array.from(text);
  chars.forEach((character, index) => {
    context.fillText(character, cursor, baselineY);
    cursor += context.measureText(character).width;
    if (index < chars.length - 1) cursor += letterSpacing;
  });
}

/**
 * Renders visual OCR replacements with the exact same browser font model used
 * by the live editor. Exporting the replacement as a transparent raster avoids
 * silently switching the edited word to Helvetica at save time.
 */
function renderOcrReplacement(word: OcrWord) {
  const text = word.text;
  const typography = word.typography;
  const metrics = measureOcrText(text || " ", typography);
  const rasterScale = 4;
  const padding = Math.max(2, typography.fontSize * 0.12);
  const width = Math.max(1, metrics.width);
  const height = Math.max(1, metrics.ascent + metrics.descent);
  const canvas = document.createElement("canvas");
  canvas.width = Math.max(1, Math.ceil((width + padding * 2) * rasterScale));
  canvas.height = Math.max(1, Math.ceil((height + padding * 2) * rasterScale));
  const context = canvas.getContext("2d", { alpha: true });
  if (!context) throw new Error("Could not create OCR replacement canvas.");

  const fg = word.textColor || "#111111";
  context.clearRect(0, 0, canvas.width, canvas.height);
  context.fillStyle = fg;
  context.textBaseline = "alphabetic";
  context.font = `${typography.fontStyle} ${typography.fontWeight} ${typography.fontSize * rasterScale}px ${typography.fontFamily}`;
  context.save();
  context.translate(padding * rasterScale, padding * rasterScale);
  context.scale(typography.scaleX, 1);
  drawTrackedText(
    context,
    text,
    metrics.ascent * rasterScale,
    typography.letterSpacing * rasterScale,
  );
  context.restore();

  return {
    dataUrl: canvas.toDataURL("image/png"),
    x: word.x - padding,
    y: typography.baselineY - metrics.ascent - padding,
    width: width + padding * 2,
    height: height + padding * 2,
    visualWidth: width,
  };
}

export async function exportEditedPdf({
  sourceBytes,
  pdfJsDocument,
  pages,
  annotations,
  ocrResults = [],
}: {
  sourceBytes: Uint8Array;
  pdfJsDocument: PdfJsDoc;
  pages: EditorPage[];
  annotations: Annotation[];
  ocrResults?: OcrPageResult[];
}) {
  const source = await PDFDocument.load(sourceBytes, { ignoreEncryption: true });
  const output = await PDFDocument.create();
  const helvetica = await output.embedFont(StandardFonts.Helvetica);
  const copied = await output.copyPages(source, pages.map((page) => page.sourceIndex));

  for (let index = 0; index < copied.length; index++) {
    const targetPage = copied[index];
    const editorPage = pages[index];
    targetPage.setRotation(degrees(editorPage.rotation));

    const sourceProxy = await pdfJsDocument.getPage(editorPage.sourceIndex + 1);
    const viewport = sourceProxy.getViewport({ scale: 1, rotation: editorPage.rotation });
    const pageAnnotations = annotations.filter((annotation) => annotation.pageId === editorPage.id);

    const toPdf = (x: number, y: number) => viewport.convertToPdfPoint(x, y);
    const box = (annotation: Annotation) => {
      const p1 = toPdf(annotation.x, annotation.y);
      const p2 = toPdf(annotation.x + annotation.width, annotation.y + annotation.height);
      return {
        x: Math.min(p1[0], p2[0]),
        y: Math.min(p1[1], p2[1]),
        width: Math.abs(p2[0] - p1[0]),
        height: Math.abs(p2[1] - p1[1]),
      };
    };

    const ocrResult = ocrResults.find((result) => result.pageId === editorPage.id);
    if (ocrResult) {
      for (const word of ocrResult.words) {
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
          height: Math.abs(b[1] - a[1]),
        };

        if (word.edited) {
          // Scans are images, so repair the original pixels before drawing new
          // text. A locally synthesized PNG patch preserves gradients, rules and
          // paper tone much better than a flat white/solid rectangle.
          if (word.backgroundPatch?.dataUrl) {
            const patchData = dataUrlBytes(word.backgroundPatch.dataUrl);
            const patchImage = await output.embedPng(patchData.bytes);
            const patchTopLeft = toPdf(word.backgroundPatch.x, word.backgroundPatch.y);
            const patchBottomRight = toPdf(
              word.backgroundPatch.x + word.backgroundPatch.width,
              word.backgroundPatch.y + word.backgroundPatch.height,
            );
            targetPage.drawImage(patchImage, {
              x: Math.min(patchTopLeft[0], patchBottomRight[0]),
              y: Math.min(patchTopLeft[1], patchBottomRight[1]),
              width: Math.abs(patchBottomRight[0] - patchTopLeft[0]),
              height: Math.abs(patchBottomRight[1] - patchTopLeft[1]),
            });
          } else {
            const bg = hexToRgb01(word.backgroundColor || "#ffffff");
            targetPage.drawRectangle({
              x: wordBox.x - 0.2,
              y: wordBox.y - 0.2,
              width: wordBox.width + 0.4,
              height: wordBox.height + 0.4,
              color: rgb(bg.r, bg.g, bg.b),
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
            height: Math.abs(bottomRight[1] - topLeft[1]),
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
              opacity: 0,
            });
          } catch {
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
            opacity: 0,
          });
        } catch {
          // Standard PDF fonts cannot encode every OCR language. Keep export
          // working and skip unsupported searchable glyphs.
        }
      }
    }

    for (const annotation of pageAnnotations) {
      const c = hexToRgb01(annotation.color);
      const color = rgb(c.r, c.g, c.b);

      if (annotation.type === "text") {
        const [x, y] = toPdf(annotation.x, annotation.y + annotation.fontSize);
        targetPage.drawText(annotation.text || "Text", {
          x,
          y,
          size: annotation.fontSize,
          font: helvetica,
          color,
          opacity: annotation.opacity,
          maxWidth: Math.max(20, annotation.width),
        });
      } else if (annotation.type === "highlight") {
        const b = box(annotation);
        targetPage.drawRectangle({ ...b, color, opacity: annotation.opacity });
      } else if (annotation.type === "rect") {
        const b = box(annotation);
        targetPage.drawRectangle({
          ...b,
          borderColor: color,
          borderWidth: annotation.strokeWidth,
          borderOpacity: annotation.opacity,
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
          borderOpacity: annotation.opacity,
        });
      } else if (annotation.type === "draw" && annotation.points && annotation.points.length > 1) {
        for (let i = 1; i < annotation.points.length; i++) {
          const a = annotation.points[i - 1];
          const b = annotation.points[i];
          const start = toPdf(a.x, a.y);
          const end = toPdf(b.x, b.y);
          targetPage.drawLine({
            start: { x: start[0], y: start[1] },
            end: { x: end[0], y: end[1] },
            thickness: annotation.strokeWidth,
            color,
            opacity: annotation.opacity,
          });
        }
      } else if (annotation.type === "image" && annotation.dataUrl) {
        const imageData = dataUrlBytes(annotation.dataUrl);
        const embedded = imageData.isJpeg
          ? await output.embedJpg(imageData.bytes)
          : await output.embedPng(imageData.bytes);
        const b = box(annotation);
        targetPage.drawImage(embedded, { ...b, opacity: annotation.opacity });
      }
    }

    output.addPage(targetPage);
  }

  return await output.save();
}
