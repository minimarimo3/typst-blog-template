#import "../api.typ": core
#import core: main-font, heading-font, math-font, base-path
#import "../i18n.typ": i18n
#import "../components/head.typ": common-head
#import "../components/page-layout.typ": page-layout
#import "../components/widgets.typ": widget-mobile-search, widget-search, widget-author, widget-responsive-toc, widget-toc-desktop-slot

#let render-page(data) = context {
  let page = data.page

  set document(title: page.title, author: page.authors)
  set heading(numbering: "1.")
  set text(font: main-font, ..data.site.language)
  show heading: set text(font: heading-font)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: i18n.code)
  set quote(block: true)
  if math-font != none {
    show math.equation: set text(font: math-font)
  }

  let excluded-from-index = page.draft or not page.index
  let indexing-attrs = if excluded-from-index {
    ("data-pagefind-ignore": "all", "data-nosnippet": "")
  } else {
    ("data-pagefind-body": "")
  }

  page-layout(
    head-content: {
      if excluded-from-index {
        html.meta(name: "robots", content: "noindex, nofollow")
      }
      common-head(
        page.title,
        description: page.description,
        image: page.at("og-image", default: none),
        url: page.url,
      )
    },
    main-content: {
      widget-mobile-search()
      html.elem("nav", attrs: (class: "back-home-nav", "aria-label": i18n.back_to_top, "data-pagefind-ignore": "all", "data-nosnippet": ""), {
        html.a(class: "back-home-btn", href: base-path + "/", i18n.back_home)
      })
      html.elem("article", attrs: (
        ..indexing-attrs,
        "aria-labelledby": "page-title",
        "data-content-preview-close-label": i18n.close_preview,
      ), {
        html.header(class: "article-header", {
          html.elem("h1", attrs: (id: "page-title", class: "article-title"), page.title)
          if page.draft {
            html.span(class: "draft-badge", i18n.draft)
          }
        })
        widget-responsive-toc()
        html.div(class: "article-body", data.body)
      })
    },
    sidebar-content: {
      html.div(class: "sidebar-inner", {
        widget-search(extra-class: "desktop-search")
        widget-toc-desktop-slot()
        widget-author()
      })
    },
    sidebar-attrs: ("data-pagefind-ignore": "all", "data-nosnippet": ""),
  )
}
