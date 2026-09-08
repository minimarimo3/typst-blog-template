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
