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
- 色テーマの切り替え、favicon・画像・追加 CSS・独自ドメインの設定ができます
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
| `language` | 主に使う言語 |
| `theme` | `"dark"` または `"light"` |
| `posts_dir` | 記事を置く場所。ルート直下なら `"."`、`posts/` にまとめるなら `"posts"` |
| `update_policy` | 更新日の決め方。`"git"`（既定・Git 履歴から自動算出）か `"manual"`（記事の `update` を使う） |
| `author.name` | 著者名 |
| `author.bio` | プロフィール文 |
| `author.socials` | X、Misskey、GitHub などのリンク |

GitHub Pages で公開する場合、`base_url` は次の形になります。

```typst
base_url: "https://USER.github.io/REPO"
```

独自ドメインを使う場合は、そのドメインの URL を指定してください。

### 3. 記事を作る

```sh
python3 command.py new my-first-post \
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
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "記事の短い説明文です。" \
  --tag Typst
```

- 作成日は実行日になり、状態は安全のため下書きになります
- タグを複数付けるときは `--tag` を繰り返します
- 最初から公開状態にするときは `--publish` を付けます
- 作成日を指定するときは `--date 2026-07-19` の形式で指定します
- 同名のディレクトリ・既存記事と同じ slug・予約済み URL がある場合はエラーになります

### 記事ファイルの形式

生成される `index.typ` の先頭は次のようになっています。

```typst
#import "/template.typ": article, calver, post-meta

#let meta = post-meta(
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "記事の短い説明文です。",
  tags: ("Typst",),
  draft: true,
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= はじめに

本文を書きます。
```

| 項目 | 内容 |
| --- | --- |
| `slug` | 記事の URL。空白・大文字・句読点・記号を含む自然な Unicode テキストを使用でき、生成 URL ではパーセントエンコードされます。パス区切り、制御文字、移植性のないファイル名だけは拒否されます。上の例は `/my-first-post/` で公開される |
| `title` | 記事タイトル |
| `create` | 作成日 |
| `update` | 更新日。`update_policy: "manual"` のときだけ使われる |
| `description` | 記事一覧や検索結果で使われる短い説明文 |
| `tags` | タグ。表示名に日本語・空白・記号を使っても、安全で重複しない URL のタグページが自動で作られる |
| `draft` | `true` なら下書き、`false` なら公開対象。省略すると下書き扱い |

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

## 見た目を変える

### テーマを切り替える

`site.typ` の `theme` で切り替えます。最初から使えるのは `dark` と `light` です。

```typst
theme: "light"
```

### 独自テーマを作る

`static/themes/` に CSS を追加し、ファイル名（拡張子なし）を `theme` に指定します。

```typst
// static/themes/my-theme.css を作った場合
theme: "my-theme"
```

### 画像・favicon・追加 CSS

`static/` に置いたファイルは、ビルド時にそのまま `public/` へコピーされます。

## ファイル構成

普段よく編集するファイル:

| パス | 内容 |
| --- | --- |
| `site.typ` | ブログ名、公開 URL、著者情報、テーマなどのサイト設定 |
| `記事ディレクトリ/index.typ` | 自分の記事 |
| `example-post/index.typ` | 記事の書き方のサンプル |
| `static/` | 画像、favicon、追加 CSS、独自テーマ、`CNAME` など |

基本的に触らないファイル:

| パス | 内容 |
| --- | --- |
| `vendor/typst-blog-core` | ブログを生成する本体。直接編集せず、[更新手順](#ブログエンジンを更新する)でバージョンを上げる |
| `typst/generated/posts.typ` | ビルド時に自動更新される記事一覧データ |
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
| `site.theme '...' does not exist` と出る | `site.typ` の `theme` と `static/themes/` のファイル名が一致しているか確認する |
| 公開ビルドに記事が出てこない | 記事の `draft` が `false` になっているか確認する（`preview` なら下書きも表示される） |
| 公開 URL がおかしい | `site.typ` の `base_url` を確認する。末尾の `/` は不要 |
| GitHub Pages で core が見つからない | `.github/workflows/deploy.yml` の checkout 設定に `submodules: recursive` があるか確認する |
| 検索が動かない | `npx -y pagefind --site public` を実行してから確認する |

## Misskey アイコンについて

Misskey 共有ボタンとサイドバーの Misskey アイコンはデフォルトで有効です。core に同梱している Misskey アイコンは Simple Icons 由来で、Misskey project によって CC-BY-NC-SA-4.0 で提供されています。商用利用などでこの条件が合わない場合は、`site.typ` の `share.misskey` を `false` にしてください。

## ライセンス

このテンプレートのコードは MIT License で提供します。

---

文書バージョン: 2026.07.19.7
（この README を更新するときは、ルートの README.md と `docs/` 配下の他言語ファイルも更新し、文書バージョンをそろえてください）
