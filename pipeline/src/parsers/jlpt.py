"""Parse JLPT kanji and vocabulary CSV files into DataFrames."""

import logging
from pathlib import Path

import pandas as pd

log = logging.getLogger(__name__)


def parse_jlpt_kanji(csv_path: Path) -> pd.DataFrame:
    """Parse jlpt_mapping.csv → DataFrame with columns: character, level.

    Args:
        csv_path: Path to jlpt_mapping.csv (2 columns: kanji, level).

    Returns:
        DataFrame with string `character` and int32 `level`.
    """
    log.info("Parsing JLPT kanji mapping: %s", csv_path)
    df = pd.read_csv(csv_path, dtype={"kanji": str, "level": "int32"})
    df = df.rename(columns={"kanji": "character"})
    log.info("Parsed %d JLPT kanji entries", len(df))
    return df


def parse_jlpt_vocab(vocab_dir: Path) -> pd.DataFrame:
    """Parse n1.csv–n5.csv → single DataFrame with columns: expression, reading, level.

    Level is derived from filename. Duplicates on (expression, reading) are resolved
    by keeping the easiest level (highest numeric value).

    Args:
        vocab_dir: Directory containing n1.csv through n5.csv.

    Returns:
        DataFrame with string `expression`, string `reading`, int32 `level`.
    """
    log.info("Parsing JLPT vocabulary from: %s", vocab_dir)
    frames: list[pd.DataFrame] = []
    for level in range(1, 6):
        csv_path = vocab_dir / f"n{level}.csv"
        df = pd.read_csv(
            csv_path,
            usecols=["expression", "reading"],
            dtype=str,
        )
        df["level"] = level
        frames.append(df)
        log.info("  N%d: %d entries", level, len(df))

    combined = pd.concat(frames, ignore_index=True)

    # Fill empty reading with expression (kana-only words)
    combined["reading"] = combined["reading"].fillna(combined["expression"])
    mask = combined["reading"] == ""
    combined.loc[mask, "reading"] = combined.loc[mask, "expression"]

    # Deduplicate: keep easiest level (max value)
    combined = (
        combined.sort_values("level", ascending=False)
        .drop_duplicates(subset=["expression", "reading"], keep="first")
        .sort_values(["level", "expression"])
        .reset_index(drop=True)
    )
    combined["level"] = combined["level"].astype("int32")

    log.info("Parsed %d unique JLPT vocab entries", len(combined))
    return combined
