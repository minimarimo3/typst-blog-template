function fragmentToId(href) {
  try {
    return decodeURIComponent(href.slice(1));
  } catch {
    return href.slice(1);
  }
}

export function initFootnoteHoverPreview() {
  const footnoteMarkers = Array.from(
    document.querySelectorAll('.footnote-marker[role="doc-noteref"][href^="#"]'),
  );
  const supportsHover = window.matchMedia("(hover: hover) and (pointer: fine)").matches;
  if (footnoteMarkers.length === 0 || !supportsHover) return;

  const hoverPreview = document.createElement("div");
  hoverPreview.id = "footnote-hover-preview";
  hoverPreview.className = "footnote-hover-preview";
  hoverPreview.setAttribute("role", "tooltip");
  hoverPreview.setAttribute("data-pagefind-ignore", "all");
  hoverPreview.setAttribute("data-nosnippet", "");
  hoverPreview.hidden = true;
  document.body.append(hoverPreview);

  let activeMarker = null;

  const hideHoverPreview = () => {
    activeMarker?.removeAttribute("aria-describedby");
    activeMarker = null;
    hoverPreview.hidden = true;
    hoverPreview.replaceChildren();
  };

  const showHoverPreview = (marker) => {
    const href = marker.getAttribute("href");
    const footnote = href ? document.getElementById(fragmentToId(href)) : null;
    const footnoteBody = footnote?.querySelector(".footnote-body");
    if (!footnoteBody) return;

    hoverPreview.replaceChildren(footnoteBody.cloneNode(true));
    hoverPreview.hidden = false;
    activeMarker?.removeAttribute("aria-describedby");
    activeMarker = marker;
    marker.setAttribute("aria-describedby", hoverPreview.id);

    const markerRect = marker.getBoundingClientRect();
    const previewRect = hoverPreview.getBoundingClientRect();
    const gap = 8;
    const viewportPadding = 10;
    const left = Math.min(
      window.innerWidth - previewRect.width - viewportPadding,
      Math.max(
        viewportPadding,
        markerRect.left + markerRect.width / 2 - previewRect.width / 2,
      ),
    );
    const above = markerRect.top - previewRect.height - gap;
    const top = above >= viewportPadding ? above : markerRect.bottom + gap;

    hoverPreview.style.left = `${left}px`;
    hoverPreview.style.top = `${top}px`;
  };

  footnoteMarkers.forEach((marker) => {
    marker.addEventListener("mouseenter", () => showHoverPreview(marker));
    marker.addEventListener("mouseleave", hideHoverPreview);
    marker.addEventListener("click", hideHoverPreview);
  });
}

export function initReferencePreview() {
  const citationLinks = Array.from(document.querySelectorAll('a[role="doc-biblioref"][href^="#"]'));
  const footnoteMarkers = Array.from(
    document.querySelectorAll('.footnote-marker[role="doc-noteref"][href^="#"]'),
  );
  const previewSources = [...citationLinks, ...footnoteMarkers];
  if (previewSources.length === 0) return;

  const sidebarInner = document.querySelector(".sidebar-inner");
  const preview = document.createElement("aside");
  preview.id = "reference-preview";
  preview.className = "sidebar-widget reference-preview";
  preview.setAttribute("role", "dialog");
  preview.setAttribute("aria-modal", "false");
  preview.setAttribute("aria-labelledby", "reference-preview-title");
  preview.setAttribute("aria-live", "polite");
  preview.setAttribute("data-pagefind-ignore", "all");
  preview.setAttribute("data-nosnippet", "");

  const header = document.createElement("div");
  header.className = "reference-preview-header";

  const title = document.createElement("h3");
  title.id = "reference-preview-title";
  title.className = "widget-title reference-preview-title";
  title.textContent = "参考文献";

  const closeButton = document.createElement("button");
  closeButton.className = "reference-preview-close";
  closeButton.type = "button";
  const article = document.querySelector("article[data-content-preview-close-label]");
  closeButton.setAttribute(
    "aria-label",
    article?.dataset.contentPreviewCloseLabel || "Close preview",
  );
  closeButton.textContent = "x";

  const body = document.createElement("div");
  body.className = "reference-preview-body";

  header.append(title, closeButton);
  preview.append(header, body);

  if (sidebarInner) {
    sidebarInner.prepend(preview);
  } else {
    document.body.append(preview);
  }

  let activeSource = null;

  const clearActiveSource = () => {
    previewSources.forEach((link) => {
      link.classList.remove("content-preview-source-is-active");
      link.setAttribute("aria-expanded", "false");
    });
  };

  const closePreview = ({ restoreFocus = false } = {}) => {
    preview.classList.remove("is-open");
    clearActiveSource();
    if (restoreFocus && activeSource?.isConnected) activeSource.focus();
    activeSource = null;
  };

  const cloneBibliographyEntry = (entry) => {
    const list = document.createElement("ol");
    list.className = "reference-preview-list";

    const clone = entry.cloneNode(true);
    clone.removeAttribute("id");
    clone.classList.add("reference-preview-entry");

    clone.querySelectorAll('[role="doc-backlink"]').forEach((link) => {
      link.replaceWith(document.createTextNode(link.textContent));
    });

    list.append(clone);
    return list;
  };

  const cloneFootnoteEntry = (entry) => {
    const footnoteBody = entry.querySelector(".footnote-body");
    if (!footnoteBody) return null;

    const clone = footnoteBody.cloneNode(true);
    clone.classList.add("footnote-preview-entry");
    return clone;
  };

  const openPreview = (link) => {
    const href = link.getAttribute("href");
    const entry = document.getElementById(fragmentToId(href));
    if (!entry) return;

    const isFootnote = link.matches('.footnote-marker[role="doc-noteref"]');
    const content = isFootnote
      ? cloneFootnoteEntry(entry)
      : cloneBibliographyEntry(entry);
    if (!content) return;

    const sectionTitle = isFootnote
      ? document.getElementById("footnotes-heading")?.textContent.trim() || "Footnotes"
      : entry.closest('[role="doc-bibliography"]')?.querySelector("h1, h2, h3")?.textContent.trim()
        || "References";

    body.replaceChildren(content);
    title.textContent = `${sectionTitle} ${link.textContent.trim()}`;

    clearActiveSource();
    activeSource = link;
    link.classList.add("content-preview-source-is-active");
    link.setAttribute("aria-expanded", "true");
    preview.classList.add("is-open");
  };

  previewSources.forEach((link) => {
    link.setAttribute("aria-controls", "reference-preview");
    link.setAttribute("aria-haspopup", "dialog");
    link.setAttribute("aria-expanded", "false");
  });

  document.addEventListener("click", (event) => {
    const link = event.target.closest(
      'a[role="doc-biblioref"][href^="#"], .footnote-marker[role="doc-noteref"][href^="#"]',
    );
    if (!link) return;

    event.preventDefault();
    event.stopPropagation();
    openPreview(link);
  });

  closeButton.addEventListener("click", () => closePreview({ restoreFocus: true }));
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && preview.classList.contains("is-open")) {
      closePreview({ restoreFocus: true });
    }
  });
}
