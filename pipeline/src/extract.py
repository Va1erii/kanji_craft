"""Phase 2: Extraction — read Parquet, apply domain logic, produce CSV files.

Reads from pipeline/data/parquet/ and writes to pipeline/data/csv/.
CSVs map 1:1 to Supabase content tables.

Usage:
    uv run python -m src.extract
"""

import logging
import time
from pathlib import Path

from src.extractors.ph2_1_radicals import extract_radicals
from src.extractors.ph2_2_kanji import extract_kanji
from src.extractors.ph2_3_components import extract_components

log = logging.getLogger(__name__)

PARQUET_DIR = Path(__file__).resolve().parent.parent / "data" / "parquet"
CSV_DIR = Path(__file__).resolve().parent.parent / "data" / "csv"
WARNINGS_DIR = CSV_DIR / "warnings"


def main() -> None:
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    )

    start = time.perf_counter()
    log.info("Phase 2: Extracting from %s → %s", PARQUET_DIR, CSV_DIR)

    CSV_DIR.mkdir(parents=True, exist_ok=True)
    WARNINGS_DIR.mkdir(parents=True, exist_ok=True)

    # 2.1 Radical extraction (radicals.csv, radical_variants.csv)
    step_start = time.perf_counter()
    try:
        rad_result = extract_radicals(PARQUET_DIR, CSV_DIR, WARNINGS_DIR)
        elapsed = time.perf_counter() - step_start
        log.info(
            "  2.1 Radical extraction: done in %.1fs (%d radicals, %d variants)",
            elapsed,
            len(rad_result["radicals"]),
            len(rad_result["radical_variants"]),
        )
    except Exception:
        log.exception("Failed during Phase 2.1 radical extraction")
        raise

    # 2.2 Kanji composition (kanji.csv, kanji_readings.csv, kanji_i18n.csv)
    step_start = time.perf_counter()
    try:
        kanji_result = extract_kanji(PARQUET_DIR, CSV_DIR, WARNINGS_DIR)
        elapsed = time.perf_counter() - step_start
        log.info(
            "  2.2 Kanji composition: done in %.1fs (%d kanji, %d readings, %d i18n)",
            elapsed,
            len(kanji_result["kanji"]),
            len(kanji_result["kanji_readings"]),
            len(kanji_result["kanji_i18n"]),
        )
    except Exception:
        log.exception("Failed during Phase 2.2 kanji composition")
        raise

    # 2.3 Component linking (kanji_components.csv, updates radicals.csv)
    step_start = time.perf_counter()
    try:
        comp_result = extract_components(
            PARQUET_DIR, CSV_DIR, WARNINGS_DIR,
            rad_result["scope_set"], rad_result["keep_set"],
        )
        elapsed = time.perf_counter() - step_start
        log.info(
            "  2.3 Component linking: done in %.1fs (%d components, %d radicals updated)",
            elapsed,
            len(comp_result["kanji_components"]),
            comp_result["radicals"]["impact_score"].notna().sum()
            if not comp_result["radicals"].empty
            else 0,
        )
    except Exception:
        log.exception("Failed during Phase 2.3 component linking")
        raise

    # TODO: Implement remaining extraction sub-phases
    #   2.4 SVG processing (updates svg fields on radicals/variants/kanji)
    #   2.5 Vocabulary extraction (vocabulary*.csv)

    elapsed = time.perf_counter() - start
    log.info("Phase 2 complete in %.1fs", elapsed)


if __name__ == "__main__":
    main()
