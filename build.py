from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent
CORE_DIR = ROOT_DIR / "vendor" / "typst-blog-core"
CORE_BUILD = CORE_DIR / "build.py"


def _load_core_build():
    if not CORE_BUILD.is_file():
        raise SystemExit(
            "typst-blog-core submodule is missing. "
            "Run: git submodule update --init --recursive"
        )

    spec = importlib.util.spec_from_file_location("typst_blog_core_build", CORE_BUILD)
    if spec is None or spec.loader is None:
        raise SystemExit(f"Could not load build engine from {CORE_BUILD}")

    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    previous_dont_write_bytecode = sys.dont_write_bytecode
    sys.dont_write_bytecode = True
    try:
        spec.loader.exec_module(module)
    finally:
        sys.dont_write_bytecode = previous_dont_write_bytecode
    return module


def main() -> None:
    core_build = _load_core_build()
    core_build.build(root_dir=ROOT_DIR)


if __name__ == "__main__":
    main()
