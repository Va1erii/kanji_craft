"""Parse JmdictFurigana JSON into a DataFrame."""

import json
import logging
import tarfile
from pathlib import Path

import pandas as pd

log = logging.getLogger(__name__)


def parse_jmdict_furigana(tar_gz_path: Path) -> pd.DataFrame:
    """Parse JmdictFurigana.json.tar.gz → DataFrame.

    The tarball contains a single JSON file with UTF-8 BOM prefix.
    Each entry has: text, reading, furigana (array of {ruby, rt?} segments).

    Args:
        tar_gz_path: Path to JmdictFurigana.json.tar.gz.

    Returns:
        DataFrame with columns: text (str), reading (str), furigana (json str).
    """
    log.info("Parsing JmdictFurigana: %s", tar_gz_path)

    with tarfile.open(tar_gz_path, "r:gz") as tar:
        members = tar.getmembers()
        json_member = next(m for m in members if m.name.endswith(".json"))
        f = tar.extractfile(json_member)
        assert f is not None
        raw = f.read()

    # Strip UTF-8 BOM if present
    if raw.startswith(b"\xef\xbb\xbf"):
        raw = raw[3:]

    entries = json.loads(raw)
    log.info("Loaded %d furigana entries", len(entries))

    rows: list[dict] = []
    for entry in entries:
        rows.append({
            "text": entry["text"],
            "reading": entry["reading"],
            "furigana": json.dumps(entry["furigana"], ensure_ascii=False),
        })

    df = pd.DataFrame(rows, columns=["text", "reading", "furigana"])
    log.info("Parsed %d JmdictFurigana entries", len(df))
    return df
