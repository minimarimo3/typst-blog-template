#import "/extensions/api.typ": export-target

// 信頼できる HTML だけに使用する。core の共通ランタイムが data-html を展開する。
#let raw_html(content) = context {
  if export-target() == "paged" {
    return []
  }

  html.elem("div", attrs: (
    class: "raw-html-embed",
    "data-html": content.text,
  ))
}
