# Typst Blog Template

A template for writing posts in Typst and publishing them as a static blog.
Write a post and build — the home page, post pages, tag pages, RSS, sitemap, and site search index are all generated for you.

Sample page showcasing the supported syntax: <https://minimarimo3.github.io/typst-blog-template/example-post/>
The template author's blog built with this template: <https://www.minimarimo3.jp>

Languages: [日本語](docs/README.ja.md) | English | [한국어](docs/README.ko.md) | [简体中文](docs/README.zh-CN.md) | [繁體中文（台灣）](docs/README.zh-TW.md)

## Features

- Write both posts and site settings entirely in Typst
- Set title, created date, updated date, description, tags, and draft status per post
- Auto-generate the home page, post pages, per-tag pages, and a tag index page
- Auto-generate RSS and sitemap
- Site search powered by [Pagefind](https://pagefind.app/)
- Publish to GitHub Pages as-is (workflow included)
- Rebuild article, home, tag, and 404 page structures under `theme/` without editing core
- Switch color schemes; add a favicon, images, extra CSS, and a custom domain
- Add template-owned extensions that combine Typst, CSS, and JavaScript without editing the core
- Generate PDF/EPUB outputs or run Python post-processing through `blog.py`
- Update only the blog engine (`vendor/typst-blog-core`) later

After creating a blog from this template, all files outside
`vendor/typst-blog-core` belong to the user and may be freely customized. Normal
engine fixes and support for newer Typst versions are delivered by updating the
core submodule alone; an existing template is not overwritten by that update.

## Requirements

| Tool | Version |
| --- | --- |
| Git | - |
| Typst | 0.15.0 or later |
| Python | 3.10 or later |
| Node.js | 20 or later |

Node.js is used to run Pagefind, which builds the search index. Even if you do not use search, the default GitHub Pages workflow uses Node.js.

## Quick Start

### 1. Create your repository and clone it

Create your own repository with GitHub's "Use this template" button, then clone it locally.

```sh
git clone --recurse-submodules https://github.com/USER/REPO.git
cd REPO
```

> [!NOTE]
> If you have already cloned and `vendor/typst-blog-core` is empty, run `git submodule update --init --recursive`.

### 2. Edit the site settings

Open `site.typ` and adjust it for your blog. Start with these:

| Key | Description |
| --- | --- |
| `title` | Blog name |
| `description` | Blog description |
| `base_url` | Public URL (no trailing `/`) |
| `github_repo` | GitHub repository URL of this blog |
| `language` | Primary language. Use `"ja"` as shorthand, or specify `lang`, `region`, and `script` separately |
| `theme.color_scheme` | `"dark"` or `"light"` |
| `posts_dir` | Where posts live. `"."` for the repository root, `"posts"` to keep them under `posts/` |
| `update_policy` | How the updated date is determined. `"git"` (default; derived from Git history) or `"manual"` (uses the post's `update`) |
| `author.name` | Author name |
| `author.bio` | Profile text |
| `author.socials` | Links to X, Misskey, GitHub, etc. |

For languages with regional or script variants, use Typst's language components instead of a BCP 47 string:

```typst
language: (
  lang: "zh",
  region: "TW",
  script: "hani",
)
```

`lang` is an ISO 639-1/2/3 code and is required. `region` is an optional ISO 3166-1 alpha-2 code. `script` is optional and defaults to `auto`. The generated HTML converts these values to a BCP 47 tag such as `zh-Hani-TW`.

When publishing on GitHub Pages, `base_url` looks like this:

```typst
base_url: "https://USER.github.io/REPO"
```

If you use a custom domain, set that domain's URL instead.

### 3. Create a post

```sh
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "A short description of the post." \
  --tag Typst
```

This creates the post directory and an `index.typ` with the metadata filled in.

### 4. Preview locally

```sh
python3 command.py preview
```

After the first build, a preview server starts at `http://localhost:8000`. Saving a file rebuilds the site automatically and reloads the browser.

### 5. Publish

Push to the `main` branch, and GitHub Actions builds and publishes to GitHub Pages automatically. See [Publish with GitHub Pages](#publish-with-github-pages) for details.

## Writing Posts

One post = one directory; the `index.typ` in each directory is the post body. Put images and references in the same directory.

### Create a new post

```sh
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "A short description of the post." \
  --tag Typst
```

- The created date is set to the day you run the command, and the post starts as a draft for safety
- Repeat `--tag` to add multiple tags
- Add `--publish` to start in the published state
- Use `--date 2026-07-19` to set the created date explicitly
- If a directory with the same name, a post with the same slug, or a reserved URL already exists, the command fails with an error

### Post file format

The top of a generated `index.typ` looks like this:

```typst
#import "/template.typ": post, calver

#show: post.with(
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "A short description of the post.",
  tags: ("Typst",),
  draft: true,
)

= Introduction

Write your content here.
```

The `post` show rule registers these values as build metadata and renders all
following content with the article layout.

| Key | Description |
| --- | --- |
| `slug` | The post URL. Human-readable Unicode text, including spaces, uppercase letters, punctuation, and symbols, is supported and percent-encoded in generated URLs. Path separators, control characters, and non-portable filesystem names are rejected. The example above is published at `/my-first-post/` |
| `title` | Post title |
| `create` | Created date |
| `update` | Updated date. Used only when `update_policy: "manual"` |
| `description` | Short description used in post lists and search results |
| `tags` | Tags. Even if a display name contains non-ASCII characters, spaces, or symbols, a tag page with a safe, unique URL is generated automatically |
| `extra` | Optional dictionary for custom, JSON-compatible metadata. Core preserves it without interpreting it and exposes it to themes and Python build callbacks |
| `draft` | `true` for draft, `false` to publish. Treated as a draft when omitted |

For example, a theme can implement a course concept without changing core by
setting `extra: (course: "typst-basics", lesson: 1)` and reading
`data.post.extra` in its renderer. Use strings, numbers, booleans, `none`,
arrays, and nested dictionaries inside `extra`.

### Drafts and publishing

Toggle with `draft`. Set `draft: false` on posts you want to publish.

- **In `preview`**: drafts are shown, with a "draft" badge on lists and post pages. Drafts get `noindex` and are excluded from search.
- **In `build` (production build)**: draft post pages are not generated, and drafts are excluded from lists, tag pages, RSS, and the sitemap.

### How the updated date works

By default (`update_policy: "git"`), the updated date is managed automatically.

- When you commit the post's `index.typ` — or images, references, and other files in the same post directory — the latest commit date becomes the updated date
- If the only commit is the one that first added the post, no updated date is shown
- If Git history is unavailable, a warning is shown, and the post's `update` value is used if present

To manage it manually, set `update_policy: "manual"` in `site.typ` and write the date in the post's `update`.

### Keeping posts under posts/

If you prefer to keep post directories under `posts/` instead of the repository root, set `posts_dir: "posts"` in `site.typ`. Both where `new` creates posts and where the build looks for posts become `posts/`.

## Previewing Locally

```sh
python3 command.py preview
```

- After the first build, a preview server starts at `http://localhost:8000`
- Saving Typst files, CSS, JavaScript, images, etc. rebuilds the site automatically and reloads the browser
- If port 8000 is in use, another free port is chosen — open the URL shown in the terminal
- Press `Ctrl+C` to stop

You can leave `base_url` in `site.typ` set to the public URL. `preview` only switches the base path for CSS, post links, and so on to `/` for the local server; canonical URLs, RSS, and the sitemap still use `base_url`.

To try search as well, build the search index in another terminal:

```sh
npx -y pagefind --site public
```

Run this command again after a post change triggers an automatic rebuild.

To inspect the exact production output, run `python3 command.py build`.

## Publish with GitHub Pages

This template ships with a GitHub Pages workflow. Setup is a one-time step.

1. Change `base_url` and the blog settings in `site.typ`
2. Open `Settings` → `Pages` on GitHub
3. Set `Source` under `Build and deployment` to `GitHub Actions`
4. Push your changes to the `main` branch

From then on, every push triggers GitHub Actions to build and deploy the contents of `public/` to GitHub Pages.

### Using a custom domain

1. Write your domain name in `static/CNAME` (or `CNAME` at the repository root)
2. Set `base_url` in `site.typ` to the custom domain as well

## Customizing the Site Theme

The complete HTML page structure belongs to `theme/`, not to the core submodule.
Edit `theme/pages/article.typ`, `home.typ`, `tag.typ`, `tags-index.typ`, or
`not-found.typ` to change a page. Shared layout, head, cards, and widgets live in
`theme/components/`; CSS and JavaScript live in `theme/static/`.

`theme/theme.typ` is the renderer contract used by the builder. Keep its five
renderer exports when reorganizing the implementation. The core supplies
resolved URLs, dates, navigation, and SEO data, while the theme decides how to
turn that data into HTML.

### Switch color schemes

Switch with `theme.color_scheme` in `site.typ`. `dark` and `light` are included.

```typst
theme: theme-config(color_scheme: "light")
```

### Create your own color scheme

Add a CSS file under `theme/static/color-schemes/` and set its file name without
the extension as `theme.color_scheme`.

```typst
// If you created theme/static/color-schemes/paper.css
theme: theme-config(color_scheme: "paper")
```

### Images, favicon, extra CSS

Files placed in `static/` are copied to `public/` as-is at build time.

### Add a blog extension

Extensions combine a Typst authoring function with its CSS and JavaScript. The template-owned alerts and YouTube embed use the same extension contract available to your own features. See [Create a Blog Extension](docs/extensions.md) for a complete example.

### Extend the build pipeline

Register per-post outputs, site-wide outputs, HTML processing, and final local
build steps in `blog.py`. See [Extend the build pipeline](docs/build-hooks.md).

## File Layout

Files you usually edit:

| Path | Description |
| --- | --- |
| `site.typ` | Site settings: blog name, public URL, author profile, color scheme, etc. |
| `theme/pages/` | Complete renderers for article, home, tag, tag-index, and 404 pages |
| `theme/components/` | Shared head, layout, card, and widget components |
| `theme/static/` | CSS and JavaScript used by the theme |
| `extensions.typ` | Enabled built-in and custom extensions |
| `extensions/` | Typst modules for built-in and custom extensions |
| `blog.py` | Python pipeline registration for extra outputs and build processing |
| `POST_DIR/index.typ` | Your posts |
| `example-post/index.typ` | Sample showing how to write a post |
| `static/` | Site-specific images, favicon, extension assets, `CNAME`, etc. |

Files you normally do not touch:

| Path | Description |
| --- | --- |
| `vendor/typst-blog-core` | The engine that generates the blog. Do not edit directly; upgrade it via the [update steps](#updating-the-blog-engine) |
| `.build/` | Private intermediate data regenerated and owned by the core build |
| `public/` | Build output, generated for publishing |

## Updating the Blog Engine

The engine that generates the blog is vendored as the `vendor/typst-blog-core` submodule. You can update just the engine later while keeping your posts and `site.typ` in your own repository.

We recommend updating by switching to a release tag.

```sh
cd vendor/typst-blog-core
git fetch --tags
git tag --sort=-version:refname   # List available versions
git checkout vYYYY.MM.DD          # Switch to the version you want
cd ../..
python3 command.py build
npx -y pagefind --site public
git add vendor/typst-blog-core
git commit -m "Update blog core to vYYYY.MM.DD"
```

`git add vendor/typst-blog-core` does not copy the contents of core; it records which version of core this blog uses.

After updating, check the site locally before pushing.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `typst-blog-core submodule is missing` appears / `vendor/typst-blog-core` is empty | Run `git submodule update --init --recursive` |
| A color-scheme CSS file cannot be found | Check that `theme.color_scheme` matches a CSS file under `theme/static/color-schemes/` |
| A post does not appear in the production build | Check that the post's `draft` is `false` (drafts are visible in `preview`) |
| Public URLs look wrong | Check `base_url` in `site.typ`. No trailing `/` |
| GitHub Pages cannot find core | Check that the checkout step in `.github/workflows/deploy.yml` has `submodules: recursive` |
| Search does not work | Run `npx -y pagefind --site public` first, then check again |

## About the Misskey Icon

The Misskey share button and sidebar icon are enabled by default. The icon in the template theme comes from Simple Icons and is provided by the Misskey project under CC-BY-NC-SA-4.0. If these terms do not fit your use case (e.g., commercial use), set `share.misskey` to `false` in `site.typ`.

## License

The code in this template is provided under the MIT License.

---

Document version: 2026.09.08.2
(When updating this README, also update the language files under `docs/` and keep the document version aligned.)
