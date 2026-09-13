# Typst Blog Template

这是一个使用 Typst 轻松创建并发布静态博客的模板。无需制作复杂的网站或构建 SSG 工具，即可专注于文章写作。

只需撰写文章并执行构建，即可自动生成首页、文章正文页、标签列表、RSS、Sitemap 和站内搜索索引（Pagefind）。

- 演示站点（示例文章）：<https://minimarimo3.github.io/typst-blog-template/example-post/>
- 使用示例（作者博客）：<https://www.minimarimo3.jp>

[日本語](README.ja.md) | [English](../README.md) | [한국어](README.ko.md) | 简体中文 | [繁體中文（台灣）](README.zh-TW.md)

## 主要特性

- 完全基于 Typst 的写作体验
不仅文章正文，整个站点的设置也都可以使用 Typst 语法编写。
- 无需繁琐设置即可自动生成
自动生成首页、带 OGP 和 Meta 标签的文章页、标签列表、RSS 和 Sitemap。还支持使用 Pagefind 进行站内搜索，以及通过附带的 GitHub Actions 自动部署到 GitHub Pages。
- 基于 Git 的自动更新日期及 GitHub 风格 Alerts
根据 Git 提交历史自动反映更新日期。默认支持 `warning`、`note` 等 GitHub 风格 Alerts 语法。
- 易于维护的核心分离结构
博客引擎主体（`vendor/typst-blog-core`）作为 Git 子模块独立存在。即使 Typst 将来对 HTML 输出规范做出破坏性变更，也只需更新核心即可跟进，不会破坏文章数据。
- 灵活的自定义能力
可根据需要进行调整，包括通过配置文件（`site.typ`）进行简单设置、更改 CSS 或配色、修改 HTML 结构（`theme/`），以及添加自定义组件。

---

## 快速开始

### 1. 创建并获取仓库

使用 GitHub 的“Use this template”按钮创建自己的仓库，然后克隆到本地。

```sh
git clone --recurse-submodules https://github.com/YOUR_USER/YOUR_REPO.git
cd YOUR_REPO
```

> Note
> 如果仓库已经克隆，但 `vendor/typst-blog-core` 目录为空，请执行：
> `git submodule update --init --recursive`

### 2. 编辑站点设置

打开 `site.typ` 并设置博客信息。

```typst
#let site-config = (
  title: "我的博客",
  description: "博客说明",
  base_url: "https://YOUR_USER.github.io/YOUR_REPO", // 使用自定义域名时填写相应 URL
  github_repo: "[https://github.com/YOUR_USER/YOUR_REPO](https://github.com/YOUR_USER/YOUR_REPO)",
  posts_dir: "posts", // 文章保存位置（"posts" 等目录名或 "."）
  language: (
    lang: "zh",
    region: "TW",
    script: "hani",
  ),
  // 也可以简写为 language: "zh"

  author: (
    name: "管理员名称",
    bio: "个人简介",
    links: (
      (id: "github", label: "GitHub", url: "https://github.com/YOUR_USER"),
    ),
  ),
  ... // 还有其他设置，但这些是基本项目
)
```

### 3. 创建新文章

使用 CLI 命令生成文章模板。

```sh
python3 command.py new post my-first-post --title "第一篇文章" --tag "Typst"
```

执行后会生成 `{posts_dir}/my-first-post/index.typ`。

### 4. 本地预览

```sh
python3 command.py preview
```

预览服务器会在 `http://localhost:8000` 启动。
保存文件后会自动重新构建并刷新浏览器。

### 5. 发布到 GitHub Pages

1. 打开 GitHub 仓库的 Settings → Pages
2. 将 Build and deployment 下的 Source 改为 GitHub Actions
3. `push` 到 `main` 分支后会自动构建并部署

---

## 文章写法

文章按“一篇文章 = 一个目录”的方式管理。请将图片和相关文件放在与 `index.typ` 相同的目录中。

### 文章文件的基本结构（`index.typ`）

```typst
#import "/template.typ": post, calver

#show: post.with(
  title: "第一篇文章",
  create: calver(2026, 1, 1, 3),
  description: "文章概要。",
  tags: ("Typst", "日记"),
  draft: true, // 发布时改为 false
)

= 前言

在此撰写正文。

```

### 文章元数据列表

| 项目 | 类型 | 说明 |
| --- | --- | --- |
| `title` | String | 必填。文章标题 |
| `create` | `calver()` | 必填。创建日期（例：`calver(2026, 1, 1)`） |
| `description` | String | 用于文章列表、SEO 和 OGP 的说明文本 |
| `tags` | Array | 标签（包含中文或空格时也会自动转换为安全的 URL） |
| `draft` | Boolean | `true` 表示草稿，`false` 表示公开（省略时为 `true`） |
| `permalink` | String | 自定义 URL（例：`"/notes/hello/"`） |
| `aliases` | Array | 用于重定向的旧 URL 列表（例：`("/old-path/",)`） |
| `update` | `calver()` | 手动更新日期（仅在设置 `update_policy: "manual"` 时使用） |
| `extra` | Dictionary | 传递给主题和自定义扩展的任意自定义数据 |

---

## 创建通用页面（About / FAQ 等）

可以创建不包含在博客文章列表或 RSS 中的固定页面，例如 About 页面或隐私政策。

```sh
python3 command.py new page about --title "关于本站" --publish
```

将生成 `pages/about/index.typ`。

```typst
#import "/template.typ": site-page

#show: site-page.with(
  title: "关于本站",
  description: "个人资料和站点介绍",
  draft: false,
  index: true, // 是否允许搜索引擎和站内搜索建立索引
)

= About 页面
```

---

## 运行与规范详情

### 草稿和发布行为

- `preview` 命令：也会显示草稿（`draft: true`）。草稿会带有“草稿”标记，并从搜索索引中排除。
- `build` 命令：正式构建不会生成草稿文章的 HTML，并会将其从列表、RSS 和 Sitemap 中排除。

### 自动反映更新日期（`update`）

默认设置（`update_policy: "git"`）会自动采用文章目录内文件的最新提交日期作为更新日期。只有初次提交时不显示更新日期。

### 更改主题和配色

可在 `site.typ` 中切换配色。

```typst
theme: theme-config(color_scheme: "light") // "dark" 或 "light"
```

如需添加自己的 CSS，请创建 `theme/static/color-schemes/my-theme.css`，并指定 `color_scheme: "my-theme"`。

---

## 目录结构

```text
.
├── site.typ                # 标题、URL、作者等站点整体设置
├── posts/                  # 在 posts_dir 中指定时的文章目录
├── pages/                  # About 等通用页面
├── theme/                  # HTML 结构和设计主题
│   ├── pages/              # article、home、tag 等各页面渲染器
│   ├── components/         # head、header、widget 等共用组件
│   └── static/             # 主题使用的 CSS / JS
├── extensions/             # 自定义组件和扩展功能
├── static/                 # 图片、favicon、CNAME 等静态文件
├── command.py              # 创建文章和预览使用的 CLI 工具
├── blog.py                 # 扩展构建处理的脚本
└── vendor/typst-blog-core/ # 【子模块】博客引擎主体（不建议直接编辑）
```

---

## 环境要求

| 工具 | 要求版本 | 备注 |
| --- | --- | --- |
| Git | - | 用于管理子模块 |
| Typst | `0.15.0` 以上 | 随时跟进最新版本 |
| Python | `3.10` 以上 | 用于构建、生成 RSS/Sitemap 和 CLI 命令 |
| Node.js | `20` 以上 | 可选（创建 Pagefind 搜索索引时使用） |

---

## 故障排除

| 现象 | 原因和解决方法 |
| --- | --- |
| 显示 `typst-blog-core submodule is missing` | 执行 `git submodule update --init --recursive` 获取核心引擎。 |
| 正式构建后不显示文章 | 请确认文章元数据中设置了 `draft: false`。 |
| 发布后链接或 CSS 异常 | 请确认 `site.typ` 中的 `base_url` 设置正确（末尾无需 `/`）。 |
| 站内搜索（Pagefind）无法工作 | 请确认 Node.js 和 `npx` 可用，然后重新启动 `preview` 或再次执行 `build`。 |

---

## 第三方许可证声明

- 本模板的代码基于 MIT License 提供。
- 内置的 Misskey 品牌图标依据 CC BY-SA 4.0 使用。包括商业用途在内所需的署名信息会在构建时自动输出到 `/third-party-licenses.txt`。详情请参阅 `THIRD_PARTY_NOTICES.md`。

---

文档版本: 2026.09.13.1
