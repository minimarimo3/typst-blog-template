#import "/site.typ": site

#let common-head(title, description: none, image: none, url: none, og_type: "website") = {
  html.meta(charset: "utf-8")
  html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
  html.title(title)

  // site.fonts の全エントリから web フォントを動的に収集
  let _gf-families = site.fonts.pairs()
    .filter(pair => {
      let e = pair.at(1)
      let w = e.at("web", default: none)
      let wt = e.at("weights", default: none)
      w != none and w != "" and wt != none and wt != ""
    })
    .map(pair => {
      let e = pair.at(1)
      e.web.replace(" ", "+") + ":wght@" + e.weights
    })

  if _gf-families.len() > 0 {
    html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
    html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
    html.link(
      rel: "stylesheet",
      href: "https://fonts.googleapis.com/css2?family=" + _gf-families.join("&family=") + "&display=swap",
    )
  }

  html.link(rel: "stylesheet", href: "/style.css")

  // style.css より後に注入することで CSS 変数を上書き（--font-{key} 形式）
  let _css-lines = site.fonts.pairs()
    .filter(pair => {
      let web = pair.at(1).at("web", default: none)
      web != none and web != ""
    })
    .map(pair => {
      let key = pair.at(0)
      let e = pair.at(1)
      let fb = e.at("fallback", default: "serif")
      let val = if fb != none and fb != "" { "\"" + e.web + "\", " + fb } else { "\"" + e.web + "\"" }
      "  --font-" + key + ": " + val + ";"
    })
  html.elem("style", ":root {\n" + _css-lines.join("\n") + "\n}")

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
