#import "../api.typ": core
#let ui = core.ui

#let render-article(data) = ui.article(
  data,
  main: {
    ui.back-home()
    ui.article-content(data, {
      ui.article-header(data.post)
      ui.toc-inline-slot()
      ui.abstract(data.post)
      ui.content-body(data)
    })
    ui.article-end-divider(data)
    ui.author(extra-class: "article-mobile-author")
    ui.article-actions()
    ui.post-navigation(data.navigation)
    ui.mobile-search()
  },
  sidebar: ui.sidebar({
    ui.reference-preview()
    ui.search(extra-class: "desktop-search")
    ui.toc()
    ui.author(extra-class: "article-desktop-author")
  }),
)
