"""Batch uploader — validate and push a release batch to Supabase.

Validates completeness, uploads SVGs (delta by hash), upserts all content
tables in FK order, rewrites localhost URLs, and records push history in
manifest.json.
"""

import hashlib
import json
import logging
import os
import re
from datetime import UTC, datetime
from pathlib import Path

import pandas as pd

from src.config import (
    RELEASES_DIR,
    SVG_DIR,
    TABLE_NATURAL_KEYS,
    TABLE_UPLOAD_ORDER,
)
from src.releases.validator import validate_batch

log = logging.getLogger(__name__)

BUCKET_NAME = "svg"
_LOCALHOST_URL_RE = re.compile(r"http://(?:localhost|127\.0\.0\.1):\d+/storage/v1/object/public/svg")


# ── Helpers ──────────────────────────────────────────────────────────────────


def _read_csv(path: Path) -> pd.DataFrame:
    if not path.exists():
        return pd.DataFrame()
    return pd.read_csv(path, dtype=str, keep_default_na=False)


def _create_supabase_client():
    """Create Supabase client from env vars."""
    from supabase import create_client

    url = os.environ["SUPABASE_URL"]
    key = os.environ["SUPABASE_SERVICE_ROLE_KEY"]
    return create_client(url, key)


def _load_manifest(batch_dir: Path) -> dict:
    """Load manifest.json or return a blank structure."""
    path = batch_dir / "manifest.json"
    if path.exists():
        try:
            return json.loads(path.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, OSError):
            log.warning("Could not read manifest.json, starting fresh")
    return {"name": batch_dir.name, "current_version": 0, "pushes": []}


def _save_manifest(batch_dir: Path, manifest: dict) -> None:
    path = batch_dir / "manifest.json"
    path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    log.info("Wrote %s", path.name)


def _csv_checksum(path: Path) -> str:
    """SHA-256 hex digest of a CSV file's contents."""
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _compute_batch_checksum(batch_dir: Path) -> str:
    """Compute a composite checksum of all CSV files in the batch."""
    hashes = []
    for csv_name in TABLE_UPLOAD_ORDER:
        path = batch_dir / f"{csv_name}.csv"
        if path.exists():
            hashes.append(_csv_checksum(path))
    return hashlib.sha256("|".join(hashes).encode()).hexdigest()


def _rewrite_svg_urls(df: pd.DataFrame, svg_base_url: str) -> pd.DataFrame:
    """Replace localhost SVG URLs with production base URL."""
    if "svg_file_url" not in df.columns:
        return df
    df = df.copy()
    df["svg_file_url"] = df["svg_file_url"].apply(
        lambda url: _LOCALHOST_URL_RE.sub(svg_base_url.rstrip("/"), url) if url else url
    )
    return df


def _upload_svgs(client, batch_dir: Path, svg_base_url: str) -> int:
    """Upload SVG files referenced in the batch to Supabase Storage.

    Reads svg_file_name + svg_hash from radicals and kanji
    CSVs. For each, checks if the file already exists remotely and uploads if
    new or changed.

    Returns count of newly uploaded files.
    """
    from storage3.exceptions import StorageApiError

    uploaded = 0

    # Collect all (svg_file_name, svg_hash, folder) triples
    entries: list[tuple[str, str, str]] = []
    for csv_name, folder in [
        ("radicals", "radicals"),
        ("kanji", "kanji"),
    ]:
        df = _read_csv(batch_dir / f"{csv_name}.csv")
        if df.empty or "svg_file_name" not in df.columns:
            continue
        for _, row in df.iterrows():
            fname = row.get("svg_file_name", "")
            fhash = row.get("svg_hash", "")
            if fname and fhash:
                entries.append((fname, fhash, folder))

    if not entries:
        return 0

    # List remote files (deduplicate folder listings)
    remote_cache: dict[str, set[str]] = {}
    for _, _, folder in entries:
        if folder not in remote_cache:
            try:
                names: set[str] = set()
                offset = 0
                while True:
                    page = client.storage.from_(BUCKET_NAME).list(
                        folder, {"limit": 1000, "offset": offset},
                    )
                    for item in page:
                        if item.get("name"):
                            names.add(item["name"])
                    if len(page) < 1000:
                        break
                    offset += 1000
                remote_cache[folder] = names
            except Exception:
                log.exception("Failed to list remote %s/%s", BUCKET_NAME, folder)
                remote_cache[folder] = set()

    # Upload missing files
    for fname, _fhash, folder in entries:
        if fname in remote_cache.get(folder, set()):
            continue

        # Find the file on disk
        local_path = SVG_DIR / folder / fname
        if not local_path.exists():
            log.warning("SVG file not found locally: %s", local_path)
            continue

        svg_bytes = local_path.read_bytes()
        remote_path = f"{folder}/{fname}"
        try:
            client.storage.from_(BUCKET_NAME).upload(
                remote_path, svg_bytes, {"content-type": "image/svg+xml"},
            )
            uploaded += 1
        except StorageApiError as exc:
            if exc.args and "already exists" in str(exc.args[0]).lower():
                remote_cache.setdefault(folder, set()).add(fname)
            else:
                raise

    log.info("SVG upload: %d new files", uploaded)
    return uploaded


def _coerce_int_columns(df: pd.DataFrame, table: str) -> pd.DataFrame:
    """Convert known integer columns from string back to int for upsert."""
    int_cols: dict[str, list[str]] = {
        "radicals": ["stroke_count", "impact_score", "min_grade", "min_jlpt_level"],
        "radical_i18n": [],
        "kanji": ["stroke_count", "min_grade", "min_jlpt_level", "frequency_rank"],
        "kanji_readings": [],
        "kanji_i18n": [],
        "kanji_components": [],
        "vocabulary": ["id", "min_jlpt_level", "frequency_rank"],
        "vocabulary_readings": ["vocabulary_id"],
        "vocabulary_i18n": ["vocabulary_id"],
        "vocabulary_kanji": ["vocabulary_id", "position"],
        "vocabulary_sentences": ["vocabulary_id"],
        "vocabulary_sentence_i18n": ["vocabulary_id"],
    }
    for col in int_cols.get(table, []):
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce").astype("Int64")
    return df


def _coerce_bool_columns(df: pd.DataFrame, table: str) -> pd.DataFrame:
    """Convert known boolean columns from string to proper bool for upsert."""
    bool_cols: dict[str, list[str]] = {
        "radicals": ["is_official"],
        "kanji_components": ["is_primary"],
    }
    for col in bool_cols.get(table, []):
        if col in df.columns:
            df[col] = df[col].map({"True": True, "true": True, "False": False, "false": False})
    return df


def _upsert_table(client, table: str, df: pd.DataFrame) -> int:
    """Upsert a DataFrame into a Supabase table. Returns row count."""
    if df.empty:
        log.info("  %s: 0 rows (skipped)", table)
        return 0

    natural_key = TABLE_NATURAL_KEYS.get(table)
    if not natural_key:
        log.warning("  %s: no natural key configured, skipping", table)
        return 0

    rows = df.to_dict(orient="records")
    # Supabase upsert in batches of 500
    batch_size = 500
    total = 0
    for i in range(0, len(rows), batch_size):
        chunk = rows[i : i + batch_size]
        client.table(table).upsert(chunk, on_conflict=natural_key).execute()
        total += len(chunk)

    log.info("  %s: %d rows upserted", table, total)
    return total


# ── Main entry point ─────────────────────────────────────────────────────────


def push_batch(name: str) -> None:
    """Validate and push a release batch to Supabase.

    Args:
        name: Batch directory name (e.g. "n5_kanji_1").

    Raises:
        SystemExit: If validation fails or required env vars are missing.
    """
    batch_dir = RELEASES_DIR / name
    if not batch_dir.exists():
        log.error("Batch directory not found: %s", batch_dir)
        raise SystemExit(1)

    # Step 1: Validate
    log.info("Validating batch '%s'...", name)
    errors = validate_batch(name)
    if errors:
        log.error("Validation failed with %d errors:", len(errors))
        for err in errors:
            log.error("  %s", err)
        raise SystemExit(1)
    log.info("Validation passed")

    # Step 2: Check env vars
    svg_base_url = os.environ.get("SVG_BASE_URL")
    if not svg_base_url:
        log.error("SVG_BASE_URL environment variable is required")
        raise SystemExit(1)
    svg_base_url = svg_base_url.rstrip("/")

    # Step 3: Create Supabase client
    supabase_url = os.environ.get("SUPABASE_URL")
    service_key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")
    if not supabase_url or not service_key:
        log.error("SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required for push")
        raise SystemExit(1)
    client = _create_supabase_client()

    # Step 4: Upload SVGs
    log.info("Uploading SVGs...")
    _upload_svgs(client, batch_dir, svg_base_url)

    # Step 5: Upsert tables in FK order
    log.info("Upserting tables...")
    row_counts: dict[str, int] = {}
    for table in TABLE_UPLOAD_ORDER:
        csv_path = batch_dir / f"{table}.csv"
        df = _read_csv(csv_path)
        if df.empty:
            row_counts[table] = 0
            continue

        # Rewrite SVG URLs if applicable
        df = _rewrite_svg_urls(df, svg_base_url)

        # Coerce types for Supabase
        df = _coerce_int_columns(df, table)
        df = _coerce_bool_columns(df, table)

        row_counts[table] = _upsert_table(client, table, df)

    # Step 6: Update manifest
    manifest = _load_manifest(batch_dir)
    manifest["name"] = name

    # Determine version: increment if content changed since last push
    current_checksum = _compute_batch_checksum(batch_dir)
    last_checksum = manifest["pushes"][-1].get("checksum") if manifest["pushes"] else None
    if last_checksum and current_checksum != last_checksum:
        manifest["current_version"] = manifest.get("current_version", 0) + 1
    elif not manifest["pushes"]:
        manifest["current_version"] = 1

    manifest["pushes"].append({
        "version": manifest["current_version"],
        "pushed_at": datetime.now(UTC).isoformat(),
        "checksum": current_checksum,
        "rows": row_counts,
    })

    # Persist jlpt_level from batch.toml if available
    import tomllib

    toml_path = batch_dir / "batch.toml"
    if toml_path.exists():
        with open(toml_path, "rb") as f:
            batch_meta = tomllib.load(f)
        manifest["jlpt_level"] = batch_meta.get("jlpt_level")

    _save_manifest(batch_dir, manifest)

    total_rows = sum(row_counts.values())
    log.info(
        "Push complete: batch '%s' v%d — %d total rows across %d tables",
        name, manifest["current_version"], total_rows, len(TABLE_UPLOAD_ORDER),
    )
