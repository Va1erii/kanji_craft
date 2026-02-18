"""Phase 3: AI Enrichment — deterministic analysis steps.

Reads and updates CSVs in pipeline/data/csv/.
Steps 0-1 are deterministic (radical classification, logic hint refinement).
AI-generated content (mnemonics, translations, search tags) is now handled
per-batch via ``release enrich`` and ``release merge``.

Usage:
    uv run python -m src.enrich
"""

import logging
import time
from pathlib import Path

from dotenv import load_dotenv

from src.enrichers.ph3_0_classify_radicals import classify_radicals
from src.enrichers.ph3_0_review import generate_review
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

    # Clear previous run's warnings so steps only accumulate within this run
    ph3_warnings_path = WARNINGS_DIR / "ph3_warnings.csv"
    if ph3_warnings_path.exists():
        ph3_warnings_path.unlink()

    # Step 0: Radical classification (deterministic analysis)
    step_start = time.perf_counter()
    try:
        result = classify_radicals(CSV_DIR, WARNINGS_DIR)
        elapsed = time.perf_counter() - step_start
        df = result["radical_classification"]
        counts = df["classification"].value_counts()
        log.info(
            "  3.0 Radical classification: done in %.1fs (%d radicals: %s)",
            elapsed,
            len(df),
            ", ".join(f"{k}={v}" for k, v in counts.items()),
        )
    except Exception:
        log.exception("Failed during Step 3.0 radical classification")
        raise

    # Step 0b: Enriched classification review with parent kanji context
    generate_review(CSV_DIR)

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

    # Steps 2-6 (AI-generated content) are now handled per-batch via:
    #   uv run python -m src.release enrich <name>
    #   uv run python -m src.release merge <name>

    elapsed = time.perf_counter() - start
    log.info("Phase 3 complete in %.1fs", elapsed)


if __name__ == "__main__":
    main()
