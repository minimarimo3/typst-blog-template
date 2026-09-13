#import "../api.typ": core

#let render-not-found(data) = core.ui.not-found(
  data,
  main: core.ui.not-found-content(),
)
