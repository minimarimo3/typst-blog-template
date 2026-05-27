# Typst Blog Template

Document version: 2026.05.28.2

Languages: [日本語](../README.md) | English | [한국어](README.ko.md) | [简体中文](README.zh-CN.md) | [繁體中文（台灣）](README.zh-TW.md)

This is a template for writing posts in Typst and publishing them as a static blog.
When you write posts and build the site, it generates the home page, post pages, tag pages, RSS, sitemap, and a search index.

This README is for people who want to use the template as their own blog.
If you want implementation details, read the README in `vendor/typst-blog-core`.

When updating this README, update the language files under `docs/` as well and keep the document version aligned.

## What You Can Do

- Write blog posts with Typst syntax.
- Set a title, created date, updated date, description, tags, and draft status per post.
- Generate the home page, post pages, tag pages, and tag index.
- Generate RSS and sitemap files.
- Add site search with Pagefind.
- Publish directly to GitHub Pages.
- Add color themes, favicon, images, CSS, and a `CNAME` for a custom domain.
- Update only the blog engine later.

## Requirements

- Git
- Typst 0.14.2 or later
- Python 3.10 or later
- Node.js 20 or later

Node.js is used to run `pagefind` for the search index.
Even if you do not use search locally, the default GitHub Pages workflow uses Node.js.

## Files You Usually Edit

These are the files you will usually touch:

- `site.typ`: site title, description, public URL, author profile, theme, and other site settings
- `example-post/index.typ`: sample post
- `your-post-directory/index.typ`: your own posts
- `static/`: images, favicon, extra CSS, custom themes, `CNAME`, and other static files

These usually do not need manual edits:

- `vendor/typst-blog-core`: the blog engine. Normally update it through the update steps instead of editing it directly.
- `typst/generated/posts.typ`: generated post data. Do not edit it by hand.
- `public/`: build output. Do not edit it by hand.

## Getting Started

Create your own repository from this repository with GitHub's template feature.
Then clone it locally.

```sh
git clone --recurse-submodules https://github.com/USER/REPO.git
cd REPO
```

If you already cloned the repository and `vendor/typst-blog-core` is empty, run:

```sh
git submodule update --init --recursive
```

Next, open `site.typ` and change it for your blog.
Start with these fields:

- `title`: blog name
- `description`: blog description
- `base_url`: public URL
- `github_repo`: GitHub repository URL for this blog
- `language`: primary language
- `theme`: `dark` or `light`
- `author.name`: author name
- `author.bio`: profile text
- `author.socials`: links such as X, Misskey, and GitHub

For GitHub Pages, `base_url` usually looks like this:

```typst
base_url: "https://USER.github.io/REPO"
```

If you use a custom domain, set `base_url` to that domain.

## Writing Posts

Each post gets its own directory with an `index.typ` file inside.
The easiest start is to copy `example-post/`.

```sh
cp -R example-post my-first-post
```

Write the post metadata at the top of the post file.

```typst
#import "/template.typ": article, calver, post-meta

#let meta = post-meta(
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "A short description.",
  tags: ("Typst",),
  draft: false,
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= Hello

Write the post body here.
```

Common fields:

- `slug`: becomes the post URL. The example above is published at `/my-first-post/`.
- `title`: post title.
- `create`: created date.
- `update`: updated date. Add it only when needed.
- `description`: short description used in post lists and search results.
- `tags`: tags. Tag pages are generated automatically.
- `draft`: `true` means draft, `false` means published.

If `draft` is omitted, the post is treated as a draft.
Set `draft: false` for posts you want to publish.

## Preview Locally

Build the blog:

```sh
python3 build.py
```

To test search as well, build the search index:

```sh
npx -y pagefind --site public
```

The output is written to `public/`.
Serve it locally with:

```sh
python3 -m http.server 8000 -d public
```

Then open `http://localhost:8000` in your browser.

## Publish With GitHub Pages

This template includes a GitHub Pages workflow.

1. Update `site.typ`, especially `base_url` and the blog information.
2. Open `Settings` -> `Pages` on GitHub.
3. Set `Build and deployment` -> `Source` to `GitHub Actions`.
4. Push your changes to the `main` branch.

After you push, GitHub Actions builds the site and deploys the contents of `public/` to GitHub Pages.

For a custom domain, put the domain name in `static/CNAME` or a root-level `CNAME`.
Also update `base_url` in `site.typ` to match that domain.

## Change The Look

Switch themes with `theme` in `site.typ`.

```typst
theme: "light"
```

The built-in themes are `dark` and `light`.

Put images, favicon files, extra CSS, and custom themes under `static/`.
Everything in `static/` is copied to `public/` during the build.

For a custom theme, add a file such as `static/themes/my-theme.css` and set it in `site.typ`.

```typst
theme: "my-theme"
```

## Update The Blog Engine

The reusable blog engine is included as `vendor/typst-blog-core`.
Your posts and `site.typ` stay in your repository, so you can update only the generation logic later.

Prefer switching the core to a release tag.

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

Replace `vYYYY.MM.DD` with the release tag you want to use.

`git add vendor/typst-blog-core` does not copy the whole core into the parent repository.
It records which core version this blog uses.

After updating, preview locally before pushing.

## Common Tasks

Add a new post:

```sh
cp -R example-post new-post
```

Turn a post back into a draft:

```typst
draft: true
```

Publish a post:

```typst
draft: false
```

Rebuild the search index:

```sh
npx -y pagefind --site public
```

Fetch the submodule again:

```sh
git submodule update --init --recursive
```

## Troubleshooting

- `typst-blog-core submodule is missing`: run `git submodule update --init --recursive`.
- Empty `vendor/typst-blog-core`: the submodule has not been fetched. Run `git submodule update --init --recursive`.
- `site.theme '...' does not exist`: check `theme` in `site.typ` and the file names under `static/themes/`.
- A post does not appear: make sure the post has `draft: false`.
- Public URLs look wrong: check `base_url` in `site.typ`. It should not end with `/`.
- GitHub Pages cannot find the core: make sure `.github/workflows/deploy.yml` uses `submodules: recursive` in the checkout step.
- Search does not work: run `npx -y pagefind --site public` and check again.

## Misskey Icon

The Misskey share button and sidebar icon are enabled by default.
The bundled Misskey icon lives in the core submodule and comes from Simple Icons under CC-BY-NC-SA-4.0 from the Misskey project.
If that license does not fit your use case, set `share.misskey` to `false` in `site.typ`.

## License

MIT License.
