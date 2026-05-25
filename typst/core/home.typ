#import "/site.typ": site
#import "/typst/core/shared.typ": calver-display, calver-key, main-font, heading-font
#import "/typst/components/head.typ": common-head
#import "/typst/components/widgets.typ": widget-author, widget-about

#let home(
  title: none,
  authors: none,
  description: none,
  og-image: none,
  posts: none,
  body,
) = context {
  let page-title = if title == none { site.title } else { title }
  let page-description = if description == none { site.description } else { description }
  let document-authors = if authors == none { (site.author.name,) } else { authors }

  set document(title: page-title, author: document-authors)
  set text(lang: site.language)

  if target() == "paged" {
    set text(font: main-font, size: 12pt, lang: site.language)
    show heading: set text(font: heading-font)
    body
    return
  }

  html.html(lang: site.language, {
    html.head({
      common-head(page-title, description: page-description, image: og-image, url: "/")
    })
    html.body({
      html.div(class: "site-container", {
        html.main(class: "main-content", {
          html.header(class: "article-header", {
            html.h1(class: "article-title", page-title)
            if page-description != "" {
              html.p(style: "color: var(--text-muted);", page-description)
            }
          })

          html.div(class: "card-grid home-card-grid", {
            let posts-list = if posts != none {
              posts
                .pairs()
                .map(pair => {
                  let (key, val) = pair
                  val + (url: "/" + key + "/")
                })
                .sorted(key: p => calver-key(p.create))
                .rev()
            } else {
              ()
            }

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
            widget-author()
            widget-about()
          })
        })
      })
    })
  })
}
