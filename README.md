# Typst Blog Template

A template for easily creating and publishing a static blog with Typst. It lets you focus on writing posts without building a complex website or static site generator from scratch.

Simply write your posts and run the build to automatically generate the home page, post pages, tag index, RSS feed, sitemap, and a Pagefind site-search index.

- Demo site (sample post): <https://minimarimo3.github.io/typst-blog-template/example-post/>
- Example in use (author's blog): <https://www.minimarimo3.jp>

[日本語](docs/README.ja.md) | English | [한국어](docs/README.ko.md) | [简体中文](docs/README.zh-CN.md) | [繁體中文（台灣）](docs/README.zh-TW.md)

## Key features

- A Typst-first writing experience
Both your post content and all site-wide settings can be written in Typst.
- Automatic generation without complicated setup
Automatically generates the home page, post pages with OGP and meta tags, tag index, RSS feed, and sitemap. Pagefind site search and automatic deployment to GitHub Pages are also supported through the included GitHub Actions workflow.
- Git-based update dates and GitHub-style alerts
Automatically derives update dates from Git commit history. GitHub-style alert syntax such as `warning` and `note` is built in.
- Easy-to-maintain separated core
The blog engine (`vendor/typst-blog-core`) is separated into a Git submodule. If a future Typst release makes breaking changes to HTML output, you can update only the core without disrupting your post data.
- Flexible customization
Customize the blog to suit your needs, from simple changes in `site.typ` to CSS and color schemes, HTML structure under `theme/`, and custom components.

---

## Quick start

### 1. Create and clone the repository

Use GitHub's “Use this template” button to create your own repository, then clone it locally.

```sh
git clone --recurse-submodules https://github.com/YOUR_USER/YOUR_REPO.git
cd YOUR_REPO
```

> Note
> If you already cloned the repository and `vendor/typst-blog-core` is empty, run:
> `git submodule update --init --recursive`

### 2. Edit the site settings

Open `site.typ` and configure your blog information.

```typst
#let site-config = (
  title: "My Blog",
  description: "A description of the blog",
  base_url: "https://YOUR_USER.github.io/YOUR_REPO", // Use your custom-domain URL if applicable
  github_repo: "[https://github.com/YOUR_USER/YOUR_REPO](https://github.com/YOUR_USER/YOUR_REPO)",
  posts_dir: "posts", // Directory name for posts, such as "posts", or "."
  language: (
    lang: "zh",
    region: "TW",
    script: "hani",
  ),
  // Or use the shorthand language: "en"

  author: (
    name: "Author name",
    bio: "Profile",
    links: (
      (id: "github", label: "GitHub", url: "https://github.com/YOUR_USER"),
    ),
  ),
  ... // Other settings are available, but these are the essentials
)
```

### 3. Create a new post

Generate a post template with the CLI command.

```sh
python3 command.py new post my-first-post --title "My First Post" --tag "Typst"
```

This creates `{posts_dir}/my-first-post/index.typ`.

### 4. Preview locally

```sh
python3 command.py preview
```

The preview server starts at `http://localhost:8000`.
When you save a file, the site is automatically rebuilt and the browser reloads.

### 5. Publish with GitHub Pages

1. Open Settings → Pages in your GitHub repository
2. Change Build and deployment → Source to GitHub Actions
3. Push to the `main` branch to automatically build and deploy the site

---

## Writing posts

Posts are organized as one directory per post. Place images and related files in the same directory as `index.typ`.

### Basic post file structure (`index.typ`)

```typst
#import "/template.typ": post, calver

#show: post.with(
  title: "My First Post",
  create: calver(2026, 1, 1, 3),
  description: "A summary of the post.",
  tags: ("Typst", "Journal"),
  draft: true, // Change to false to publish
)

= Introduction

Write your post here.

```

### Post metadata

| Field | Type | Description |
| --- | --- | --- |
| `title` | String | Required. The post title |
| `create` | `calver()` | Required. The creation date (for example, `calver(2026, 1, 1)`) |
| `description` | String | Description used in post lists, SEO, and OGP metadata |
| `tags` | Array | Tags; Japanese text and spaces are automatically converted to safe URLs |
| `draft` | Boolean | `true` for a draft and `false` to publish; defaults to `true` when omitted |
| `permalink` | String | Custom URL (for example, `"/notes/hello/"`) |
| `aliases` | Array | Previous URLs used for redirects (for example, `("/old-path/",)`) |
| `update` | `calver()` | Manual update date, used only when `update_policy: "manual"` is configured |
| `extra` | Dictionary | Optional custom data passed to the theme and custom extensions |

---

## Creating general pages (About, FAQ, and more)

You can create fixed pages such as an About page or privacy policy that are not included in the blog post list or RSS feed.

```sh
python3 command.py new page about --title "About This Site" --publish
```

This creates `pages/about/index.typ`.

```typst
#import "/template.typ": site-page

#show: site-page.with(
  title: "About This Site",
  description: "An introduction to the profile and site",
  draft: false,
  index: true, // Whether search engines and site search should index the page
)

= About
```

---

## Operation and specification details

### Draft and publication behavior

- `preview` command: Drafts (`draft: true`) are also displayed. They receive a “Draft” badge and are excluded from the search index.
- `build` command: The production build does not generate HTML for draft posts and excludes them from lists, RSS, and the sitemap.

### Automatically derived update dates (`update`)

By default (`update_policy: "git"`), the latest commit date for files in the post directory is used automatically as the update date. The update date is not displayed if there has only been an initial commit.

### Changing the theme and color scheme

Switch color schemes in `site.typ`.

```typst
theme: theme-config(color_scheme: "light") // "dark" or "light"
```

To add your own CSS, create `theme/static/color-schemes/my-theme.css` and set `color_scheme: "my-theme"`.

---

## Directory structure

```text
.
├── site.typ                # Site-wide settings such as the title, URL, and author
├── posts/                  # Post directory when selected in posts_dir
├── pages/                  # General pages such as About
├── theme/                  # HTML structure and visual theme
│   ├── pages/              # Page renderers for articles, home, tags, and more
│   ├── components/         # Shared parts such as the head, header, and widgets
│   └── static/             # Theme CSS and JavaScript
├── extensions/             # Custom components and extensions
├── static/                 # Static files such as images, favicon, and CNAME
├── command.py              # CLI for creating posts and running previews
├── blog.py                 # Script for extending the build process
└── vendor/typst-blog-core/ # Blog engine submodule; direct edits are not recommended
```

---

## Requirements

| Tool | Required version | Notes |
| --- | --- | --- |
| Git | - | Used to manage the submodule |
| Typst | `0.15.0` or later | Updated as new Typst versions are released |
| Python | `3.10` or later | Used by the build, RSS/sitemap generation, and CLI commands |
| Node.js | `20` or later | Optional; used to create the Pagefind search index |

---

## Troubleshooting

| Symptom | Cause and solution |
| --- | --- |
| `typst-blog-core submodule is missing` is displayed | Run `git submodule update --init --recursive` to fetch the core engine. |
| Posts are missing after a production build | Make sure the post metadata contains `draft: false`. |
| Links or CSS break after publication | Check that `base_url` in `site.typ` is correct and has no trailing `/`. |
| Pagefind site search does not work | Make sure Node.js and `npx` are available, then restart `preview` or run `build` again. |

---

## Third-party license notices

- This template's code is provided under the MIT License.
- The included Misskey brand icon is used under CC BY-SA 4.0. Attribution, including for commercial use, is automatically written to `/third-party-licenses.txt` during the build. See `THIRD_PARTY_NOTICES.md` for details.

---

Document version: 2026.09.13.1
