#let _alert-box(kind, title, icon, body) = context {
  if target() == "paged" {
    return icon + " " + title + ": " + body
  }

  html.div(class: "markdown-alert markdown-alert-" + kind, {
    html.p(class: "markdown-alert-title", {
      html.span(class: "markdown-alert-icon", icon)
      title
    })
    html.div(class: "markdown-alert-content", body)
  })
}

#let note(body) = _alert-box("note", "補足", "i", body)
#let tip(body) = _alert-box("tip", "ヒント", "+", body)
#let important(body) = _alert-box("important", "重要", "!", body)
#let warning(body) = _alert-box("warning", "注意", "!", body)
#let caution(body) = _alert-box("caution", "警告", "!!", body)
