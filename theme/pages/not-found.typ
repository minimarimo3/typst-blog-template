#import "/vendor/typst-blog-core/typst/core/shared.typ": base-path
#import "../i18n.typ": i18n
#import "../components/head.typ": common-head
#import "../components/page-layout.typ": page-layout

#let render-not-found(data) = context {
  let title = "404 Not Found"
  set document(title: title, author: data.page.authors)
  set text(..data.site.language)

  page-layout(
    head-content: common-head(title, description: i18n.not_found_desc),
    main-content: {
      html.article({
        html.header(class: "article-header", {
          html.a(class: "back-home-btn", href: base-path + "/", i18n.back_home)
          html.h1(class: "article-title", title)
          html.p(style: "color: var(--text-muted);", i18n.not_found_desc)
        })
        html.div(class: "article-body", {
          html.p(i18n.not_found_body)
          html.p({ html.a(href: base-path + "/", i18n.back_to_top) })
        })
      })
    },
    sidebar-content: none,
  )
}
