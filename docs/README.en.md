# Typst Blog Template

Document version: 2026.07.19.5

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
- Typst 0.15.0 or later
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
- `posts_dir`: post directory; use `"."` for the blog root or `"posts"` for `posts/`
- `update_policy`: how update dates are determined. The default `"git"` derives them from each post directory's Git history; `"manual"` uses the post's `update` value.
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
Create the directory and a metadata-filled `index.typ` together with:

```sh
python3 command.py new my-first-post \
  --title "My First Post" \
  --description "A short description." \
  --tag Typst
```

The command uses today as the creation date and creates a draft by default. Repeat `--tag` to add more tags, or add `--publish` only when the post should be published immediately. Use `--date 2026-07-19` to set another creation date. Existing directories, duplicate slugs, and reserved URLs are rejected without overwriting files.

To keep articles under `posts/`, set `posts_dir: "posts"` in `site.typ`. Both the `new` destination and the build's post discovery scope then use `posts/`. Omit it or use `"."` to keep using the blog root.

The generated post starts with metadata in this form:

```typst
#import "/template.typ": article, calver, post-meta

#let meta = post-meta(
  slug: "my-first-post",
  title: "My First Post",
  create: calver(2026, 1, 1),
  description: "A short description.",
  tags: ("Typst",),
  draft: true,
)

#metadata(meta) <post-meta>
#show: article.with(..meta)

= Hello

Write the post body here.
```

Common fields:

- `slug`: becomes the post URL. Use lowercase ASCII letters and numbers separated by single hyphens. The example above is published at `/my-first-post/`.
- `title`: post title.
- `create`: created date.
- `update`: updated date used when `update_policy: "manual"` is selected.
- `description`: short description used in post lists and search results.
- `tags`: tags. Japanese text, spaces, and symbols may be used in display names; safe, non-conflicting tag-page URLs are generated automatically.
- `draft`: `true` means draft, `false` means published.

If `draft` is omitted, the post is treated as a draft.
Set `draft: false` for posts you want to publish.

Update dates are automatic by default. Committing changes to a post's `index.typ`, images, references, or other files in the same post directory makes the latest commit date its update date. No update date is shown when the post only has its initial commit. If Git history is unavailable, the build warns and falls back to the post's authored `update` value when present.

## Preview Locally

Run:

```sh
python3 command.py preview
```

`preview` includes posts with `draft: true` and marks them with a Draft badge on lists and post pages. Drafts receive `noindex` metadata and are excluded from Pagefind. Regular `build` and GitHub Pages deployment do not generate draft post pages, list entries, tag pages, RSS entries, or sitemap entries.

After the first build, the preview server starts at `http://localhost:8000`. Saving a Typst file, CSS, JavaScript, image, or another site source automatically rebuilds the site and reloads open browser pages. If port 8000 is in use, another available port is selected; open the URL shown in the terminal. Press `Ctrl+C` to stop it.

Keep `base_url` in `site.typ` set to the public URL. `preview` changes only the base path used by CSS, post links, and other site resources to `/` for the local server. Canonical URLs, RSS, and sitemap still use `base_url`.

To test search as well, build the search index in another terminal. Run it again after an automatic rebuild caused by a post change.

```sh
npx -y pagefind --site public
```

To produce the deployable build, or to check its public paths, run `python3 command.py build`.

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
python3 command.py build
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
python3 command.py new new-post \
  --title "New Post" \
  --description "A short description."
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
- A post is missing from a published build: make sure the post has `draft: false`. Drafts remain visible in `preview`.
- Public URLs look wrong: check `base_url` in `site.typ`. It should not end with `/`.
- GitHub Pages cannot find the core: make sure `.github/workflows/deploy.yml` uses `submodules: recursive` in the checkout step.
- Search does not work: run `npx -y pagefind --site public` and check again.

## Misskey Icon

The Misskey share button and sidebar icon are enabled by default.
The bundled Misskey icon lives in the core submodule and comes from Simple Icons under CC-BY-NC-SA-4.0 from the Misskey project.
If that license does not fit your use case, set `share.misskey` to `false` in `site.typ`.

## License

MIT License.
