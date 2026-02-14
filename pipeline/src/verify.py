"""Phase 4: Verification & Upload — validate CSVs and upload to Supabase.

Reads from pipeline/data/csv/, validates completeness and referential
integrity, then uploads to remote Supabase via comparison-based sync.

Usage:
    uv run python -m src.verify --data data/csv --scope n5
"""

from pathlib import Path


CSV_DIR = Path(__file__).resolve().parent.parent / "data" / "csv"


def main() -> None:
    print(f"Phase 4: Verifying and uploading from {CSV_DIR}")
    # TODO: Implement verification and upload
    #   4.1 Referential integrity checks
    #   4.2 Completeness checks (per JLPT level)
    #   4.3 SVG upload (delta by hash)
    #   4.4 Comparison-based sync (query remote, diff, upsert)
    #   4.5 URL rewrite (local → production storage URLs)


if __name__ == "__main__":
    main()
