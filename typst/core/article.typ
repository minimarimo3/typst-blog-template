#import "/site.typ": site
#import "/typst/core/shared.typ": calver-display, calver-iso, calver-key, main-font, heading-font, math-font, base-path
#import "/typst/core/i18n.typ": i18n
#import "/typst/generated/posts.typ": post-data
#import "/typst/components/head.typ": common-head
#import "/typst/components/widgets.typ": widget-author, widget-search
#import "@preview/suiji:0.5.0": *

#let env(..items) = context {
  heading(outlined: false, numbering: none, i18n.writing_env)

  table(
    columns: (auto, auto, 1fr),
    inset: 8pt,
    align: horizon,
    stroke: (x, y) => if y == 0 { (bottom: 1pt + black) } else { (bottom: 0.5pt + gray) },
    table.header(i18n.env_software, i18n.env_version, i18n.env_notes),
    ..items
      .pos()
      .map(item => (
        item.at(0),
        item.at(1),
        item.at(2, default: [---]),
      ))
      .flatten(),
  )
}

/// 記事のメタデータを構築する。
///
/// - slug (str, none): URLスラッグ（例: `"my-first-post"`）。`none` のとき build.py がファイルパスから推定する
/// - title (str): 記事タイトル
/// - authors (array, none): 著者名のリスト（例: `("Alice", "Bob")`）。`none` のとき `site.author.name` が使われる
/// - create (datetime, none): 作成日（例: `datetime(year: 2024, month: 1, day: 1)`）
/// - update (datetime, none): 最終更新日。`none` のとき作成日と同じ扱い
/// - tags (array): タグのリスト（例: `("Typst", "Web")`）
/// - description (str, none): メタディスクリプション（SEO・OGP用）
/// - abstract (content, none): 記事要約。`none` のとき `description` がフォールバックとして使われる
/// - og-image (str, none): OGP画像の URL（例: `"https://example.com/og.png"`）
/// - draft (bool): `true` のとき下書き。build.py が公開対象から除外する
/// -> dictionary
#let post-meta(
  slug: none,
  title: "記事タイトル",
  authors: none,
  create: none,
  update: none,
  tags: (),
  description: none,
  abstract: none,
  og-image: none,
  draft: true,
) = (
  slug: slug,
  title: title,
  authors: authors,
  create: create,
  update: update,
  tags: tags,
  description: description,
  abstract: abstract,
  og-image: og-image,
  draft: draft,
)

#let _article-url(slug) = {
  site.base_url + "/" + slug.trim("/", at: start).trim("/", at: end) + "/"
}

#let _absolute-article-url(value, page-url) = {
  let cleaned = if value.starts-with("./") { value.slice(2) } else { value }
  if cleaned.starts-with("https://") or cleaned.starts-with("http://") {
    cleaned
  } else if cleaned.starts-with("/") {
    site.base_url + cleaned
  } else {
    page-url + cleaned
  }
}

#let _article-json-ld(title, description, authors, create, update, slug, image) = {
  let page-url = _article-url(slug)
  let modified = if update == none { create } else { update }
  let author-data = authors.map(name => (
    "@type": "Person",
    name: name,
  ))
  let data = (
    "@context": "https://schema.org",
    "@type": "BlogPosting",
    headline: title,
    description: description,
    datePublished: calver-iso(create),
    dateModified: calver-iso(modified),
    author: if author-data.len() == 1 { author-data.first() } else { author-data },
    mainEntityOfPage: (
      "@type": "WebPage",
      "@id": page-url,
    ),
    url: page-url,
    inLanguage: site.language,
  )

  if image != none and image != "" {
    data.insert("image", _absolute-article-url(image, page-url))
  }
  data
}

#let article(
  slug: none,
  title: "記事タイトル",
  authors: none,
  create: none,
  update: none,
  tags: (),
  description: none,
  abstract: none,
  og-image: none,
  draft: false,
  ..args,
  body,
) = context {
  let document-authors = if authors == none { (site.author.name,) } else { authors }
  set document(title: title, author: document-authors)
  set heading(numbering: "1.")
  set text(lang: site.language, font: main-font)
  show heading: set text(font: heading-font)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: i18n.code)
  set quote(block: true)

  if target() == "paged" {
    set text(font: main-font, size: 12pt)
    show heading: set text(font: heading-font)
    if math-font != none {
      show math.equation: set text(font: math-font)
    }
    body
    return
  }

  assert(slug != none, message: "slug is required")
  assert(create != none, message: "create is required")
  assert(description != none, message: "description is required")
  let abstract-content = if abstract != none { abstract } else { description }
  let article-json-ld = _article-json-ld(title, description, document-authors, create, update, slug, og-image)

  let note-counter = counter("my-footnote")
  show footnote: it => {
    note-counter.step()
    let num = note-counter.get().first() + 1
    html.span(class: "footnote-wrapper", {
      html.span(class: "footnote-marker", "※" + str(num))
      html.span(class: "footnote-content", it.body)
    })
  }

  // TODO: 2026/05/26日の最新mainではこのハックが必要なくなっている。0.15.0では数式もHTMLエクスポートできるようになるだろうからリリース後に確認して削除する必要があるかも。
  show math.equation.where(block: false): it => {
    html.elem("span", attrs: (role: "math"), html.frame(it))
  }
  show math.equation.where(block: true): it => {
    html.elem("figure", attrs: (role: "math"), html.frame(it))
  }

  let share-enabled = site.share.x or site.share.misskey or site.share.copy
  let feedback-enabled = site.feedback.google_form_url != none and site.feedback.google_form_url != ""

  html.html(lang: site.language, {
    html.head({
      common-head(
        title,
        description: description,
        image: og-image,
        url: "/" + slug + "/",
        og_type: "article",
        json_ld: article-json-ld,
      )
    })
    html.body({
      html.div(id: "copy-toast", i18n.copied)
      html.div(class: "site-container", {
        html.main(class: "main-content", {
          html.div(class: "mobile-search", {
            widget-search()
          })

          html.elem("article", attrs: ("data-pagefind-body": "", "aria-labelledby": "article-title"), {
            html.header(class: "article-header", {
              html.a(class: "back-home-btn", href: base-path + "/", i18n.back_home)
              html.elem("h1", attrs: (id: "article-title", class: "article-title"), title)
              html.div(class: "article-meta", {
                html.div(class: "meta-dates", {
                  if create != none {
                    html.span(class: "meta-date", {
                      i18n.created
                      html.elem("time", attrs: (datetime: calver-iso(create)), calver-display(create))
                    })
                  }
                  if update != none {
                    html.span(class: "meta-date", {
                      i18n.updated
                      html.elem("time", attrs: (datetime: calver-iso(update)), calver-display(update))
                    })
                  }
                })
                if tags.len() > 0 {
                  html.div(class: "meta-tags", {
                    for tag in tags {
                      html.a(class: "tag", href: base-path + "/tags/" + tag.replace(" ", "-") + "/", "#" + tag)
                    }
                  })
                }
                let github-repo = site.at("github_repo", default: none)
                if github-repo != none and github-repo != "" {
                  let source-path = post-data.at(slug, default: (:)).at("source_path", default: none)
                  if source-path != none {
                    html.div(class: "meta-edit-history", {
                      html.elem(
                        "a",
                        attrs: (
                          class: "edit-history-link",
                          href: github-repo.trim("/", at: end) + "/commits/main/" + source-path,
                          target: "_blank",
                          rel: "noopener noreferrer",
                        ),
                        i18n.edit_history,
                      )
                    })
                  }
                }
              })
            })

            html.elem("nav", attrs: (class: "mobile-toc", "aria-label": i18n.toc, "data-pagefind-ignore": ""), {
              html.details({
                html.summary(i18n.toc_open)
                outline(title: none)
              })
            })

            if type(abstract-content) != str or abstract-content != "" {
              html.elem(
                "section",
                attrs: (class: "article-abstract", "aria-labelledby": "article-abstract-heading"),
                {
                  html.elem("h2", attrs: (id: "article-abstract-heading", class: "abstract-title"), i18n.abstract)
                  if type(abstract-content) == str {
                    html.p(class: "abstract-content", abstract-content)
                  } else {
                    html.div(class: "abstract-content", abstract-content)
                  }
                },
              )
            }

            html.div(class: "article-body", body)
          })

          if share-enabled or feedback-enabled {
            html.elem("section", attrs: (class: "share-feedback-section", "aria-label": i18n.article_actions, "data-pagefind-ignore": ""), {
              html.hr(class: "section-divider")
              if share-enabled {
                html.elem("section", attrs: (class: "share-area", "aria-labelledby": "share-heading"), {
                  html.elem("h3", attrs: (id: "share-heading"), i18n.share)
                  html.div(class: "share-buttons", {
                    if site.share.x {
                      html.elem("button", attrs: (class: "share-btn btn-x", onclick: "shareX()"), i18n.post_on_x)
                    }
                    if site.share.misskey {
                      html.elem("button", attrs: (class: "share-btn btn-misskey", onclick: "shareMisskey()"), i18n.note_on_misskey)
                    }
                    if site.share.copy {
                      html.elem("button", attrs: (class: "share-btn btn-copy", onclick: "copyInfo()"), i18n.copy_info)
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
                      onclick: "openFeedback('" + site.feedback.google_form_url + "', '" + feedback-entry-id + "')",
                    ),
                    i18n.feedback_send,
                  )
                })
              }
            })
          }

          let other-posts = post-data
            .pairs()
            .filter(p => p.first() != slug)
          if other-posts.len() > 0 {
            html.hr(class: "section-divider")

            html.elem("aside", attrs: (class: "related-posts", "aria-labelledby": "related-posts-heading", "data-pagefind-ignore": ""), {
              html.elem("h2", attrs: (id: "related-posts-heading", class: "section-title"), i18n.other_articles)
              let seed-src = slug + title
              let seed = int(seed-src.clusters().map(str.to-unicode).map(str).join().slice(0, calc.min(14, seed-src.clusters().len())))
              let rng = gen-rng(seed)
              let (_, indices) = shuffle-f(rng, range(other-posts.len()))
              let picks = indices.slice(0, calc.min(3, indices.len())).map(i => other-posts.at(i))

              html.div(class: "card-grid", {
                for pair in picks {
                  let (other-slug, post) = pair
                  let url = base-path + "/" + other-slug + "/"
                  html.a(class: "post-card", href: url, {
                    html.div(class: "card-content", {
                      if "create" in post {
                        html.elem("time", attrs: (class: "card-date", datetime: calver-iso(post.create)), calver-display(post.create))
                      }
                      html.h3(class: "card-title", post.title)
                      if "description" in post {
                        html.p(class: "card-desc", post.description)
                      }
                    })
                  })
                }
              })
            })
          }

          let sorted-posts = post-data
            .pairs()
            .map(pair => {
              let (key, val) = pair
              val + (slug: key)
            })
            .sorted(key: p => calver-key(p.create))
            .rev()
          let current-idx = sorted-posts.position(p => p.slug == slug)
          if current-idx != none {
            let prev-post = if current-idx + 1 < sorted-posts.len() { sorted-posts.at(current-idx + 1) } else { none }
            let next-post = if current-idx > 0 { sorted-posts.at(current-idx - 1) } else { none }
            if prev-post != none or next-post != none {
              html.hr(class: "section-divider")
              html.elem("nav", attrs: (class: "post-nav", "aria-label": i18n.adjacent_articles, "data-pagefind-ignore": ""), {
                if prev-post != none {
                  html.a(class: "post-nav-link post-nav-prev", href: base-path + "/" + prev-post.slug + "/", {
                    html.span(class: "post-nav-label", i18n.prev_article)
                    html.span(class: "post-nav-title", prev-post.title)
                  })
                }
                if next-post != none {
                  html.a(class: "post-nav-link post-nav-next", href: base-path + "/" + next-post.slug + "/", {
                    html.span(class: "post-nav-label", i18n.next_article)
                    html.span(class: "post-nav-title", next-post.title)
                  })
                }
              })
            }
          }
        })

        html.aside(class: "sidebar", {
          html.div(class: "sidebar-inner", {
            widget-search(extra-class: "desktop-search")
            html.elem("nav", attrs: (class: "sidebar-widget toc-widget", "aria-label": i18n.toc, "data-pagefind-ignore": ""), {
              html.h3(class: "widget-title", i18n.toc)
              outline(title: none)
            })
            widget-author()
          })
        })
      })
    })
  })
}
