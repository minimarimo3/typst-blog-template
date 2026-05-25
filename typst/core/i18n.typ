#import "/site.typ": site

#let _translations = (
  ja: (
    back_home: "← ホームに戻る",
    author: "執筆者",
    about_blog: "このブログについて",
    toc: "目次",
    toc_open: "目次を開く",
    created: "作成: ",
    updated: "更新日: ",
    abstract: "概要",
    code: "コード",
    copied: "コピーしました",
    share: "この記事をシェアする",
    post_on_x: "Xでポスト",
    note_on_misskey: "Misskeyでノート",
    copy_info: "タイトルと概要をコピー",
    feedback_title: "ご意見・ご感想",
    feedback_body: "記事に関するご意見や誤字の報告などをお待ちしています。",
    feedback_send: "フォームで送る",
    other_articles: "その他の記事",
    writing_env: "執筆環境",
    env_software: "ソフト名",
    env_version: "バージョン",
    env_notes: "補足",
    not_found_desc: "お探しのページは見つかりませんでした。",
    not_found_body: "ページが移動または削除された可能性があります。",
    back_to_top: "トップページに戻る",
  ),
  en: (
    back_home: "← Back to home",
    author: "Author",
    about_blog: "About this blog",
    toc: "Table of Contents",
    toc_open: "Open table of contents",
    created: "Created: ",
    updated: "Updated: ",
    abstract: "Abstract",
    code: "Code",
    copied: "Copied!",
    share: "Share this article",
    post_on_x: "Post on X",
    note_on_misskey: "Note on Misskey",
    copy_info: "Copy title and summary",
    feedback_title: "Feedback",
    feedback_body: "We welcome your feedback on articles, including corrections.",
    feedback_send: "Send via form",
    other_articles: "Other articles",
    writing_env: "Writing Environment",
    env_software: "Software",
    env_version: "Version",
    env_notes: "Notes",
    not_found_desc: "The page you are looking for could not be found.",
    not_found_body: "The page may have been moved or deleted.",
    back_to_top: "Back to top",
  ),
)

// Falls back to Japanese for unrecognized language codes.
#let i18n = _translations.at(site.language, default: _translations.ja)

// Renders a coverage table comparing each non-Japanese language against Japanese.
// Use in a paged document (e.g. typst compile docs/i18n-check.typ).
#let i18n-coverage() = {
  let ja = _translations.ja
  let keys = ja.keys()
  let other-langs = _translations.keys().filter(l => l != "ja")

  if other-langs.len() == 0 {
    [日本語以外の翻訳が登録されていません。]
    return
  }

  for lang in other-langs {
    let t = _translations.at(lang)
    let done = keys.filter(k => k in t).len()
    let total = keys.len()

    heading(level: 2)[#lang  (#done / #total)]

    table(
      columns: (auto, 1fr, 1fr, auto),
      align: (left, left, left, center),
      inset: 6pt,
      stroke: 0.5pt + gray,
      table.header([*キー*], [*日本語 (ja)*], [*#lang*], [*状態*]),
      ..keys.map(key => {
        let ja-val = ja.at(key)
        let lang-val = t.at(key, default: none)
        (
          raw(key),
          ja-val,
          if lang-val != none { lang-val } else { [—] },
          if lang-val != none {
            text(fill: green.darken(20%))[✓]
          } else {
            text(fill: red)[✗]
          },
        )
      }).flatten()
    )
  }
}
