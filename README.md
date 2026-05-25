# Typst Blog Template

文書バージョン: 2026.05.25.2

言語: 日本語 | [English](docs/README.en.md) | [한국어](docs/README.ko.md) | [简体中文](docs/README.zh-CN.md) | [繁體中文（台灣）](docs/README.zh-TW.md)

Typst の HTML 出力を使ってブログを書くための小さな静的サイトテンプレートです。
記事本文、記事メタデータ、サイト設定を Typst で管理し、`build.py` が HTML、RSS、sitemap を生成します。
サイト内検索は Pagefind で静的インデックスを生成します。

この README を更新するときは、`docs/` 配下の各言語ファイルも更新し、文書バージョンをそろえてください。

## 要件

- Typst 0.14.2 以上
- Python 3.10 以上
- Node.js 20 以上（Pagefind の検索インデックス生成に使用）

## クイックスタート

```sh
python3 build.py
npx -y pagefind --site public
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

## フォント設定

`site.typ` の `fonts` ブロックで本文・見出し・コード・数式・任意の追加フォントをまとめて管理します。
`web` フィールドを持つ全エントリが Google Fonts から自動で読み込まれ、`--font-{キー名}` という CSS 変数として使えます。

| キー | 説明 |
|------|------|
| `main` | 本文フォント（必須） |
| `heading` | 見出しフォント（省略すると `main` を継承） |
| `code` | コードブロックフォント（必須） |
| `math` | 数式フォント。PDF のみ有効。web では数式が SVG にベイクされるため `web: none` にする |
| 任意の名前 | `accent` など好きなキーで追加可能。CSS 変数 `--font-{キー名}` が自動生成される |

各エントリのフィールド:

- `pdf`: PDF 出力で使うフォント名（文字列またはフォールバックチェーンの配列）
- `web`: Google Fonts のフォント名（`none` にすると web では読み込まれない）
- `weights`: Google Fonts に要求するウェイト（例: `"400;700"`, `"300..700"`）
- `fallback`: CSS の汎用フォントファミリー（例: `"serif"`, `"sans-serif"`, `"monospace"`）

記事内で特定の単語だけフォントを変えるには `text` 関数を使います:

```typst
#text(font: "Zen Antique")[特別な単語]
```

そのフォントを `site.fonts` に登録しておけば web でも確実に読み込まれます。

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

ワークフローは `python3 build.py` と `npx -y pagefind --site public` を実行し、`public/` を GitHub Pages へデプロイします。

## Misskey アイコンについて

Misskey 共有ボタンとサイドバーの Misskey アイコンはデフォルトで有効です。
同梱している Misskey アイコンは Simple Icons 由来で、Misskey project によって CC-BY-NC-SA-4.0 で提供されています。
商用利用などでこの条件が合わない場合は、`typst/components/widgets.typ` の Misskey アイコンを削除または差し替え、`site.typ` の `share.misskey` を `false` にしてください。

## ライセンス

このテンプレートのコードは MIT License で提供します。
