"""HTML post-processing for images emitted by Typst."""

import base64
import binascii
import hashlib
import re
from urllib.parse import quote


IMAGE_ASSET_EXTENSIONS = frozenset(
    {".avif", ".gif", ".jpeg", ".jpg", ".png", ".svg", ".webp"}
)
EMBEDDED_IMAGE_RE = re.compile(
    r"(?P<prefix>\bsrc\s*=\s*)(?P<quote>['\"])"
    r"data:image/[A-Za-z0-9.+-]+(?:;[^,;'\"]+)*;base64,"
    r"(?P<payload>[A-Za-z0-9+/]*={0,2})(?P=quote)",
    re.IGNORECASE,
)


def externalize_content_images(task) -> None:
    """Point embedded Typst images at byte-identical copied assets."""
    html = task.path.read_text(encoding="utf-8")
    if "data:image/" not in html.lower():
        return

    assets_by_digest = {}
    for asset in task.path.parent.rglob("*"):
        if not asset.is_file() or asset.suffix.lower() not in IMAGE_ASSET_EXTENSIONS:
            continue
        digest = hashlib.sha256(asset.read_bytes()).digest()
        assets_by_digest.setdefault(digest, []).append(asset)

    def replace(match) -> str:
        try:
            digest = hashlib.sha256(
                base64.b64decode(match.group("payload"), validate=True)
            ).digest()
        except (binascii.Error, ValueError):
            return match.group(0)
        candidates = assets_by_digest.get(digest)
        if not candidates:
            return match.group(0)
        asset = min(
            candidates,
            key=lambda path: (
                len(path.relative_to(task.path.parent).parts),
                path.relative_to(task.path.parent).as_posix(),
            ),
        )
        relative = asset.relative_to(task.path.parent)
        url = "/".join(quote(part, safe="-._~") for part in relative.parts)
        delimiter = match.group("quote")
        return f"{match.group('prefix')}{delimiter}{url}{delimiter}"

    rewritten = EMBEDDED_IMAGE_RE.sub(replace, html)
    if rewritten != html:
        task.path.write_text(rewritten, encoding="utf-8")
