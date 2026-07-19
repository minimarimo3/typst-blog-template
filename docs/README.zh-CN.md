# Typst Blog Template

文档版本: 2026.07.19.1

语言: [日本語](../README.md) | [English](README.en.md) | [한국어](README.ko.md) | 简体中文 | [繁體中文（台灣）](README.zh-TW.md)

这是一个用 Typst 写文章，并发布为静态博客的模板。
写好文章并构建后，可以一起生成博客首页、文章页、标签页、RSS、sitemap 和搜索索引。

这份 README 面向想把这个模板当作自己博客来使用的人。
如果想了解内部实现，请阅读 `vendor/typst-blog-core` 中的 README。

更新这份 README 时，也请更新 `docs/` 下的各语言文件，并保持文档版本一致。

## 可以做什么

- 用 Typst 语法写博客文章。
- 为每篇文章设置标题、创建日期、更新日期、说明、标签和草稿状态。
- 生成首页、文章页、按标签分类的页面和标签列表页。
- 生成 RSS 和 sitemap。
- 使用 Pagefind 添加站内搜索。
- 直接发布到 GitHub Pages。
- 添加颜色主题、favicon、图片、CSS，以及自定义域名用的 `CNAME`。
- 之后只更新博客引擎部分。

## 需要准备

- Git
- Typst 0.15.0 或更高版本
- Python 3.10 或更高版本
- Node.js 20 或更高版本

Node.js 用于运行生成搜索索引的 `pagefind`。
即使本地不使用搜索功能，默认的 GitHub Pages workflow 也会使用 Node.js。

## 最常编辑的文件

平时经常编辑的是这些文件。

- `site.typ`: 博客名称、说明、公开 URL、作者信息、主题等站点设置
- `example-post/index.typ`: 文章写法示例
- `任意文章目录/index.typ`: 你自己的文章
- `static/`: 图片、favicon、附加 CSS、自定义主题、`CNAME` 等

也有一些通常不需要手动编辑的文件。

- `vendor/typst-blog-core`: 生成博客的核心。通常不要直接编辑，而是按更新步骤升级版本。
- `typst/generated/posts.typ`: 构建时生成的文章列表数据。不要手动编辑。
- `public/`: 构建结果。不要手动编辑。

## 开始使用

先通过 GitHub 的模板功能，从这个仓库创建自己的仓库。
然后 clone 到本地。

```sh
git clone --recurse-submodules https://github.com/USER/REPO.git
cd REPO
```

如果已经 clone 过，但 `vendor/typst-blog-core` 是空的，请运行：

```sh
git submodule update --init --recursive
```

接着打开 `site.typ`，改成自己的博客信息。
建议先修改这些字段：

- `title`: 博客名称
- `description`: 博客说明
- `base_url`: 发布后的 URL
- `github_repo`: 这个博客的 GitHub 仓库 URL
- `language`: 主要使用的语言
- `theme`: `dark` 或 `light`
- `author.name`: 作者名称
- `author.bio`: 个人简介
- `author.socials`: X、Misskey、GitHub 等链接

如果发布到 GitHub Pages，`base_url` 通常是这样的形式。

```typst
base_url: "https://USER.github.io/REPO"
```

如果使用自定义域名，请设置为该域名的 URL。

## 写文章

每篇文章建立一个目录，并在其中放置 `index.typ`。
第一次可以复制 `example-post/` 开始。

```sh
cp -R example-post my-first-post
```

文章文件开头写文章信息。

```typst
#import "/template.typ": article, calver, post-meta

#let meta = post-meta(
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "简短说明。",
  tags: ("Typst",),
  draft: false,
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= Hello

在这里写正文。
```

常用字段如下。

- `slug`: 会成为文章 URL。上面的例子会发布到 `/my-first-post/`。
- `title`: 文章标题。
- `create`: 创建日期。
- `update`: 更新日期。需要时再添加。
- `description`: 用在文章列表和搜索结果等位置的简短说明。
- `tags`: 标签。标签页会自动生成。
- `draft`: `true` 表示草稿，`false` 表示发布。

如果省略 `draft`，文章会被当作草稿。
想发布的文章请设置 `draft: false`。

## 本地预览

运行以下命令：

```sh
python3 build.py --preview
```

首次构建完成后，预览服务器会在 `http://localhost:8000` 启动。保存 Typst 文件、CSS、JavaScript、图片等站点源文件后，网站会自动重新构建，已打开的浏览器页面也会自动刷新。如果 8000 端口已被占用，则会选择其他可用端口，请打开终端中显示的 URL。按 `Ctrl+C` 即可停止。

`site.typ` 中的 `base_url` 可以继续保持为公开 URL。`--preview` 只会把 CSS、文章链接等站点资源的基准路径切换为本地服务器使用的 `/`。canonical URL、RSS 和 sitemap 仍然使用 `base_url`。

如果也想确认搜索功能，请在另一个终端生成搜索索引。文章修改触发自动重建后，请再次运行此命令。

```sh
npx -y pagefind --site public
```

生成部署用结果或检查公开路径时，请不加 `--preview`，直接运行 `python3 build.py`。

## 发布到 GitHub Pages

这个模板包含 GitHub Pages 用的 workflow。

1. 修改 `site.typ` 中的 `base_url` 和博客信息。
2. 在 GitHub 打开 `Settings` -> `Pages`。
3. 将 `Build and deployment` 的 `Source` 设置为 `GitHub Actions`。
4. 把修改 push 到 `main` 分支。

push 后，GitHub Actions 会自动构建，并把 `public/` 的内容部署到 GitHub Pages。

如果使用自定义域名，请在 `static/CNAME` 或仓库根目录的 `CNAME` 中写入域名。
同时也要让 `site.typ` 中的 `base_url` 与该域名一致。

## 改变外观

通过 `site.typ` 的 `theme` 切换主题。

```typst
theme: "light"
```

内置主题有 `dark` 和 `light`。

图片、favicon、附加 CSS、自定义主题等都放在 `static/` 中。
构建时，`static/` 的内容会被复制到 `public/`。

如果要创建自定义主题，例如添加 `static/themes/my-theme.css`，然后在 `site.typ` 中指定。

```typst
theme: "my-theme"
```

## 更新博客引擎

这个模板将生成博客的核心作为 `vendor/typst-blog-core` 引入。
文章和 `site.typ` 会留在自己的仓库中，所以之后可以只更新生成逻辑。

更新时，推荐切换到 release tag。

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

请把 `vYYYY.MM.DD` 替换为实际要使用的 release tag。

`git add vendor/typst-blog-core` 并不是把整个 core 复制到父仓库。
它只是记录这个博客使用哪个 core 版本。

更新后，请先在本地确认显示效果，再 push。

## 常见操作

添加新文章：

```sh
cp -R example-post new-post
```

把文章改回草稿：

```typst
draft: true
```

发布文章：

```typst
draft: false
```

重新生成搜索索引：

```sh
npx -y pagefind --site public
```

重新获取 submodule：

```sh
git submodule update --init --recursive
```

## 故障排查

- 出现 `typst-blog-core submodule is missing`：运行 `git submodule update --init --recursive`。
- `vendor/typst-blog-core` 是空的：submodule 还没有获取。运行 `git submodule update --init --recursive`。
- 出现 `site.theme '...' does not exist`：检查 `site.typ` 中的 `theme` 和 `static/themes/` 下的文件名。
- 文章没有出现：确认文章的 `draft` 是否为 `false`。
- 公开 URL 不正确：检查 `site.typ` 中的 `base_url`。末尾不需要 `/`。
- GitHub Pages 找不到 core：确认 `.github/workflows/deploy.yml` 的 checkout 设置中有 `submodules: recursive`。
- 搜索不可用：运行 `npx -y pagefind --site public` 后再确认。

## Misskey 图标

Misskey 分享按钮和侧边栏图标默认启用。
core 中附带的 Misskey 图标来自 Simple Icons，由 Misskey project 以 CC-BY-NC-SA-4.0 提供。
如果该许可不适合你的用途，请在 `site.typ` 中将 `share.misskey` 设置为 `false`。

## 许可证

MIT License.
