#import "/theme/api.typ": core
#import "/theme/theme.typ": render-article
#import "/theme/authoring.typ": env
#import "/extensions/alerts.typ": note, tip, important, warning, caution
#import "/extensions/youtube.typ": youtube
#import "/extensions/raw-html.typ": raw_html

#let calver = core.calver
#let post-meta = core.post-meta
#let article = core.article.with(renderer: render-article)
#let post = core.post.with(renderer: render-article)
#let project = article
