"""Site-specific build pipeline.

Register extra outputs and build hooks in configure(). See docs/build-hooks.md
or docs/build-hooks.ja.md for complete PDF, EPUB, and post-processing examples.
"""


def configure(pipeline) -> None:
    # The default site needs no custom build stages.
    pass
