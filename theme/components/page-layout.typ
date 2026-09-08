#import "/site.typ": site
#import "../api.typ": core
#import core: html-language

#let page-layout(
  head-content: none,
  main-content: none,
  sidebar-content: none,
  before-content: none,
  sidebar-attrs: (:),
) = {
  assert(head-content != none, message: "page-layout: head-content is required")
  assert(main-content != none, message: "page-layout: main-content is required")

  html.elem("html", attrs: (lang: html-language(site.language), "data-color-scheme": site.theme.color_scheme), {
    html.head(head-content)
    html.body({
      if before-content != none {
        before-content
      }
      html.div(class: "site-container", {
        html.main(class: "main-content", main-content)
        if sidebar-content != none {
          html.elem(
            "aside",
            attrs: (class: "sidebar", ..sidebar-attrs),
            sidebar-content,
          )
        }
      })
    })
  })
}
