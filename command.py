from __future__ import annotations

import sys
from pathlib import Path


ROOT_DIR = Path(__file__).resolve().parent
CORE_DIR = ROOT_DIR / "vendor" / "typst-blog-core"
CORE_PACKAGE = CORE_DIR / "typst_blog_core"
# Defaults for preview; command-line --host and --port take precedence.
PREVIEW_HOST = "localhost"
PREVIEW_PORT = 8000


def _load_core_api():
    if not CORE_PACKAGE.is_dir():
        raise SystemExit(
            "typst-blog-core submodule is missing. "
            "Run: git submodule update --init --recursive"
        )
    sys.path.insert(0, str(CORE_DIR))
    from typst_blog_core import api as core_api

    return core_api


def main() -> int:
    return _load_core_api().main(
        root_dir=ROOT_DIR,
        preview_host=PREVIEW_HOST,
        preview_port=PREVIEW_PORT,
    )


if __name__ == "__main__":
    raise SystemExit(main())
