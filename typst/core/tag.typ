#import "/site.typ": site
#import "/typst/core/shared.typ": calver-display, calver-key, main-font, heading-font, base-path
#import "/typst/core/i18n.typ": i18n
#import "/typst/components/head.typ": common-head
#import "/typst/components/widgets.typ": widget-author, widget-about, widget-search

#let tag-page(
  tag: "",
  posts: (:),
  body,
) = context {
  let tag-slug = tag.replace(" ", "-")
  let page-title = "#" + tag + " | " + site.title
  set document(title: page-title, author: site.author.name)
  set text(lang: site.language)

  if target() == "paged" {
    set text(font: main-font, size: 12pt)
    show heading: set text(font: heading-font)
    body
    return
  }

  html.html(lang: site.language, {
    html.head({
      common-head(page-title, url: "/tags/" + tag-slug + "/")
    })
    html.body({
      html.div(class: "site-container", {
        html.main(class: "main-content", {
          html.header(class: "article-header", {
            html.a(class: "back-home-btn", href: base-path + "/", i18n.back_home)
            html.h1(class: "article-title", {
              html.span(class: "tag-page-prefix", i18n.tags + " / ")
              "#" + tag
            })
          })

          html.div(class: "mobile-search", {
            widget-search()
          })

          let posts-list = posts
            .pairs()
            .map(pair => {
              let (key, val) = pair
              val + (url: base-path + "/" + key + "/")
            })
            .sorted(key: p => calver-key(p.create))
            .rev()

          html.div(class: "card-grid home-card-grid", {
            for post in posts-list {
              html.a(class: "post-card", href: post.url, {
                html.div(class: "card-content", {
                  if "create" in post {
                    html.time(class: "card-date", calver-display(post.create))
                  }
                  html.h3(class: "card-title", post.title)
                  if "description" in post {
                    html.p(class: "card-desc", post.description)
                  }
                })
              })
            }
          })
        })

        html.aside(class: "sidebar", {
          html.div(class: "sidebar-inner", {
            widget-search(extra-class: "desktop-search")
            widget-author()
            widget-about()
          })
        })
      })
    })
  })
}
