#import "site.typ": site
#import "/vendor/typst-blog-core/typst/core/i18n.typ": i18n
#import "/vendor/typst-blog-core/typst/components/head.typ": common-head

#let title = "404 Not Found"

#html.html(lang: site.language, {
  html.head({
    common-head(title, description: i18n.not_found_desc)
  })
  html.body({
    html.div(class: "site-container", {
      html.main(class: "main-content", {
        html.article({
          html.header(class: "article-header", {
            html.a(class: "back-home-btn", href: "/", i18n.back_home)
            html.h1(class: "article-title", title)
            html.p(style: "color: var(--text-muted);", i18n.not_found_desc)
          })
          html.div(class: "article-body", {
            html.p(i18n.not_found_body)
            html.p({
              html.a(href: "/", i18n.back_to_top)
            })
          })
        })
      })
    })
  })
})
