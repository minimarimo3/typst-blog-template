#import "/site.typ": site
#import "/extensions.typ": extensions
#import "../api.typ": core
#import core: base-path, extension-assets, extension-asset-url, google-font-families, font-css-lines

#let _json-ld-text(value) = {
  json.encode(value)
    .replace("<", "\\u003c")
    .replace(">", "\\u003e")
    .replace("&", "\\u0026")
}

#let _absolute-url(value, page-url: none) = {
  let cleaned = if value.starts-with("./") { value.slice(2) } else { value }
  if cleaned.starts-with("https://") or cleaned.starts-with("http://") {
    cleaned
  } else if cleaned.starts-with("//") {
    "https:" + cleaned
  } else if cleaned.starts-with("/") {
    site.base_url + cleaned
  } else if page-url != none and page-url != "" {
    page-url + cleaned
  } else {
    site.base_url + "/" + cleaned
  }
}

#let common-head(
  title,
  description: none,
  image: none,
  url: none,
  og_type: "website",
  json_ld: none,
  article_published_time: none,
  article_modified_time: none,
  article_authors: (),
  article_tags: (),
) = {
  let absolute-url = if url == none { none } else { _absolute-url(url) }
  let supplied-image = image != none and image != ""
  let default-image = site.at("default_og_image", default: none)
  let image-value = if supplied-image { image } else { default-image }
  let image-page-url = if supplied-image { absolute-url } else { site.base_url + "/" }
  let absolute-image = if image-value != none and image-value != "" {
    _absolute-url(image-value, page-url: image-page-url)
  } else {
    none
  }
  let article-author-list = if type(article_authors) == str { (article_authors,) } else { article_authors }
  let article-tag-list = if type(article_tags) == str { (article_tags,) } else { article_tags }

  html.meta(charset: "utf-8")
  html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
  html.title(title)
  if absolute-url != none {
    html.link(rel: "canonical", href: absolute-url)
  }

  // site.fonts の全エントリから web フォントを動的に収集
  let _gf-families = google-font-families(site.fonts)

  if _gf-families.len() > 0 {
    html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
    html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
    html.link(
      rel: "stylesheet",
      href: "https://fonts.googleapis.com/css2?family=" + _gf-families.join("&family=") + "&display=swap",
    )
  }

  // base-path をメタタグに埋め込む（検索モジュールが Pagefind のパス解決に使う）
  html.meta(name: "base-path", content: base-path)
  html.link(rel: "stylesheet", href: base-path + "/styles/base.css")
  html.link(rel: "stylesheet", href: base-path + "/styles/layout.css")
  html.link(rel: "stylesheet", href: base-path + "/styles/article.css")
  html.link(rel: "stylesheet", href: base-path + "/styles/components.css")
  html.link(rel: "stylesheet", href: base-path + "/styles/pages.css")
  html.link(rel: "stylesheet", href: base-path + "/color-schemes/" + site.theme.color_scheme + ".css")

  let assets = extension-assets(extensions)
  for stylesheet in assets.styles {
    html.link(rel: "stylesheet", href: extension-asset-url(stylesheet, base-path))
  }

  // theme CSS より後に注入することで CSS 変数を上書き（--font-{key} 形式）
  let _css-lines = font-css-lines(site.fonts)
  html.elem("style", ":root {\n" + _css-lines.join("\n") + "\n}")

  html.elem("script", attrs: (type: "module", src: base-path + "/scripts/main.js"))
  for script in assets.scripts {
    html.elem("script", attrs: (type: "module", src: extension-asset-url(script, base-path)))
  }
  if sys.inputs.at("preview", default: "false") == "true" {
    html.elem("script", attrs: (src: "/__typst_blog_preview.js", defer: ""))
  }
  html.elem("link", attrs: (rel: "alternate", type: "application/rss+xml", title: site.title, href: base-path + "/feed.xml"))

  let token = site.theme.cloudflare_token
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
  if absolute-url != none {
    html.elem("meta", attrs: (property: "og:url", content: absolute-url))
  }
  if absolute-image != none {
    html.elem("meta", attrs: (property: "og:image", content: absolute-image))
  }
  if og_type == "article" {
    if article_published_time != none {
      html.elem("meta", attrs: (property: "article:published_time", content: article_published_time))
    }
    if article_modified_time != none {
      html.elem("meta", attrs: (property: "article:modified_time", content: article_modified_time))
    }
    for author in article-author-list {
      if author != "" {
        html.elem("meta", attrs: (property: "article:author", content: author))
      }
    }
    for tag in article-tag-list {
      if tag != "" {
        html.elem("meta", attrs: (property: "article:tag", content: tag))
      }
    }
  }
  html.meta(name: "twitter:card", content: if absolute-image == none { "summary" } else { "summary_large_image" })
  html.meta(name: "twitter:title", content: title)
  if description != none and description != "" {
    html.meta(name: "twitter:description", content: description)
  }
  if absolute-image != none {
    html.meta(name: "twitter:image", content: absolute-image)
  }
  if json_ld != none {
    html.elem("script", attrs: (type: "application/ld+json"), _json-ld-text(json_ld))
  }
}
