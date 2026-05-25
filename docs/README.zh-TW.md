# Typst Blog Template

文件版本：2026.05.25

語言：[日本語](../README.md) | [English](README.en.md) | [한국어](README.ko.md) | [简体中文](README.zh-CN.md) | 繁體中文（台灣）

這是一個小型靜態網站範本，可透過 Typst 的 HTML 輸出撰寫部落格。
文章內容、文章中繼資料與網站設定都由 Typst 管理，`build.py` 會產生 HTML、RSS 與 sitemap。

更新此 README 時，請一併更新 `docs/` 中的在地化文件，並保持文件版本一致。

## 需求

- Typst 0.14.2 或更新版本
- Python 3.10 或更新版本

## 快速開始

```sh
python3 build.py
```

產生的檔案會輸出到 `public/`。
若要在本機預覽，請用任一靜態檔案伺服器提供 `public/` 目錄。

```sh
python3 -m http.server 8000 -d public
```

## 網站設定

`site.typ` 是全站設定的唯一來源。
請先編輯以下值：

- `title`: 部落格名稱
- `description`: 部落格描述
- `base_url`: 公開 URL
- `author`: 作者名稱、簡介與社群連結
- `analytics.cloudflare_token`: 只有使用 Cloudflare Web Analytics 時才需要設定
- `feedback.google_form_url` 與 `feedback.entry_id`: 只有使用 Google Forms 時才需要設定
- `share`: X、Misskey 與複製分享按鈕的顯示設定

## 撰寫文章

為每篇文章建立一個目錄，並在其中放置 `index.typ`。
最簡單的開始方式是複製 `example-post/index.typ`。

```typst
#import "../template.typ": article, calver

#let meta = (
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "文章的簡短描述。",
  tags: ("Typst",),
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= Introduction

Write your post here.
```

`slug` 會成為公開 URL。上面的範例會輸出到 `/my-first-post/`。
`create` 使用 CalVer 格式。可以像 `calver(26, 1, 1)` 這樣使用兩位數年份。年月日不能省略，只有修補號可以省略，省略時會以 `0` 處理。
在中繼資料中加入 `draft: true`，即可讓文章不出現在文章列表、RSS、sitemap 與 HTML 輸出中。

## 使用 GitHub Pages 發布

此範本包含 GitHub Pages 用的工作流程。

1. 從此範本建立儲存庫。
2. 依照你的網站需求編輯 `site.typ`。
3. 在 GitHub 中開啟 `Settings` -> `Pages` -> `Build and deployment`，然後將 `Source` 設為 `GitHub Actions`。
4. 推送到 `main` 分支。

工作流程會執行 `python3 build.py`，並將 `public/` 部署到 GitHub Pages。

## Misskey 圖示說明

Misskey 分享按鈕與側邊欄中的 Misskey 圖示預設為啟用。
隨附的 Misskey 圖示來自 Simple Icons，並由 Misskey project 以 CC-BY-NC-SA-4.0 授權提供。
如果這些條款不符合你的使用情境，例如商業使用，請刪除或替換 `typst/components/widgets.typ` 中的 Misskey 圖示，並在 `site.typ` 中將 `share.misskey` 設為 `false`。

## 授權

此範本中的程式碼以 MIT License 提供。
