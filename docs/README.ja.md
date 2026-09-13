# Typst Blog Template

Typstで手軽に静的ブログを作成・公開するためのテンプレートです。複雑なサイト制作やSSGツールの構築を行わず、記事の執筆に集中できます。

記事を書いてビルドするだけで、トップページ・記事本文・タグ一覧・RSS・Sitemap・サイト内検索インデックス（Pagefind）を自動生成します。

- デモサイト（サンプル記事）: <https://minimarimo3.github.io/typst-blog-template/example-post/>
- 使用例（作者ブログ）: <https://www.minimarimo3.jp>

[English](../README.md) | [한국語](README.ko.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md)

## 主な特徴

- Typstで完結する執筆体験
記事本文はもちろん、サイト全体の設定もすべてTypst記法で記述可能です。
- 面倒な設定なしで自動生成
トップページ、OGP・Metaタグ付き記事ページ、タグ一覧、RSS、Sitemapを自動生成。Pagefindによるサイト内検索やGitHub Pagesへの自動デプロイ（GitHub Actions同梱）にも対応しています。
- Git連動の自動更新日設定 & GitHub風Alerts対応
Gitのコミット履歴から更新日を自動反映。`warning` や `note` などのGitHub風Alerts記法を標準搭載しています。
- 保守が容易なコア分離構造
ブログエンジン本体（`vendor/typst-blog-core`）がGit submoduleとして分離されています。将来TypstのHTML出力仕様に破壊的変更があっても、コア部を更新するだけで記事データを壊さず追従可能です。
- 柔軟なカスタマイズ性
設定ファイル（`site.typ`）での簡易設定から、CSS/配色変更、HTML構造（`theme/`）の変更、独自コンポーネント追加まで用途に応じた調整が可能です。

---

## クイックスタート

### 1. リポジトリの作成と取得

GitHubの 「Use this template」 ボタンから自分用のリポジトリを作成し、ローカルにクローンします。

```sh
git clone --recurse-submodules https://github.com/YOUR_USER/YOUR_REPO.git
cd YOUR_REPO
```

> Note
> 既にクローン済みで `vendor/typst-blog-core` ディレクトリが空の場合は、以下を実行してください。
> `git submodule update --init --recursive`

### 2. サイト設定の編集

`site.typ` を開き、ブログ情報を設定します。

```typst
#let site-config = (
  title: "マイブログ",
  description: "ブログの説明文",
  base_url: "https://YOUR_USER.github.io/YOUR_REPO", // 独自ドメインの場合はそのURL
  github_repo: "[https://github.com/YOUR_USER/YOUR_REPO](https://github.com/YOUR_USER/YOUR_REPO)",
  posts_dir: "posts", // 記事の保存先（"posts"等のディレクトリ名または"."）
  language: (
    lang: "zh",
    region: "TW",
    script: "hani",
  ),
  // もしくは短縮で language: "ja"

  author: (
    name: "管理者名",
    bio: "プロフィール文",
    links: (
      (id: "github", label: "GitHub", url: "https://github.com/YOUR_USER"),
    ),
  ),
  ... // 他にも色々ありますが必須はこの辺
)
```

### 3. 新規記事の作成

CLIコマンドで記事の雛形を生成します。

```sh
python3 command.py new post my-first-post --title "最初の記事" --tag "Typst"
```

実行すると `{posts_dir}/my-first-post/index.typ` が生成されます。

### 4. ローカルでのプレビュー

```sh
python3 command.py preview
```

`http://localhost:8000` でプレビューサーバーが起動します。
ファイルを保存すると自動で再ビルドされ、ブラウザがリロードされます。

### 5. GitHub Pagesでの公開

1. GitHubリポジトリの Settings → Pages を開く
2. Build and deployment の Source を GitHub Actions に変更する
3. `main` ブランチへ `push` すると自動でビルド＆デプロイされます

---

## 記事の書き方

記事は「1記事 = 1ディレクトリ」で管理します。画像や関連ファイルは `index.typ` と同じディレクトリに配置してください。

### 記事ファイルの基本構造（`index.typ`）

```typst
#import "/template.typ": post, calver

#show: post.with(
  title: "最初の記事",
  create: calver(2026, 1, 1, 3),
  description: "記事の概要文です。",
  tags: ("Typst", "日記"),
  draft: true, // 公開する場合は false に変更
)

= はじめに

ここに本文を記述します。

```

### 記事のメタデータ一覧

| 項目 | 型 | 説明 |
| --- | --- | --- |
| `title` | String | 必須。記事のタイトル |
| `create` | `calver()` | 必須。作成日（例: `calver(2026, 1, 1)`） |
| `description` | String | 記事一覧やSEO・OGPで使われる説明文 |
| `tags` | Array | タグ指定（日本語やスペース含みも安全なURLに自動変換） |
| `draft` | Boolean | `true` で下書き、`false` で公開（省略時は `true`） |
| `permalink` | String | カスタムURL（例: `"/notes/hello/"`） |
| `aliases` | Array | 転送リダイレクト用旧URLリスト（例: `("/old-path/",)`） |
| `update` | `calver()` | 手動更新日（`update_policy: "manual"` 設定時のみ使用） |
| `extra` | Dictionary | テーマや独自拡張へ渡す任意のカスタムデータ |

---

## 汎用ページの作成（About / FAQなど）

ブログ記事一覧やRSSに含まれない固定ページ（Aboutページやプライバシーポリシーなど）を作成できます。

```sh
python3 command.py new page about --title "このサイトについて" --publish
```

`pages/about/index.typ` が生成されます。

```typst
#import "/template.typ": site-page

#show: site-page.with(
  title: "このサイトについて",
  description: "プロフィールとサイトの紹介",
  draft: false,
  index: true, // 検索エンジン・サイト内検索にインデックスさせるか
)

= アバウトページ
```

---

## 運用・仕様の詳細

### 下書きと公開の挙動

- `preview` コマンド: 下書き（`draft: true`）も表示されます（「下書き」バッジが付与され、検索インデックスからは除外）。
- `build` コマンド: 公開ビルドでは下書き記事のHTMLは生成されず、一覧・RSS・Sitemapからも除外されます。

### 更新日（`update`）の自動反映

デフォルト（`update_policy: "git"`）では、記事ディレクトリ内のファイルがコミットされた最新日時を自動で更新日として採用します。初回コミットのみの場合は更新日を表示しません。

### テーマとカラーシェームの変更

`site.typ` で配色を切り替えられます。

```typst
theme: theme-config(color_scheme: "light") // "dark" または "light"
```

自作のCSSを追加する場合は `theme/static/color-schemes/my-theme.css` を作成し、`color_scheme: "my-theme"` と指定します。

---

## ディレクトリ構造

```text
.
├── site.typ                # サイト全体の設定（タイトル、URL、著者など）
├── posts/                  # 記事ディレクトリ（posts_dir に指定した場合）
├── pages/                  # 汎用ページ（Aboutなど）
├── theme/                  # HTML構造・デザインテーマ
│   ├── pages/              # 各ページのレンダラー（article, home, tagなど）
│   ├── components/         # 共通パーツ（head, header, widgetなど）
│   └── static/             # テーマ用 CSS / JS
├── extensions/             # 独自コンポーネント・拡張機能
├── static/                 # 静的ファイル（画像、favicon、CNAMEなど）
├── command.py              # 記事作成・プレビュー用CLIツール
├── blog.py                 # ビルド処理の拡張スクリプト
└── vendor/typst-blog-core/ # 【submodule】ブログエンジン本体（直接編集非推奨）
```

---

## 動作環境

| ツール | 要求バージョン | 備考 |
| --- | --- | --- |
| Git | - | サブモジュール管理に使用 |
| Typst | `0.15.0` 以上 | 最新バージョンに随時追従 |
| Python | `3.10` 以上 | ビルド、RSS/Sitemap生成、CLIコマンドに使用 |
| Node.js | `20` 以上 | 任意（Pagefind検索インデックス作成時に使用） |

---

## トラブルシューティング

| 症状 | 原因と対処法 |
| --- | --- |
| `typst-blog-core submodule is missing` と表示される | `git submodule update --init --recursive` を実行してコアエンジンを取得してください。 |
| 本番ビルド後に記事が表示されない | 記事のメタデータで `draft: false` になっているか確認してください。 |
| 公開後のリンクやCSSが崩れる | `site.typ` の `base_url` 設定が正しいか確認してください（末尾の `/` は不要です）。 |
| サイト内検索（Pagefind）が動かない | Node.js / `npx` が利用可能か確認し、`preview` を再起動するか `build` を再実行してください。 |

---

## サードパーティ・ライセンス表示

- 本テンプレートのコードは MIT License のもとで提供されています。
- 組み込まれている Misskey ブランドアイコンは CC BY-SA 4.0 に基づき使用されています。商用利用を含めた帰属表示は、ビルド時に `/third-party-licenses.txt` へ自動出力されます。詳細は `THIRD_PARTY_NOTICES.md` をご確認ください。

---

Document version: 2026.09.13.1
