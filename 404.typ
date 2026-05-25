#import "site.typ": site
#import "/typst/components/head.typ": common-head

#let title = "404 Not Found"
#let description = "お探しのページは見つかりませんでした。"

#html.html(lang: site.language, {
  html.head({
    common-head(title, description: description)
  })
  html.body({
    html.div(class: "site-container", {
      html.main(class: "main-content", {
        html.article({
          html.header(class: "article-header", {
            html.a(class: "back-home-btn", href: "/", "← ホームに戻る")
            html.h1(class: "article-title", title)
            html.p(style: "color: var(--text-muted);", description)
          })
          html.div(class: "article-body", {
            html.p("ページが移動または削除された可能性があります。")
            html.p({
              html.a(href: "/", "トップページに戻る")
            })
          })
        })
      })
    })
  })
})
