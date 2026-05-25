# Typst Blog Template

Documentation version: 2026.05.25

Language: [日本語](../README.md) | English | [한국어](README.ko.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md)

A small static site template for writing a blog with Typst's HTML output.
Post content, post metadata, and site settings are managed in Typst, and `build.py` generates HTML, RSS, and a sitemap.

When you update this README, update the localized files in `docs/` and keep their documentation version in sync.

## Requirements

- Typst 0.14.2 or later
- Python 3.10 or later

## Quick Start

```sh
python3 build.py
```

Generated files are written to `public/`.
To preview the site locally, serve `public/` with any static file server.

```sh
python3 -m http.server 8000 -d public
```

## Site Settings

`site.typ` is the source of truth for site-wide settings.
Edit these values first:

- `title`: blog name
- `description`: blog description
- `base_url`: public URL
- `author`: author name, profile, and social links
- `analytics.cloudflare_token`: set this only when using Cloudflare Web Analytics
- `feedback.google_form_url` and `feedback.entry_id`: set these only when using Google Forms
- `share`: display settings for X, Misskey, and copy share buttons

## Writing Posts

Create a directory for each post and put an `index.typ` file inside it.
The easiest way to start is to copy `example-post/index.typ`.

```typst
#import "../template.typ": article, calver

#let meta = (
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "A short description of the post.",
  tags: ("Typst",),
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= Introduction

Write your post here.
```

`slug` becomes the public URL. The example above is output to `/my-first-post/`.
`create` uses CalVer. You can write a two-digit year such as `calver(26, 1, 1)`. Year, month, and day are required; only the patch number can be omitted, and it is treated as `0`.
Add `draft: true` to the metadata to exclude a post from the post list, RSS, sitemap, and HTML output.

## Publishing with GitHub Pages

This template includes a workflow for GitHub Pages.

1. Create a repository from this template.
2. Edit `site.typ` for your site.
3. In GitHub, open `Settings` -> `Pages` -> `Build and deployment`, then set `Source` to `GitHub Actions`.
4. Push to the `main` branch.

The workflow runs `python3 build.py` and deploys `public/` to GitHub Pages.

## Misskey Icon Notice

The Misskey share button and sidebar Misskey icon are enabled by default.
The bundled Misskey icon comes from Simple Icons and is provided by the Misskey project under CC-BY-NC-SA-4.0.
If those terms do not fit your use case, such as commercial use, remove or replace the Misskey icon in `typst/components/widgets.typ` and set `share.misskey` to `false` in `site.typ`.

## License

The code in this template is provided under the MIT License.
