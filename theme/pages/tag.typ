#import "../api.typ": core
#let ui = core.ui

#let render-tag(data) = ui.tag(
  data,
  main: {
    ui.tag-header(data)
    ui.mobile-search()
    ui.post-cards(data.posts)
    ui.pagination(data.pagination)
  },
  sidebar: ui.sidebar({
    ui.search(extra-class: "desktop-search")
    ui.author()
    ui.about()
  }),
)
