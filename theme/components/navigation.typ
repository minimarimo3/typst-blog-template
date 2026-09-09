#import "/site.typ": site
#import "../api.typ": core
#import core: base-path
#import "../i18n.typ": i18n

#let _navigation-href(item) = if "path" in item {
  base-path + item.path
} else {
  item.url
}

#let site-navigation() = {
  let navigation = site.theme.navigation
  if navigation.len() > 0 {
    html.elem(
      "nav",
      attrs: (
        class: "site-navigation",
        "aria-label": i18n.site_navigation,
        "data-pagefind-ignore": "all",
        "data-nosnippet": "",
      ),
      {
        html.div(class: "site-navigation-inner", {
          for item in navigation {
            html.a(class: "site-navigation-link", href: _navigation-href(item), item.label)
          }
        })
      },
    )
  }
}
