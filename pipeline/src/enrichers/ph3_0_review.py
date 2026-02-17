"""Generate review files for radical classification decisions.

Standalone script — reads existing CSVs to produce:
  1. radical_classification_review.csv  — classification + parent_kanji column
  2. kanji_decomposition.csv           — kanji-centric component view

Usage:
    cd pipeline && uv run python -m src.enrichers.ph3_0_review
"""

from __future__ import annotations

import logging
from pathlib import Path

import pandas as pd

from src.extractors.shared import write_csv_atomic

log = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Lookups
# ---------------------------------------------------------------------------

def _build_parent_kanji_lookup(csv_dir: Path) -> dict[str, list[str]]:
    """Build {master_symbol: [parent_kanji, ...]} from kanji_components.csv."""
    comp = pd.read_csv(csv_dir / "kanji_components.csv", dtype=str)
    lookup: dict[str, list[str]] = {}
    for _, row in comp.iterrows():
        symbol = row["master_symbol"]
        kanji = row["character"]
        lookup.setdefault(symbol, []).append(kanji)
    return lookup


# ---------------------------------------------------------------------------
# Output 1: enriched classification
# ---------------------------------------------------------------------------

def _enrich_classification(csv_dir: Path) -> pd.DataFrame:
    """Add parent_kanji column to radical_classification."""
    cls = pd.read_csv(csv_dir / "radical_classification.csv", dtype=str)
    lookup = _build_parent_kanji_lookup(csv_dir)

    cls["parent_kanji"] = cls["master_symbol"].map(
        lambda s: ",".join(lookup.get(s, []))  # noqa: B023
    )
    return cls


# ---------------------------------------------------------------------------
# Output 2: kanji decomposition
# ---------------------------------------------------------------------------

def _format_component(row: pd.Series) -> str:
    """Format a single component as 'symbol(position,hint)'."""
    parts = [row["position"]]
    hint = row.get("logic_hint", "")
    if pd.notna(hint) and hint:
        parts.append(hint)
    return f"{row['master_symbol']}({','.join(parts)})"


def _build_decomposition(csv_dir: Path) -> pd.DataFrame:
    """Build kanji-centric decomposition view."""
    comp = pd.read_csv(csv_dir / "kanji_components.csv", dtype=str)
    kanji = pd.read_csv(csv_dir / "kanji.csv", dtype=str)

    # Group components per kanji
    grouped = (
        comp.groupby("character")
        .apply(lambda g: " + ".join(g.apply(_format_component, axis=1)), include_groups=False)
        .rename("components")
    )
    counts = comp.groupby("character").size().rename("component_count")

    decomp = pd.DataFrame(grouped).join(counts)
    decomp.index.name = "character"
    decomp = decomp.reset_index()

    # Merge kanji metadata
    kanji_meta = kanji[["character", "stroke_count", "min_jlpt_level", "frequency_rank"]].copy()
    decomp = decomp.merge(kanji_meta, on="character", how="left")

    # Reorder columns
    decomp = decomp[
        ["character", "stroke_count", "min_jlpt_level", "frequency_rank",
         "components", "component_count"]
    ]

    # Sort: JLPT N5 first → nulls last, then frequency_rank
    jlpt_order = {"N5": 0, "N4": 1, "N3": 2, "N2": 3, "N1": 4}
    decomp["_jlpt_sort"] = decomp["min_jlpt_level"].map(jlpt_order).fillna(99).astype(int)
    decomp["_freq_sort"] = (
        pd.to_numeric(decomp["frequency_rank"], errors="coerce")
        .fillna(99999).astype(int)
    )
    decomp = (
        decomp.sort_values(["_jlpt_sort", "_freq_sort"])
        .drop(columns=["_jlpt_sort", "_freq_sort"])
    )

    return decomp.reset_index(drop=True)


# ---------------------------------------------------------------------------
# Public entry point
# ---------------------------------------------------------------------------

def generate_review(csv_dir: Path) -> None:
    """Generate review files from radical classification + components."""
    log.info("Generating radical classification review ...")
    cls_review = _enrich_classification(csv_dir)
    write_csv_atomic(cls_review, csv_dir / "radical_classification_review.csv")

    log.info("Generating kanji decomposition review ...")
    decomp = _build_decomposition(csv_dir)
    write_csv_atomic(decomp, csv_dir / "kanji_decomposition.csv")

    log.info("Review generation complete.")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="%(levelname)s  %(message)s")
    csv_dir = Path(__file__).resolve().parents[2] / "data" / "csv"
    generate_review(csv_dir)
