#import "/vendor/typst-blog-core/typst/core/shared.typ": calver
#import "/vendor/typst-blog-core/typst/core/article.typ" as core-article
#import "/theme/theme.typ": render-article
#import "/theme/authoring.typ": env
#import "/extensions/alerts.typ": note, tip, important, warning, caution
#import "/extensions/youtube.typ": youtube
#import "/extensions/raw-html.typ": raw_html

#let post-meta = core-article.post-meta
#let article = core-article.article.with(renderer: render-article)
#let post = core-article.post.with(renderer: render-article)
#let project = article
