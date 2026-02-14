"""Phase 2: Extraction — read Parquet, apply domain logic, produce CSV files.

Reads from pipeline/data/parquet/ and writes to pipeline/data/csv/.
CSVs map 1:1 to Supabase content tables.

Usage:
    uv run python -m src.extract --input data/parquet --output data/csv
"""

from pathlib import Path


PARQUET_DIR = Path(__file__).resolve().parent.parent / "data" / "parquet"
CSV_DIR = Path(__file__).resolve().parent.parent / "data" / "csv"
WARNINGS_DIR = CSV_DIR / "warnings"


def main() -> None:
    CSV_DIR.mkdir(parents=True, exist_ok=True)
    WARNINGS_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Phase 2: Extracting from {PARQUET_DIR} → {CSV_DIR}")
    # TODO: Implement extraction sub-phases
    #   2.1 Radical extraction (radicals.csv, radical_variants.csv)
    #   2.2 Kanji composition (kanji.csv, kanji_readings.csv, kanji_i18n.csv)
    #   2.3 Component linking (kanji_components.csv, updates radicals.csv)
    #   2.4 SVG processing (updates svg fields on radicals/variants/kanji)
    #   2.5 Vocabulary extraction (vocabulary*.csv)


if __name__ == "__main__":
    main()
