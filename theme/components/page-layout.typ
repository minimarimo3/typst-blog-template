#import "/site.typ": site
#import "../api.typ": core
#import core: html-language
#import "../i18n.typ": i18n
#import "navigation.typ": site-navigation

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
      html.elem(
        "a",
        attrs: (
          class: "skip-link",
          href: "#main-content",
          "data-pagefind-ignore": "all",
          "data-nosnippet": "",
        ),
        i18n.skip_to_main_content,
      )
      if before-content != none {
        before-content
      }
      site-navigation()
      html.div(class: "site-container", {
        html.elem("main", attrs: (id: "main-content", class: "main-content"), main-content)
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
