# Typst Blog Template

文書バージョン: 2026.05.25

言語: 日本語 | [English](docs/README.en.md) | [한국어](docs/README.ko.md) | [简体中文](docs/README.zh-CN.md) | [繁體中文（台灣）](docs/README.zh-TW.md)

Typst の HTML 出力を使ってブログを書くための小さな静的サイトテンプレートです。
記事本文、記事メタデータ、サイト設定を Typst で管理し、`build.py` が HTML、RSS、sitemap を生成します。

この README を更新するときは、`docs/` 配下の各言語ファイルも更新し、文書バージョンをそろえてください。

## 要件

- Typst 0.14.2 以上
- Python 3.10 以上

## クイックスタート

```sh
python3 build.py
```

生成物は `public/` に出力されます。
ローカルで確認する場合は、任意の静的ファイルサーバーで `public/` を配信してください。

```sh
python3 -m http.server 8000 -d public
```

## サイト設定

サイト全体の設定は `site.typ` が正本です。
最初に以下を書き換えてください。

- `title`: ブログ名
- `description`: ブログ説明文
- `base_url`: 公開 URL
- `author`: 著者名、プロフィール、SNS リンク
- `analytics.cloudflare_token`: Cloudflare Web Analytics を使う場合だけ設定
- `feedback.google_form_url` と `feedback.entry_id`: Google フォームを使う場合だけ設定
- `share`: X、Misskey、コピー共有ボタンの表示設定

## 記事を書く

記事ごとにディレクトリを作り、その中に `index.typ` を置きます。
`example-post/index.typ` をコピーして始めるのが簡単です。

```typst
#import "../template.typ": article, calver

#let meta = (
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "記事の短い説明文です。",
  tags: ("Typst",),
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= はじめに

本文を書きます。
```

`slug` が公開 URL になります。上の例は `/my-first-post/` に出力されます。
`create` は CalVer 形式です。`calver(26, 1, 1)` のように年を下二桁にできます。年月日の省略はできず、パッチ番号だけ省略でき、その場合は `0` として扱われます。
`draft: true` をメタデータに追加すると、記事一覧、RSS、sitemap、HTML 出力から除外されます。

## GitHub Pages で公開する

このテンプレートには GitHub Pages 向けのワークフローが入っています。

1. このテンプレートからリポジトリを作る。
2. `site.typ` を自分のサイト用に編集する。
3. GitHub の `Settings` -> `Pages` -> `Build and deployment` で `Source` を `GitHub Actions` にする。
4. `main` ブランチに push する。

ワークフローは `python3 build.py` を実行し、`public/` を GitHub Pages へデプロイします。

## Misskey アイコンについて

Misskey 共有ボタンとサイドバーの Misskey アイコンはデフォルトで有効です。
同梱している Misskey アイコンは Simple Icons 由来で、Misskey project によって CC-BY-NC-SA-4.0 で提供されています。
商用利用などでこの条件が合わない場合は、`typst/components/widgets.typ` の Misskey アイコンを削除または差し替え、`site.typ` の `share.misskey` を `false` にしてください。

## ライセンス

このテンプレートのコードは MIT License で提供します。
