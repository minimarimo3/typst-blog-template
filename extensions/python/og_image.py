"""Build the template's default social preview image."""


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
