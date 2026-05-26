/// サイト全体の設定を構築する。未知のキーはコンパイルエラー、制約違反は assert で即時検出される。
///
/// - title (str): サイトタイトル（空文字不可）
/// - description (str): サイト説明文（空文字不可）
/// - base_url (str): サイトのベース URL（例: `"https://example.com"`）。末尾スラッシュなし
/// - language (str): サイト言語コード（例: `"ja"`, `"en"`）
/// - theme (str): テーマ名。英数字・`_`・`-` のみ使用可（例: `"dark"`, `"light"`）
/// - fonts (dictionary): フォント設定。`main` と `code` キーが必須で、各々 `pdf` フィールドが必要。```typst
///   fonts: (
///     main: (pdf: "Noto Serif CJK JP", web: "Noto Serif JP", weights: "400;700", fallback: "serif"),
///     code: (pdf: "Fira Code",         web: "Fira Code",     weights: "300..700", fallback: "monospace"),
///     // heading / math / 任意名のフォントも追加可
///   )
///   ```
/// - author (dictionary): 著者情報。`name`（必須）, `bio`（str）, `socials`（`x` / `misskey` / `github` の URL）を含む辞書
/// - analytics (dictionary): アナリティクス設定。`cloudflare_token`（str | none）を含む辞書
/// - feedback (dictionary): フィードバック設定。`google_form_url`（str | none）と `entry_id`（str | none）を含む辞書
/// - share (dictionary): シェアボタン設定。`x`, `misskey`, `copy` の各 bool を含む辞書
/// -> dictionary
#let _site(
  title: none,
  description: none,
  base_url: none,
  language: none,
  theme: "dark",
  fonts: none,
  author: none,
  analytics: (cloudflare_token: none),
  feedback: (google_form_url: none, entry_id: none),
  share: none,
) = {
  let _req = (v, f) => assert(
    type(v) == str and v != "",
    message: "site." + f + ": 空でない文字列が必要です",
  )
  let _url = (u, f) => assert(
    u == "" or u.starts-with("https://") or u.starts-with("http://"),
    message: "site." + f + ": URL は https:// または http:// で始まる必要があります",
  )

  // 必須文字列
  _req(title,       "title")
  _req(description, "description")
  _req(base_url,    "base_url")
  assert(
    base_url.starts-with("https://") or base_url.starts-with("http://"),
    message: "site.base_url: https:// または http:// で始まる必要があります",
  )
  assert(not base_url.ends-with("/"), message: "site.base_url: 末尾にスラッシュは不要です")
  _req(language, "language")

  // theme（英数字・アンダースコア・ハイフンのみ）
  assert(type(theme) == str and theme != "", message: "site.theme: 空でない文字列が必要です")
  assert(
    theme.clusters().all(c =>
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-".contains(c)
    ),
    message: "site.theme: 英数字・アンダースコア・ハイフンのみ使用可能です",
  )

  // fonts（main・code は必須、それぞれ pdf フィールドが必要）
  assert(type(fonts) == dictionary, message: "site.fonts: 辞書が必要です")
  assert("main" in fonts, message: "site.fonts.main: 必須です")
  assert("code" in fonts, message: "site.fonts.code: 必須です")
  assert("pdf" in fonts.main, message: "site.fonts.main.pdf: 必須です")
  assert("pdf" in fonts.code, message: "site.fonts.code.pdf: 必須です")

  // author
  assert(type(author) == dictionary, message: "site.author: 辞書が必要です")
  _req(author.at("name", default: none), "author.name")
  assert(type(author.at("bio", default: "")) == str, message: "site.author.bio: 文字列が必要です")
  let _soc = author.at("socials", default: (:))
  _url(_soc.at("x",       default: ""), "author.socials.x")
  _url(_soc.at("misskey",  default: ""), "author.socials.misskey")
  _url(_soc.at("github",   default: ""), "author.socials.github")

  // share
  assert(type(share) == dictionary, message: "site.share: 辞書が必要です")
  assert(type(share.at("x",       default: none)) == bool, message: "site.share.x: true/false が必要です")
  assert(type(share.at("misskey", default: none)) == bool, message: "site.share.misskey: true/false が必要です")
  assert(type(share.at("copy",    default: none)) == bool, message: "site.share.copy: true/false が必要です")

  // analytics（省略可・設定する場合は文字列）
  let _cf = analytics.at("cloudflare_token", default: none)
  assert(_cf == none or type(_cf) == str, message: "site.analytics.cloudflare_token: none か文字列が必要です")

  // feedback（省略可・設定する場合は文字列）
  let _gf  = feedback.at("google_form_url", default: none)
  let _eid = feedback.at("entry_id",        default: none)
  assert(_gf  == none or type(_gf)  == str, message: "site.feedback.google_form_url: none か文字列が必要です")
  assert(_eid == none or type(_eid) == str, message: "site.feedback.entry_id: none か文字列が必要です")

  (
    title: title, description: description, base_url: base_url, language: language,
    theme: theme, fonts: fonts, author: author, analytics: analytics,
    feedback: feedback, share: share,
  )
}
