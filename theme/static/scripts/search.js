let pagefindPromise;

function loadPagefind() {
  if (!pagefindPromise) {
    const basePath = document.querySelector('meta[name="base-path"]')?.content ?? "";
    pagefindPromise = import(basePath + "/pagefind/pagefind.js")
      .then((pagefind) => {
        pagefind.init();
        return pagefind;
      })
      .catch((error) => {
        pagefindPromise = undefined;
        throw error;
      });
  }

  return pagefindPromise;
}

export function initSiteSearch() {
  const widgets = document.querySelectorAll(".site-search");
  if (widgets.length === 0) return;

  widgets.forEach((widget) => {
    const input = widget.querySelector(".search-input");
    const status = widget.querySelector(".search-status");
    const results = widget.querySelector(".search-results");
    if (!input || !status || !results) return;

    const loadingMessage = widget.dataset.searchLoading || "Searching...";
    const emptyMessage = widget.dataset.searchEmpty || "No matching posts.";
    const errorMessage = widget.dataset.searchError || "Could not load the search index.";
    let requestId = 0;

    const setStatus = (message) => {
      status.textContent = message;
      status.hidden = !message;
    };

    const clearResults = () => {
      results.replaceChildren();
      setStatus("");
    };

    const renderResults = (items) => {
      results.replaceChildren();

      if (items.length === 0) {
        setStatus(emptyMessage);
        return;
      }

      setStatus("");
      items.forEach((item) => {
        const li = document.createElement("li");
        li.className = "search-result";

        const link = document.createElement("a");
        link.className = "search-result-link";
        link.href = item.url;

        const title = document.createElement("span");
        title.className = "search-result-title";
        title.textContent = item.meta?.title || item.url;

        const excerpt = document.createElement("span");
        excerpt.className = "search-result-excerpt";
        excerpt.innerHTML = item.excerpt || "";

        link.append(title, excerpt);
        li.append(link);
        results.append(li);
      });
    };

    const runSearch = async () => {
      const query = input.value.trim();
      const currentRequest = ++requestId;

      if (!query) {
        clearResults();
        return;
      }

      setStatus(loadingMessage);

      try {
        const pagefind = await loadPagefind();
        const search = await pagefind.debouncedSearch(query);
        if (search === null || currentRequest !== requestId) return;

        const items = await Promise.all(search.results.slice(0, 6).map((result) => result.data()));
        if (currentRequest !== requestId) return;

        renderResults(items);
      } catch (error) {
        console.warn("Pagefind search is unavailable.", error);
        results.replaceChildren();
        setStatus(errorMessage);
      }
    };

    input.addEventListener("focus", () => {
      loadPagefind().catch(() => {});
    }, { once: true });

    input.addEventListener("input", runSearch);
  });
}
