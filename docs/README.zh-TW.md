# Typst Blog Template

這是一個使用 Typst 輕鬆建立並發佈靜態部落格的範本。無需製作複雜的網站或建構 SSG 工具，即可專注於文章寫作。

只需撰寫文章並執行建置，即可自動產生首頁、文章內頁、標籤一覽、RSS、Sitemap 與站內搜尋索引（Pagefind）。

- 示範網站（範例文章）：<https://minimarimo3.github.io/typst-blog-template/example-post/>
- 使用範例（作者部落格）：<https://www.minimarimo3.jp>

[日本語](README.ja.md) | [English](../README.md) | [한국어](README.ko.md) | [简体中文](README.zh-CN.md) | 繁體中文（台灣）

## 主要特色

- 完全使用 Typst 的寫作體驗
不僅文章內容，整個網站的設定也都可以使用 Typst 語法撰寫。
- 無需繁瑣設定即可自動產生
自動產生首頁、含 OGP 與 Meta 標籤的文章頁、標籤一覽、RSS 與 Sitemap。也支援使用 Pagefind 進行站內搜尋，以及透過隨附的 GitHub Actions 自動部署至 GitHub Pages。
- 基於 Git 的自動更新日期及 GitHub 風格 Alerts
依照 Git commit 紀錄自動反映更新日期。預設提供 `warning`、`note` 等 GitHub 風格 Alerts 語法。
- 易於維護的核心分離結構
部落格引擎本體（`vendor/typst-blog-core`）以 Git submodule 獨立管理。即使 Typst 未來對 HTML 輸出規格進行破壞性變更，也只需更新核心即可因應，不會破壞文章資料。
- 靈活的自訂能力
可以依需求調整，從設定檔（`site.typ`）的簡易設定、CSS 或配色變更，到 HTML 結構（`theme/`）修改及新增自訂元件。

---

## 快速開始

### 1. 建立並取得儲存庫

使用 GitHub 的「Use this template」按鈕建立自己的儲存庫，再 clone 至本機。

```sh
git clone --recurse-submodules https://github.com/YOUR_USER/YOUR_REPO.git
cd YOUR_REPO
```

> Note
> 如果已經 clone，但 `vendor/typst-blog-core` 目錄是空的，請執行：
> `git submodule update --init --recursive`

### 2. 編輯網站設定

開啟 `site.typ` 並設定部落格資訊。

```typst
#let site-config = (
  title: "我的部落格",
  description: "部落格說明",
  base_url: "https://YOUR_USER.github.io/YOUR_REPO", // 使用自訂網域時填寫對應 URL
  github_repo: "[https://github.com/YOUR_USER/YOUR_REPO](https://github.com/YOUR_USER/YOUR_REPO)",
  posts_dir: "posts", // 文章儲存位置（"posts" 等目錄名稱或 "."）
  language: (
    lang: "zh",
    region: "TW",
    script: "hani",
  ),
  // 也可以簡寫為 language: "zh"

  author: (
    name: "管理員名稱",
    bio: "個人簡介",
    links: (
      (id: "github", label: "GitHub", url: "https://github.com/YOUR_USER"),
    ),
  ),
  ... // 還有其他設定，但這些是基本項目
)
```

### 3. 建立新文章

使用 CLI 指令產生文章範本。

```sh
python3 command.py new post my-first-post --title "第一篇文章" --tag "Typst"
```

執行後會產生 `{posts_dir}/my-first-post/index.typ`。

### 4. 本機預覽

```sh
python3 command.py preview
```

預覽伺服器會在 `http://localhost:8000` 啟動。
儲存檔案後會自動重新建置並重新載入瀏覽器。

### 5. 發佈至 GitHub Pages

1. 開啟 GitHub 儲存庫的 Settings → Pages
2. 將 Build and deployment 下的 Source 改為 GitHub Actions
3. `push` 至 `main` 分支後會自動建置並部署

---

## 文章寫法

文章以「一篇文章 = 一個目錄」的方式管理。請將圖片與相關檔案放在和 `index.typ` 相同的目錄中。

### 文章檔案的基本結構（`index.typ`）

```typst
#import "/template.typ": post, calver

#show: post.with(
  title: "第一篇文章",
  create: calver(2026, 1, 1, 3),
  description: "文章摘要。",
  tags: ("Typst", "日記"),
  draft: true, // 發佈時改為 false
)

= 前言

在此撰寫內容。

```

### 文章中繼資料一覽

| 項目 | 型別 | 說明 |
| --- | --- | --- |
| `title` | String | 必填。文章標題 |
| `create` | `calver()` | 必填。建立日期（例：`calver(2026, 1, 1)`） |
| `description` | String | 用於文章列表、SEO 與 OGP 的說明文字 |
| `tags` | Array | 標籤（包含中文或空格時也會自動轉換為安全的 URL） |
| `draft` | Boolean | `true` 表示草稿，`false` 表示公開（省略時為 `true`） |
| `permalink` | String | 自訂 URL（例：`"/notes/hello/"`） |
| `aliases` | Array | 用於重新導向的舊 URL 清單（例：`("/old-path/",)`） |
| `update` | `calver()` | 手動更新日期（僅在設定 `update_policy: "manual"` 時使用） |
| `extra` | Dictionary | 傳遞給主題與自訂擴充功能的任意自訂資料 |

---

## 建立一般頁面（About / FAQ 等）

可以建立不包含在部落格文章列表或 RSS 中的固定頁面，例如 About 頁面或隱私權政策。

```sh
python3 command.py new page about --title "關於本站" --publish
```

將產生 `pages/about/index.typ`。

```typst
#import "/template.typ": site-page

#show: site-page.with(
  title: "關於本站",
  description: "個人資料與網站介紹",
  draft: false,
  index: true, // 是否讓搜尋引擎與站內搜尋建立索引
)

= About 頁面
```

---

## 營運與規格詳情

### 草稿與發佈行為

- `preview` 指令：也會顯示草稿（`draft: true`）。草稿會加上「草稿」標記，並從搜尋索引中排除。
- `build` 指令：正式建置不會產生草稿文章的 HTML，並會將其從列表、RSS 與 Sitemap 中排除。

### 自動反映更新日期（`update`）

預設設定（`update_policy: "git"`）會自動採用文章目錄中檔案的最新 commit 日期作為更新日期。只有初次 commit 時不會顯示更新日期。

### 變更主題與配色

可在 `site.typ` 中切換配色。

```typst
theme: theme-config(color_scheme: "light") // "dark" 或 "light"
```

如需加入自己的 CSS，請建立 `theme/static/color-schemes/my-theme.css`，並指定 `color_scheme: "my-theme"`。

---

## 目錄結構

```text
.
├── site.typ                # 標題、URL、作者等網站整體設定
├── posts/                  # 在 posts_dir 中指定時的文章目錄
├── pages/                  # About 等一般頁面
├── theme/                  # HTML 結構與設計主題
│   ├── pages/              # article、home、tag 等各頁面 renderer
│   ├── components/         # head、header、widget 等共用元件
│   └── static/             # 主題使用的 CSS / JS
├── extensions/             # 自訂元件與擴充功能
├── static/                 # 圖片、favicon、CNAME 等靜態檔案
├── command.py              # 建立文章與預覽使用的 CLI 工具
├── blog.py                 # 擴充建置處理的腳本
└── vendor/typst-blog-core/ # 【submodule】部落格引擎本體（不建議直接編輯）
```

---

## 環境需求

| 工具 | 需求版本 | 備註 |
| --- | --- | --- |
| Git | - | 用於管理 submodule |
| Typst | `0.15.0` 以上 | 隨時跟進最新版本 |
| Python | `3.10` 以上 | 用於建置、產生 RSS/Sitemap 與 CLI 指令 |
| Node.js | `20` 以上 | 選用（建立 Pagefind 搜尋索引時使用） |

---

## 疑難排解

| 現象 | 原因與解決方法 |
| --- | --- |
| 顯示 `typst-blog-core submodule is missing` | 執行 `git submodule update --init --recursive` 取得核心引擎。 |
| 正式建置後沒有顯示文章 | 請確認文章中繼資料中設定了 `draft: false`。 |
| 發佈後連結或 CSS 異常 | 請確認 `site.typ` 中的 `base_url` 設定正確（結尾不需要 `/`）。 |
| 站內搜尋（Pagefind）無法運作 | 請確認 Node.js 與 `npx` 可以使用，然後重新啟動 `preview` 或再次執行 `build`。 |

---

## 第三方授權條款聲明

- 本範本的程式碼依 MIT License 提供。
- 內建的 Misskey 品牌圖示依 CC BY-SA 4.0 使用。包含商業用途在內所需的標示資訊會在建置時自動輸出至 `/third-party-licenses.txt`。詳情請參閱 `THIRD_PARTY_NOTICES.md`。

---

文件版本: 2026.09.13.1
