# SVG Processing & Hashing

## Overview

SVG Processing (pipeline Phase 2.4) populates SVG-related fields on `radicals.csv`, `radical_variants.csv`, and `kanji.csv`. Each entity that represents a visible character needs an SVG illustration from the KanjiVG archive for stroke-order display in the client app.

The phase runs in two passes:

1. **Pass 1 — ZIP matching:** Match entities to standalone SVG files from the KanjiVG ZIP archive.
2. **Pass 2 — Component extraction:** For radicals/variants still missing an SVG after Pass 1, extract stroke paths from a parent kanji SVG that contains the radical as a component.

**Core principle:** Content-based hashing for delta sync. Each SVG file is hashed (SHA-256) so that the upload phase (Phase 4) can compare hashes against Remote storage and upload only changed files. Identical bytes across KanjiVG versions produce the same hash — unchanged characters are never re-uploaded.

**Scope boundary:** This phase populates `svg_file_name`, `svg_hash`, and `svg_file_url` on output CSVs. It also saves SVG files to `data/svg/` (matched) and `data/svg/extracted/` (component-extracted) for Phase 4 batch upload to Remote Supabase, and uploads to Local Supabase Storage for dev verification.

## Prerequisites

| Dependency | Reason |
|---|---|
| Radical extraction (Phase 2.1, Passes 1–2) | `radicals.csv` and `radical_variants.csv` must exist |
| Kanji composition (Phase 2.2, Steps 1–3) | `kanji.csv` rows must exist |
| KanjiVG ZIP from sources | Source archive: `kanjivg-{version}-main.zip` |
| KanjiVG Parquet from Phase 1 | `kanjivg.parquet` — component trees for parent kanji lookup (Pass 2) |

The phase reads from output CSVs, the ZIP archive, and the KanjiVG Parquet. It updates only SVG columns on those same CSVs.

## Algorithm

### Pass 1: ZIP Matching

#### Step 1: Build SVG Map

Read the `kanjivg-{version}-main.zip` archive in memory. Each file in the archive is a standalone SVG for one character, named by Unicode code point (see [File Naming](#file-naming)).

Build a lookup map: `Map<kvg_filename, (bytes, sha256)>` keyed by KanjiVG filename (e.g. `06c34.svg` → (raw bytes, hex digest)). Hash is computed inline as `SHA-256` of the raw file bytes.

```
SHA-256(raw bytes of 06c34.svg) → "a1b2c3d4..."  (64-char hex string)
```

#### Step 2: Match Entities

For each entity type, resolve the character to its SVG filename, look up in the map, and update the CSV row.

**2a. Radicals:** For each `radicals.csv` row:
1. Convert `master_symbol` to its Unicode code point → filename (see [File Naming](#file-naming)).
2. Look up the filename in the SVG map from Step 1.
3. If found, set `svg_file_name`, `svg_hash`, `svg_file_url`.
4. If not found, leave SVG fields empty (candidate for Pass 2).

**2b. Radical variants:** For each `radical_variants.csv` row:
1. Convert `shape` to its Unicode code point → filename.
2. Look up and populate as above.

**2c. Kanji:** For each `kanji.csv` row:
1. Convert `character` to its Unicode code point → filename.
2. Look up and populate as above.

### Pass 2: Component Extraction

After Pass 1, some radicals/variants have no standalone SVG in the KanjiVG archive. Many of these exist as component elements inside parent kanji SVGs — their stroke paths are embedded in `<g kvg:element="...">` groups. Pass 2 extracts these strokes to create standalone SVGs.

**Only radicals and radical variants are candidates for extraction.** Kanji without a standalone SVG are never extracted from other kanji.

#### Step 3: Find Parent Kanji

For each radical/variant still missing SVG fields after Pass 1:

1. Search `kanjivg.parquet` component trees for any kanji whose `component_tree` contains the target character as an `element` value.
2. Select the best parent — prefer one where the target is a direct child (not deeply nested) and that has a standalone SVG in the ZIP.
3. If no parent found, the radical truly has no SVG source — emit a high-severity warning.

#### Step 4: Extract Strokes

For each matched parent kanji:

1. Parse the parent's SVG bytes from the ZIP.
2. Locate the `<g>` group with `kvg:element` matching the target character.
3. Extract all `<path>` elements within that group (these are the strokes for the radical).
4. Re-wrap into a standalone SVG with a viewBox fitted to the extracted paths' bounding area.
5. Compute SHA-256 of the generated SVG bytes.
6. Set `svg_file_name`, `svg_hash`, `svg_file_url` on the CSV row (same naming/URL rules as Pass 1).
7. Save to `data/svg/extracted/radicals/` (separate folder for admin visual verification).

#### Step 5: Update Warnings

After Pass 2, rebuild the warnings list:

- Radicals/variants that were **extracted** in Pass 2: emit a **low**-severity `"extracted"` warning so the admin knows which SVGs are component-extracted (not from standalone files). These may need visual review.
- Radicals/variants still **missing** after both passes: emit a **high**-severity warning (JLPT-mapped) or **low**-severity warning (non-JLPT), same as before.
- Kanji missing SVGs: **high** severity (JLPT-mapped) or **low** severity (non-JLPT).

## File Naming

SVG files use the Unicode code point as filename: **5-digit zero-padded lowercase hex** with `.svg` extension.

| Character | Code point | Filename |
|---|---|---|
| 水 | U+6C34 | `06c34.svg` |
| 氵 | U+6C35 | `06c35.svg` |
| 休 | U+4F11 | `04f11.svg` |
| 一 | U+4E00 | `04e00.svg` |
| 𠀋 | U+2000B | `2000b.svg` |

**Conversion:** Take the character's Unicode code point as an integer, format as lowercase hex, zero-pad to at least 5 digits. Characters in the supplementary planes (above U+FFFF) produce filenames longer than 5 digits — no padding needed since they already exceed 5 digits.

## URL Construction

The `svg_file_url` is constructed from the Supabase Storage public bucket URL pattern:

```
{supabase_url}/storage/v1/object/public/svg/{svg_file_name}
```

Example: `https://xyz.supabase.co/storage/v1/object/public/svg/06c34.svg`

The `svg` bucket is declared in `supabase/config.toml` and created by migration. It is a **public** bucket — SVG files are read without authentication.

## Entity Matching

### Radicals

`master_symbol` → Unicode code point → filename. Example: radical with `master_symbol` = 水 → code point 0x6C34 → `06c34.svg`.

### Radical Variants

`shape` → Unicode code point → filename. Example: variant with `shape` = 氵 → code point 0x6C35 → `06c35.svg`.

Each variant has its own SVG showing the shape as it appears at a specific position in a kanji. The master radical (水) and its variant (氵) have separate SVG files.

### Kanji

`character` → Unicode code point → filename. Example: kanji with `character` = 休 → code point 0x4F11 → `04f11.svg`.

## Worked Examples

### 水 (Radical — Water)

- `master_symbol` = 水, code point = U+6C34
- Filename: `06c34.svg`
- Hash: SHA-256 of `06c34.svg` raw bytes → `"a1b2..."`
- URL: `{supabase_url}/storage/v1/object/public/svg/06c34.svg`
- Updated fields on `radicals.csv`: `svg_file_name = '06c34.svg'`, `svg_hash = 'a1b2...'`, `svg_file_url = '{url}'`

### 氵 (Variant of 水)

- `shape` = 氵, code point = U+6C35
- Filename: `06c35.svg`
- Hash: SHA-256 of `06c35.svg` raw bytes → `"e5f6..."`
- URL: `{supabase_url}/storage/v1/object/public/svg/06c35.svg`
- Updated fields on `radical_variants.csv`: `svg_file_name = '06c35.svg'`, `svg_hash = 'e5f6...'`, `svg_file_url = '{url}'`

### 休 (Kanji — Rest)

- `character` = 休, code point = U+4F11
- Filename: `04f11.svg`
- Hash: SHA-256 of `04f11.svg` raw bytes → `"c3d4..."`
- URL: `{supabase_url}/storage/v1/object/public/svg/04f11.svg`
- Updated fields on `kanji.csv`: `svg_file_name = '04f11.svg'`, `svg_hash = 'c3d4...'`, `svg_file_url = '{url}'`

### 㐭 (Radical — Component-Extracted, Pass 2)

- `master_symbol` = 㐭, code point = U+342D
- No standalone SVG in KanjiVG ZIP (Pass 1 misses)
- Pass 2: found as `kvg:element="㐭"` in parent kanji 亶 (`04eb6.svg`) — 8 strokes (亠 + 回)
- Extract `<g>` group strokes → re-wrap into standalone SVG → compute SHA-256
- Filename: `342d.svg` (same naming rules)
- Saved to: `data/svg/extracted/radicals/342d.svg`
- URL: `{supabase_url}/storage/v1/object/public/svg/radicals/342d.svg` (same bucket)
- Warning: low severity — "Extracted SVG for radical '㐭' from parent 亶"

## Disk Output

SVG files are saved to `data/svg/` alongside `data/csv/`. The folder structure separates ZIP-matched files from component-extracted files:

```
data/svg/
  radicals/              # Pass 1: ZIP-matched radical + variant SVGs (e.g. 4e00.svg)
  kanji/                 # Pass 1: ZIP-matched kanji SVGs (e.g. 4f11.svg)
  extracted/
    radicals/            # Pass 2: Component-extracted radical SVGs (e.g. 342d.svg)
```

The `extracted/` subfolder exists specifically for admin visual verification — the admin can browse these files in an SVG viewer to confirm the extraction produced correct glyphs. Broken extractions can be identified and the extraction logic updated.

**Upload destination:** Both `data/svg/radicals/` and `data/svg/extracted/radicals/` upload to the same `radicals/` folder in the Supabase Storage `svg` bucket. Same naming convention, same hash rules, same URL pattern. From the client app's perspective there is no distinction.

**Idempotency:** Files are skipped if already on disk with the same size. Re-running the phase does not re-write unchanged files.

**Purpose:** These folders are the staging area for Phase 4, which batch-uploads SVGs to Remote Supabase Storage. The entire `data/svg/` tree is gitignored (`pipeline/data/.gitignore`).

## Local Supabase Upload

When `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` environment variables are set, the phase also uploads SVGs to Local Supabase Storage for dev verification. This uses the `svg` bucket declared in `supabase/config.toml`.

- **New files** are uploaded via `POST`.
- **Existing files** (already in remote listing) are skipped.
- **409 Duplicate** errors (race condition or incomplete listing) are handled gracefully — the file is counted as skipped.
- **Changed hashes** (file exists remotely but local hash differs from previous CSV hash) emit a high-severity warning for admin review. The admin must re-upload manually.

If the env vars are not set, uploads are skipped with a warning log — the phase still populates CSV fields and writes disk files normally.

## Warnings

Warnings are written to `data/csv/warnings/ph2_4_warnings.csv` with columns: `severity, phase, entity, message`.

| Condition | Severity | Rationale |
|---|---|---|
| Extracted SVG for radical/variant (Pass 2) | low | SVG was component-extracted, not from standalone file — admin should visually verify |
| Missing SVG for JLPT-mapped kanji | high | Learner-facing content gap — kanji in a JLPT level will lack stroke-order display |
| Missing SVG for JLPT-mapped radical/variant (after both passes) | high | No standalone SVG and no parent kanji to extract from |
| Missing SVG for non-JLPT kanji | low | Informational — may be a rare or ungraded character |
| Missing SVG for non-JLPT radical/variant (after both passes) | low | Informational — radical only appears in ungraded kanji |
| SVG file in archive with no matching entity | low | Expected for unused characters — KanjiVG has broader coverage than our entity set |

The "extracted" warnings are important for tracking which SVGs are not from the original KanjiVG archive. If an extracted SVG turns out to be visually broken, the admin can identify it from this list and update the extraction logic.

**JLPT presence detection:**
- **Kanji:** Checked via `kanji.csv` `min_jlpt_level` being non-empty.
- **Radicals:** A radical is JLPT-mapped if any kanji it composes is JLPT-mapped. Derived from `radicals.csv` `min_jlpt_level` (populated by radical metadata derivation in Phase 2.3 Step 3).
- **Radical variants:** Inherit JLPT status from their parent radical's `min_jlpt_level`.

## Edge Cases

### Missing SVG for a character

For radicals/variants, Pass 2 attempts component extraction before giving up. If neither pass produces an SVG, the fields (`svg_file_name`, `svg_hash`, `svg_file_url`) remain empty in the CSV. A warning is emitted (severity depends on JLPT mapping — see warnings table). The entity row is still valid and uploads normally (SVG fields are nullable in Supabase). The client app handles missing SVGs gracefully (e.g. render the character as plain text without stroke-order illustration).

For kanji, only Pass 1 (ZIP matching) is attempted — kanji are never extracted from other kanji.

### SVG file with no matching entity

The KanjiVG archive contains SVGs for thousands of characters, many of which are not in our radical or kanji set. These unmatched files are silently skipped with a low-severity warning summarizing the count. This is expected — KanjiVG covers far more characters than JLPT N5–N1.

### Re-run idempotency

The phase is idempotent. Re-running with the same KanjiVG archive and the same CSVs produces identical results:
- SVG fields are overwritten with the same values (same bytes → same hash).
- Warnings are regenerated identically.

If the KanjiVG archive changes between runs (new version), only characters with modified SVG bytes get a new `svg_hash`. Unchanged characters retain their previous hash value.

### Characters with multiple code points (ZWJ sequences, combining marks)

KanjiVG files are keyed by a single Unicode code point. All kanji, radicals, and radical variants in our dataset are single code point characters. Multi-code-point sequences do not occur in this context.

## Output Summary

| CSV | Fields Updated | Source |
|---|---|---|
| `radicals.csv` | `svg_file_name`, `svg_file_url`, `svg_hash` | Pass 1: ZIP match on `master_symbol`; Pass 2: component extraction |
| `radical_variants.csv` | `svg_file_name`, `svg_file_url`, `svg_hash` | Pass 1: ZIP match on `shape`; Pass 2: component extraction |
| `kanji.csv` | `svg_file_name`, `svg_file_url`, `svg_hash` | Pass 1 only: ZIP match on `character` |

SVG fields are **nullable** in both CSVs and the Supabase schema. A kanji or radical may exist in KANJIDIC without a corresponding KanjiVG entry — the row is still valid, it just lacks stroke-order illustration. The client app handles missing SVGs gracefully (plain text fallback). High-severity warnings flag entities still missing SVGs after both passes.

## Hash Stability

The `svg_hash` field enables efficient delta sync in Phase 4 (upload):

1. **Same KanjiVG version:** Re-running produces identical hashes. No uploads needed.
2. **New KanjiVG version, unchanged character:** If the SVG file bytes are identical, the hash is unchanged. Phase 4 skips the upload.
3. **New KanjiVG version, modified character:** Different bytes → different hash. Phase 4 detects the mismatch and uploads the new file.

This approach avoids re-uploading the entire SVG set (~13,000 files) on each release. Only delta changes are transmitted.

## Related Docs

- [radical.md](../domain/radical.md) — Radical entity spec (SVG fields: `svg_file_name`, `svg_file_url`, `svg_hash`)
- [kanji.md](../domain/kanji.md) — Kanji entity spec (SVG fields)
- [pipeline.md](pipeline.md) — Full pipeline orchestration (Phase 2.4 summary)
- [ph2_1_radical_extraction.md](ph2_1_radical_extraction.md) — Phase 2.1: radical/variant creation (prerequisite)
- [ph2_2_kanji_composition.md](ph2_2_kanji_composition.md) — Phase 2.2: kanji row creation (prerequisite)
- [supabase.md](../adr/supabase.md) — Storage bucket configuration and URL patterns
