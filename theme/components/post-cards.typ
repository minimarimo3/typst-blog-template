#import "../api.typ": core
#import core: calver-display, calver-iso
#import "../i18n.typ": i18n

#let post-card-grid(posts) = {
  html.div(class: "card-grid home-card-grid", {
    for post in posts {
      html.a(class: "post-card", href: post.url, {
        html.div(class: "card-content", {
          if "create" in post {
            html.elem(
              "time",
              attrs: (class: "card-date", datetime: calver-iso(post.create)),
              calver-display(post.create),
            )
          }
          if post.at("draft", default: false) {
            html.span(class: "draft-badge", i18n.draft)
          }
          html.h2(class: "card-title", post.title)
          if "description" in post {
            html.p(class: "card-desc", post.description)
          }
        })
      })
    }
  })
}

#let pagination-nav(pagination, label, previous-label, next-label) = {
  if pagination.total > 1 {
    html.elem("nav", attrs: (class: "pagination", aria-label: label), {
      if pagination.previous != none {
        html.a(class: "pagination-direction", href: pagination.previous, previous-label)
      } else {
        html.span(class: "pagination-direction is-disabled", previous-label)
      }
      html.div(class: "pagination-pages", {
        for page in pagination.pages {
          if page.number == pagination.current {
            html.span(class: "pagination-page is-current", aria-current: "page", str(page.number))
          } else {
            html.a(class: "pagination-page", href: page.url, str(page.number))
          }
        }
      })
      if pagination.next != none {
        html.a(class: "pagination-direction", href: pagination.next, next-label)
      } else {
        html.span(class: "pagination-direction is-disabled", next-label)
      }
    })
  }
}
