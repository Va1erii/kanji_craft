"""HTML card-based batch review server and JSON changeset apply.

Usage:
    uv run python -m src.release review <name>          # start HTML review server
    uv run python -m src.release review <name> --xlsx    # legacy xlsx
    uv run python -m src.release apply <name>            # auto-detects changes.json or review.xlsx
"""

import json
import logging
import webbrowser
from datetime import UTC, datetime
from pathlib import Path

import pandas as pd
from flask import Flask, jsonify, request

from src.config import CSV_DIR, RELEASES_DIR, TARGET_LANGS

log = logging.getLogger(__name__)

LANGS = TARGET_LANGS  # ["en", "es", "ru"]

# Tables whose fields can appear in changes.json
EDITABLE_TABLES = {
    "radical_i18n",
    "kanji_i18n",
    "vocabulary_i18n",
    "vocabulary_sentences",
    "vocabulary_sentence_i18n",
}

# Natural keys per editable table (used for row matching in apply)
_TABLE_KEYS: dict[str, list[str]] = {
    "radical_i18n": ["master_symbol", "lang_code"],
    "kanji_i18n": ["character", "lang_code"],
    "vocabulary_i18n": ["vocabulary_id", "lang_code"],
    "vocabulary_sentences": ["vocabulary_id"],
    "vocabulary_sentence_i18n": ["vocabulary_id", "lang_code"],
}


# ── Public API ───────────────────────────────────────────────────────────────


def start_review_server(name: str, port: int = 5111) -> None:
    """Load batch data, start Flask server, open browser."""
    batch_dir = RELEASES_DIR / name
    if not batch_dir.is_dir():
        raise FileNotFoundError(f"Batch directory not found: {batch_dir}")

    data = _load_batch_data(batch_dir, name)

    app = _create_app(batch_dir, data)

    log.info("Starting review server for '%s' at http://localhost:%d", name, port)
    webbrowser.open(f"http://localhost:{port}")
    app.run(host="127.0.0.1", port=port, debug=False)


def apply_changes_json(name: str) -> int:
    """Read changes.json, patch batch CSVs. Return number of fields changed."""
    batch_dir = RELEASES_DIR / name
    changes_path = batch_dir / "changes.json"
    if not changes_path.is_file():
        raise FileNotFoundError(f"changes.json not found: {changes_path}")

    with open(changes_path) as f:
        changeset = json.load(f)

    changes = changeset.get("changes", {})
    total = 0

    for table_name, edits in changes.items():
        if table_name not in EDITABLE_TABLES:
            log.warning("Skipping unknown table in changeset: %s", table_name)
            continue

        csv_path = batch_dir / f"{table_name}.csv"
        if not csv_path.is_file():
            log.warning("CSV not found for table %s, skipping", table_name)
            continue

        df = pd.read_csv(csv_path, dtype=str, keep_default_na=False)

        for edit in edits:
            key = edit["key"]
            fields = edit["fields"]

            # Build boolean mask from key
            mask = pd.Series(True, index=df.index)
            for col, val in key.items():
                mask = mask & (df[col] == str(val))

            matched = mask.sum()
            if matched == 0:
                log.warning("No match for key %s in %s", key, table_name)
                continue

            for field, value in fields.items():
                if field in df.columns:
                    df.loc[mask, field] = str(value)
                    total += int(matched)

        df.to_csv(csv_path, index=False)

    log.info("Applied %d field change(s) from changes.json to %s", total, batch_dir)
    return total


# ── Data loading ─────────────────────────────────────────────────────────────


def _load_warnings(
    radical_symbols: set[str], kanji_chars: set[str],
) -> dict[str, list[dict]]:
    """Load ph3_warnings.csv and return warnings grouped by entity key.

    Returns a dict mapping entity identifier to a list of warning dicts.
    Radical warnings are keyed by master_symbol, kanji warnings by character.
    """
    warnings_path = CSV_DIR / "warnings" / "ph3_warnings.csv"
    if not warnings_path.is_file():
        return {}

    df = pd.read_csv(warnings_path, dtype=str, keep_default_na=False)
    result: dict[str, list[dict]] = {}

    for _, row in df.iterrows():
        entity = row["entity"]
        entry = {
            "severity": row["severity"],
            "phase": row["phase"],
            "message": row["message"],
        }

        # Phase 3.1: entity is "kanji=X" format
        if entity.startswith("kanji="):
            char = entity[len("kanji="):]
            if char in kanji_chars:
                result.setdefault(char, []).append(entry)
        # Phases 3.0, 3.2: entity is a radical master_symbol
        elif entity in radical_symbols:
            result.setdefault(entity, []).append(entry)

    return result


def _load_batch_data(batch_dir: Path, batch_name: str = "") -> dict:
    """Read all 12 batch CSVs and structure into nested dicts for the template."""

    def _read(filename: str) -> pd.DataFrame:
        return pd.read_csv(batch_dir / filename, dtype=str, keep_default_na=False)

    # --- Load warnings for batch entities ---
    radicals_df = _read("radicals.csv")
    kanji_df = _read("kanji.csv")
    radical_symbols = set(radicals_df["master_symbol"])
    kanji_chars = set(kanji_df["character"])
    warnings_map = _load_warnings(radical_symbols, kanji_chars)

    # --- Radicals ---
    radical_i18n_df = _read("radical_i18n.csv")
    radicals = []
    for _, r in radicals_df.iterrows():
        symbol = r["master_symbol"]
        i18n = {}
        for lang in LANGS:
            lang_rows = radical_i18n_df[
                (radical_i18n_df["master_symbol"] == symbol)
                & (radical_i18n_df["lang_code"] == lang)
            ]
            if len(lang_rows) > 0:
                row = lang_rows.iloc[0]
                i18n[lang] = {
                    "name": row.get("name", ""),
                    "system_mnemonic": row.get("system_mnemonic", ""),
                    "search_tags": row.get("search_tags", "[]"),
                    "disambiguation_note": row.get("disambiguation_note", ""),
                }
            else:
                i18n[lang] = {
                    "name": "", "system_mnemonic": "",
                    "search_tags": "[]", "disambiguation_note": "",
                }
        radicals.append({
            "master_symbol": symbol,
            "family_symbol": r.get("family_symbol", ""),
            "positions": r.get("positions", "[]"),
            "is_official": r.get("is_official", ""),
            "stroke_count": r.get("stroke_count", ""),
            "i18n": i18n,
            "warnings": warnings_map.get(symbol, []),
        })

    # --- Kanji ---
    kanji_i18n_df = _read("kanji_i18n.csv")
    kanji_readings_df = _read("kanji_readings.csv")
    kanji_components_df = _read("kanji_components.csv")
    kanji_list = []
    for _, k in kanji_df.iterrows():
        char = k["character"]
        # Components
        comp_rows = kanji_components_df[kanji_components_df["character"] == char]
        components = []
        for _, c in comp_rows.iterrows():
            components.append({
                "master_symbol": c["master_symbol"],
                "position": c.get("position", ""),
                "logic_hint": c.get("logic_hint", ""),
            })
        # Readings
        read_rows = kanji_readings_df[kanji_readings_df["character"] == char]
        readings = []
        for _, rd in read_rows.iterrows():
            readings.append({
                "reading": rd["reading"],
                "reading_type": rd.get("reading_type", ""),
                "priority": rd.get("priority", ""),
            })
        # i18n
        i18n = {}
        for lang in LANGS:
            lang_rows = kanji_i18n_df[
                (kanji_i18n_df["character"] == char)
                & (kanji_i18n_df["lang_code"] == lang)
            ]
            if len(lang_rows) > 0:
                row = lang_rows.iloc[0]
                i18n[lang] = {
                    "meanings": row.get("meanings", "[]"),
                    "system_mnemonic": row.get("system_mnemonic", ""),
                    "search_tags": row.get("search_tags", "[]"),
                }
            else:
                i18n[lang] = {"meanings": "[]", "system_mnemonic": "", "search_tags": "[]"}

        kanji_list.append({
            "character": char,
            "stroke_count": k.get("stroke_count", ""),
            "frequency_rank": k.get("frequency_rank", ""),
            "components": components,
            "readings": readings,
            "i18n": i18n,
            "warnings": warnings_map.get(char, []),
        })

    # --- Vocabulary ---
    vocab_df = _read("vocabulary.csv")
    vocab_i18n_df = _read("vocabulary_i18n.csv")
    vocab_list = []
    for _, v in vocab_df.iterrows():
        vid = v["id"]
        i18n = {}
        for lang in LANGS:
            lang_rows = vocab_i18n_df[
                (vocab_i18n_df["vocabulary_id"] == vid)
                & (vocab_i18n_df["lang_code"] == lang)
            ]
            if len(lang_rows) > 0:
                row = lang_rows.iloc[0]
                i18n[lang] = {
                    "meanings": row.get("meanings", "[]"),
                    "system_mnemonic": row.get("system_mnemonic", ""),
                    "search_tags": row.get("search_tags", "[]"),
                }
            else:
                i18n[lang] = {"meanings": "[]", "system_mnemonic": "", "search_tags": "[]"}
        vocab_list.append({
            "id": vid,
            "word": v.get("word", ""),
            "furigana": v.get("furigana", ""),
            "frequency_rank": v.get("frequency_rank", ""),
            "i18n": i18n,
        })

    # --- Sentences ---
    sentences_df = _read("vocabulary_sentences.csv")
    sentence_i18n_df = _read("vocabulary_sentence_i18n.csv")
    # Build word lookup from vocab
    word_map = dict(zip(vocab_df["id"], vocab_df["word"], strict=False))
    sentences = []
    for _, s in sentences_df.iterrows():
        vid = s["vocabulary_id"]
        i18n = {}
        for lang in LANGS:
            lang_rows = sentence_i18n_df[
                (sentence_i18n_df["vocabulary_id"] == vid)
                & (sentence_i18n_df["lang_code"] == lang)
            ]
            if len(lang_rows) > 0:
                row = lang_rows.iloc[0]
                i18n[lang] = {"sentence_translated": row.get("sentence_translated", "")}
            else:
                i18n[lang] = {"sentence_translated": ""}
        sentences.append({
            "vocabulary_id": vid,
            "word": word_map.get(vid, ""),
            "original_text": s.get("original_text", ""),
            "i18n": i18n,
        })

    return {
        "batch_name": batch_name,
        "radicals": radicals,
        "kanji": kanji_list,
        "vocabulary": vocab_list,
        "sentences": sentences,
    }


# ── Flask app ────────────────────────────────────────────────────────────────


def _create_app(batch_dir: Path, data: dict) -> Flask:
    """Create Flask app with routes for serving review UI and saving changes."""
    template_dir = Path(__file__).parent / "templates"
    app = Flask(__name__, template_folder=str(template_dir))

    @app.route("/")
    def index():
        from flask import render_template

        return render_template("review.html", batch_data_json=json.dumps(data, ensure_ascii=False))

    @app.route("/api/save", methods=["POST"])
    def save():
        try:
            payload = request.get_json()
            if not payload:
                return jsonify({"error": "No JSON body"}), 400

            changeset = {
                "version": 1,
                "batch_name": data.get("batch_name", ""),
                "created_at": datetime.now(UTC).isoformat(),
                "changes": payload.get("changes", {}),
            }

            changes_path = batch_dir / "changes.json"
            with open(changes_path, "w") as f:
                json.dump(changeset, f, ensure_ascii=False, indent=2)

            log.info("Saved changes.json to %s", changes_path)
            return jsonify({"ok": True, "path": str(changes_path)})
        except Exception as exc:
            log.exception("Error saving changes")
            return jsonify({"error": str(exc)}), 500

    return app
