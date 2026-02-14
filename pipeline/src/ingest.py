"""Phase 1: Ingestion — parse source XML/CSV/JSON into Parquet files.

Reads from sources/ and writes to pipeline/data/parquet/.
No transformation — faithful columnar representation of source data.

Usage:
    uv run python -m src.ingest
"""

import logging
import time
from pathlib import Path

import pandas as pd

from src.parsers.jlpt import parse_jlpt_kanji, parse_jlpt_vocab
from src.parsers.jmdict import parse_jmdict, parse_jmdict_examples
from src.parsers.jmdict_furigana import parse_jmdict_furigana
from src.parsers.kanjidic import parse_kanjidic
from src.parsers.kanjivg import parse_kanjivg

log = logging.getLogger(__name__)

SOURCES_DIR = Path(__file__).resolve().parent.parent.parent / "sources"
OUTPUT_DIR = Path(__file__).resolve().parent.parent / "data" / "parquet"


def write_parquet_atomic(df: pd.DataFrame, path: Path) -> None:
    """Write a DataFrame to Parquet using temp file + rename for atomicity."""
    tmp = path.with_suffix(".parquet.tmp")
    df.to_parquet(tmp, engine="pyarrow", index=False)
    tmp.rename(path)
    log.info("Wrote %s (%d rows)", path.name, len(df))


def _find_one(pattern: str, base: Path) -> Path:
    """Find exactly one directory matching a glob pattern under base."""
    matches = sorted(base.glob(pattern))
    if not matches:
        raise FileNotFoundError(f"No directory matching '{pattern}' in {base}")
    return matches[-1]  # Latest version if multiple


def discover_sources(sources_dir: Path) -> dict[str, Path]:
    """Find source folders matching expected patterns.

    Returns:
        Dict mapping source name to resolved path of the required file(s).

    Raises:
        FileNotFoundError: If any required source is missing.
    """
    missing: list[str] = []
    sources: dict[str, Path] = {}

    # KANJIDIC
    try:
        kd_dir = _find_one("kanjidic2-*/", sources_dir)
        kd_file = kd_dir / "kanjidic2.xml.gz"
        if not kd_file.exists():
            missing.append(f"kanjidic2.xml.gz in {kd_dir}")
        else:
            sources["kanjidic"] = kd_file
    except FileNotFoundError:
        missing.append("kanjidic2-*/ directory")

    # KanjiVG
    try:
        kvg_dir = _find_one("kanjivg-*/", sources_dir)
        kvg_files = list(kvg_dir.glob("kanjivg-*.xml.gz"))
        if not kvg_files:
            missing.append(f"kanjivg-*.xml.gz in {kvg_dir}")
        else:
            sources["kanjivg"] = kvg_files[0]
    except FileNotFoundError:
        missing.append("kanjivg-*/ directory")

    # JMdict
    try:
        jm_dir = _find_one("jmdict-*/", sources_dir)
        jm_file = jm_dir / "JMdict.gz"
        jm_examp = jm_dir / "JMdict_e_examp.gz"
        if not jm_file.exists():
            missing.append(f"JMdict.gz in {jm_dir}")
        else:
            sources["jmdict"] = jm_file
        if not jm_examp.exists():
            missing.append(f"JMdict_e_examp.gz in {jm_dir}")
        else:
            sources["jmdict_examples"] = jm_examp
    except FileNotFoundError:
        missing.append("jmdict-*/ directory")

    # JLPT kanji
    jlpt_dir = sources_dir / "jlpt_mapping"
    jlpt_file = jlpt_dir / "jlpt_mapping.csv"
    if not jlpt_file.exists():
        missing.append("jlpt_mapping/jlpt_mapping.csv")
    else:
        sources["jlpt_kanji"] = jlpt_file

    # JLPT vocab
    jlpt_vocab_dir = sources_dir / "jlpt_vocab_mapping"
    if not jlpt_vocab_dir.is_dir():
        missing.append("jlpt_vocab_mapping/ directory")
    else:
        for level in range(1, 6):
            f = jlpt_vocab_dir / f"n{level}.csv"
            if not f.exists():
                missing.append(f"jlpt_vocab_mapping/n{level}.csv")
        if not any(f"n{i}.csv" in str(m) for m in missing for i in range(1, 6)):
            sources["jlpt_vocab"] = jlpt_vocab_dir

    # JmdictFurigana
    try:
        jf_dir = _find_one("jmdictfurigana-*/", sources_dir)
        jf_file = jf_dir / "JmdictFurigana.json.tar.gz"
        if not jf_file.exists():
            missing.append(f"JmdictFurigana.json.tar.gz in {jf_dir}")
        else:
            sources["jmdict_furigana"] = jf_file
    except FileNotFoundError:
        missing.append("jmdictfurigana-*/ directory")

    if missing:
        raise FileNotFoundError(
            "Missing required sources:\n" + "\n".join(f"  - {m}" for m in missing)
        )

    return sources


def main() -> None:
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    )

    start = time.perf_counter()
    log.info("Phase 1: Ingesting from %s → %s", SOURCES_DIR, OUTPUT_DIR)

    sources = discover_sources(SOURCES_DIR)
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    # Parse and write each source
    steps: list[tuple[str, callable, Path]] = [
        ("kanjidic", lambda: parse_kanjidic(sources["kanjidic"]), OUTPUT_DIR / "kanjidic.parquet"),
        ("kanjivg", lambda: parse_kanjivg(sources["kanjivg"]), OUTPUT_DIR / "kanjivg.parquet"),
        ("jmdict", lambda: parse_jmdict(sources["jmdict"]), OUTPUT_DIR / "jmdict.parquet"),
        (
            "jmdict_examples",
            lambda: parse_jmdict_examples(sources["jmdict_examples"]),
            OUTPUT_DIR / "jmdict_examples.parquet",
        ),
        (
            "jlpt_kanji",
            lambda: parse_jlpt_kanji(sources["jlpt_kanji"]),
            OUTPUT_DIR / "jlpt_kanji.parquet",
        ),
        (
            "jlpt_vocab",
            lambda: parse_jlpt_vocab(sources["jlpt_vocab"]),
            OUTPUT_DIR / "jlpt_vocab.parquet",
        ),
        (
            "jmdict_furigana",
            lambda: parse_jmdict_furigana(sources["jmdict_furigana"]),
            OUTPUT_DIR / "jmdict_furigana.parquet",
        ),
    ]

    for name, parser, output_path in steps:
        try:
            step_start = time.perf_counter()
            df = parser()
            write_parquet_atomic(df, output_path)
            elapsed = time.perf_counter() - step_start
            log.info("  %s: done in %.1fs", name, elapsed)
        except Exception:
            log.exception("Failed to parse %s", name)
            raise

    elapsed = time.perf_counter() - start
    log.info("Phase 1 complete in %.1fs", elapsed)


if __name__ == "__main__":
    main()
