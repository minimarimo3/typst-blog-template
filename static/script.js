function shareX() {
  const url = encodeURIComponent(window.location.href);
  const text = encodeURIComponent(document.title);
  window.open(`https://twitter.com/intent/tweet?text=${text}&url=${url}`, "_blank");
}

function shareMisskey() {
  const url = encodeURIComponent(window.location.href);
  const text = encodeURIComponent(document.title);
  window.open(`https://misskey-hub.net/share/?text=${text}&url=${url}`, "_blank");
}

function openFeedback(url, entryId) {
  if (!url) return;

  const title = document.title;
  if (!entryId) {
    window.open(url, "_blank");
    return;
  }

  const separator = url.includes("?") ? "&" : "?";
  const fullUrl = `${url}${separator}usp=pp_url&${entryId}=${encodeURIComponent(title)}`;
  window.open(fullUrl, "_blank");
}

function copyInfo() {
  const title = document.title;
  const desc = document.querySelector(".abstract-content")?.innerText.trim()
    || document.querySelector('meta[name="description"]')?.content
    || "";
  const url = window.location.href;
  const textToCopy = `${title}\n${desc}\n${url}`;

  navigator.clipboard.writeText(textToCopy).then(() => {
    const toast = document.getElementById("copy-toast");
    if (!toast) return;
    toast.classList.add("show");
    setTimeout(() => toast.classList.remove("show"), 3000);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".raw-html-embed").forEach((el) => {
    const htmlContent = el.getAttribute("data-html");
    if (htmlContent) {
      el.outerHTML = htmlContent;
    }
  });
});

document.addEventListener("DOMContentLoaded", () => {
  const footnoteWrappers = document.querySelectorAll(".footnote-wrapper");

  footnoteWrappers.forEach((wrapper) => {
    wrapper.addEventListener("click", (event) => {
      footnoteWrappers.forEach((item) => {
        if (item !== wrapper) item.classList.remove("is-active");
      });
      wrapper.classList.toggle("is-active");
      event.stopPropagation();
    });
  });

  document.addEventListener("click", () => {
    footnoteWrappers.forEach((wrapper) => {
      wrapper.classList.remove("is-active");
    });
  });
});

document.addEventListener("DOMContentLoaded", () => {
  const citationLinks = Array.from(document.querySelectorAll('a[role="doc-biblioref"][href^="#"]'));
  if (citationLinks.length === 0) return;

  const sidebarInner = document.querySelector(".sidebar-inner");
  const preview = document.createElement("aside");
  preview.id = "reference-preview";
  preview.className = "sidebar-widget reference-preview";
  preview.setAttribute("role", "dialog");
  preview.setAttribute("aria-modal", "false");
  preview.setAttribute("aria-labelledby", "reference-preview-title");
  preview.setAttribute("aria-live", "polite");

  const header = document.createElement("div");
  header.className = "reference-preview-header";

  const title = document.createElement("h3");
  title.id = "reference-preview-title";
  title.className = "widget-title reference-preview-title";
  title.textContent = "参考文献";

  const closeButton = document.createElement("button");
  closeButton.className = "reference-preview-close";
  closeButton.type = "button";
  closeButton.setAttribute("aria-label", "参考文献を閉じる");
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

  const clearActiveCitation = () => {
    citationLinks.forEach((link) => {
      link.classList.remove("biblioref-is-active");
      link.setAttribute("aria-expanded", "false");
    });
  };

  const closePreview = () => {
    preview.classList.remove("is-open");
    clearActiveCitation();
  };

  const fragmentToId = (href) => {
    try {
      return decodeURIComponent(href.slice(1));
    } catch {
      return href.slice(1);
    }
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

  const openPreview = (link) => {
    const href = link.getAttribute("href");
    const entry = document.getElementById(fragmentToId(href));
    if (!entry) return;

    document.querySelectorAll(".footnote-wrapper.is-active").forEach((wrapper) => {
      wrapper.classList.remove("is-active");
    });

    body.replaceChildren(cloneBibliographyEntry(entry));
    title.textContent = `参考文献 ${link.textContent.trim()}`;

    clearActiveCitation();
    link.classList.add("biblioref-is-active");
    link.setAttribute("aria-expanded", "true");
    preview.classList.add("is-open");
  };

  citationLinks.forEach((link) => {
    link.setAttribute("aria-controls", "reference-preview");
    link.setAttribute("aria-haspopup", "dialog");
    link.setAttribute("aria-expanded", "false");

    link.addEventListener("click", (event) => {
      event.preventDefault();
      event.stopPropagation();
      openPreview(link);
    });
  });

  closeButton.addEventListener("click", closePreview);
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") closePreview();
  });
});
