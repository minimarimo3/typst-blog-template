#import "../components/head.typ": common-head
#import "../components/page-layout.typ": page-layout
#import "../components/post-cards.typ": post-card-grid
#import "../components/widgets.typ": widget-mobile-search, widget-site-sidebar

#let render-home(data) = context {
  set document(title: data.page.title, author: data.page.authors)
  set text(..data.site.language)

  page-layout(
    head-content: common-head(
      data.page.title,
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
    },
    sidebar-content: widget-site-sidebar(),
  )
}
