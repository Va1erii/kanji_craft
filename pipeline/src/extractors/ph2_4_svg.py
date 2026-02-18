"""Phase 2.4: SVG Processing, Hashing & Upload.

Populates svg_file_name, svg_file_url, svg_hash on radicals.csv
and kanji.csv from the KanjiVG ZIP archive.
Uploads new SVGs to Supabase Storage.

Usage:
    Called from src.extract as part of the Phase 2 pipeline.
"""

import hashlib
import logging
import os
import re
import zipfile
from pathlib import Path

import pandas as pd
from lxml import etree

from src.extractors.shared import (
    char_to_kvg_filename,
    char_to_svg_filename,
    parse_component_tree,
    severity_sort_key,
    write_csv_atomic,
)

log = logging.getLogger(__name__)

SOURCES_DIR = Path(__file__).resolve().parent.parent.parent.parent / "sources"

BUCKET_NAME = "svg"


def _discover_zip() -> Path:
    """Find the KanjiVG ZIP archive in sources/."""
    candidates = sorted(SOURCES_DIR.glob("kanjivg-*/kanjivg-*-main.zip"))
    if not candidates:
        msg = f"No KanjiVG ZIP found in {SOURCES_DIR}/kanjivg-*/kanjivg-*-main.zip"
        raise FileNotFoundError(msg)
    if len(candidates) > 1:
        log.warning("Multiple KanjiVG ZIPs found, using latest: %s", candidates[-1])
    return candidates[-1]


def _build_svg_map(zip_path: Path) -> dict[str, tuple[bytes, str]]:
    """Build map: kvg_filename → (raw_bytes, sha256_hex) from ZIP.

    Only includes entries matching ``kanji/*.svg``.
    """
    svg_map: dict[str, tuple[bytes, str]] = {}
    with zipfile.ZipFile(zip_path, "r") as zf:
        for entry in zf.namelist():
            if not entry.endswith(".svg"):
                continue
            # Entries are like "kanji/04e00.svg" — extract the filename part
            filename = entry.rsplit("/", 1)[-1]
            raw = zf.read(entry)
            sha = hashlib.sha256(raw).hexdigest()
            svg_map[filename] = (raw, sha)
    log.info("Built SVG map: %d files from %s", len(svg_map), zip_path.name)
    return svg_map


def _load_old_hashes(
    csv_path: Path,
    name_col: str = "svg_file_name",
    hash_col: str = "svg_hash",
) -> dict[str, str]:
    """Read current CSV to build svg_file_name → old_svg_hash map."""
    if not csv_path.exists():
        return {}
    try:
        df = pd.read_csv(csv_path)
    except pd.errors.EmptyDataError:
        return {}
    if name_col not in df.columns or hash_col not in df.columns:
        return {}
    subset = df[[name_col, hash_col]].dropna()
    return dict(zip(subset[name_col], subset[hash_col], strict=False))


def _list_remote_files(client, folder: str) -> set[str]:
    """List all filenames in a Supabase storage folder (paginated)."""
    PAGE_SIZE = 1000
    names: set[str] = set()
    try:
        offset = 0
        while True:
            page = client.storage.from_(BUCKET_NAME).list(
                folder, {"limit": PAGE_SIZE, "offset": offset}
            )
            for item in page:
                if item.get("name"):
                    names.add(item["name"])
            if len(page) < PAGE_SIZE:
                break
            offset += PAGE_SIZE
    except Exception:
        log.exception("Failed to list remote files in %s/%s", BUCKET_NAME, folder)
    return names


def _upload_file(client, folder: str, filename: str, data: bytes) -> bool:
    """Upload a single SVG file to Supabase storage.

    Returns True if uploaded, False if already exists (409 Duplicate)
    or connection failed. Raises on other storage API failures.
    """
    import httpx
    from storage3.exceptions import StorageApiError

    path = f"{folder}/{filename}"
    try:
        client.storage.from_(BUCKET_NAME).upload(
            path, data, {"content-type": "image/svg+xml"}
        )
    except StorageApiError as exc:
        if exc.args and "already exists" in str(exc.args[0]).lower():
            return False
        raise
    except httpx.ConnectError:
        log.warning("Connection refused — is Supabase running? Skipping upload for %s", path)
        return False
    return True


def _create_supabase_client():
    """Create Supabase client from env vars."""
    from supabase import create_client

    url = os.environ["SUPABASE_URL"]
    key = os.environ["SUPABASE_SERVICE_ROLE_KEY"]
    return create_client(url, key)


SVG_NS = "http://www.w3.org/2000/svg"
KVG_NS = "http://kanjivg.tagaini.net"
_NS_MAP = {"svg": SVG_NS, "kvg": KVG_NS}

# Regex: split on SVG path command letters, then extract numbers
_CMD_RE = re.compile(r"([MmCcSs])")
_NUM_RE = re.compile(r"-?\d+(?:\.\d+)?")


def _tokenize_path(d: str) -> list[str]:
    """Split SVG path `d` attribute into command + number tokens."""
    tokens: list[str] = []
    for part in _CMD_RE.split(d):
        part = part.strip()
        if not part:
            continue
        if _CMD_RE.fullmatch(part):
            tokens.append(part)
        else:
            tokens.extend(_NUM_RE.findall(part))
    return tokens


def _compute_bbox_from_paths(d_values: list[str]) -> tuple[float, float, float, float]:
    """Compute bounding box from SVG path d-strings.

    Tracks current point through M/m/C/c/S/s commands,
    collecting all coordinate points (including control points).
    Returns (min_x, min_y, max_x, max_y).
    Fallback to (0, 0, 109, 109) if no points found.
    """
    points: list[tuple[float, float]] = []
    for d in d_values:
        tokens = _tokenize_path(d)
        cur_x, cur_y = 0.0, 0.0
        i = 0
        while i < len(tokens):
            tok = tokens[i]
            if tok in ("M", "m", "C", "c", "S", "s"):
                cmd = tok
                i += 1
            else:
                # Implicit repeat of previous command
                if cmd is None:
                    i += 1
                    continue
                # Don't increment — process this number token below

            if cmd == "M":
                if i + 1 < len(tokens):
                    cur_x, cur_y = float(tokens[i]), float(tokens[i + 1])
                    points.append((cur_x, cur_y))
                    i += 2
                else:
                    break
            elif cmd == "m":
                if i + 1 < len(tokens):
                    cur_x += float(tokens[i])
                    cur_y += float(tokens[i + 1])
                    points.append((cur_x, cur_y))
                    i += 2
                else:
                    break
            elif cmd == "C":
                if i + 5 < len(tokens):
                    for j in range(0, 6, 2):
                        px, py = float(tokens[i + j]), float(tokens[i + j + 1])
                        points.append((px, py))
                    cur_x, cur_y = float(tokens[i + 4]), float(tokens[i + 5])
                    i += 6
                else:
                    break
            elif cmd == "c":
                if i + 5 < len(tokens):
                    for j in range(0, 6, 2):
                        px = cur_x + float(tokens[i + j])
                        py = cur_y + float(tokens[i + j + 1])
                        points.append((px, py))
                    cur_x += float(tokens[i + 4])
                    cur_y += float(tokens[i + 5])
                    i += 6
                else:
                    break
            elif cmd == "S":
                if i + 3 < len(tokens):
                    for j in range(0, 4, 2):
                        px, py = float(tokens[i + j]), float(tokens[i + j + 1])
                        points.append((px, py))
                    cur_x, cur_y = float(tokens[i + 2]), float(tokens[i + 3])
                    i += 4
                else:
                    break
            elif cmd == "s":
                if i + 3 < len(tokens):
                    for j in range(0, 4, 2):
                        px = cur_x + float(tokens[i + j])
                        py = cur_y + float(tokens[i + j + 1])
                        points.append((px, py))
                    cur_x += float(tokens[i + 2])
                    cur_y += float(tokens[i + 3])
                    i += 4
                else:
                    break
            else:
                i += 1
                cmd = None  # type: ignore[assignment]

    if not points:
        return (0.0, 0.0, 109.0, 109.0)

    xs = [p[0] for p in points]
    ys = [p[1] for p in points]
    return (min(xs), min(ys), max(xs), max(ys))


_SVG_STYLE = "fill:none;stroke:#000000;stroke-width:3;stroke-linecap:round;stroke-linejoin:round;"
_BBOX_PADDING = 2.0


def _generate_extracted_svg(d_values: list[str], bbox: tuple[float, float, float, float]) -> bytes:
    """Generate a standalone SVG from extracted path d-strings.

    ViewBox = bbox + padding. Inherits KanjiVG stroke style.
    """
    min_x, min_y, max_x, max_y = bbox
    vb_x = min_x - _BBOX_PADDING
    vb_y = min_y - _BBOX_PADDING
    vb_w = (max_x - min_x) + 2 * _BBOX_PADDING
    vb_h = (max_y - min_y) + 2 * _BBOX_PADDING

    paths = "\n".join(f'  <path d="{d}" style="{_SVG_STYLE}"/>' for d in d_values)
    svg = (
        f'<svg xmlns="http://www.w3.org/2000/svg"'
        f' viewBox="{vb_x:.1f} {vb_y:.1f} {vb_w:.1f} {vb_h:.1f}">\n'
        f"{paths}\n"
        f"</svg>\n"
    )
    return svg.encode("utf-8")


def _build_parent_index(parquet_dir: Path) -> dict[str, list[tuple[str, int]]]:
    """Build reverse index: element_char → [(parent_char, depth), ...].

    Reads kanjivg.parquet component trees and walks each recursively.
    """
    pq_path = parquet_dir / "kanjivg.parquet"
    if not pq_path.exists():
        return {}

    df = pd.read_parquet(pq_path)
    index: dict[str, list[tuple[str, int]]] = {}

    def _walk(node: dict, parent_char: str, depth: int) -> None:
        for child in node.get("children", []):
            elem = child.get("element")
            if elem:
                index.setdefault(elem, []).append((parent_char, depth))
            # Also index by original (canonical form) when variant=True
            orig = child.get("original")
            if orig and orig != elem:
                index.setdefault(orig, []).append((parent_char, depth))
            _walk(child, parent_char, depth + 1)

    for _, row in df.iterrows():
        char = row.get("character")
        tree_str = row.get("component_tree")
        if not char or pd.isna(tree_str):
            continue
        tree = parse_component_tree(tree_str)
        _walk(tree, char, 1)

    log.info("Built parent index: %d elements from %d kanji", len(index), len(df))
    return index


def _select_best_parent(
    candidates: list[tuple[str, int]],
    svg_map: dict[str, tuple[bytes, str]],
) -> str | None:
    """Select best parent kanji that has an SVG in the archive.

    Prefer direct children (lower depth), then sort by character for determinism.
    """
    with_svg = [
        (char, depth)
        for char, depth in candidates
        if char_to_kvg_filename(char) in svg_map
    ]
    if not with_svg:
        return None
    with_svg.sort(key=lambda x: (x[1], x[0]))
    return with_svg[0][0]


def _parse_svg_extract_paths(
    svg_bytes: bytes,
    target_element: str,
) -> list[str] | None:
    """Extract path d-strings for a target element from a parent SVG.

    First tries kvg:element match, then falls back to kvg:original.
    KanjiVG stores variant forms as kvg:element with the canonical
    (master) form in kvg:original — e.g. element="寉" original="隺".
    """
    try:
        root = etree.fromstring(svg_bytes)  # noqa: S320
    except etree.XMLSyntaxError:
        return None

    # Try kvg:element first (direct match — common case)
    xpath = f'.//svg:g[@kvg:element="{target_element}"]'
    groups = root.xpath(xpath, namespaces=_NS_MAP)

    # Fall back to kvg:original (variant-encoded radicals)
    if not groups:
        xpath = f'.//svg:g[@kvg:original="{target_element}"]'
        groups = root.xpath(xpath, namespaces=_NS_MAP)

    if not groups:
        return None

    d_values: list[str] = []
    for group in groups:
        for path_el in group.iter(f"{{{SVG_NS}}}path"):
            d = path_el.get("d")
            if d:
                d_values.append(d)

    return d_values if d_values else None


def _process_entity(
    df: pd.DataFrame,
    char_col: str,
    svg_map: dict[str, tuple[bytes, str]],
    base_url: str,
    url_folder: str,
    entity_label: str,
    old_hashes: dict[str, str],
    remote_files: set[str],
    client,
    warnings: list[dict],
    jlpt_series: pd.Series | None = None,
    svg_dir: Path | None = None,
) -> pd.DataFrame:
    """Update SVG fields on a DataFrame and upload new files.

    Args:
        df: Entity DataFrame to update in-place.
        char_col: Column name containing the character (master_symbol/shape/character).
        svg_map: kvg_filename → (bytes, sha256).
        base_url: SVG_BASE_URL for URL construction.
        url_folder: 'radicals' or 'kanji' for URL path.
        entity_label: For logging ('radical', 'kanji').
        old_hashes: svg_file_name → old sha256 from previous CSV.
        remote_files: Set of filenames already in remote storage folder.
        client: Supabase client (or None to skip uploads).
        warnings: Accumulator for warning dicts.
        jlpt_series: Optional Series of JLPT levels aligned with df index for severity.
        svg_dir: Optional directory to save SVG files to disk.

    Returns:
        Updated DataFrame.
    """
    # Ensure SVG columns are object dtype (they start as float64 when all NaN)
    for col in ("svg_file_name", "svg_hash", "svg_file_url"):
        if col in df.columns:
            df[col] = df[col].astype(object)

    uploaded = 0
    skipped = 0
    changed = 0
    missing = 0
    written = 0

    for idx, row in df.iterrows():
        char = row[char_col]
        if pd.isna(char) or not char:
            continue

        # Skip non-Unicode identifiers (e.g. CDP-8BB0) that have no SVG
        if len(char) != 1:
            missing += 1
            warnings.append({
                "severity": "low",
                "phase": "2.4",
                "entity": char,
                "message": f"Non-Unicode {entity_label} '{char}' — no SVG possible",
            })
            continue

        kvg_name = char_to_kvg_filename(char)
        storage_name = char_to_svg_filename(char)

        if kvg_name not in svg_map:
            missing += 1
            has_jlpt = (
                jlpt_series is not None
                and idx in jlpt_series.index
                and pd.notna(jlpt_series[idx])
            )
            warnings.append({
                "severity": "high" if has_jlpt else "low",
                "phase": "2.4",
                "entity": char,
                "message": f"Missing SVG for {entity_label} '{char}' (expected {kvg_name})",
            })
            continue

        raw_bytes, sha256 = svg_map[kvg_name]

        # Set all three fields atomically
        df.at[idx, "svg_file_name"] = storage_name
        df.at[idx, "svg_hash"] = sha256
        df.at[idx, "svg_file_url"] = f"{base_url}/{url_folder}/{storage_name}"

        # Save to disk
        if svg_dir is not None:
            dest = svg_dir / url_folder / storage_name
            dest.parent.mkdir(parents=True, exist_ok=True)
            if not dest.exists() or dest.stat().st_size != len(raw_bytes):
                dest.write_bytes(raw_bytes)
                written += 1

        # Upload decision
        if client is not None:
            if storage_name not in remote_files:
                if _upload_file(client, url_folder, storage_name, raw_bytes):
                    uploaded += 1
                else:
                    skipped += 1  # 409 Duplicate
                remote_files.add(storage_name)
            else:
                old_hash = old_hashes.get(storage_name)
                if old_hash and sha256 != old_hash:
                    changed += 1
                    warnings.append({
                        "severity": "high",
                        "phase": "2.4",
                        "entity": char,
                        "message": (
                            f"SVG content changed since last upload for {entity_label} "
                            f"'{char}' ({storage_name}). Admin must re-upload manually."
                        ),
                    })
                else:
                    skipped += 1

    log.info(
        "  %s: %d uploaded, %d written, %d skipped, %d changed, %d missing, %d total",
        entity_label,
        uploaded,
        written,
        skipped,
        changed,
        missing,
        len(df),
    )
    return df


def _extract_component_svgs(
    radicals_df: pd.DataFrame,
    svg_map: dict[str, tuple[bytes, str]],
    parent_index: dict[str, list[tuple[str, int]]],
    svg_base_url: str,
    svg_dir: Path,
    remote_files: set[str],
    client,
    warnings: list[dict],
) -> pd.DataFrame:
    """Pass 2: Extract component SVGs from parent kanji for missing radicals.

    For each radical still missing SVG fields, find a parent kanji that
    contains it as a component, extract the stroke paths, generate a standalone SVG,
    and populate the CSV fields.
    """
    extracted_dir = svg_dir / "extracted" / "radicals"
    extracted_dir.mkdir(parents=True, exist_ok=True)

    extracted_count = 0

    for idx, row in radicals_df.iterrows():
        # Skip rows that already have SVG from Pass 1
        if pd.notna(row.get("svg_file_name")):
            continue

        char = row["master_symbol"]
        if pd.isna(char) or not char:
            continue

        candidates = parent_index.get(char, [])
        if not candidates:
            continue

        parent_char = _select_best_parent(candidates, svg_map)
        if parent_char is None:
            continue

        parent_kvg = char_to_kvg_filename(parent_char)
        parent_bytes, _ = svg_map[parent_kvg]

        d_values = _parse_svg_extract_paths(parent_bytes, char)
        if not d_values:
            continue

        bbox = _compute_bbox_from_paths(d_values)
        svg_bytes = _generate_extracted_svg(d_values, bbox)
        sha256 = hashlib.sha256(svg_bytes).hexdigest()

        storage_name = char_to_svg_filename(char)
        radicals_df.at[idx, "svg_file_name"] = storage_name
        radicals_df.at[idx, "svg_hash"] = sha256
        radicals_df.at[idx, "svg_file_url"] = f"{svg_base_url}/radicals/{storage_name}"

        # Save to extracted/ subfolder
        dest = extracted_dir / storage_name
        if not dest.exists() or dest.stat().st_size != len(svg_bytes):
            dest.write_bytes(svg_bytes)

        # Upload to radicals/ folder in bucket
        if client is not None and storage_name not in remote_files:
            if _upload_file(client, "radicals", storage_name, svg_bytes):
                pass
            remote_files.add(storage_name)

        extracted_count += 1
        warnings.append({
            "severity": "low",
            "phase": "2.4",
            "entity": char,
            "message": (
                f"Extracted SVG for radical '{char}' "
                f"from parent {parent_char}"
            ),
        })

    log.info("Pass 2: extracted %d component SVGs", extracted_count)
    return radicals_df


def extract_svg(
    csv_dir: Path,
    warnings_dir: Path,
    *,
    supabase_client=None,
    zip_path: Path | None = None,
    parquet_dir: Path | None = None,
) -> dict:
    """Phase 2.4 entry point: populate SVG fields and upload to storage.

    Args:
        csv_dir: Directory containing radicals.csv, kanji.csv.
        warnings_dir: Directory for ph2_4_warnings.csv.
        supabase_client: Optional pre-built Supabase client (for testing).
            If None, creates from env vars.
        zip_path: Optional explicit path to KanjiVG ZIP (for testing).
            If None, discovers via glob in sources/.
        parquet_dir: Optional directory containing kanjivg.parquet for Pass 2.
            Defaults to csv_dir.parent / "parquet".

    Returns:
        Dict with updated DataFrames: radicals, kanji.
    """
    # Config from env
    svg_base_url = os.environ.get("SVG_BASE_URL")
    if not svg_base_url:
        msg = "SVG_BASE_URL environment variable is required"
        raise OSError(msg)

    # Strip trailing slash
    svg_base_url = svg_base_url.rstrip("/")

    # Step 1: Build SVG map from ZIP
    if zip_path is None:
        zip_path = _discover_zip()
    svg_map = _build_svg_map(zip_path)

    # SVG disk output directory
    svg_dir = csv_dir.parent / "svg"
    svg_dir.mkdir(parents=True, exist_ok=True)
    (svg_dir / "radicals").mkdir(exist_ok=True)
    (svg_dir / "kanji").mkdir(exist_ok=True)

    # Step 2: Load old hashes + list remote files
    old_radical_hashes = _load_old_hashes(csv_dir / "radicals.csv")
    old_kanji_hashes = _load_old_hashes(csv_dir / "kanji.csv")

    # Create/use Supabase client
    client = supabase_client
    if client is None:
        supabase_url = os.environ.get("SUPABASE_URL")
        service_key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")
        if supabase_url and service_key:
            client = _create_supabase_client()
        else:
            log.warning("SUPABASE_URL/SUPABASE_SERVICE_ROLE_KEY not set — skipping uploads")

    remote_radicals: set[str] = set()
    remote_kanji: set[str] = set()
    if client is not None:
        remote_radicals = _list_remote_files(client, "radicals")
        remote_kanji = _list_remote_files(client, "kanji")

    warnings: list[dict] = []

    # Step 3: Radicals
    radicals_path = csv_dir / "radicals.csv"
    radicals_df = pd.read_csv(radicals_path)

    jlpt_radicals = (
        radicals_df["min_jlpt_level"] if "min_jlpt_level" in radicals_df.columns else None
    )

    radicals_df = _process_entity(
        radicals_df,
        "master_symbol",
        svg_map,
        svg_base_url,
        "radicals",
        "radical",
        old_radical_hashes,
        remote_radicals,
        client,
        warnings,
        jlpt_series=jlpt_radicals,
        svg_dir=svg_dir,
    )
    write_csv_atomic(radicals_df, radicals_path)

    # Step 4: Kanji
    kanji_path = csv_dir / "kanji.csv"
    kanji_df = pd.read_csv(kanji_path)

    jlpt_kanji = kanji_df["min_jlpt_level"] if "min_jlpt_level" in kanji_df.columns else None

    kanji_df = _process_entity(
        kanji_df,
        "character",
        svg_map,
        svg_base_url,
        "kanji",
        "kanji",
        old_kanji_hashes,
        remote_kanji,
        client,
        warnings,
        jlpt_series=jlpt_kanji,
        svg_dir=svg_dir,
    )
    write_csv_atomic(kanji_df, kanji_path)

    # Pass 2: Component extraction for missing radicals
    if parquet_dir is None:
        parquet_dir = csv_dir.parent / "parquet"
    pq_path = parquet_dir / "kanjivg.parquet"
    if pq_path.exists():
        parent_index = _build_parent_index(parquet_dir)
        radicals_df = _extract_component_svgs(
            radicals_df,
            svg_map,
            parent_index,
            svg_base_url,
            svg_dir,
            remote_radicals,
            client,
            warnings,
        )
        write_csv_atomic(radicals_df, radicals_path)

        # Replace "Missing SVG" warnings with "Extracted SVG" for entities that got extracted
        extracted_entities = {
            w["entity"] for w in warnings if "Extracted SVG" in w.get("message", "")
        }
        warnings = [
            w
            for w in warnings
            if not (w["entity"] in extracted_entities and "Missing SVG" in w.get("message", ""))
        ]
    else:
        log.info("Pass 2 skipped: %s not found", pq_path)

    # Unmatched SVGs in archive
    matched_kvg = set()
    for _, row in radicals_df.iterrows():
        if pd.notna(row.get("svg_file_name")):
            matched_kvg.add(char_to_kvg_filename(row["master_symbol"]))
    for _, row in kanji_df.iterrows():
        if pd.notna(row.get("svg_file_name")):
            matched_kvg.add(char_to_kvg_filename(row["character"]))

    unmatched_count = len(svg_map) - len(matched_kvg)
    if unmatched_count > 0:
        warnings.append({
            "severity": "low",
            "phase": "2.4",
            "entity": "-",
            "message": f"{unmatched_count} SVG files in archive with no matching entity",
        })

    # Write warnings
    if warnings:
        warnings.sort(key=severity_sort_key)
        warnings_df = pd.DataFrame(warnings, columns=["severity", "phase", "entity", "message"])
        write_csv_atomic(warnings_df, warnings_dir / "ph2_4_warnings.csv")
        high_count = sum(1 for w in warnings if w["severity"] == "high")
        log.info("Warnings: %d total (%d high severity)", len(warnings), high_count)

    return {
        "radicals": radicals_df,
        "kanji": kanji_df,
    }
