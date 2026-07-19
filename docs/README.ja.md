# Typst Blog Template

文書バージョン: 2026.07.19.4

言語: [日本語](../README.md) | [English](README.en.md) | [한국어](README.ko.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md)

Typst で記事を書き、静的なブログとして公開するためのテンプレートです。
記事を書いてビルドすると、ブログのトップページ、記事ページ、タグページ、RSS、sitemap、検索用インデックスをまとめて生成できます。

この README は、このテンプレートを「自分のブログとして使う人」向けの説明です。
内部実装を知りたい場合は、`vendor/typst-blog-core` 側の README を読んでください。

この README を更新するときは、`docs/` 配下の各言語ファイルも更新し、文書バージョンをそろえてください。

## できること

- Typst の文法でブログ記事を書けます。
- 記事ごとにタイトル、作成日、更新日、説明文、タグ、下書き状態を設定できます。
- トップページ、記事ページ、タグ別ページ、タグ一覧ページが生成されます。
- RSS と sitemap が生成されます。
- Pagefind を使ったサイト内検索を追加できます。
- GitHub Pages にそのまま公開できます。
- 色テーマ、favicon、画像、CSS、独自ドメイン用の `CNAME` を追加できます。
- ブログエンジン部分だけをあとから更新できます。

## 必要なもの

- Git
- Typst 0.15.0 以上
- Python 3.10 以上
- Node.js 20 以上

Node.js は検索インデックスを作る `pagefind` の実行に使います。
検索機能を使わない場合でも、GitHub Pages の標準ワークフローでは Node.js を使います。

## 最初に触るファイル

普段よく編集するのは次のファイルです。

- `site.typ`: ブログ名、説明文、公開 URL、著者情報、テーマなどのサイト設定
- `example-post/index.typ`: 記事の書き方のサンプル
- `任意の記事ディレクトリ/index.typ`: 自分の記事
- `static/`: 画像、favicon、追加 CSS、独自テーマ、`CNAME` など

基本的に触らなくてよいものもあります。

- `vendor/typst-blog-core`: ブログを生成する本体。通常は直接編集せず、更新手順でバージョンを上げます。
- `typst/generated/posts.typ`: ビルド時に更新される記事一覧データです。手で編集しません。
- `public/`: ビルド結果です。公開用に生成されるため、手で編集しません。

## 使い始める

GitHub のテンプレート機能でこのリポジトリから自分用のリポジトリを作ります。
そのあと、ローカルに clone します。

```sh
git clone --recurse-submodules https://github.com/USER/REPO.git
cd REPO
```

すでに clone 済みで `vendor/typst-blog-core` が空の場合は、次を実行してください。

```sh
git submodule update --init --recursive
```

次に `site.typ` を開き、自分のブログ用に書き換えます。
まず変更するのはこのあたりです。

- `title`: ブログ名
- `description`: ブログの説明文
- `base_url`: 公開後の URL
- `github_repo`: このブログの GitHub リポジトリ URL
- `language`: 主に使う言語
- `theme`: `dark` または `light`
- `posts_dir`: 記事を置くディレクトリ。ルート直下なら `"."`、`posts/` にまとめるなら `"posts"`
- `update_policy`: 更新日の決定方法。既定の `"git"` は記事ディレクトリの Git 履歴から自動算出し、`"manual"` は記事の `update` を使います。
- `author.name`: 著者名
- `author.bio`: プロフィール文
- `author.socials`: X、Misskey、GitHub などのリンク

GitHub Pages で公開する場合、`base_url` は次のような形になります。

```typst
base_url: "https://USER.github.io/REPO"
```

独自ドメインを使う場合は、そのドメインの URL を指定してください。

## 記事を書く

記事は、記事ごとにディレクトリを作り、その中に `index.typ` を置きます。
次のコマンドでディレクトリとメタ情報入りの `index.typ` をまとめて作成できます。

```sh
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "記事の短い説明文です。" \
  --tag Typst
```

作成日は実行日、状態は安全のため下書きになります。タグを複数付ける場合は `--tag` を繰り返し、最初から公開状態にする場合だけ `--publish` を付けます。作成日を指定する場合は `--date 2026-07-19` の形式で指定できます。同名のディレクトリ、既存記事と同じ slug、予約済み URL がある場合は上書きせずエラーになります。

記事を `posts/` 配下にまとめる場合は、`site.typ` で `posts_dir: "posts"` を指定してください。`new` の作成先とビルド時の記事探索範囲がどちらも `posts/` になります。未指定または `"."` なら従来どおりルート直下を使います。

生成される記事ファイルの先頭は次のような形式です。

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

よく使う項目は次のとおりです。

- `slug`: 記事の URL になります。小文字の英数字を単一の `-` でつないだ形式にします。上の例は `/my-first-post/` で公開されます。
- `title`: 記事タイトルです。
- `create`: 作成日です。
- `update`: `update_policy: "manual"` のときに使う更新日です。
- `description`: 記事一覧や検索結果などで使われる短い説明文です。
- `tags`: タグです。表示名に日本語・空白・記号を使っても、安全で重複しない URL のタグページが自動で作られます。
- `draft`: `true` なら下書き、`false` なら公開対象です。

`draft` を省略すると下書き扱いになります。
公開したい記事には `draft: false` を入れてください。

更新日は既定で自動管理されます。記事の `index.typ` や同じ記事ディレクトリ内の画像・参考文献などをコミットすると、その最新コミット日が更新日になります。記事を最初に追加したコミットしかない場合は更新日を表示しません。Git 履歴を取得できない環境では警告を表示し、記事に書かれた `update` があればその値を使います。

## ローカルで確認する

次のコマンドを実行します。

```sh
python3 command.py preview
```

初回ビルド後に `http://localhost:8000` でプレビューサーバーが起動します。Typst ファイル、CSS、JavaScript、画像などを保存すると自動的に再ビルドされ、開いているブラウザも再読み込みされます。8000 番が使用中の場合は別の空きポートが選ばれるため、ターミナルに表示された URL を開いてください。終了するときは `Ctrl+C` を押します。

`site.typ` の `base_url` は公開 URL のままで構いません。`preview` は CSS、記事リンクなどの基準パスだけをローカルサーバー向けの `/` に切り替えます。canonical URL、RSS、sitemap には引き続き `base_url` が使われます。

検索機能も確認したい場合は、別のターミナルで検索インデックスを作ります。記事を変更して自動再ビルドされた後は、もう一度実行してください。

```sh
npx -y pagefind --site public
```

公開用の生成結果を確認したい場合やデプロイ時は、`python3 command.py build` を実行します。

## GitHub Pages で公開する

このテンプレートには GitHub Pages 用のワークフローが入っています。

1. `site.typ` の `base_url` とブログ情報を自分用に変更します。
2. GitHub の `Settings` -> `Pages` を開きます。
3. `Build and deployment` の `Source` を `GitHub Actions` にします。
4. 変更を `main` ブランチに push します。

push すると GitHub Actions が自動でビルドし、`public/` の内容を GitHub Pages にデプロイします。

独自ドメインを使う場合は、`static/CNAME` またはリポジトリ直下の `CNAME` にドメイン名を書きます。
その場合は `site.typ` の `base_url` も独自ドメインに合わせてください。

## 見た目を変える

テーマは `site.typ` の `theme` で切り替えます。

```typst
theme: "light"
```

最初から使えるテーマは `dark` と `light` です。

画像、favicon、追加 CSS、独自テーマなどは `static/` に置きます。
ビルド時に `static/` の中身が `public/` へコピーされます。

独自テーマを作る場合は、例えば `static/themes/my-theme.css` を追加し、`site.typ` で指定します。

```typst
theme: "my-theme"
```

## ブログエンジンを更新する

このテンプレートでは、ブログを生成する本体を `vendor/typst-blog-core` として取り込んでいます。
記事や `site.typ` は自分のリポジトリに残したまま、生成部分だけをあとから更新できます。

更新するときは、release tag に切り替える運用をおすすめします。

```sh
cd vendor/typst-blog-core
git fetch --tags
git tag --sort=-version:refname
git checkout vYYYY.MM.DD
cd ../..
python3 command.py build
npx -y pagefind --site public
git add vendor/typst-blog-core
git commit -m "Update blog core to vYYYY.MM.DD"
```

`vYYYY.MM.DD` は実際に使いたい release tag に置き換えてください。

`git add vendor/typst-blog-core` は、core の中身を丸ごとコピーする操作ではありません。
「このブログでは、どの core のバージョンを使うか」を更新する操作です。

更新後は、ローカルで表示を確認してから push してください。

## よくある作業

新しい記事を追加する:

```sh
python3 command.py new new-post \
  --title "New Post" \
  --description "記事の短い説明文です。"
```

記事を下書きに戻す:

```typst
draft: true
```

記事を公開する:

```typst
draft: false
```

検索インデックスを作り直す:

```sh
npx -y pagefind --site public
```

submodule を取り直す:

```sh
git submodule update --init --recursive
```

## 困ったとき

- `typst-blog-core submodule is missing` と出る場合は、`git submodule update --init --recursive` を実行してください。
- `vendor/typst-blog-core` が空の場合は、submodule が未取得です。`git submodule update --init --recursive` を実行してください。
- `site.theme '...' does not exist` と出る場合は、`site.typ` の `theme` と `static/themes/` のファイル名を確認してください。
- 記事が出てこない場合は、記事の `draft` が `false` になっているか確認してください。
- 公開 URL がおかしい場合は、`site.typ` の `base_url` を確認してください。末尾の `/` は不要です。
- GitHub Pages で core が見つからない場合は、`.github/workflows/deploy.yml` の checkout 設定に `submodules: recursive` があるか確認してください。
- 検索が動かない場合は、`npx -y pagefind --site public` を実行したあとに確認してください。

## Misskey アイコンについて

Misskey 共有ボタンとサイドバーの Misskey アイコンはデフォルトで有効です。
core に同梱している Misskey アイコンは Simple Icons 由来で、Misskey project によって CC-BY-NC-SA-4.0 で提供されています。
商用利用などでこの条件が合わない場合は、`site.typ` の `share.misskey` を `false` にしてください。

## ライセンス

このテンプレートのコードは MIT License で提供します。
