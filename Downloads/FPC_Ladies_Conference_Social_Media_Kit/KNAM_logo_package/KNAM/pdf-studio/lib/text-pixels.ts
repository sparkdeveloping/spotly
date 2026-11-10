export type SampledAppearance = {
  backgroundColor: string;
  textColor: string;
  inkCoverage: number;
};

function clamp(value: number, min: number, max: number) {
  return Math.min(max, Math.max(min, value));
}

function median(values: number[]) {
  if (!values.length) return 0;
  const sorted = [...values].sort((a, b) => a - b);
  const middle = Math.floor(sorted.length / 2);
  return sorted.length % 2 ? sorted[middle] : (sorted[middle - 1] + sorted[middle]) / 2;
}

function rgbHex(r: number, g: number, b: number) {
  return `#${[r, g, b].map((value) => clamp(Math.round(value), 0, 255).toString(16).padStart(2, "0")).join("")}`;
}

type Region = {
  data: Uint8ClampedArray;
  width: number;
  height: number;
  x: number;
  y: number;
};

/**
 * Read one local rectangle from the canvas and then sample it from JS memory.
 * The previous implementation called getImageData(x, y, 1, 1) for every
 * sampled pixel and, during patch synthesis, up to four times per output pixel.
 * Canvas readbacks are synchronous; that pattern can block Chromium for seconds.
 */
function readRegion(
  context: CanvasRenderingContext2D,
  canvas: HTMLCanvasElement,
  left: number,
  top: number,
  right: number,
  bottom: number,
): Region | null {
  const x0 = clamp(Math.floor(left), 0, Math.max(0, canvas.width - 1));
  const y0 = clamp(Math.floor(top), 0, Math.max(0, canvas.height - 1));
  const x1 = clamp(Math.ceil(right), x0 + 1, canvas.width);
  const y1 = clamp(Math.ceil(bottom), y0 + 1, canvas.height);
  const width = Math.max(1, x1 - x0);
  const height = Math.max(1, y1 - y0);
  try {
    const image = context.getImageData(x0, y0, width, height);
    return { data: image.data, width, height, x: x0, y: y0 };
  } catch {
    return null;
  }
}

function pixel(region: Region, canvasX: number, canvasY: number) {
  const x = clamp(Math.round(canvasX - region.x), 0, region.width - 1);
  const y = clamp(Math.round(canvasY - region.y), 0, region.height - 1);
  const index = (y * region.width + x) * 4;
  return [
    region.data[index],
    region.data[index + 1],
    region.data[index + 2],
    region.data[index + 3],
  ] as const;
}

export function sampleTextAppearance(
  canvas: HTMLCanvasElement | undefined,
  left: number,
  top: number,
  width: number,
  height: number,
): SampledAppearance {
  if (!canvas) return { backgroundColor: "#ffffff", textColor: "#111111", inkCoverage: 0.22 };
  // Do not request willReadFrequently on the visible PDF canvas. That hint can
  // force a software-backed canvas. We only perform one bounded read here.
  const context = canvas.getContext("2d");
  if (!context) return { backgroundColor: "#ffffff", textColor: "#111111", inkCoverage: 0.22 };

  const margin = Math.max(3, Math.min(10, Math.round(height * 0.2)));
  const region = readRegion(context, canvas, left - margin - 1, top - margin - 1, left + width + margin + 1, top + height + margin + 1);
  if (!region) return { backgroundColor: "#ffffff", textColor: "#111111", inkCoverage: 0.22 };

  const ring: Array<readonly [number, number, number, number]> = [];
  const stepsX = Math.max(6, Math.min(24, Math.round(width / 7)));
  const stepsY = Math.max(4, Math.min(12, Math.round(height / 5)));
  for (let i = 0; i <= stepsX; i++) {
    const x = left + (width * i) / Math.max(1, stepsX);
    ring.push(pixel(region, x, top - margin));
    ring.push(pixel(region, x, top + height + margin));
  }
  for (let i = 0; i <= stepsY; i++) {
    const y = top + (height * i) / Math.max(1, stepsY);
    ring.push(pixel(region, left - margin, y));
    ring.push(pixel(region, left + width + margin, y));
  }

  const bgR = median(ring.map((p) => p[0]));
  const bgG = median(ring.map((p) => p[1]));
  const bgB = median(ring.map((p) => p[2]));

  const inside: Array<{ r: number; g: number; b: number; distance: number }> = [];
  const gridX = Math.max(6, Math.min(34, Math.round(width / 3)));
  const gridY = Math.max(5, Math.min(22, Math.round(height / 3)));
  for (let gy = 0; gy < gridY; gy++) {
    for (let gx = 0; gx < gridX; gx++) {
      const [r, g, b] = pixel(
        region,
        left + ((gx + 0.5) * width) / gridX,
        top + ((gy + 0.5) * height) / gridY,
      );
      inside.push({ r, g, b, distance: Math.hypot(r - bgR, g - bgG, b - bgB) });
    }
  }

  const distances = inside.map((p) => p.distance);
  const adaptiveThreshold = Math.max(26, median(distances) * 1.55);
  const ink = inside.filter((p) => p.distance >= adaptiveThreshold).sort((a, b) => b.distance - a.distance);
  const strongest = ink.slice(0, Math.max(1, Math.ceil(ink.length * 0.5)));
  const lightBackground = (bgR + bgG + bgB) / 3 > 140;
  const textR = strongest.length ? median(strongest.map((p) => p.r)) : lightBackground ? 20 : 240;
  const textG = strongest.length ? median(strongest.map((p) => p.g)) : textR;
  const textB = strongest.length ? median(strongest.map((p) => p.b)) : textR;

  return {
    backgroundColor: rgbHex(bgR, bgG, bgB),
    textColor: rgbHex(textR, textG, textB),
    inkCoverage: ink.length / Math.max(1, inside.length),
  };
}

/**
 * Build a cleanup patch with ONE canvas readback. The hot loop below works on
 * the returned typed array, never by repeatedly calling getImageData().
 * This function is intentionally called lazily, only when the user edits a
 * text run, instead of during preparation for every line on the page.
 */
export function synthesizeBackgroundPatch(
  canvas: HTMLCanvasElement,
  left: number,
  top: number,
  width: number,
  height: number,
  padding = 3,
) {
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
  const ctx = out.getContext("2d", { alpha: false });
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

  for (let oy = Math.max(0, Math.floor(insideTop)); oy <= Math.min(outHeight - 1, Math.ceil(insideBottom)); oy++) {
    for (let ox = Math.max(0, Math.floor(insideLeft)); ox <= Math.min(outWidth - 1, Math.ceil(insideRight)); ox++) {
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
  return { dataUrl: out.toDataURL("image/png"), x: x0, y: y0, width: outWidth, height: outHeight };
}
