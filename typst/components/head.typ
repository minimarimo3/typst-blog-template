#import "/site.typ": site

#let common-head(title, description: none, image: none, url: none, og_type: "website") = {
  html.meta(charset: "utf-8")
  html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
  html.title(title)

  html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
  html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
  let _gf-families = (
    site.fonts.main.web.replace(" ", "+") + ":wght@" + site.fonts.main.weights,
    site.fonts.code.web.replace(" ", "+") + ":wght@" + site.fonts.code.weights,
  )
  html.link(
    rel: "stylesheet",
    href: "https://fonts.googleapis.com/css2?family=" + _gf-families.join("&family=") + "&display=swap",
  )

  html.link(rel: "stylesheet", href: "/style.css")
  html.elem("script", attrs: (src: "/script.js", defer: ""))
  html.elem("link", attrs: (rel: "alternate", type: "application/rss+xml", title: site.title, href: "/feed.xml"))

  let token = site.analytics.cloudflare_token
  if token != none and token != "" {
    html.elem(
      "script",
      attrs: (
        defer: "",
        src: "https://static.cloudflareinsights.com/beacon.min.js",
        data-cf-beacon: "{\"token\":\"" + token + "\"}",
      ),
    )
  }

  if description != none and description != "" {
    html.meta(name: "description", content: description)
    html.elem("meta", attrs: (property: "og:description", content: description))
  }
  html.elem("meta", attrs: (property: "og:title", content: title))
  html.elem("meta", attrs: (property: "og:site_name", content: site.title))
  html.elem("meta", attrs: (property: "og:type", content: og_type))
  if url != none {
    html.elem("meta", attrs: (property: "og:url", content: site.base_url + url))
  }
  if image != none {
    html.elem("meta", attrs: (property: "og:image", content: image))
  }
}
