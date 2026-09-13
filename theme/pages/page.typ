#import "../api.typ": core
#let ui = core.ui

#let render-page(data) = ui.page(
  data,
  main: {
    ui.mobile-search()
    ui.back-home()
    ui.page-content(data, {
      ui.page-header(data.page)
      ui.toc-inline-slot()
      ui.content-body(data)
    })
  },
  sidebar: ui.sidebar({
    ui.reference-preview()
    ui.search(extra-class: "desktop-search")
    ui.toc()
    ui.author()
  }),
)
