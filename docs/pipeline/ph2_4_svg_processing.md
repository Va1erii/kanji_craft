# SVG Processing & Hashing

## Overview

SVG Processing (pipeline Phase 2.4) populates SVG-related fields on `radicals.csv`, `radical_variants.csv`, and `kanji.csv`. Each entity that represents a visible character needs an SVG illustration from the KanjiVG archive for stroke-order display in the client app.

**Core principle:** Content-based hashing for delta sync. Each SVG file is hashed (SHA-256) so that the upload phase (Phase 4) can compare hashes against Remote storage and upload only changed files. Identical bytes across KanjiVG versions produce the same hash — unchanged characters are never re-uploaded.

**Scope boundary:** This phase populates `svg_file_name`, `svg_hash`, and `svg_file_url` on output CSVs. It does **not** upload SVGs to Supabase Storage — that is the responsibility of Phase 4 (upload).

## Prerequisites

| Dependency | Reason |
|---|---|
| Radical extraction (Phase 2.1, Passes 1–2) | `radicals.csv` and `radical_variants.csv` must exist |
| Kanji composition (Phase 2.2, Steps 1–3) | `kanji.csv` rows must exist |
| KanjiVG ZIP from sources | Source archive: `kanjivg-{version}-main.zip` |

The phase reads from output CSVs and the ZIP archive. It updates only SVG columns on those same CSVs.

## Algorithm

### Step 1: Extract SVG Files

Unzip the `kanjivg-{version}-main.zip` archive into a local working directory. Each file in the archive is a standalone SVG for one character, named by Unicode code point (see [File Naming](#file-naming)).

Build a lookup map: `Map<String, File>` keyed by filename (e.g. `06c34.svg` → file handle). This map is used in Step 3 to match entities to their SVG files.

### Step 2: Compute Hashes

For each extracted SVG file, compute `SHA-256` of the raw file bytes and store the hex digest as a string.

```
SHA-256(raw bytes of 06c34.svg) → "a1b2c3d4..."  (64-char hex string)
```

Build a hash map: `Map<String, String>` keyed by filename → hex digest.

### Step 3: Update Output CSVs

For each entity type, resolve the character to its SVG filename, look up the hash, construct the URL, and update the CSV row.

**3a. Radicals:** For each `radicals.csv` row:
1. Convert `master_symbol` to its Unicode code point → filename (see [File Naming](#file-naming)).
2. Look up the filename in the SVG map from Step 1.
3. If found, set `svg_file_name`, `svg_hash`, `svg_file_url`.
4. If not found, leave SVG fields empty and emit a warning.

**3b. Radical variants:** For each `radical_variants.csv` row:
1. Convert `shape` to its Unicode code point → filename.
2. Look up and populate as above.

**3c. Kanji:** For each `kanji.csv` row:
1. Convert `character` to its Unicode code point → filename.
2. Look up and populate as above.

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

## Warnings

Warnings are written to `data/csv/warnings/ph2_4_warnings.csv` with columns: `severity, phase, entity, message`.

| Condition | Severity | Rationale |
|---|---|---|
| Missing SVG for JLPT-mapped kanji | high | Learner-facing content gap — kanji in a JLPT level will lack stroke-order display |
| Missing SVG for JLPT-mapped radical/variant | high | Learner-facing content gap — radical in a JLPT study path will lack illustration |
| Missing SVG for non-JLPT kanji | low | Informational — may be a rare or ungraded character |
| Missing SVG for non-JLPT radical/variant | low | Informational — radical only appears in ungraded kanji |
| SVG file in archive with no matching entity | low | Expected for unused characters — KanjiVG has broader coverage than our entity set |

**JLPT presence detection:**
- **Kanji:** Checked via `kanji.csv` `min_jlpt_level` being non-empty.
- **Radicals:** A radical is JLPT-mapped if any kanji it composes is JLPT-mapped. Derived from `radicals.csv` `min_jlpt_level` (populated by radical metadata derivation in Phase 2.3 Step 3).
- **Radical variants:** Inherit JLPT status from their parent radical's `min_jlpt_level`.

## Edge Cases

### Missing SVG for a character

If an entity's character has no matching SVG file in the archive, the SVG fields (`svg_file_name`, `svg_hash`, `svg_file_url`) remain empty in the CSV. A warning is emitted (severity depends on JLPT mapping — see table above). The entity row is still valid and uploads normally (SVG fields are nullable in Supabase). The client app handles missing SVGs gracefully (e.g. render the character as plain text without stroke-order illustration).

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
| `radicals.csv` | `svg_file_name`, `svg_file_url`, `svg_hash` | `master_symbol` → code point → SVG file |
| `radical_variants.csv` | `svg_file_name`, `svg_file_url`, `svg_hash` | `shape` → code point → SVG file |
| `kanji.csv` | `svg_file_name`, `svg_file_url`, `svg_hash` | `character` → code point → SVG file |

SVG fields are **nullable** in both CSVs and the Supabase schema. A kanji or radical may exist in KANJIDIC without a corresponding KanjiVG entry — the row is still valid, it just lacks stroke-order illustration. The client app handles missing SVGs gracefully (plain text fallback). High-severity warnings flag JLPT-mapped entities with missing SVGs for admin review.

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
