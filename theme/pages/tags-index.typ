#import "../api.typ": core
#let ui = core.ui

#let render-tags-index(data) = ui.tags-index(
  data,
  main: {
    ui.tags-index-header()
    ui.mobile-search()
    ui.tag-list(data.tags)
  },
  sidebar: ui.sidebar({
    ui.search(extra-class: "desktop-search")
    ui.author()
    ui.about()
  }),
)
