"""Site-specific build pipeline."""

import shutil

from extensions.python import build_og_image, externalize_content_images


PAGEFIND_VERSION = "1.5.2"


def build_search(task) -> None:
    if shutil.which("npx") is None:
        print("Pagefind skipped: npx is not available.")
        return
    task.run(
        ["npx", "-y", f"pagefind@{PAGEFIND_VERSION}", "--site", "public"]
    )


def configure(pipeline) -> None:
    pipeline.post_output(
        id="og-image",
        filename="og.png",
        label="Social preview",
        media_type="image/png",
        build=build_og_image,
    )
    # Production benefits from cacheable files; keeping this hook out of preview
    # preserves core's incremental preview rebuilds.
    pipeline.after_html(
        id="externalize-content-images",
        run=externalize_content_images,
        modes=("build",),
    )
    pipeline.post_build(id="pagefind-build", run=build_search)
    pipeline.preview_start(id="pagefind-preview", run=build_search)
