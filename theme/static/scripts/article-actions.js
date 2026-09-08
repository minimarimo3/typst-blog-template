let copyToastTimer;

function shareX() {
  const url = encodeURIComponent(window.location.href);
  const text = encodeURIComponent(document.title);
  window.open(`https://twitter.com/intent/tweet?text=${text}&url=${url}`, "_blank", "noopener,noreferrer");
}

function shareMisskey() {
  const url = encodeURIComponent(window.location.href);
  const text = encodeURIComponent(document.title);
  window.open(`https://misskey-hub.net/share/?text=${text}&url=${url}`, "_blank", "noopener,noreferrer");
}

function openFeedback(url, entryId) {
  if (!url) return;

  const title = document.title;
  if (!entryId) {
    window.open(url, "_blank", "noopener,noreferrer");
    return;
  }

  const separator = url.includes("?") ? "&" : "?";
  const fullUrl = `${url}${separator}usp=pp_url&${entryId}=${encodeURIComponent(title)}`;
  window.open(fullUrl, "_blank", "noopener,noreferrer");
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
    toast.textContent = toast.dataset.copiedLabel || "Copied!";
    toast.classList.add("show");
    window.clearTimeout(copyToastTimer);
    copyToastTimer = window.setTimeout(() => {
      toast.classList.remove("show");
      copyToastTimer = window.setTimeout(() => {
        if (!toast.classList.contains("show")) {
          toast.textContent = "";
        }
      }, 300);
    }, 3000);
  });
}

export function initArticleActions() {
  document.querySelectorAll("[data-article-action]").forEach((button) => {
    button.addEventListener("click", () => {
      switch (button.dataset.articleAction) {
        case "share-x":
          shareX();
          break;
        case "share-misskey":
          shareMisskey();
          break;
        case "copy-info":
          copyInfo();
          break;
        case "open-feedback":
          openFeedback(button.dataset.feedbackUrl, button.dataset.feedbackEntryId);
          break;
      }
    });
  });
}
