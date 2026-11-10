import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "PDF Studio",
  description: "A private, browser-first PDF editor built with Next.js.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
