# Typst Blog Template

Documentation version: 2026.05.25.3

Language: [日本語](../README.md) | English | [한국어](README.ko.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md)

A small static site template for writing a blog with Typst's HTML output.
Post content, post metadata, and site settings are managed in Typst, and `build.py` generates HTML, RSS, and a sitemap.
Site search is powered by a static Pagefind index.

When you update this README, update the localized files in `docs/` and keep their documentation version in sync.

## Requirements

- Typst 0.14.2 or later
- Python 3.10 or later
- Node.js 20 or later (used to generate the Pagefind search index)

## Quick Start

```sh
python3 build.py
npx -y pagefind --site public
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
- `theme`: theme preset name to use (`dark` by default)
- `author`: author name, profile, and social links
- `analytics.cloudflare_token`: set this only when using Cloudflare Web Analytics
- `feedback.google_form_url` and `feedback.entry_id`: set these only when using Google Forms
- `share`: display settings for X, Misskey, and copy share buttons

## Theme Settings

Colors, card backgrounds, and other visual theme values are managed by CSS files in `static/themes/`.
The default theme is `static/themes/dark.css`. To switch to the light theme, change `theme` in `site.typ`.

```typst
theme: "light"
```

To create a custom theme, add `static/themes/my-theme.css`, define the same CSS variables as `dark.css` or `light.css`, and set `theme: "my-theme"` in `site.typ`.
Theme names may only contain letters, numbers, `_`, and `-`.

## Font Settings

The `fonts` block in `site.typ` manages all fonts for body text, headings, code, math, and any custom roles.
Every entry that has a `web` field is automatically loaded from Google Fonts, and each becomes available as a CSS variable named `--font-{key}`.

| Key | Description |
|-----|-------------|
| `main` | Body font (required) |
| `heading` | Heading font (falls back to `main` when omitted) |
| `code` | Code block font (required) |
| `math` | Math font. PDF only — math is baked into SVG on the web, so set `web: none` |
| Any name | Add any key such as `accent`; the CSS variable `--font-{key}` is generated automatically |

Fields for each entry:

- `pdf`: Font name for PDF output (string, or an array for a fallback chain)
- `web`: Google Fonts name (`none` to skip web loading)
- `weights`: Weights to request from Google Fonts (e.g. `"400;700"`, `"300..700"`)
- `fallback`: CSS generic font family (e.g. `"serif"`, `"sans-serif"`, `"monospace"`)

To change the font for a specific word inside a post, use the `text` function:

```typst
#text(font: "Zen Antique")[special word]
```

Register the font in `site.fonts` to ensure it is loaded on the web as well.

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

The workflow runs `python3 build.py` and `npx -y pagefind --site public`, then deploys `public/` to GitHub Pages.

## Misskey Icon Notice

The Misskey share button and sidebar Misskey icon are enabled by default.
The bundled Misskey icon comes from Simple Icons and is provided by the Misskey project under CC-BY-NC-SA-4.0.
If those terms do not fit your use case, such as commercial use, remove or replace the Misskey icon in `typst/components/widgets.typ` and set `share.misskey` to `false` in `site.typ`.

## License

The code in this template is provided under the MIT License.
