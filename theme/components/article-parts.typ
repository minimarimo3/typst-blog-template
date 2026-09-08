#import "/site.typ": site
#import "/vendor/typst-blog-core/typst/core/shared.typ": calver-display, calver-iso
#import "../i18n.typ": i18n

#let article-header(post) = {
  html.header(class: "article-header", {
    html.elem("h1", attrs: (id: "article-title", class: "article-title", itemprop: "headline"), post.title)
    if post.draft {
      html.span(class: "draft-badge", i18n.draft)
    }
    html.div(class: "article-meta", {
      html.div(class: "meta-dates", {
        html.span(class: "meta-date", {
          i18n.created
          html.elem(
            "time",
            attrs: (
              datetime: calver-iso(post.create),
              itemprop: if post.update == none { "datePublished dateModified" } else { "datePublished" },
            ),
            calver-display(post.create),
          )
        })
        if post.update != none {
          html.span(class: "meta-date", {
            i18n.updated
            html.elem(
              "time",
              attrs: (datetime: calver-iso(post.update), itemprop: "dateModified"),
              calver-display(post.update),
            )
          })
        }
      })
      if post.tag-links.len() > 0 {
        html.div(class: "meta-tags", {
          for tag in post.tag-links {
            html.a(class: "tag", href: tag.url, "#" + tag.name)
          }
        })
      }
      if post.source-url != none {
        html.elem("div", attrs: (class: "meta-edit-history", "data-pagefind-ignore": "all", "data-nosnippet": ""), {
          html.elem(
            "a",
            attrs: (
              class: "edit-history-link",
              href: post.source-url,
              target: "_blank",
              rel: "noopener noreferrer",
            ),
            i18n.edit_history,
          )
        })
      }
    })
  })
}

#let article-actions() = {
  let share-enabled = site.share.x or site.share.misskey or site.share.copy
  let feedback-enabled = site.feedback.google_form_url != none and site.feedback.google_form_url != ""

  if share-enabled or feedback-enabled {
    html.elem("aside", attrs: (class: "share-feedback-section", "aria-label": i18n.article_actions, "data-pagefind-ignore": "all", "data-nosnippet": ""), {
      html.hr(class: "section-divider")
      if share-enabled {
        html.elem("section", attrs: (class: "share-area", "aria-labelledby": "share-heading"), {
          html.elem("h3", attrs: (id: "share-heading"), i18n.share)
          html.div(class: "share-buttons", {
            if site.share.x {
              html.elem("button", attrs: (class: "share-btn btn-x", type: "button", "data-article-action": "share-x"), i18n.post_on_x)
            }
            if site.share.misskey {
              html.elem("button", attrs: (class: "share-btn btn-misskey", type: "button", "data-article-action": "share-misskey"), i18n.note_on_misskey)
            }
            if site.share.copy {
              html.elem("button", attrs: (class: "share-btn btn-copy", type: "button", "data-article-action": "copy-info"), i18n.copy_info)
            }
          })
        })
      }

      if feedback-enabled {
        let feedback-entry-id = if site.feedback.entry_id == none { "" } else { site.feedback.entry_id }
        html.elem("section", attrs: (class: "feedback-area", "aria-labelledby": "feedback-heading"), {
          html.elem("h3", attrs: (id: "feedback-heading"), i18n.feedback_title)
          html.p(i18n.feedback_body)
          html.elem(
            "button",
            attrs: (
              class: "feedback-link",
              type: "button",
              "data-article-action": "open-feedback",
              "data-feedback-url": site.feedback.google_form_url,
              "data-feedback-entry-id": feedback-entry-id,
            ),
            i18n.feedback_send,
          )
        })
      }
    })
  }
}

#let post-navigation(navigation) = {
  if navigation.previous != none or navigation.next != none {
    html.hr(class: "section-divider")
    html.elem("nav", attrs: (class: "post-nav", "aria-label": i18n.adjacent_articles, "data-pagefind-ignore": "all", "data-nosnippet": ""), {
      if navigation.previous != none {
        html.a(class: "post-nav-link post-nav-prev", href: navigation.previous.url, {
          html.span(class: "post-nav-label", i18n.prev_article)
          html.span(class: "post-nav-title", navigation.previous.title)
        })
      }
      if navigation.next != none {
        html.a(class: "post-nav-link post-nav-next", href: navigation.next.url, {
          html.span(class: "post-nav-label", i18n.next_article)
          html.span(class: "post-nav-title", navigation.next.title)
        })
      }
    })
  }
}
