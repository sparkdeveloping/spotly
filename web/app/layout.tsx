import type { Metadata, Viewport } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Spotly — Discover, book, and plan your city",
  description: "Spotly is Zimbabwe's lifestyle marketplace for food, groceries, events, wellness, activities, healthcare, gifts, and bookings.",
  metadataBase: new URL("https://spotly.app"),
  openGraph: {
    title: "Spotly — Launching 2026",
    description: "A clean customer app for discovering, booking, ordering, and planning everything in one spot.",
    images: ["/spotly-mark.svg"]
  }
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  themeColor: "#0d9354"
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
