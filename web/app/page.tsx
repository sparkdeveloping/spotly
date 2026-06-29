import { BlueprintBlock } from "@/components/BlueprintBlock";
import { CategoryShowcase } from "@/components/CategoryShowcase";
import { Footer } from "@/components/Footer";
import { Hero } from "@/components/Hero";
import { LaunchPlan } from "@/components/LaunchPlan";
import { NavBar } from "@/components/NavBar";
import { PartnerPipeline } from "@/components/PartnerPipeline";
import { ProductSections } from "@/components/ProductSections";

export default function Home() {
  return (
    <main className="min-h-screen bg-paper text-ink">
      <NavBar />
      <Hero />
      <ProductSections />
      <CategoryShowcase />
      <PartnerPipeline />
      <BlueprintBlock />
      <LaunchPlan />
      <Footer />
    </main>
  );
}
