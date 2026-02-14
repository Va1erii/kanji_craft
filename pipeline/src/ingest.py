"""Phase 1: Ingestion — parse source XML/CSV/JSON into Parquet files.

Reads from sources/ and writes to pipeline/data/parquet/.
No transformation — faithful columnar representation of source data.

Usage:
    uv run python -m src.ingest --sources ../sources --output data/parquet
"""

from pathlib import Path


SOURCES_DIR = Path(__file__).resolve().parent.parent.parent / "sources"
OUTPUT_DIR = Path(__file__).resolve().parent.parent / "data" / "parquet"


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Phase 1: Ingesting from {SOURCES_DIR} → {OUTPUT_DIR}")
    # TODO: Implement parsers for each source
    #   - kanjidic2.xml.gz → kanjidic.parquet
    #   - kanjivg-*.xml.gz → kanjivg.parquet
    #   - JMdict.gz → jmdict.parquet
    #   - JMdict_e_examp.gz → jmdict_examples.parquet
    #   - jlpt_mapping.csv → jlpt_kanji.parquet
    #   - n1-n5.csv → jlpt_vocab.parquet
    #   - JmdictFurigana.json.tar.gz → jmdict_furigana.parquet


if __name__ == "__main__":
    main()
