#import "../api.typ": core
#import core: calver-iso-datetime, main-font, heading-font, math-font, base-path
#import "../i18n.typ": i18n
#import "../components/article-parts.typ": article-header, article-actions, post-navigation
#import "../components/head.typ": common-head
#import "../components/page-layout.typ": page-layout
#import "../components/widgets.typ": widget-author, widget-search, widget-responsive-toc, widget-toc-desktop-slot

#let render-article(data) = context {
  let post = data.post
  let page = data.page
  let body = data.body
  let generated-og-image = post.outputs.find(output => output.id == "og-image")
  let authored-og-image = post.at("og-image", default: none)
  let use-generated-og-image = (
    (authored-og-image == none or authored-og-image == "")
      and generated-og-image != none
  )
  let generated-og-image-url = if generated-og-image == none {
    none
  } else {
    data.site.base_url.trim("/", at: end) + generated-og-image.path
  }
  let effective-og-image = if use-generated-og-image {
    generated-og-image-url
  } else {
    data.seo.image-url
  }
  let effective-json-ld = data.seo.json-ld
  if use-generated-og-image {
    effective-json-ld.insert("image", generated-og-image-url)
  }

  set heading(numbering: "1.")
  set text(font: main-font, ..data.site.language)
  show heading: set text(font: heading-font)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: i18n.code)
  set quote(block: true)
  if math-font != none {
    show math.equation: set text(font: math-font)
  }

  let note-counter = counter("my-footnote")
  let footnotes = state("article-footnotes-" + post.slug, ())
  show footnote: it => {
    context {
      note-counter.step()
      let num = note-counter.get().first() + 1
      let note-id = "footnote-" + str(num)
      let reference-id = "footnote-reference-" + str(num)
      footnotes.update(notes => notes + ((number: num, body: it.body),))
      html.elem("sup", attrs: (class: "footnote-wrapper"), {
        html.elem(
          "a",
          attrs: (id: reference-id, class: "footnote-marker", href: "#" + note-id, role: "doc-noteref"),
          "※" + str(num),
        )
      })
    }
  }

  if sys.version < version(0, 15, 0) {
    show math.equation.where(block: false): it => {
      html.elem("span", attrs: (role: "math"), html.frame(it))
    }
    show math.equation.where(block: true): it => {
      html.elem("figure", attrs: (role: "math"), html.frame(it))
    }
  }

  let modified = if post.update == none { post.create } else { post.update }
  let article-indexing-attrs = if post.draft {
    ("data-pagefind-ignore": "all", "data-nosnippet": "")
  } else {
    ("data-pagefind-body": "")
  }

  page-layout(
    head-content: {
      if post.draft {
        html.meta(name: "robots", content: "noindex, nofollow")
      }
      common-head(
        page.title,
        description: page.description,
        image: effective-og-image,
        url: page.url,
        og_type: "article",
        json_ld: effective-json-ld,
        article_published_time: calver-iso-datetime(post.create),
        article_modified_time: calver-iso-datetime(modified),
        article_authors: post.authors,
        article_tags: post.tags,
      )
    },
    before-content: {
      html.elem(
        "div",
        attrs: (
          id: "copy-toast",
          role: "status",
          "aria-live": "polite",
          "aria-atomic": "true",
          "data-copied-label": i18n.copied,
          "data-pagefind-ignore": "all",
          "data-nosnippet": "",
        ),
      )
    },
    main-content: {
      html.elem("div", attrs: (class: "mobile-search", "data-pagefind-ignore": "all", "data-nosnippet": ""), {
        widget-search()
      })

      html.elem("nav", attrs: (class: "back-home-nav", "aria-label": i18n.back_to_top, "data-pagefind-ignore": "all", "data-nosnippet": ""), {
        html.elem("a", attrs: (class: "back-home-btn", href: base-path + "/", "data-pagefind-ignore": "all", "data-nosnippet": ""), i18n.back_home)
      })

      html.elem("article", attrs: (
        ..article-indexing-attrs,
        "aria-labelledby": "article-title",
        "data-content-preview-close-label": i18n.close_preview,
        itemscope: "",
        itemtype: "https://schema.org/BlogPosting",
      ), {
        article-header(post)

        widget-responsive-toc()

        if type(post.abstract) != str or post.abstract != "" {
          html.elem("section", attrs: (class: "article-abstract", "aria-labelledby": "article-abstract-heading"), {
            html.elem("h2", attrs: (id: "article-abstract-heading", class: "abstract-title"), i18n.abstract)
            if type(post.abstract) == str {
              html.p(class: "abstract-content", post.abstract)
            } else {
              html.div(class: "abstract-content", post.abstract)
            }
          })
        }

        html.elem("div", attrs: (class: "article-body", itemprop: "articleBody"), {
          body
          context {
            let notes = footnotes.final()
            if notes.len() > 0 {
              html.elem("section", attrs: (class: "footnotes", role: "doc-endnotes", "aria-labelledby": "footnotes-heading"), {
                html.elem("h2", attrs: (id: "footnotes-heading", class: "footnotes-heading"), i18n.footnotes)
                html.elem("ol", attrs: (class: "footnotes-list"), {
                  for note in notes {
                    let note-id = "footnote-" + str(note.number)
                    let reference-id = "footnote-reference-" + str(note.number)
                    html.elem("li", attrs: (id: note-id, role: "doc-endnote"), {
                      html.div(class: "footnote-body", note.body)
                      [ ]
                      html.elem("a", attrs: (class: "footnote-backlink", href: "#" + reference-id, role: "doc-backlink", "aria-label": i18n.back_to_footnote_reference), "↩")
                    })
                  }
                })
              })
            }
          }
        })
      })

      article-actions()
      post-navigation(data.navigation)
    },
    sidebar-content: {
      html.div(class: "sidebar-inner", {
        widget-search(extra-class: "desktop-search")
        widget-toc-desktop-slot()
        widget-author()
      })
    },
    sidebar-attrs: ("data-pagefind-ignore": "all", "data-nosnippet": ""),
  )
}
