# Site theme

このディレクトリは、ブログが出力する完成HTMLを所有します。ページ構造や
見た目を変更するために `vendor/typst-blog-core` を編集する必要はありません。

## 公開renderer

`theme.typ` はbuilderと記事用 `template.typ` が参照する公開窓口です。生成ページは
このfacadeだけをimportし、`vendor/typst-blog-core`のファイルを直接参照しません。
次のrendererをexportします。

- `render-article(data)`
- `render-page(data)`
- `render-home(data)`
- `render-tag(data)`
- `render-tags-index(data)`
- `render-not-found(data)`

関数を別ファイルへ移動しても構いませんが、この名前と `theme.typ` からのexportは
維持してください。

`theme.typ` は生成ページ向けに`core`名前空間もexportします。`api.typ`はcoreの
公開moduleを名前空間のまま転送するため、coreにAPIが追加されてもtemplate側で
exportを追加する必要はありません。独自themeへ置き換える場合も、生成ページとの
境界として`theme.typ`の`core`とrendererのexportを維持してください。

`api.typ` の `supported-core-api-version` は、このthemeが対応するrenderer/data
contractの版です。coreの`api-version`と一致しない場合はbuildを停止します。
`data.post`や`data.seo`などのshape変更に対応してthemeを更新するときだけ、この値も
新しいcoreの版へ更新してください。互換なcore更新では変更不要です。

## coreから渡されるもの

coreは完成HTMLを作りません。代わりに、検証・正規化済みの辞書をrendererへ
渡します。

- `data.site`: `site.typ` のサイト設定
- `data.page`: ページタイトル、説明、URL、著者など
- `data.posts`: URLと日付順を解決済みの記事一覧
- `data.pagination`: 現在ページ、総ページ数、ページ番号と前後ページのURL
- `data.post`: 記事renderer用のメタデータ、タグリンク、編集履歴URL
- `data.navigation`: 前後記事とそのURL
- `data.seo`: OGP画像URLとJSON-LD
- `data.body`: 記事または汎用ページの本文

ページ種類によって存在するフィールドは異なります。標準rendererは
`pages/` の各ファイルで、実際の利用例を兼ねています。

URLエンコード、Git由来の更新日、前後記事、タグURL、SEOデータはcoreが決めます。
これらをrenderer側で再計算せず、渡された値を使うとRSS・sitemapなどとの整合性を
保てます。

## ディレクトリ

- `pages/`: 各ページの完成renderer
- `components/`: 標準theme内で共有する部品
- `api.typ`: coreの公開moduleを`core`名前空間として転送する内部facade
- `static/`: build時に公開ディレクトリへコピーするCSSとJavaScript
- `static/color-schemes/`: `site.theme.color_scheme` で選ぶ配色
- `config.typ`: 標準theme固有の設定と検証
- `authoring.typ`: 標準themeに付属する記事執筆用部品
- `i18n.typ`: 標準themeの表示文言
- `dev/i18n-check.typ`: 翻訳キーの揃い方を確認するpaged文書

`components/` は標準themeの内部構成であり、coreとの契約ではありません。独自theme
では削除したり、まったく異なる構成へ置き換えたりできます。

## 表示文言と言語の追加

`site.typ` の `theme-config` に `translations` を指定すると、既存言語の文言を
部分的に上書きできます。既定の5言語以外も、BCP 47言語タグをキーにして追加できます。

```typst
theme: theme-config(
  color_scheme: "dark",
  translations: (
    ja: (back_home: "← トップへ"),
    fr: (back_home: "← Retour à l’accueil", toc: "Sommaire"),
    "zh-SG": (back_home: "← 返回首页"),
    "zh-Hani-TW": (back_home: "← 返回首頁"),
  ),
)
```

新しく追加した言語で省略した文言は日本語へフォールバックします。未知の翻訳キーや
空文字はbuild時にエラーになります。`typst compile --root . --features html
theme/dev/i18n-check.typ` で、追加言語の翻訳済み項目とフォールバック項目を確認できます。

## CSSテーマトークン

`static/styles/theme.css` では、coreのclass名を参照せずに、よく使う見た目をCSS変数で
変更できます。変更したい変数だけを `:root` に追加してください。指定しなかった値は
coreの既定値を使うため、core更新時のデザイン改善も受け取れます。

```css
:root {
  --card-grid-gap: 32px;
  --article-title-size: 2.6rem;
  --sidebar-widget-padding: 28px;
  --sidebar-widget-border-radius: 0;
}
```

公開しているトークンは次のとおりです。

| 分類 | トークン | 対象 |
| --- | --- | --- |
| フォント | `--font-main` | 本文のフォント |
|  | `--font-heading` | 見出しのフォント |
|  | `--font-code` | コード・日付のフォント |
| レイアウト | `--content-width` | 本文領域の幅 |
|  | `--sidebar-width` | サイドバーの幅 |
|  | `--gap-width` | 本文とサイドバーの間隔 |
|  | `--container-width` | ページ全体の最大幅。通常は上の3変数から自動計算 |
| カード | `--card-grid-min-width` | カード1枚の最小幅 |
|  | `--card-grid-gap` | カード間の余白 |
|  | `--card-border-radius` | カードの角丸 |
|  | `--card-content-padding` | カード内側の余白 |
|  | `--card-title-size` | カードの記事タイトルサイズ |
| 記事 | `--article-title-size` | 記事ページのタイトルサイズ |
|  | `--article-title-size-mobile` | モバイルでの記事タイトルサイズ |
|  | `--article-title-line-height` | 記事タイトルの行間 |
|  | `--article-heading-2-size` | 記事本文の第2階層見出しサイズ |
|  | `--article-heading-3-size` | 記事本文の第3階層見出しサイズ |
| サイドバー | `--sidebar-widget-gap` | ウィジェット間の余白 |
|  | `--sidebar-widget-padding` | ウィジェット内側の余白 |
|  | `--sidebar-widget-border-radius` | ウィジェットの角丸 |
|  | `--sidebar-widget-border-width` | ウィジェットの枠線幅 |
|  | `--sidebar-widget-title-size` | ウィジェット見出しのサイズ |
|  | `--sidebar-widget-title-gap` | 見出しと内容の間隔 |

色は `static/color-schemes/` のカラースキームで変更します。公開トークンより踏み込んだ
変更では `theme.css` に独自のCSSセレクターを追加できますが、coreのclass名は内部実装で
あり、core更新で変わる可能性があります。
