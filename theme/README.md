# Site theme

このディレクトリは、ブログが出力する完成HTMLを所有します。ページ構造や
見た目を変更するために `vendor/typst-blog-core` を編集する必要はありません。

## 公開renderer

`theme.typ` はbuilderと記事用 `template.typ` が参照する公開窓口です。次の
rendererをexportします。

- `render-article(data)`
- `render-home(data)`
- `render-tag(data)`
- `render-tags-index(data)`
- `render-not-found(data)`

関数を別ファイルへ移動しても構いませんが、この名前と `theme.typ` からのexportは
維持してください。

## coreから渡されるもの

coreは完成HTMLを作りません。代わりに、検証・正規化済みの辞書をrendererへ
渡します。

- `data.site`: `site.typ` のサイト設定
- `data.page`: ページタイトル、説明、URL、著者など
- `data.posts`: URLと日付順を解決済みの記事一覧
- `data.post`: 記事renderer用のメタデータ、タグリンク、編集履歴URL
- `data.navigation`: 前後記事とそのURL
- `data.seo`: OGP画像URLとJSON-LD
- `data.body`: 記事本文

ページ種類によって存在するフィールドは異なります。標準rendererは
`pages/` の各ファイルで、実際の利用例を兼ねています。

URLエンコード、Git由来の更新日、前後記事、タグURL、SEOデータはcoreが決めます。
これらをrenderer側で再計算せず、渡された値を使うとRSS・sitemapなどとの整合性を
保てます。

## ディレクトリ

- `pages/`: 各ページの完成renderer
- `components/`: 標準theme内で共有する部品
- `static/`: build時に公開ディレクトリへコピーするCSSとJavaScript
- `static/color-schemes/`: `site.theme.color_scheme` で選ぶ配色
- `config.typ`: 標準theme固有の設定と検証
- `authoring.typ`: 標準themeに付属する記事執筆用部品
- `i18n.typ`: 標準themeの表示文言
- `dev/i18n-check.typ`: 翻訳キーの揃い方を確認するpaged文書

`components/` は標準themeの内部構成であり、coreとの契約ではありません。独自theme
では削除したり、まったく異なる構成へ置き換えたりできます。
