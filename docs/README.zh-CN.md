# Typst Blog Template

文档版本：2026.05.25

语言：[日本語](../README.md) | [English](README.en.md) | [한국어](README.ko.md) | 简体中文 | [繁體中文（台灣）](README.zh-TW.md)

这是一个小型静态站点模板，用于通过 Typst 的 HTML 输出编写博客。
文章正文、文章元数据和站点设置都由 Typst 管理，`build.py` 会生成 HTML、RSS 和 sitemap。

更新此 README 时，请同时更新 `docs/` 中的本地化文件，并保持文档版本一致。

## 要求

- Typst 0.14.2 或更高版本
- Python 3.10 或更高版本

## 快速开始

```sh
python3 build.py
```

生成的文件会输出到 `public/`。
如需在本地预览，请使用任意静态文件服务器提供 `public/` 目录。

```sh
python3 -m http.server 8000 -d public
```

## 站点设置

`site.typ` 是全站设置的唯一来源。
请先编辑以下值：

- `title`: 博客名称
- `description`: 博客描述
- `base_url`: 公开 URL
- `author`: 作者姓名、简介和社交链接
- `analytics.cloudflare_token`: 仅在使用 Cloudflare Web Analytics 时设置
- `feedback.google_form_url` 和 `feedback.entry_id`: 仅在使用 Google Forms 时设置
- `share`: X、Misskey 和复制分享按钮的显示设置

## 编写文章

为每篇文章创建一个目录，并在其中放置 `index.typ`。
最简单的开始方式是复制 `example-post/index.typ`。

```typst
#import "../template.typ": article, calver

#let meta = (
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "文章的简短描述。",
  tags: ("Typst",),
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= Introduction

Write your post here.
```

`slug` 会成为公开 URL。上面的示例会输出到 `/my-first-post/`。
`create` 使用 CalVer 格式。可以像 `calver(26, 1, 1)` 这样使用两位数年份。年月日不能省略，只有补丁号可以省略，省略时会按 `0` 处理。
在元数据中添加 `draft: true` 可将文章从文章列表、RSS、sitemap 和 HTML 输出中排除。

## 使用 GitHub Pages 发布

此模板包含用于 GitHub Pages 的工作流。

1. 基于此模板创建仓库。
2. 按你的站点需求编辑 `site.typ`。
3. 在 GitHub 中打开 `Settings` -> `Pages` -> `Build and deployment`，然后将 `Source` 设置为 `GitHub Actions`。
4. 推送到 `main` 分支。

该工作流会运行 `python3 build.py`，并将 `public/` 部署到 GitHub Pages。

## Misskey 图标说明

Misskey 分享按钮和侧边栏中的 Misskey 图标默认启用。
随附的 Misskey 图标来自 Simple Icons，并由 Misskey project 以 CC-BY-NC-SA-4.0 授权提供。
如果这些条款不适合你的使用场景，例如商业使用，请删除或替换 `typst/components/widgets.typ` 中的 Misskey 图标，并在 `site.typ` 中将 `share.misskey` 设置为 `false`。

## 许可证

此模板中的代码以 MIT License 提供。
