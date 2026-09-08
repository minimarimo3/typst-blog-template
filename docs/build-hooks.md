# Extend the build pipeline

The root `blog.py` can register Python processing without modifying
`vendor/typst-blog-core`. The core loads `configure(pipeline)` afresh for every
production build and preview rebuild.

There are four extension points:

| Registration | Runs | Typical use |
| --- | --- | --- |
| `post_output` | Once per included post, before HTML | PDF or per-post EPUB |
| `site_output` | Once before HTML | Whole-site EPUB, JSON, or an archive |
| `after_html` | Once for every HTML file after the site is assembled | Minification or HTML rewriting |
| `post_build` | After all files and `after_html` hooks are complete | Pagefind, checksums, or an output manifest |

Hooks run in registration order. An exception, a non-zero subprocess exit, or
an output callback that does not create its declared file fails the build.
Declared output paths are validated before `public/` is changed and may not
escape their output directory or collide with posts, static assets, or another
generated route.

## Generate and link a PDF for every post

Replace the root `blog.py` with:

```python
def build_pdf(task):
    task.run_typst(
        "compile",
        "--root",
        ".",
        task.relative(task.post.source_file),
        task.relative(task.destination),
    )


def configure(pipeline):
    pipeline.post_output(
        id="pdf",
        filename="article.pdf",
        label="PDF",
        media_type="application/pdf",
        build=build_pdf,
        modes={"build", "preview"},
    )
```

The file for a post named `hello` is written to
`public/hello/article.pdf`. Its renderer receives the following normalized
entry in `data.post.outputs`:

```typst
(
  id: "pdf",
  label: "PDF",
  media-type: "application/pdf",
  path: "/hello/article.pdf",
  url: "/hello/article.pdf",
)
```

`path` is the public path without a preview base path. `url` includes the
current base path and is normally the right value for a theme link. The default
theme displays these outputs beside the edit-history link. A replacement theme
can place them anywhere by iterating over `data.post.outputs`.

The default mode for extra outputs is `{"build"}`. Include `"preview"`
explicitly when generating the output on every preview rebuild is useful and
fast enough.

## Generate one site-wide output

Use `site_output` when the result belongs to the whole blog:

```python
def build_epub(task):
    task.run(["python3", "tools/build_epub.py", task.relative(task.destination)])


def configure(pipeline):
    pipeline.site_output(
        id="epub",
        filename="downloads/blog.epub",
        label="EPUB",
        media_type="application/epub+zip",
        build=build_epub,
    )
```

Site-wide entries are available to the home renderer as `data.outputs`.

## Process HTML

`after_html` receives every `.html` file under `public/`, including copied
static HTML files. It runs in both build and preview modes unless `modes` is
specified.

```python
def add_marker(task):
    source = task.path.read_text(encoding="utf-8")
    task.path.write_text(source.replace("</body>", "<!-- built --></body>"), encoding="utf-8")


def configure(pipeline):
    pipeline.after_html(id="build-marker", run=add_marker)
```

`task.output_path` is `/` for the home page and otherwise the path below
`public/`, such as `/hello/index.html`.

## Run a final local build step

`post_build` is intended for processing the completed local artifact:

```python
def build_search(task):
    task.run(["npx", "-y", "pagefind@1.5.2", "--site", "public"])


def configure(pipeline):
    pipeline.post_build(id="pagefind", run=build_search)
```

Its default mode is `{"build"}`, so it does not run repeatedly during preview.

`post_build` means that the local `public/` directory is complete; it does not
mean that GitHub Pages deployment succeeded. Send Discord notifications from a
workflow step after `actions/deploy-pages`, where the deployed URL and protected
webhook secret are available.

## Callback context

All callbacks receive absolute `root_dir`, `build_dir`, and `output_dir` paths,
the mode (`"build"` or `"preview"`), read-only-by-contract site data, and the
included posts. `post_output` also receives `task.post` and `task.destination`.
Custom post metadata is available as `task.post.extra`; core preserves this
JSON-compatible dictionary without assigning meaning to its keys.

Use `task.run([...])` for subprocesses and `task.run_typst(...)` for Typst. Both
run from the blog root and fail the build on a non-zero exit status. The core
does not install Python or Node dependencies automatically; pin and install any
additional build dependencies in the repository's own workflow.

`blog.py` is trusted code with the same filesystem and network permissions as
the build command. Review third-party hook code before using it, and do not make
deployment secrets available to pull-request builds.
