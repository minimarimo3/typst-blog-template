"""Site-specific build pipeline."""


def build_og_image(task) -> None:
    """Build the default social preview image from article metadata."""
    if task.post is None:
        raise ValueError("the OG image pipeline requires a post")
    task.run_typst(
        "compile",
        "--root",
        ".",
        "--ppi",
        "72",
        "--input",
        f"title={task.post.title}",
        "--input",
        f"description={task.post.description}",
        "--input",
        f"site-title={task.site['title']}",
        "tools/og-image.typ",
        task.relative(task.destination),
    )


def configure(pipeline) -> None:
    pipeline.post_output(
        id="og-image",
        filename="og.png",
        label="Social preview",
        media_type="image/png",
        build=build_og_image,
    )
