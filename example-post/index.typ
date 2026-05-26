#import "../template.typ": article, calver, env, note, tip, important, warning, caution, raw_html, youtube, post-meta

#let meta = post-meta(
  slug: "example-post",
  title: "Typst HTML Export Regression Test",
  create: calver(2026, 1, 1),
  update: calver(2026, 4, 1),
  description: "Typst Blog TemplateのHTML出力と独自コンポーネントを確認するためのサンプル記事です。meta.descriptionになります。",
  tags: ("Typst", "Template", "Test"),
  abstract: "記事の内容（アブストラクト）",
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= TypstのHTMLエクスポート機能のテスト

これはただの文章です。日本語、English、12345、記号 `& < > " '` が混ざっても本文として読めるかを確認します。

#note[
  この投稿は見た目とHTML出力の回帰確認用です。記事を書くときの雰囲気を保ちつつ、テンプレートが対応している要素を広めに踏みます。
]

= 基本機能

== インライン装飾

*太字強調*

_斜体強調_

`生文字列`

https://example.co.jp

#link("https://example.com/docs")[表示テキスト付きリンク]

'シングルクオート'

"ダブルクオート"

== コード

```c
#include <stdio.h>

int main(void) {
  printf("hello\n");
  return 0;
}
```

#figure(
  ```typst
  #let greet(name) = [Hello, #name!]
  #greet("Typst")
  ```,
  caption: [コードブロックのfigure],
) <code-figure>

#[@code-figure] は raw figure のキャプション表示を確認します。

== リストと用語

- hoge
- fuga
  - nested hoge
  - nested fuga
+ piyo
+ moge

/ 用語: 説明内容
/ HTML export: Typstの文書をHTMLとして出力する機能

== 引用

#quote(attribution: [Plato])[
  ... ἔοικα γοῦν τούτου γε σμικρῷ τινι αὐτῷ τούτῳ σοφώτερος εἶναι, ὅτι
  ἃ μὴ οἶδα οὐδὲ οἴομαι εἰδέναι.
]

#quote(attribution: [from the Henry Cary literal translation of 1897])[
  ... I seem, then, in just this little thing to be wiser than this man at
  any rate, that what I do not know I do not think I know either.
]

== 数式

インライン数式: $(v dot nabla) v < "nya"$

ブロック数式:

$
  integral_0^1 x^2 dif x = 1 / 3
$

= 参照、図、表

== 見出し参照 <heading-reference-target>

#[@heading-reference-target] は見出しへの参照です。

引用は @typst-html-2026 だよ。複数引用は @typst-html-2026 と @template-regression-2026 です。

#figure(
  image("./test-image.png", alt: "てすとと書かれた画像"),
  caption: [画像のfigure#linebreak()キャプション2行目],
) <test-image>

#[@test-image] は画像がテスト用であることを示しています。

#figure(
  table(
    columns: 3,
    table.header("hoge", "fuga", "piyo"),
    "hoge1", "fuga1", "piyo1",
    "hoge2", "fuga2", "piyo2",
    "hoge3", "fuga3", "piyo3",
  ),
  caption: [表のfigure],
) <test-table>

#[@test-table] は表のキャプション位置と参照表示を確認します。

= カスタム

== アラート

#note[
  これは「補足」です。記事の端っこに書いておきたいちょっとした情報に使います。
]

#tip[
  これは「ヒント」です。役に立つテクニックなどを書くのに最適です。
]

#important[
  これは「重要」です。見逃してほしくない情報に使います。
]

#warning[
  これは「注意」です。ユーザーが気をつけるべき点です。
]

#caution[
  これは「警告」です。危険な操作や、取り返しのつかないことについて書きます。
]

== 環境表

#env(
  ("Typst", "0.14.2", "HTML export"),
  ("Python", "3.x", "build.py"),
  ("Pagefind", "optional", "検索インデックスがある場合だけ有効"),
)

== footnote <footnote>

Typst 0.14ではカスタムHTMLエクスポート内だと、標準のfootnote出力は使えません。このテンプレートでは独自の show rule でfootnoteを表示しています。

これがノートを付けられる対象1#footnote[footnoteの中身1]

これがノートを付けられる対象2#footnote[https://example.co.jp #lorem(50) @typst-html-2026]

#[@footnote] はfootnoteの説明セクションを参照しています。

== サイトの埋め込み

#raw_html(`<iframe width="560" height="315" src="https://www.youtube.com/embed/eWw8HoNkVkU?si=t5T43P_gid2S7B5z" title="YouTube video player (raw HTML)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>`)

#youtube("https://www.youtube.com/watch?v=eWw8HoNkVkU", start: 30)

= 参考文献

#bibliography("reference.bib")

// comment

/* comment */
