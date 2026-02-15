"""Phase 3: AI Enrichment — add mnemonics, translations, furigana to CSVs.

Reads and updates CSVs in pipeline/data/csv/.
Step 1 (logic hints) is deterministic; Steps 2-6 use AI generation.

Usage:
    uv run python -m src.enrich
"""

import logging
import time
from pathlib import Path

from dotenv import load_dotenv

from src.enrichers.ph3_1_logic_hints import refine_logic_hints
from src.extractors.shared import validate_all_manual_files

log = logging.getLogger(__name__)

PARQUET_DIR = Path(__file__).resolve().parent.parent / "data" / "parquet"
CSV_DIR = Path(__file__).resolve().parent.parent / "data" / "csv"
WARNINGS_DIR = CSV_DIR / "warnings"


def main() -> None:
    load_dotenv()
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    )

    # Validate manual override files before any phase runs
    data_dir = Path(__file__).resolve().parent.parent / "data"
    validate_all_manual_files(data_dir)
    log.info("Manual override files validated")

    start = time.perf_counter()
    log.info("Phase 3: Enriching CSVs in %s", CSV_DIR)

    WARNINGS_DIR.mkdir(parents=True, exist_ok=True)

    # Step 1: Logic hint refinement (deterministic onyomi comparison)
    step_start = time.perf_counter()
    try:
        result = refine_logic_hints(PARQUET_DIR, CSV_DIR, WARNINGS_DIR)
        elapsed = time.perf_counter() - step_start
        phonetic_count = (result["kanji_components"]["logic_hint"] == "phonetic").sum()
        total = len(result["kanji_components"])
        log.info(
            "  3.1 Logic hints: done in %.1fs (%d/%d phonetic)",
            elapsed,
            phonetic_count,
            total,
        )
    except Exception:
        log.exception("Failed during Step 3.1 logic hint refinement")
        raise

    # TODO: Step 2 — Radical i18n creation (Layer 1 mnemonics)
    # TODO: Step 3 — Kanji i18n enrichment (Layer 2 mnemonics)
    # TODO: Step 4 — Vocabulary i18n enrichment (Layer 3 mnemonics)
    # TODO: Step 5 — Sentence furigana annotation (SudachiPy + AI)
    # TODO: Step 6 — Sentence translation (EN → ES/RU)

    elapsed = time.perf_counter() - start
    log.info("Phase 3 complete in %.1fs", elapsed)


if __name__ == "__main__":
    main()
