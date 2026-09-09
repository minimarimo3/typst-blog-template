#import "../components/head.typ": common-head
#import "../components/page-layout.typ": page-layout
#import "../components/post-cards.typ": post-card-grid, pagination-nav
#import "../i18n.typ": i18n
#import "../components/widgets.typ": widget-mobile-search, widget-site-sidebar

#let render-home(data) = context {
  let page-title = if data.pagination.current == 1 { data.page.title } else {
    data.page.title + " — " + i18n.page + " " + str(data.pagination.current)
  }
  set document(title: page-title, author: data.page.authors)
  set text(..data.site.language)

  page-layout(
    head-content: common-head(
      page-title,
      description: data.page.description,
      image: data.page.at("og-image", default: none),
      url: data.page.url,
    ),
    main-content: {
      html.header(class: "article-header", {
        html.h1(class: "article-title", data.page.title)
        if data.page.description != "" {
          html.p(style: "color: var(--text-muted);", data.page.description)
        }
      })
      widget-mobile-search()
      post-card-grid(data.posts)
      pagination-nav(data.pagination, i18n.pagination, i18n.previous_page, i18n.next_page)
    },
    sidebar-content: widget-site-sidebar(),
  )
}
