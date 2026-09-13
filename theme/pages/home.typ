#import "../api.typ": core
#let ui = core.ui

#let render-home(data) = ui.home(
  data,
  main: {
    ui.home-header(data)
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
