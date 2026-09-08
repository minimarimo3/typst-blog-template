const COPY_ICON = '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>';
const CHECK_ICON = '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>';
const COPY_LABELS = {
  ja: { copy: "コードをコピー", copied: "コピーしました" },
  en: { copy: "Copy code", copied: "Copied!" },
  ko: { copy: "코드 복사", copied: "복사됨" },
  "zh-CN": { copy: "复制代码", copied: "已复制" },
  "zh-TW": { copy: "複製程式碼", copied: "已複製" },
};

export function initCodeCopy() {
  const language = document.documentElement.lang || "ja";
  const subtags = language.split("-");
  const region = subtags.slice(1).find((subtag) => /^[A-Za-z]{2}$/.test(subtag));
  const regionalLanguage = region ? `${subtags[0].toLowerCase()}-${region.toUpperCase()}` : null;
  const labels = COPY_LABELS[language]
    ?? (regionalLanguage ? COPY_LABELS[regionalLanguage] : undefined)
    ?? COPY_LABELS[subtags[0].toLowerCase()]
    ?? COPY_LABELS.ja;

  document.querySelectorAll("pre").forEach((pre) => {
    const wrapper = document.createElement("div");
    wrapper.className = "code-block-wrapper";
    pre.parentNode.insertBefore(wrapper, pre);
    wrapper.appendChild(pre);

    const button = document.createElement("button");
    button.className = "code-copy-btn";
    button.setAttribute("aria-label", labels.copy);
    button.innerHTML = COPY_ICON;
    wrapper.appendChild(button);

    button.addEventListener("click", () => {
      const code = pre.querySelector("code")?.innerText ?? pre.innerText;
      navigator.clipboard.writeText(code).then(() => {
        button.classList.add("copied");
        button.innerHTML = CHECK_ICON;
        button.setAttribute("aria-label", labels.copied);
        window.setTimeout(() => {
          button.classList.remove("copied");
          button.innerHTML = COPY_ICON;
          button.setAttribute("aria-label", labels.copy);
        }, 2000);
      }).catch(() => {
        const selection = window.getSelection();
        const range = document.createRange();
        range.selectNodeContents(pre);
        selection?.removeAllRanges();
        selection?.addRange(range);
      });
    });
  });
}

export function initExternalLinks() {
  document.querySelectorAll("a[href]").forEach((anchor) => {
    if (anchor.hostname && anchor.hostname !== window.location.hostname) {
      anchor.setAttribute("target", "_blank");
      anchor.setAttribute("rel", "noopener noreferrer");
    }
  });
}

export function initRawHtmlEmbeds() {
  document.querySelectorAll(".raw-html-embed").forEach((element) => {
    const htmlContent = element.getAttribute("data-html");
    if (!htmlContent) return;

    const template = document.createElement("template");
    template.innerHTML = htmlContent;

    template.content.querySelectorAll("script").forEach((oldScript) => {
      const newScript = document.createElement("script");

      for (const attribute of oldScript.attributes) {
        newScript.setAttribute(attribute.name, attribute.value);
      }

      newScript.textContent = oldScript.textContent;
      oldScript.replaceWith(newScript);
    });

    element.replaceWith(template.content);
  });
}
