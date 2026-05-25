#import "../template.typ": article, calver, env, note, tip

#let meta = (
  slug: "example-post",
  title: "Example Post",
  create: calver(2026, 1, 1),
  description: "Typst Blog Templateのサンプル記事です。",
  tags: ("Typst", "Template"),
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= はじめに

これはTypst Blog Templateのサンプル記事です。
記事はディレクトリごとに作成し、`index.typ` の先頭にメタデータを書きます。

#note[
  `slug` は公開URLになります。このサンプル記事は `/example-post/` に出力されます。
]

= 便利な部品

#tip[
  `note`, `tip`, `important`, `warning`, `caution` を使うと、記事中に簡単な補足ボックスを置けます。
]

#env(
  ("Typst", "0.14.2", "HTML export"),
  ("Python", "3.x", "build.py"),
)

脚注も使えます。#footnote[スマートフォンではタップして開きます。]

== 次にやること

- `site.typ` を自分のブログ名やURLに書き換える
- このサンプル記事を参考に新しい記事ディレクトリを作る
- `python3 build.py` でビルドする
