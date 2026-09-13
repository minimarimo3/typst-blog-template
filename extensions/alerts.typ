#import "/site.typ": site
#import "/extensions/api.typ": extension, export-target

#let alert-extension = extension(
  "alerts",
  styles: ("extensions/alerts.css",),
)

#let _alert-translations = (
  ja: (
    note: "補足",
    tip: "ヒント",
    important: "重要",
    warning: "注意",
    caution: "警告",
  ),
  en: (
    note: "Note",
    tip: "Tip",
    important: "Important",
    warning: "Warning",
    caution: "Caution",
  ),
  ko: (
    note: "참고",
    tip: "팁",
    important: "중요",
    warning: "경고",
    caution: "주의",
  ),
  "zh-CN": (
    note: "备注",
    tip: "提示",
    important: "重要",
    warning: "警告",
    caution: "注意",
  ),
  "zh-TW": (
    note: "附註",
    tip: "提示",
    important: "重要",
    warning: "警告",
    caution: "注意",
  ),
)

#let _alert-language(language) = {
  let candidates = ()
  let full = language.lang
  if language.script != auto {
    let script = language.script
    full += "-" + upper(script.slice(0, 1)) + lower(script.slice(1))
  }
  if language.region != none {
    full += "-" + upper(language.region)
  }
  candidates.push(full)
  if language.region != none {
    candidates.push(language.lang + "-" + upper(language.region))
  }
  if language.script != auto {
    let script = language.script
    candidates.push(
      language.lang + "-" + upper(script.slice(0, 1)) + lower(script.slice(1)),
    )
  }
  candidates.push(language.lang)

  let matched = candidates.find(candidate => candidate in _alert-translations)
  if matched != none {
    matched
  } else if language.lang == "zh" {
    "zh-CN"
  } else {
    "en"
  }
}

#let _alert-labels = _alert-translations.at(_alert-language(site.language))

#let _alert-title(kind, title) = if title == auto {
  _alert-labels.at(kind)
} else {
  title
}

#let _alert-box(kind, title, icon, body) = context {
  if export-target() == "paged" {
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

#let note(body, title: auto) = _alert-box("note", _alert-title("note", title), "i", body)
#let tip(body, title: auto) = _alert-box("tip", _alert-title("tip", title), "+", body)
#let important(body, title: auto) = _alert-box(
  "important",
  _alert-title("important", title),
  "!",
  body,
)
#let warning(body, title: auto) = _alert-box(
  "warning",
  _alert-title("warning", title),
  "⚠",
  body,
)
#let caution(body, title: auto) = _alert-box(
  "caution",
  _alert-title("caution", title),
  "!!",
  body,
)
