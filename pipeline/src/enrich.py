"""Phase 3: AI Enrichment — add mnemonics, translations, furigana to CSVs.

Reads and updates CSVs in pipeline/data/csv/.
Step 1 (logic hints) is deterministic; Steps 2-6 use AI generation.

Usage:
    uv run python -m src.enrich --data data/csv --parquet data/parquet
"""

from pathlib import Path


PARQUET_DIR = Path(__file__).resolve().parent.parent / "data" / "parquet"
CSV_DIR = Path(__file__).resolve().parent.parent / "data" / "csv"


def main() -> None:
    print(f"Phase 3: Enriching CSVs in {CSV_DIR}")
    # TODO: Implement enrichment steps
    #   Step 1: Logic hint refinement (deterministic onyomi comparison)
    #   Step 2: Radical i18n creation (Layer 1 mnemonics)
    #   Step 3: Kanji i18n enrichment (Layer 2 mnemonics)
    #   Step 4: Vocabulary i18n enrichment (Layer 3 mnemonics)
    #   Step 5: Sentence furigana annotation (SudachiPy + AI)
    #   Step 6: Sentence translation (EN → ES/RU)


if __name__ == "__main__":
    main()
