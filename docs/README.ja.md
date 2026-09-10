# Typst Blog Template

Typst で記事を書いて、静的なブログとして公開するためのテンプレートです。
記事を書いてビルドするだけで、トップページ・記事ページ・タグページ・RSS・sitemap・サイト内検索用インデックスがまとめて生成されます。

さまざまな記法が書かれたサンプルページ：<https://minimarimo3.github.io/typst-blog-template/example-post/>
このテンプレートを使用したリポジトリ作者のブログ：<https://www.minimarimo3.jp>

言語: 日本語 | [English](../README.md) | [한국어](README.ko.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md)

## 特徴

- 記事もサイト設定もすべて Typst で書けます
- タイトル・作成日・更新日・説明文・タグ・下書き状態を記事ごとに設定できます
- トップページ、記事ページ、タグ別ページ、タグ一覧ページを自動生成します
- RSS と sitemap も自動生成します
- [Pagefind](https://pagefind.app/) によるサイト内検索に対応しています
- GitHub Pages にそのまま公開できます（ワークフロー同梱）
- About・FAQ・利用規約などを、記事ではない汎用ページとして作れます
- coreを変更せず、`theme/` で記事・汎用・トップ・タグ・404ページの構造を作り替えられます
- 配色の切り替え、favicon・画像・追加 CSS・独自ドメインの設定ができます
- core を変更せず、Typst・CSS・JavaScript をまとめた template 側の拡張を追加できます
- `blog.py`からPDF・EPUB生成やPythonによる後処理を追加できます
- ブログエンジン部分（`vendor/typst-blog-core`）だけを後から更新できます

## 動作環境

| ツール | バージョン |
| --- | --- |
| Git | - |
| Typst | 0.15.0 以上 |
| Python | 3.10 以上 |
| Node.js | 20 以上 |

Node.js は検索インデックスを作る Pagefind の実行に使います。検索機能を使わない場合でも、GitHub Pages の標準ワークフローでは Node.js を使います。

## クイックスタート

### 1. リポジトリを作って clone する

GitHub の「Use this template」ボタンで自分用のリポジトリを作り、ローカルに clone します。

```sh
git clone --recurse-submodules https://github.com/USER/REPO.git
cd REPO
```

> [!NOTE]
> すでに clone 済みで `vendor/typst-blog-core` が空の場合は、`git submodule update --init --recursive` を実行してください。

### 2. サイト設定を書き換える

`site.typ` を開き、自分のブログに合わせて変更します。最初に見直すのは次の項目です。

| 項目 | 内容 |
| --- | --- |
| `title` | ブログ名 |
| `description` | ブログの説明文 |
| `base_url` | 公開後の URL（末尾に `/` は付けない） |
| `github_repo` | このブログの GitHub リポジトリ URL |
| `language` | 主に使う言語。`"ja"` の短縮形、または `lang`・`region`・`script` を個別に指定 |
| `theme.color_scheme` | `"dark"` または `"light"` |
| `theme.navigation` | 任意のナビゲーション。空なら何も表示しない |
| `theme.article_actions` | シェアボタンと任意の記事フィードバックフォーム |
| `posts_dir` | 記事を置く場所。ルート直下なら `"."`、`posts/` にまとめるなら `"posts"` |
| `update_policy` | 更新日の決め方。`"git"`（既定・Git 履歴から自動算出）か `"manual"`（記事の `update` を使う） |
| `author.name` | 著者名 |
| `author.bio` | プロフィール文 |
| `author.links` | `id`・`label`・`url`と、省略可能な`static/`基準の`icon`パスを持つ著者プロフィールリンク |

地域や用字系を区別する言語では、BCP 47 文字列ではなく Typst の言語要素を個別に指定します。

```typst
language: (
  lang: "zh",
  region: "TW",
  script: "hani",
)
```

`lang` は必須の ISO 639-1/2/3 コードです。`region` は省略可能な ISO 3166-1 alpha-2 コード、`script` も省略可能で既定値は `auto` です。生成される HTML では、これらを `zh-Hani-TW` のような BCP 47 タグへ変換します。

GitHub Pages で公開する場合、`base_url` は次の形になります。

```typst
base_url: "https://USER.github.io/REPO"
```

独自ドメインを使う場合は、そのドメインの URL を指定してください。

### 3. 記事を作る

```sh
python3 command.py new post my-first-post \
  --title "My First Post" \
  --description "記事の短い説明文です。" \
  --tag Typst
```

記事用のディレクトリと、メタ情報入りの `index.typ` がまとめて作られます。

### 4. ローカルで確認する

```sh
python3 command.py preview
```

初回ビルド後、`http://localhost:8000` でプレビューサーバーが起動します。ファイルを保存すると自動で再ビルドされ、ブラウザも再読み込みされます。

### 5. 公開する

`main` ブランチに push すると、GitHub Actions が自動でビルドして GitHub Pages に公開します。詳しくは [GitHub Pages で公開する](#github-pages-で公開する) を見てください。

## 記事の書き方

記事は「1 記事 = 1 ディレクトリ」で、各ディレクトリの `index.typ` が本文になります。画像や参考文献も同じディレクトリに置きます。

### 記事を新規作成する

```sh
python3 command.py new post my-first-post \
  --title "My First Post" \
  --description "記事の短い説明文です。" \
  --tag Typst
```

- 作成日は実行日になり、状態は安全のため下書きになります
- タグを複数付けるときは `--tag` を繰り返します
- 最初から公開状態にするときは `--publish` を付けます
- 作成日を指定するときは `--date 2026-07-19` の形式で指定します
- 同名の出力先ディレクトリがすでにある場合はエラーになります

#### `new post` をブログ側で拡張する

ブログ固有のメタデータ用オプションは、core を変更せず、ルートの
`command.py` から追加できます。たとえば `--course` と `--lesson` を
追加する場合は、次の関数を定義して `core_api.main()` に渡します。

```python
import argparse


core_api = _load_core_api()


def configure_new_post(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--course", required=True)
    parser.add_argument("--lesson", required=True, type=int)


def main() -> int:
    return core_api.main(
        root_dir=ROOT_DIR,
        configure_new_post=configure_new_post,
    )
```

これで次のように実行できます。

```sh
python3 command.py new post lesson-one \
  --title "Lesson one" \
  --description "最初のレッスンです。" \
  --course typst-basics \
  --lesson 1
```

追加した値は core 標準の投稿テンプレートに `extra` 辞書として書き込まれます。
値には JSON として表現できる文字列・数値・真偽値・配列・辞書を使用してください。
値が `None` の省略可能な引数は `extra` に書き込まれません。

記事ファイル全体の雛形も変えたい場合は、検証済みの
`PostTemplateContext` を受け取る関数を `new_post_template` に指定できます。
メタデータ部分を標準のまま保つ場合は、core の標準雛形を呼び出して本文だけを
置き換える方法が簡単です。

```python
def course_post_template(post: core_api.PostTemplateContext) -> str:
    source = core_api.default_post_template(post)
    return source.replace(
        "// Write the post body below.",
        "= 目標\n\n= レッスン\n\n= 練習問題",
    )


def main() -> int:
    return core_api.main(
        root_dir=ROOT_DIR,
        configure_new_post=configure_new_post,
        new_post_template=course_post_template,
    )
```

どちらも指定しない既定状態では、これまでどおり core 側の引数と投稿テンプレートが
使用されます。

### 記事ファイルの形式

生成される `index.typ` の先頭は次のようになっています。

```typst
#import "/template.typ": post, calver

#show: post.with(
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "記事の短い説明文です。",
  tags: ("Typst",),
  draft: true,
)

= はじめに

本文を書きます。
```

`post` の show ルールが、これらの値をビルド用メタデータとして登録し、以降の本文を記事レイアウトで描画します。

| 項目 | 内容 |
| --- | --- |
| `permalink` | 正式URLを変える省略可能な指定。`"/notes/hello/"` のように書く。省略すると `posts_dir` からのディレクトリ階層がURLになる |
| `aliases` | 以前のURLを `("/hello/", "/2025/hello/")` のように指定する省略可能な配列。各URLに正式URLへの転送ページが生成される |
| `title` | 記事タイトル |
| `create` | 作成日 |
| `update` | 更新日。`update_policy: "manual"` のときだけ使われる |
| `description` | 記事一覧や検索結果で使われる短い説明文 |
| `tags` | タグ。表示名に日本語・空白・記号を使っても、安全で重複しない URL のタグページが自動で作られる |
| `extra` | 任意のJSON互換メタデータを入れる省略可能な辞書。coreは内容を解釈せず、themeとPythonのビルドcallbackへそのまま渡す |
| `draft` | `true` なら下書き、`false` なら公開対象。省略すると下書き扱い |

例えば`extra: (course: "typst-basics", lesson: 1)`を指定し、rendererから
`data.post.extra`を読むことで、coreを変更せずにtheme側でコースという概念を実装できます。
`extra`の中では、文字列・数値・真偽値・`none`・配列・ネストした辞書を使用できます。

## 汎用ページを書く

About、FAQ、利用規約などの記事ではないページは、記事一覧・タグページ・前後記事・
RSSへ入らない汎用ページとして作れます。公開かつindex対象のページはsitemapと
Pagefindへ含まれます。

```sh
python3 command.py new page about \
  --title "このサイトについて" \
  --description "このサイトと運営者について紹介します。"
```

作成直後は下書きです。すぐ公開する場合は`--publish`を付けます。公開はするものの
検索エンジン・Pagefind・sitemapに含めない補助ページには`--no-index`を付けます。
生成される`pages/about/index.typ`は次の形式です。

```typst
#import "/template.typ": site-page

#show: site-page.with(
  title: "このサイトについて",
  description: "このサイトと運営者について紹介します。",
  draft: true,
  index: true,
)

= このサイトについて
```

初期状態では、ディレクトリの階層がそのままURLの階層になります。たとえば
`posts_dir: "posts"` のとき、`posts/guides/install/index.typ` は
`/guides/install/`、`pages/legal/privacy/index.typ` は `/legal/privacy/` で
公開されます。別のURLで公開する場合や、移動前のリンクを残す場合は
`permalink` と `aliases` を指定します。

```typst
#show: post.with(
  permalink: "/blog/install/",
  aliases: ("/guides/install/",),
  // ...
)
```

ナビゲーションはページとは独立して、必要な場合だけ`theme-config`へ設定します。
サイト内リンクは`path`、外部リンクは`url`を使います。

```typst
theme: theme-config(
  color_scheme: "dark",
  navigation: (
    (label: "ホーム", path: "/"),
    (label: "About", path: "/about/"),
    (label: "GitHub", url: "https://github.com/example"),
  ),
)
```

homeとタグ別の記事一覧は、初期状態では全件を1ページに表示します。分割したい一覧の
`enabled`を`true`にし、1ページに表示する記事カード数を`per_page`で指定します。

```typst
pagination: (
  home: (enabled: true, per_page: 10),
  tag: (enabled: true, per_page: 20),
),
```

homeは`/`、`/page/2/`、`/page/3/`の順に生成されます。タグ別一覧の2ページ目は
`/tags/{タグ}/page/2/`です。`enabled: false`に戻すとその一覧は1ページになり、
`per_page`は使用されません。

## 記事の公開と配置

### 下書きと公開

`draft` の値で切り替えます。公開したい記事には `draft: false` を書いてください。

- **`preview` では**: 下書きも表示され、一覧と記事ページに「下書き」バッジが付きます。下書きには `noindex` が設定され、検索対象にもなりません。
- **`build`（公開ビルド）では**: 下書きの記事ページは生成されず、一覧・タグページ・RSS・sitemap にも含まれません。

### 更新日の仕組み

更新日は既定（`update_policy: "git"`）で自動管理されます。

- 記事の `index.typ` や、同じ記事ディレクトリ内の画像・参考文献などをコミットすると、その最新コミット日が更新日になります
- 記事を最初に追加したコミットしかない場合、更新日は表示されません
- Git 履歴を取得できない環境では警告を表示し、記事に `update` が書かれていればその値を使います

手動で管理したい場合は、`site.typ` で `update_policy: "manual"` を指定し、記事の `update` に日付を書きます。

### 記事を posts/ にまとめる

記事ディレクトリをルート直下ではなく `posts/` 配下にまとめたい場合は、`site.typ` で `posts_dir: "posts"` を指定します。`new` コマンドの作成先と、ビルド時の記事探索範囲の両方が `posts/` になります。

## ローカルで確認する

```sh
python3 command.py preview
```

- 初回ビルド後、`http://localhost:8000` でプレビューサーバーが起動します
- Typst ファイル・CSS・JavaScript・画像などを保存すると、自動で再ビルドされブラウザも再読み込みされます
- 8000 番が使用中の場合は別の空きポートが選ばれるので、ターミナルに表示された URL を開いてください
- 終了するには `Ctrl+C` を押します

`site.typ` の `base_url` は公開 URL のままで構いません。`preview` は CSS や記事リンクなどの基準パスだけをローカルサーバー向けの `/` に切り替え、canonical URL・RSS・sitemap には引き続き `base_url` を使います。

検索機能も確認したい場合は、別のターミナルで検索インデックスを作ります。

```sh
npx -y pagefind --site public
```

記事を変更して自動再ビルドされた後は、このコマンドをもう一度実行してください。

公開用の生成結果をそのまま確認したい場合は `python3 command.py build` を実行します。

## GitHub Pages で公開する

このテンプレートには GitHub Pages 用のワークフローが入っています。設定は最初の一度だけです。

1. `site.typ` の `base_url` とブログ情報を自分用に変更する
2. GitHub の `Settings` → `Pages` を開く
3. `Build and deployment` の `Source` を `GitHub Actions` にする
4. 変更を `main` ブランチに push する

以降は push するたびに GitHub Actions が自動でビルドし、`public/` の内容を GitHub Pages にデプロイします。

### 独自ドメインを使う

1. `static/CNAME`（またはリポジトリ直下の `CNAME`）にドメイン名を書く
2. `site.typ` の `base_url` も独自ドメインに合わせる

## サイトthemeを変更する

完成したHTMLページの構造はcoreではなく `theme/` が所有します。記事は
`theme/pages/article.typ`、汎用ページは`page.typ`、トップは `home.typ`、タグ関連は `tag.typ` と
`tags-index.typ`、404は `not-found.typ` で変更できます。共通レイアウトやhead、
カード、widgetは `theme/components/`、CSSとJavaScriptは `theme/static/` にあります。

`theme/theme.typ` はbuilderが利用するrendererの公開窓口です。内部を整理する場合も、
6種類のrendererのexportは維持してください。coreは確定済みURL、日付、前後記事、
SEOデータを渡し、themeがそれをどのようなHTMLにするかを決めます。

### 配色を切り替える

`site.typ` の `theme.color_scheme` で切り替えます。最初から使えるのは `dark` と `light` です。

```typst
theme: theme-config(color_scheme: "light")
```

### 独自の配色を作る

`theme/static/color-schemes/` にCSSを追加し、ファイル名（拡張子なし）を
`theme.color_scheme` に指定します。

```typst
// theme/static/color-schemes/paper.css を作った場合
theme: theme-config(color_scheme: "paper")
```

### 画像・favicon・追加 CSS

`static/` に置いたファイルは、ビルド時にそのまま `public/` へコピーされます。
標準パイプラインは各記事のタイトルと説明から1200×630の`og.png`も生成します。
記事で`og-image`を明示した場合はそちらを優先します。生成カードの見た目は
`tools/og-image.typ`で変更できます。

### ブログ拡張を追加する

拡張は、記事で使う Typst 関数と CSS・JavaScript をひとまとまりにします。template 側にある標準 alert と YouTube 埋め込みも、ユーザーが利用できるものと同じ拡張の仕組みで実装されています。作り方は[ブログ拡張を作る](extensions.ja.md)を参照してください。

### ビルドパイプラインを拡張する

記事・サイト単位の追加出力、HTML後処理、ローカル成果物完成後の処理は`blog.py`へ
登録できます。詳しくは[ビルドパイプラインを拡張する](build-hooks.ja.md)を参照してください。

## ファイル構成

普段よく編集するファイル:

| パス | 内容 |
| --- | --- |
| `site.typ` | ブログ名、公開 URL、著者情報、配色などのサイト設定 |
| `theme/pages/` | 記事・汎用・トップ・タグ・タグ一覧・404ページの完成renderer |
| `theme/components/` | head、共通レイアウト、カード、widgetなどの部品 |
| `theme/static/` | themeが使うCSSとJavaScript |
| `extensions.typ` | 有効にする標準・独自拡張の登録簿 |
| `extensions/` | 標準・独自拡張の Typst モジュール |
| `blog.py` | 追加出力やビルド処理を登録するPython設定 |
| `記事ディレクトリ/index.typ` | 自分の記事 |
| `pages/ページ名/index.typ` | Aboutや利用規約などの汎用ページ |
| `example-post/index.typ` | 記事の書き方のサンプル |
| `static/` | サイト固有の画像、favicon、拡張用asset、`CNAME` など |

基本的に触らないファイル:

| パス | 内容 |
| --- | --- |
| `vendor/typst-blog-core` | ブログを生成する本体。直接編集せず、[更新手順](#ブログエンジンを更新する)でバージョンを上げる |
| `.build/` | coreが所有し、ビルドごとに再生成する非公開の中間データ |
| `public/` | ビルド結果。公開用に生成されるもの |

## ブログエンジンを更新する

ブログを生成する本体は `vendor/typst-blog-core` として submodule で取り込まれています。記事や `site.typ` は自分のリポジトリに残したまま、生成部分だけを後から更新できます。

更新は release tag に切り替える運用がおすすめです。

```sh
cd vendor/typst-blog-core
git fetch --tags
git tag --sort=-version:refname   # 使えるバージョンの一覧を確認
git checkout vYYYY.MM.DD          # 使いたいバージョンに切り替え
cd ../..
python3 command.py build
npx -y pagefind --site public
git add vendor/typst-blog-core
git commit -m "Update blog core to vYYYY.MM.DD"
```

`git add vendor/typst-blog-core` は core の中身をコピーする操作ではなく、「このブログで使う core のバージョン」を記録する操作です。

更新後は、ローカルで表示を確認してから push してください。

## 困ったとき

| 症状 | 対処 |
| --- | --- |
| `typst-blog-core submodule is missing` と出る / `vendor/typst-blog-core` が空 | `git submodule update --init --recursive` を実行する |
| 配色のCSSファイルが見つからないと出る | `theme.color_scheme` と `theme/static/color-schemes/` のCSSファイル名が一致しているか確認する |
| 公開ビルドに記事が出てこない | 記事の `draft` が `false` になっているか確認する（`preview` なら下書きも表示される） |
| 公開 URL がおかしい | `site.typ` の `base_url` を確認する。末尾の `/` は不要 |
| GitHub Pages で core が見つからない | `.github/workflows/deploy.yml` の checkout 設定に `submodules: recursive` があるか確認する |
| 検索が動かない | `npx -y pagefind --site public` を実行してから確認する |

## Misskey アイコンについて

Misskey共有ボタンとサイドバーのMisskeyアイコンはデフォルトで有効です。templateのthemeにあるアイコンはSimple Icons由来で、Misskey projectによってCC-BY-NC-SA-4.0で提供されています。商用利用などでこの条件が合わない場合は、`site.typ` の `share.misskey` を `false` にしてください。

## ライセンス

このテンプレートのコードは MIT License で提供します。

---

文書バージョン: 2026.09.08.2
（この README を更新するときは、ルートの README.md と `docs/` 配下の他言語ファイルも更新し、文書バージョンをそろえてください）
