# Typst Blog Template

文件版本: 2026.05.28.2

語言: [日本語](../README.md) | [English](README.en.md) | [한국어](README.ko.md) | [简体中文](README.zh-CN.md) | 繁體中文（台灣）

這是一個用 Typst 撰寫文章，並發布為靜態部落格的範本。
寫好文章並建置後，可以一起產生部落格首頁、文章頁、標籤頁、RSS、sitemap 與搜尋索引。

這份 README 是給想把這個範本當作自己部落格來使用的人看的。
如果想了解內部實作，請閱讀 `vendor/typst-blog-core` 中的 README。

更新這份 README 時，也請更新 `docs/` 下的各語言檔案，並保持文件版本一致。

## 可以做什麼

- 用 Typst 語法撰寫部落格文章。
- 為每篇文章設定標題、建立日期、更新日期、說明、標籤與草稿狀態。
- 產生首頁、文章頁、按標籤分類的頁面與標籤列表頁。
- 產生 RSS 與 sitemap。
- 使用 Pagefind 加入站內搜尋。
- 直接發布到 GitHub Pages。
- 加入色彩主題、favicon、圖片、CSS，以及自訂網域用的 `CNAME`。
- 之後只更新部落格引擎部分。

## 需要準備

- Git
- Typst 0.14.2 或更新版本
- Python 3.10 或更新版本
- Node.js 20 或更新版本

Node.js 用於執行產生搜尋索引的 `pagefind`。
即使本機不使用搜尋功能，預設的 GitHub Pages workflow 也會使用 Node.js。

## 最常編輯的檔案

平常經常編輯的是這些檔案。

- `site.typ`: 部落格名稱、說明、公開 URL、作者資訊、主題等網站設定
- `example-post/index.typ`: 文章寫法範例
- `任意文章目錄/index.typ`: 你自己的文章
- `static/`: 圖片、favicon、附加 CSS、自訂主題、`CNAME` 等

也有一些通常不需要手動編輯的檔案。

- `vendor/typst-blog-core`: 產生部落格的核心。通常不要直接編輯，而是按更新步驟升級版本。
- `typst/generated/posts.typ`: 建置時產生的文章列表資料。不要手動編輯。
- `public/`: 建置結果。不要手動編輯。

## 開始使用

先透過 GitHub 的範本功能，從這個儲存庫建立自己的儲存庫。
然後 clone 到本機。

```sh
git clone --recurse-submodules https://github.com/USER/REPO.git
cd REPO
```

如果已經 clone 過，但 `vendor/typst-blog-core` 是空的，請執行：

```sh
git submodule update --init --recursive
```

接著開啟 `site.typ`，改成自己的部落格資訊。
建議先修改這些欄位：

- `title`: 部落格名稱
- `description`: 部落格說明
- `base_url`: 發布後的 URL
- `github_repo`: 這個部落格的 GitHub 儲存庫 URL
- `language`: 主要使用的語言
- `theme`: `dark` 或 `light`
- `author.name`: 作者名稱
- `author.bio`: 個人簡介
- `author.socials`: X、Misskey、GitHub 等連結

如果發布到 GitHub Pages，`base_url` 通常是這樣的形式。

```typst
base_url: "https://USER.github.io/REPO"
```

如果使用自訂網域，請設定為該網域的 URL。

## 撰寫文章

每篇文章建立一個目錄，並在其中放置 `index.typ`。
第一次可以複製 `example-post/` 開始。

```sh
cp -R example-post my-first-post
```

文章檔案開頭寫文章資訊。

```typst
#import "/template.typ": article, calver, post-meta

#let meta = post-meta(
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "簡短說明。",
  tags: ("Typst",),
  draft: false,
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= Hello

在這裡撰寫內文。
```

常用欄位如下。

- `slug`: 會成為文章 URL。上面的例子會發布到 `/my-first-post/`。
- `title`: 文章標題。
- `create`: 建立日期。
- `update`: 更新日期。需要時再加入。
- `description`: 用在文章列表和搜尋結果等位置的簡短說明。
- `tags`: 標籤。標籤頁會自動產生。
- `draft`: `true` 表示草稿，`false` 表示發布。

如果省略 `draft`，文章會被當作草稿。
想發布的文章請設定 `draft: false`。

## 本機預覽

產生部落格：

```sh
python3 build.py
```

如果也想確認搜尋功能，請繼續產生搜尋索引。

```sh
npx -y pagefind --site public
```

建置結果會輸出到 `public/`。
本機查看時，可以啟動一個靜態檔案伺服器。

```sh
python3 -m http.server 8000 -d public
```

然後在瀏覽器開啟 `http://localhost:8000`。

## 發布到 GitHub Pages

這個範本包含 GitHub Pages 用的 workflow。

1. 修改 `site.typ` 中的 `base_url` 與部落格資訊。
2. 在 GitHub 開啟 `Settings` -> `Pages`。
3. 將 `Build and deployment` 的 `Source` 設為 `GitHub Actions`。
4. 把修改 push 到 `main` 分支。

push 後，GitHub Actions 會自動建置，並把 `public/` 的內容部署到 GitHub Pages。

如果使用自訂網域，請在 `static/CNAME` 或儲存庫根目錄的 `CNAME` 中寫入網域。
同時也要讓 `site.typ` 中的 `base_url` 與該網域一致。

## 改變外觀

透過 `site.typ` 的 `theme` 切換主題。

```typst
theme: "light"
```

內建主題有 `dark` 與 `light`。

圖片、favicon、附加 CSS、自訂主題等都放在 `static/` 中。
建置時，`static/` 的內容會被複製到 `public/`。

如果要建立自訂主題，例如新增 `static/themes/my-theme.css`，然後在 `site.typ` 中指定。

```typst
theme: "my-theme"
```

## 更新部落格引擎

這個範本將產生部落格的核心作為 `vendor/typst-blog-core` 引入。
文章和 `site.typ` 會留在自己的儲存庫中，所以之後可以只更新產生邏輯。

更新時，推薦切換到 release tag。

```sh
cd vendor/typst-blog-core
git fetch --tags
git tag --sort=-version:refname
git checkout vYYYY.MM.DD
cd ../..
python3 build.py
npx -y pagefind --site public
git add vendor/typst-blog-core
git commit -m "Update blog core to vYYYY.MM.DD"
```

請把 `vYYYY.MM.DD` 替換為實際要使用的 release tag。

`git add vendor/typst-blog-core` 並不是把整個 core 複製到父儲存庫。
它只是記錄這個部落格使用哪個 core 版本。

更新後，請先在本機確認顯示效果，再 push。

## 常見操作

新增文章：

```sh
cp -R example-post new-post
```

把文章改回草稿：

```typst
draft: true
```

發布文章：

```typst
draft: false
```

重新產生搜尋索引：

```sh
npx -y pagefind --site public
```

重新取得 submodule：

```sh
git submodule update --init --recursive
```

## 疑難排解

- 出現 `typst-blog-core submodule is missing`：執行 `git submodule update --init --recursive`。
- `vendor/typst-blog-core` 是空的：submodule 尚未取得。執行 `git submodule update --init --recursive`。
- 出現 `site.theme '...' does not exist`：檢查 `site.typ` 中的 `theme` 與 `static/themes/` 下的檔名。
- 文章沒有出現：確認文章的 `draft` 是否為 `false`。
- 公開 URL 不正確：檢查 `site.typ` 中的 `base_url`。結尾不需要 `/`。
- GitHub Pages 找不到 core：確認 `.github/workflows/deploy.yml` 的 checkout 設定中有 `submodules: recursive`。
- 搜尋不可用：執行 `npx -y pagefind --site public` 後再確認。

## Misskey 圖示

Misskey 分享按鈕與側邊欄圖示預設啟用。
core 中附帶的 Misskey 圖示來自 Simple Icons，由 Misskey project 以 CC-BY-NC-SA-4.0 提供。
如果該授權不適合你的用途，請在 `site.typ` 中將 `share.misskey` 設為 `false`。

## 授權

MIT License.
