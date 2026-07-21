# Typst Blog Template

这是一个用 Typst 写文章并发布为静态博客的模板。
写好文章并构建后，首页、文章页、标签页、RSS、sitemap 和站内搜索索引都会一并生成。

展示各种语法的示例页面：<https://minimarimo3.github.io/typst-blog-template/example-post/>
模板作者使用本模板搭建的博客：<https://www.minimarimo3.jp>

语言: [日本語](README.ja.md) | [English](../README.md) | [한국어](README.ko.md) | 简体中文 | [繁體中文（台灣）](README.zh-TW.md)

## 特性

- 文章和站点配置全部用 Typst 编写
- 每篇文章可设置标题、创建日期、更新日期、描述、标签和草稿状态
- 自动生成首页、文章页、按标签页面和标签一览页
- 自动生成 RSS 和 sitemap
- 支持基于 [Pagefind](https://pagefind.app/) 的站内搜索
- 可直接发布到 GitHub Pages（附带工作流）
- 支持切换颜色主题，配置 favicon、图片、附加 CSS 和自定义域名
- 之后可以只更新博客引擎部分（`vendor/typst-blog-core`）

## 环境要求

| 工具 | 版本 |
| --- | --- |
| Git | - |
| Typst | 0.15.0 及以上 |
| Python | 3.10 及以上 |
| Node.js | 20 及以上 |

Node.js 用于运行生成搜索索引的 Pagefind。即使不使用搜索功能，GitHub Pages 的默认工作流也会用到 Node.js。

## 快速开始

### 1. 创建仓库并 clone

用 GitHub 的 "Use this template" 按钮创建自己的仓库，然后 clone 到本地。

```sh
git clone --recurse-submodules https://github.com/USER/REPO.git
cd REPO
```

> [!NOTE]
> 如果已经 clone 且 `vendor/typst-blog-core` 为空，请运行 `git submodule update --init --recursive`。

### 2. 修改站点配置

打开 `site.typ`，按自己的博客进行修改。先检查这些项：

| 配置项 | 说明 |
| --- | --- |
| `title` | 博客名称 |
| `description` | 博客描述 |
| `base_url` | 发布后的 URL（结尾不要加 `/`） |
| `github_repo` | 本博客的 GitHub 仓库 URL |
| `language` | 主要使用的语言 |
| `theme` | `"dark"` 或 `"light"` |
| `posts_dir` | 文章存放位置。放在根目录下用 `"."`，集中到 `posts/` 用 `"posts"` |
| `update_policy` | 更新日期的确定方式。`"git"`（默认，从 Git 历史自动计算）或 `"manual"`（使用文章的 `update`） |
| `author.name` | 作者名 |
| `author.bio` | 个人简介 |
| `author.socials` | X、Misskey、GitHub 等链接 |

在 GitHub Pages 上发布时，`base_url` 形如：

```typst
base_url: "https://USER.github.io/REPO"
```

使用自定义域名时，请填写该域名的 URL。

### 3. 创建文章

```sh
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "文章的简短描述。" \
  --tag Typst
```

会一次性创建文章目录和已填好元信息的 `index.typ`。

### 4. 本地预览

```sh
python3 command.py preview
```

首次构建后，预览服务器会在 `http://localhost:8000` 启动。保存文件会自动重新构建并刷新浏览器。

### 5. 发布

push 到 `main` 分支后，GitHub Actions 会自动构建并发布到 GitHub Pages。详见[使用 GitHub Pages 发布](#使用-github-pages-发布)。

## 撰写文章

文章采用"一篇文章 = 一个目录"的结构，每个目录中的 `index.typ` 就是正文。图片和参考文献也放在同一目录中。

### 新建文章

```sh
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "文章的简短描述。" \
  --tag Typst
```

- 创建日期为执行当天，出于安全考虑初始状态为草稿
- 需要多个标签时重复使用 `--tag`
- 想一开始就处于发布状态时加上 `--publish`
- 指定创建日期时使用 `--date 2026-07-19` 的格式
- 如果存在同名目录、与现有文章相同的 slug 或保留 URL，会报错

### 文章文件格式

生成的 `index.typ` 开头如下：

```typst
#import "/template.typ": post, calver

#show: post.with(
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "文章的简短描述。",
  tags: ("Typst",),
  draft: true,
)

= 前言

在这里写正文。
```

`post` show 规则会将这些值注册为构建元数据，并使用文章布局渲染后续正文。

| 字段 | 说明 |
| --- | --- |
| `slug` | 文章的 URL。可使用包含空格、大写字母、标点和符号的自然 Unicode 文本，生成的 URL 会使用百分号编码。路径分隔符、控制字符和不可移植的文件名会被拒绝。上例发布在 `/my-first-post/` |
| `title` | 文章标题 |
| `create` | 创建日期 |
| `update` | 更新日期。仅在 `update_policy: "manual"` 时使用 |
| `description` | 用于文章列表和搜索结果的简短描述 |
| `tags` | 标签。即使显示名包含中文、空格或符号，也会自动生成 URL 安全且不重复的标签页 |
| `draft` | `true` 为草稿，`false` 为发布对象。省略时视为草稿 |

### 草稿与发布

通过 `draft` 切换。想发布的文章请写上 `draft: false`。

- **在 `preview` 中**：草稿也会显示，列表和文章页会带"草稿"徽章。草稿会设置 `noindex`，也不会被搜索收录。
- **在 `build`（发布构建）中**：不会生成草稿的文章页，列表、标签页、RSS、sitemap 中也不会包含草稿。

### 更新日期的机制

更新日期默认（`update_policy: "git"`）自动管理。

- 提交文章的 `index.typ` 或同一文章目录中的图片、参考文献等时，最新提交日期会成为更新日期
- 如果只有最初添加文章的那次提交，则不显示更新日期
- 在无法获取 Git 历史的环境中会显示警告，若文章写有 `update` 则使用该值

想手动管理时，在 `site.typ` 中指定 `update_policy: "manual"`，并在文章的 `update` 中写日期。

### 把文章集中到 posts/

如果想把文章目录集中放在 `posts/` 下而不是根目录，在 `site.typ` 中指定 `posts_dir: "posts"`。`new` 命令的创建位置和构建时的文章查找范围都会变为 `posts/`。

## 本地预览

```sh
python3 command.py preview
```

- 首次构建后，预览服务器会在 `http://localhost:8000` 启动
- 保存 Typst 文件、CSS、JavaScript、图片等会自动重新构建并刷新浏览器
- 如果 8000 端口被占用会自动选择其他空闲端口，请打开终端中显示的 URL
- 按 `Ctrl+C` 退出

`site.typ` 的 `base_url` 保持发布 URL 即可。`preview` 只会把 CSS、文章链接等的基准路径切换为本地服务器的 `/`；canonical URL、RSS、sitemap 仍然使用 `base_url`。

想同时确认搜索功能时，在另一个终端生成搜索索引：

```sh
npx -y pagefind --site public
```

修改文章触发自动重新构建后，请再次执行该命令。

想直接查看发布用的生成结果时，运行 `python3 command.py build`。

## 使用 GitHub Pages 发布

本模板附带 GitHub Pages 工作流。只需在最初设置一次。

1. 把 `site.typ` 的 `base_url` 和博客信息改成自己的
2. 打开 GitHub 的 `Settings` → `Pages`
3. 把 `Build and deployment` 的 `Source` 设为 `GitHub Actions`
4. 把改动 push 到 `main` 分支

之后每次 push，GitHub Actions 都会自动构建并把 `public/` 的内容部署到 GitHub Pages。

### 使用自定义域名

1. 在 `static/CNAME`（或仓库根目录的 `CNAME`）中写入域名
2. `site.typ` 的 `base_url` 也改成自定义域名

## 修改外观

### 切换主题

用 `site.typ` 的 `theme` 切换。开箱可用的是 `dark` 和 `light`。

```typst
theme: "light"
```

### 制作自己的主题

在 `static/themes/` 下添加 CSS，并把文件名（不含扩展名）指定给 `theme`。

```typst
// 创建了 static/themes/my-theme.css 时
theme: "my-theme"
```

### 图片、favicon、附加 CSS

放在 `static/` 中的文件会在构建时原样复制到 `public/`。

## 文件结构

平时经常编辑的文件：

| 路径 | 说明 |
| --- | --- |
| `site.typ` | 博客名称、发布 URL、作者信息、主题等站点配置 |
| `文章目录/index.typ` | 自己的文章 |
| `example-post/index.typ` | 文章写法示例 |
| `static/` | 图片、favicon、附加 CSS、自定义主题、`CNAME` 等 |

基本不需要碰的文件：

| 路径 | 说明 |
| --- | --- |
| `vendor/typst-blog-core` | 生成博客的主体。不直接编辑，通过[更新步骤](#更新博客引擎)升级版本 |
| `typst/generated/posts.typ` | 构建时自动更新的文章列表数据 |
| `public/` | 构建结果，作为发布内容生成 |

## 更新博客引擎

生成博客的主体以 submodule 形式收录为 `vendor/typst-blog-core`。文章和 `site.typ` 留在自己的仓库中，之后可以只更新生成部分。

推荐通过切换 release tag 来更新。

```sh
cd vendor/typst-blog-core
git fetch --tags
git tag --sort=-version:refname   # 查看可用版本列表
git checkout vYYYY.MM.DD          # 切换到想用的版本
cd ../..
python3 command.py build
npx -y pagefind --site public
git add vendor/typst-blog-core
git commit -m "Update blog core to vYYYY.MM.DD"
```

`git add vendor/typst-blog-core` 不是复制 core 内容的操作，而是记录"这个博客使用哪个 core 版本"的操作。

更新后请先在本地确认显示，再 push。

## 遇到问题时

| 症状 | 处理 |
| --- | --- |
| 提示 `typst-blog-core submodule is missing` / `vendor/typst-blog-core` 为空 | 运行 `git submodule update --init --recursive` |
| 提示 `site.theme '...' does not exist` | 检查 `site.typ` 的 `theme` 与 `static/themes/` 的文件名是否一致 |
| 发布构建中没有出现文章 | 检查文章的 `draft` 是否为 `false`（`preview` 中可以看到草稿） |
| 发布 URL 不对 | 检查 `site.typ` 的 `base_url`。结尾不需要 `/` |
| GitHub Pages 上找不到 core | 检查 `.github/workflows/deploy.yml` 的 checkout 配置中是否有 `submodules: recursive` |
| 搜索不工作 | 先运行 `npx -y pagefind --site public` 再确认 |

## 关于 Misskey 图标

Misskey 分享按钮和侧边栏的 Misskey 图标默认启用。core 中附带的 Misskey 图标来自 Simple Icons，由 Misskey project 以 CC-BY-NC-SA-4.0 提供。如商用等场景下该条款不适用，请把 `site.typ` 的 `share.misskey` 设为 `false`。

## 许可证

本模板的代码以 MIT License 提供。

---

文档版本: 2026.07.19.7
（更新此 README 时，请同时更新根目录的 README.md 和 `docs/` 下的其他语言文件，并保持文档版本一致）
