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
    search: "検索",
    search_placeholder: "記事を検索",
    search_loading: "検索中...",
    search_no_results: "該当する記事がありません",
    search_error: "検索インデックスを読み込めませんでした。",
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
    search: "Search",
    search_placeholder: "Search posts",
    search_loading: "Searching...",
    search_no_results: "No matching posts.",
    search_error: "Could not load the search index.",
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
  ko: (
    back_home: "← 홈으로 돌아가기",
    author: "글쓴이",
    about_blog: "이 블로그에 대하여",
    toc: "목차",
    toc_open: "목차 열기",
    created: "작성: ",
    updated: "업데이트: ",
    abstract: "개요",
    code: "코드",
    search: "검색",
    search_placeholder: "글 검색",
    search_loading: "검색 중...",
    search_no_results: "일치하는 글이 없습니다.",
    search_error: "검색 인덱스를 불러올 수 없습니다.",
    copied: "복사되었습니다",
    share: "이 글 공유하기",
    post_on_x: "X에 포스트",
    note_on_misskey: "Misskey에 노트",
    copy_info: "제목과 개요 복사",
    feedback_title: "의견 · 감상",
    feedback_body: "글에 관한 의견이나 오탈자 제보를 기다리고 있습니다.",
    feedback_send: "폼으로 보내기",
    other_articles: "다른 글",
    writing_env: "작성 환경",
    env_software: "소프트웨어",
    env_version: "버전",
    env_notes: "비고",
    not_found_desc: "찾으시는 페이지를 찾을 수 없습니다.",
    not_found_body: "페이지가 이동되었거나 삭제되었을 수 있습니다.",
    back_to_top: "홈으로 돌아가기",
  ),
  "zh-CN": (
    back_home: "← 返回首页",
    author: "作者",
    about_blog: "关于本博客",
    toc: "目录",
    toc_open: "展开目录",
    created: "创建于：",
    updated: "更新于：",
    abstract: "摘要",
    code: "代码",
    search: "搜索",
    search_placeholder: "搜索文章",
    search_loading: "搜索中...",
    search_no_results: "没有匹配的文章。",
    search_error: "无法加载搜索索引。",
    copied: "已复制",
    share: "分享本文",
    post_on_x: "发布到 X",
    note_on_misskey: "发布到 Misskey",
    copy_info: "复制标题和摘要",
    feedback_title: "意见与感想",
    feedback_body: "欢迎您对文章提出意见或指正错别字。",
    feedback_send: "通过表单发送",
    other_articles: "其他文章",
    writing_env: "写作环境",
    env_software: "软件",
    env_version: "版本",
    env_notes: "备注",
    not_found_desc: "找不到您要访问的页面。",
    not_found_body: "页面可能已移动或删除。",
    back_to_top: "返回首页",
  ),
  "zh-TW": (
    back_home: "← 返回首頁",
    author: "作者",
    about_blog: "關於本部落格",
    toc: "目錄",
    toc_open: "展開目錄",
    created: "建立於：",
    updated: "更新於：",
    abstract: "摘要",
    code: "程式碼",
    search: "搜尋",
    search_placeholder: "搜尋文章",
    search_loading: "搜尋中...",
    search_no_results: "沒有符合的文章。",
    search_error: "無法載入搜尋索引。",
    copied: "已複製",
    share: "分享本文",
    post_on_x: "發布到 X",
    note_on_misskey: "發布到 Misskey",
    copy_info: "複製標題與摘要",
    feedback_title: "意見與感想",
    feedback_body: "歡迎您對文章提出意見或指正錯別字。",
    feedback_send: "透過表單傳送",
    other_articles: "其他文章",
    writing_env: "寫作環境",
    env_software: "軟體",
    env_version: "版本",
    env_notes: "備註",
    not_found_desc: "找不到您要瀏覽的頁面。",
    not_found_body: "頁面可能已移動或刪除。",
    back_to_top: "返回首頁",
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
