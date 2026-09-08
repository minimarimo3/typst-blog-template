#import "/vendor/typst-blog-core/typst/core/shared.typ": base-path
#import "../i18n.typ": i18n
#import "../components/head.typ": common-head
#import "../components/page-layout.typ": page-layout
#import "../components/widgets.typ": widget-mobile-search, widget-site-sidebar

#let render-tags-index(data) = context {
  let page-title = i18n.tag_index_title + " | " + data.site.title
  set document(title: page-title, author: data.page.authors)
  set text(..data.site.language)

  page-layout(
    head-content: common-head(page-title, url: data.page.url),
    main-content: {
      html.header(class: "article-header", {
        html.a(class: "back-home-btn", href: base-path + "/", i18n.back_home)
        html.h1(class: "article-title", i18n.tag_index_title)
      })
      widget-mobile-search()
      html.div(class: "tag-index-list", {
        for tag in data.tags {
          html.a(class: "tag-index-item", href: tag.url, {
            html.span(class: "tag", "#" + tag.name)
            html.span(class: "tag-count", str(tag.count))
          })
        }
      })
    },
    sidebar-content: widget-site-sidebar(),
  )
}
