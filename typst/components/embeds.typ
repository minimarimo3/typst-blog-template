#let raw_html(content) = {
  html.elem("div", attrs: (
    class: "raw-html-embed",
    "data-html": content.text,
  ))
}

#let youtube(url-or-id, start: none) = context {
  let m = url-or-id.match(regex("(?:v=|youtu\\.be/|embed/)([a-zA-Z0-9_-]{11})"))

  let clean-id = if m != none {
    m.captures.at(0)
  } else {
    url-or-id.split("?").at(0).split("&").at(0)
  }

  let query-params = ()
  if start != none {
    query-params.push("start=" + str(start))
  }

  let query-string = if query-params.len() > 0 {
    "?" + query-params.join("&")
  } else {
    ""
  }

  let embed-url = "https://www.youtube.com/embed/" + clean-id + query-string

  if target() == "paged" {
    return [
      #align(center)[
        #rect(inset: 10pt, stroke: luma(150), radius: 4pt)[
          YouTube: #link("https://youtu.be/" + clean-id)
        ]
      ]
    ]
  }

  html.div(class: "video-wrapper", {
    html.elem("iframe", attrs: (
      src: embed-url,
      title: "YouTube video player",
      frameborder: "0",
      allow: "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share",
      allowfullscreen: "",
    ))
  })
}
