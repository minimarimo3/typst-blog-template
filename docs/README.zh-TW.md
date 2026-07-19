# Typst Blog Template

這是一個用 Typst 撰寫文章並發佈為靜態部落格的範本。
寫好文章並建置後，首頁、文章頁、標籤頁、RSS、sitemap 與站內搜尋索引都會一併產生。

展示各種語法的範例頁面：<https://minimarimo3.github.io/typst-blog-template/example-post/>
範本作者使用本範本架設的部落格：<https://www.minimarimo3.jp>

語言: [日本語](README.ja.md) | [English](../README.md) | [한국어](README.ko.md) | [简体中文](README.zh-CN.md) | 繁體中文（台灣）

## 特色

- 文章和網站設定全部用 Typst 撰寫
- 每篇文章可設定標題、建立日期、更新日期、描述、標籤與草稿狀態
- 自動產生首頁、文章頁、各標籤頁面與標籤一覽頁
- 自動產生 RSS 與 sitemap
- 支援基於 [Pagefind](https://pagefind.app/) 的站內搜尋
- 可直接發佈到 GitHub Pages（附帶工作流程）
- 支援切換色彩主題，設定 favicon、圖片、額外 CSS 與自訂網域
- 之後可以只更新部落格引擎部分（`vendor/typst-blog-core`）

## 環境需求

| 工具 | 版本 |
| --- | --- |
| Git | - |
| Typst | 0.15.0 以上 |
| Python | 3.10 以上 |
| Node.js | 20 以上 |

Node.js 用於執行產生搜尋索引的 Pagefind。即使不使用搜尋功能，GitHub Pages 的預設工作流程也會用到 Node.js。

## 快速開始

### 1. 建立儲存庫並 clone

用 GitHub 的「Use this template」按鈕建立自己的儲存庫，然後 clone 到本機。

```sh
git clone --recurse-submodules https://github.com/USER/REPO.git
cd REPO
```

> [!NOTE]
> 如果已經 clone 且 `vendor/typst-blog-core` 是空的，請執行 `git submodule update --init --recursive`。

### 2. 修改網站設定

打開 `site.typ`，依自己的部落格進行修改。先檢查這些項目：

| 設定項 | 說明 |
| --- | --- |
| `title` | 部落格名稱 |
| `description` | 部落格描述 |
| `base_url` | 發佈後的 URL（結尾不要加 `/`） |
| `github_repo` | 本部落格的 GitHub 儲存庫 URL |
| `language` | 主要使用的語言 |
| `theme` | `"dark"` 或 `"light"` |
| `posts_dir` | 文章存放位置。放在根目錄下用 `"."`，集中到 `posts/` 用 `"posts"` |
| `update_policy` | 更新日期的決定方式。`"git"`（預設，從 Git 歷史自動計算）或 `"manual"`（使用文章的 `update`） |
| `author.name` | 作者名稱 |
| `author.bio` | 個人簡介 |
| `author.socials` | X、Misskey、GitHub 等連結 |

在 GitHub Pages 上發佈時，`base_url` 形如：

```typst
base_url: "https://USER.github.io/REPO"
```

使用自訂網域時，請填寫該網域的 URL。

### 3. 建立文章

```sh
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "文章的簡短描述。" \
  --tag Typst
```

會一次建立文章目錄和已填好中繼資料的 `index.typ`。

### 4. 本機預覽

```sh
python3 command.py preview
```

首次建置後，預覽伺服器會在 `http://localhost:8000` 啟動。儲存檔案會自動重新建置並重新整理瀏覽器。

### 5. 發佈

push 到 `main` 分支後，GitHub Actions 會自動建置並發佈到 GitHub Pages。詳見[使用 GitHub Pages 發佈](#使用-github-pages-發佈)。

## 撰寫文章

文章採用「一篇文章 = 一個目錄」的結構，每個目錄中的 `index.typ` 就是內文。圖片和參考文獻也放在同一個目錄中。

### 新增文章

```sh
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "文章的簡短描述。" \
  --tag Typst
```

- 建立日期為執行當天，為了安全起見初始狀態為草稿
- 需要多個標籤時重複使用 `--tag`
- 想一開始就是發佈狀態時加上 `--publish`
- 指定建立日期時使用 `--date 2026-07-19` 的格式
- 如果存在同名目錄、與既有文章相同的 slug 或保留 URL，會出現錯誤

### 文章檔案格式

產生的 `index.typ` 開頭如下：

```typst
#import "/template.typ": article, calver, post-meta

#let meta = post-meta(
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "文章的簡短描述。",
  tags: ("Typst",),
  draft: true,
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= 前言

在這裡撰寫內文。
```

| 欄位 | 說明 |
| --- | --- |
| `slug` | 文章的 URL。由小寫英數字以單一 `-` 連接。上例會發佈在 `/my-first-post/` |
| `title` | 文章標題 |
| `create` | 建立日期 |
| `update` | 更新日期。僅在 `update_policy: "manual"` 時使用 |
| `description` | 用於文章列表和搜尋結果的簡短描述 |
| `tags` | 標籤。即使顯示名稱包含中文、空白或符號，也會自動產生 URL 安全且不重複的標籤頁 |
| `draft` | `true` 為草稿，`false` 為發佈對象。省略時視為草稿 |

### 草稿與發佈

透過 `draft` 切換。想發佈的文章請寫上 `draft: false`。

- **在 `preview` 中**：草稿也會顯示，列表和文章頁會帶「草稿」徽章。草稿會設定 `noindex`，也不會被搜尋收錄。
- **在 `build`（發佈建置）中**：不會產生草稿的文章頁，列表、標籤頁、RSS、sitemap 中也不會包含草稿。

### 更新日期的機制

更新日期預設（`update_policy: "git"`）自動管理。

- 提交文章的 `index.typ` 或同一文章目錄中的圖片、參考文獻等時，最新提交日期會成為更新日期
- 如果只有最初加入文章的那次提交，則不顯示更新日期
- 在無法取得 Git 歷史的環境中會顯示警告，若文章寫有 `update` 則使用該值

想手動管理時，在 `site.typ` 中指定 `update_policy: "manual"`，並在文章的 `update` 中寫日期。

### 把文章集中到 posts/

如果想把文章目錄集中放在 `posts/` 下而不是根目錄，在 `site.typ` 中指定 `posts_dir: "posts"`。`new` 指令的建立位置和建置時的文章搜尋範圍都會變為 `posts/`。

## 本機預覽

```sh
python3 command.py preview
```

- 首次建置後，預覽伺服器會在 `http://localhost:8000` 啟動
- 儲存 Typst 檔案、CSS、JavaScript、圖片等會自動重新建置並重新整理瀏覽器
- 如果 8000 連接埠被佔用會自動選擇其他空閒連接埠，請開啟終端機中顯示的 URL
- 按 `Ctrl+C` 結束

`site.typ` 的 `base_url` 保持發佈 URL 即可。`preview` 只會把 CSS、文章連結等的基準路徑切換為本機伺服器的 `/`；canonical URL、RSS、sitemap 仍然使用 `base_url`。

想同時確認搜尋功能時，在另一個終端機產生搜尋索引：

```sh
npx -y pagefind --site public
```

修改文章觸發自動重新建置後，請再次執行該指令。

想直接查看發佈用的產生結果時，執行 `python3 command.py build`。

## 使用 GitHub Pages 發佈

本範本附帶 GitHub Pages 工作流程。只需要在最初設定一次。

1. 把 `site.typ` 的 `base_url` 和部落格資訊改成自己的
2. 開啟 GitHub 的 `Settings` → `Pages`
3. 把 `Build and deployment` 的 `Source` 設為 `GitHub Actions`
4. 把變更 push 到 `main` 分支

之後每次 push，GitHub Actions 都會自動建置並把 `public/` 的內容部署到 GitHub Pages。

### 使用自訂網域

1. 在 `static/CNAME`（或儲存庫根目錄的 `CNAME`）中寫入網域名稱
2. `site.typ` 的 `base_url` 也改成自訂網域

## 更改外觀

### 切換主題

用 `site.typ` 的 `theme` 切換。內建可用的是 `dark` 和 `light`。

```typst
theme: "light"
```

### 製作自己的主題

在 `static/themes/` 下新增 CSS，並把檔案名稱（不含副檔名）指定給 `theme`。

```typst
// 建立了 static/themes/my-theme.css 時
theme: "my-theme"
```

### 圖片、favicon、額外 CSS

放在 `static/` 中的檔案會在建置時原樣複製到 `public/`。

## 檔案結構

平常經常編輯的檔案：

| 路徑 | 說明 |
| --- | --- |
| `site.typ` | 部落格名稱、發佈 URL、作者資訊、主題等網站設定 |
| `文章目錄/index.typ` | 自己的文章 |
| `example-post/index.typ` | 文章寫法範例 |
| `static/` | 圖片、favicon、額外 CSS、自訂主題、`CNAME` 等 |

基本上不需要動的檔案：

| 路徑 | 說明 |
| --- | --- |
| `vendor/typst-blog-core` | 產生部落格的主體。不直接編輯，透過[更新步驟](#更新部落格引擎)升級版本 |
| `typst/generated/posts.typ` | 建置時自動更新的文章列表資料 |
| `public/` | 建置結果，作為發佈內容產生 |

## 更新部落格引擎

產生部落格的主體以 submodule 形式收錄為 `vendor/typst-blog-core`。文章和 `site.typ` 留在自己的儲存庫中，之後可以只更新產生部分。

推薦透過切換 release tag 來更新。

```sh
cd vendor/typst-blog-core
git fetch --tags
git tag --sort=-version:refname   # 查看可用版本列表
git checkout vYYYY.MM.DD          # 切換到想用的版本
cd ../..
python3 command.py build
npx -y pagefind --site public
git add vendor/typst-blog-core
git commit -m "Update blog core to vYYYY.MM.DD"
```

`git add vendor/typst-blog-core` 不是複製 core 內容的操作，而是記錄「這個部落格使用哪個 core 版本」的操作。

更新後請先在本機確認顯示，再 push。

## 遇到問題時

| 症狀 | 處理 |
| --- | --- |
| 顯示 `typst-blog-core submodule is missing` / `vendor/typst-blog-core` 是空的 | 執行 `git submodule update --init --recursive` |
| 顯示 `site.theme '...' does not exist` | 檢查 `site.typ` 的 `theme` 與 `static/themes/` 的檔案名稱是否一致 |
| 發佈建置中沒有出現文章 | 檢查文章的 `draft` 是否為 `false`（`preview` 中可以看到草稿） |
| 發佈 URL 不對 | 檢查 `site.typ` 的 `base_url`。結尾不需要 `/` |
| GitHub Pages 上找不到 core | 檢查 `.github/workflows/deploy.yml` 的 checkout 設定中是否有 `submodules: recursive` |
| 搜尋沒有作用 | 先執行 `npx -y pagefind --site public` 再確認 |

## 關於 Misskey 圖示

Misskey 分享按鈕和側邊欄的 Misskey 圖示預設啟用。core 中附帶的 Misskey 圖示來自 Simple Icons，由 Misskey project 以 CC-BY-NC-SA-4.0 提供。如商用等情境下該條款不適用，請把 `site.typ` 的 `share.misskey` 設為 `false`。

## 授權條款

本範本的程式碼以 MIT License 提供。

---

文件版本: 2026.07.19.7
（更新此 README 時，請同時更新根目錄的 README.md 和 `docs/` 下的其他語言檔案，並保持文件版本一致）
