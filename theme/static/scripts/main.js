import { initArticleActions } from "./article-actions.js";
import {
  initCodeCopy,
  initExternalLinks,
  initRawHtmlEmbeds,
} from "./content-enhancements.js";
import {
  initFootnoteHoverPreview,
  initReferencePreview,
} from "./reference-preview.js";
import { initSiteSearch } from "./search.js";
import { initResponsiveToc } from "./responsive-toc.js";

initResponsiveToc();
initSiteSearch();
initCodeCopy();
initExternalLinks();
initRawHtmlEmbeds();
initFootnoteHoverPreview();
initReferencePreview();
initArticleActions();
