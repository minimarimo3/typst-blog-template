export function initResponsiveToc() {
  const toc = document.querySelector("[data-responsive-toc]");
  const origin = document.querySelector("[data-toc-origin]");
  const desktopSlot = document.querySelector("[data-toc-desktop-slot]");

  if (!toc || !origin || !desktopSlot) return;

  const desktopQuery = window.matchMedia("(min-width: 901px)");
  const details = toc.querySelector("details");

  const updatePlacement = () => {
    if (desktopQuery.matches) {
      desktopSlot.append(toc);
      if (details) details.open = true;
      toc.dataset.tocPlacement = "desktop";
      return;
    }

    origin.after(toc);
    toc.dataset.tocPlacement = "inline";
  };

  updatePlacement();
  desktopQuery.addEventListener("change", updatePlacement);
}
