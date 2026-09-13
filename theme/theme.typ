#import "pages/article.typ": render-article
#import "pages/page.typ": render-page
#import "pages/home.typ": render-home
#import "pages/tag.typ": render-tag
#import "pages/tags-index.typ": render-tags-index
#import "pages/not-found.typ": render-not-found
#import "api.typ": core as core-api

// 生成ページ向け facade。生成側には core の配置を公開しない。
#let core = core-api
