"""Site-specific build pipeline."""

from extensions.python import build_og_image, externalize_content_images


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
