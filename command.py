from __future__ import annotations

import sys
from pathlib import Path


ROOT_DIR = Path(__file__).resolve().parent
CORE_DIR = ROOT_DIR / "vendor" / "typst-blog-core"
CORE_PACKAGE = CORE_DIR / "typst_blog_core"


def _load_core_main():
    if not CORE_PACKAGE.is_dir():
        raise SystemExit(
            "typst-blog-core submodule is missing. "
            "Run: git submodule update --init --recursive"
        )
    sys.path.insert(0, str(CORE_DIR))
    from typst_blog_core.cli import main

    return main


def main() -> int:
    return _load_core_main()(root_dir=ROOT_DIR)


if __name__ == "__main__":
    raise SystemExit(main())
