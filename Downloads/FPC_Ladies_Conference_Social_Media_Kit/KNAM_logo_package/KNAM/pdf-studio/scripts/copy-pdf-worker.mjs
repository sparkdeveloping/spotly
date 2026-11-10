import { copyFile, mkdir } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
await mkdir(join(root, "public"), { recursive: true });
await copyFile(
  join(root, "node_modules", "pdfjs-dist", "build", "pdf.worker.min.mjs"),
  join(root, "public", "pdf.worker.min.mjs"),
);
