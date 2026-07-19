#import "/template.typ": article, calver, env, note, tip, important, warning, caution, raw_html, youtube, post-meta

#let meta = post-meta(
  slug: "example-post",
  title: "Typst blog template Sample Page",
  create: calver(2026, 1, 1),
  update: calver(2026, 4, 1),
  description: "サンプル記事です。meta.descriptionになります。",
  tags: ("Typst", "Template", "Test"),
  abstract: "記事の内容（アブストラクト）",
  draft: false,
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

#env(
  ("Typst", "0.15.0", "HTML export"),
  ("Python", "3.x", "command.py"),
  ("Pagefind", "optional", "検索インデックスがある場合だけ有効"),
)

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

== footnote <footnote>

TypstのカスタムHTMLエクスポートでは、本文中に脚注への参照リンクを置き、脚注本文を記事末尾の脚注セクションへ出力します。PCでは参照リンクにカーソルを合わせると脚注をすぐに確認でき、押すとPC・スマートフォンともに参考文献と同じプレビューパネルで内容を確認できます。

これがノートを付けられる対象1#footnote[footnoteの中身1]

これがノートを付けられる対象2#footnote[https://example.co.jp #lorem(50) @typst-html-2026]

#[@footnote] はfootnoteの説明セクションを参照しています。

== サイトの埋め込み

#raw_html(`<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">ぽんこつフリーナ様<a href="https://x.com/hashtag/Furina?src=hash&amp;ref_src=twsrc%5Etfw">#Furina</a> <a href="https://x.com/hashtag/GenshinImpact?src=hash&amp;ref_src=twsrc%5Etfw">#GenshinImpact</a> <a href="https://t.co/1gGJqkbBNw">pic.twitter.com/1gGJqkbBNw</a></p>&mdash; くるん:C108(土)東ア23b (@kurun_p) <a href="https://x.com/kurun_p/status/1699020600084513137?ref_src=twsrc%5Etfw">September 5, 2023</a></blockquote> <script async src="https://platform.x.com/widgets.js" charset="utf-8"></script>`)

#youtube("https://www.youtube.com/watch?v=eWw8HoNkVkU", start: 30)

#bibliography("reference.bib")

// comment

/* comment */
