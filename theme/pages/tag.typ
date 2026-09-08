#import "../api.typ": core
#import core: base-path
#import "../i18n.typ": i18n
#import "../components/head.typ": common-head
#import "../components/page-layout.typ": page-layout
#import "../components/post-cards.typ": post-card-grid
#import "../components/widgets.typ": widget-mobile-search, widget-site-sidebar

#let render-tag(data) = context {
  set document(title: data.page.title, author: data.page.authors)
  set text(..data.site.language)

  page-layout(
    head-content: common-head(data.page.title, url: data.page.url),
    main-content: {
      html.header(class: "article-header", {
        html.a(class: "back-home-btn", href: base-path + "/", i18n.back_home)
        html.h1(class: "article-title", {
          html.span(class: "tag-page-prefix", i18n.tags + " / ")
          "#" + data.tag.name
        })
      })
      widget-mobile-search()
      post-card-grid(data.posts)
    },
    sidebar-content: widget-site-sidebar(),
  )
}
