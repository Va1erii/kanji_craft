"""Release bundle CLI — slice, validate, push, review, and apply content batches.

Usage:
    uv run python -m src.release slice <name> --jlpt <level> --kanji <N> --vocab <N>
    uv run python -m src.release validate <name>
    uv run python -m src.release push <name>
    uv run python -m src.release review <name>
    uv run python -m src.release apply <name>
"""

import argparse
import logging
import sys

from dotenv import load_dotenv


def main() -> None:
    load_dotenv()

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    )

    parser = argparse.ArgumentParser(
        prog="release",
        description="Manage release bundles: slice, validate, push.",
    )
    subparsers = parser.add_subparsers(dest="command")

    # ── slice ─────────────────────────────────────────────────────────────

    slice_p = subparsers.add_parser("slice", help="Create a batch from main CSVs")
    slice_p.add_argument("name", help="Batch name (e.g. n5_kanji_1)")
    slice_p.add_argument("--jlpt", type=int, required=True, help="JLPT level (1-5)")
    slice_p.add_argument("--kanji", type=int, required=True, help="Kanji count")
    slice_p.add_argument("--vocab", type=int, required=True, help="Vocab count")

    # ── validate ──────────────────────────────────────────────────────────

    validate_p = subparsers.add_parser("validate", help="Check batch completeness before push")
    validate_p.add_argument("name", help="Batch name to validate")

    # ── push ──────────────────────────────────────────────────────────────

    push_p = subparsers.add_parser("push", help="Validate and push batch to Supabase")
    push_p.add_argument("name", help="Batch name to push")

    # ── review ────────────────────────────────────────────────────────────

    review_p = subparsers.add_parser("review", help="Generate review.xlsx from batch CSVs")
    review_p.add_argument("name", help="Batch name to review")

    # ── apply ─────────────────────────────────────────────────────────────

    apply_p = subparsers.add_parser("apply", help="Apply review.xlsx edits back to batch CSVs")
    apply_p.add_argument("name", help="Batch name to apply edits to")

    args = parser.parse_args()

    if args.command == "slice":
        from src.releases.slicer import slice_batch

        slice_batch(args.name, args.jlpt, args.kanji, args.vocab)

    elif args.command == "validate":
        from src.releases.validator import validate_batch

        errors = validate_batch(args.name)
        if errors:
            print(f"\n{len(errors)} validation error(s):\n")
            for err in errors:
                print(f"  {err}")
            sys.exit(1)
        else:
            print("Batch is valid and ready to push.")

    elif args.command == "push":
        from src.releases.uploader import push_batch

        push_batch(args.name)

    elif args.command == "review":
        from src.releases.reviewer import generate_review_xlsx

        path = generate_review_xlsx(args.name)
        print(f"Review workbook: {path}")

    elif args.command == "apply":
        from src.releases.reviewer import apply_review_xlsx

        apply_review_xlsx(args.name)
        print("Applied edits from review.xlsx to batch CSVs.")

    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
