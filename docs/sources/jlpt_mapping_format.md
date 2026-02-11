# JLPT Mapping Format Reference

## Overview

The JLPT mapping file provides a curated kanji-to-JLPT-level mapping for the current (post-2010) N1–N5 scale. No official kanji lists exist for the new JLPT levels — this dataset is compiled from community-maintained sources.

**Primary source:** [David Luz Gouveia's kanji-data](https://github.com/davidluzgouveia/kanji-data) repository (MIT license), which combines KANJIDIC frequency/grade data with Jonathan Waller's [Tanos JLPT lists](https://www.tanos.co.uk/jlpt/).

**Source file:** `sources/jlpt_mapping/jlpt_mapping.csv`

See [attributions.md](../legal/attributions.md) for license details and required credits.

## File Format

Plain CSV with a header row. Two columns, no quoting needed (values are single characters and integers).

| Column | Type | Description |
|---|---|---|
| `kanji` | Single character | The kanji character |
| `level` | Integer 1–5 | JLPT level (5 = N5 easiest, 1 = N1 hardest) |

**Encoding:** UTF-8, Unix line endings (LF).

**Row count:** 2,211 entries (header excluded).

### Sample Rows

```csv
kanji,level
一,5
二,5
九,5
七,5
人,5
力,4
口,4
工,4
刀,1
```

## Level Distribution

| Level | Label | Count |
|---|---|---|
| N1 | 1 | 1,232 |
| N2 | 2 | 367 |
| N3 | 3 | 367 |
| N4 | 4 | 166 |
| N5 | 5 | 79 |
| **Total** | | **2,211** |

N1 dominates because it is the catch-all for advanced kanji — any JLPT-relevant kanji not assigned to N2–N5 falls here.

## Versioning

No versioning scheme — this is a single curated file, not a periodically released archive. The folder is `sources/jlpt_mapping/` (no version suffix). Updates are manual edits committed directly to the repository.

Unlike KANJIDIC and KanjiVG sources (which use `{source}-{version}/` folders and are tracked in `data_imports`), the JLPT mapping has no import lifecycle. It is loaded directly into `source_jlpt_levels` via TRUNCATE + INSERT.

## Mapping to `source_jlpt_levels`

| CSV Column | Table Column | Transformation |
|---|---|---|
| `kanji` | `character` | Direct copy |
| `level` | `level` | Direct copy |
| — | `source` | Default `'tanos'` |

The table is loaded by truncating all existing rows and bulk-inserting from the CSV. This ensures the table always reflects the current file contents exactly.

## Relationship to `raw_kanjidic.jlpt`

KANJIDIC2 includes a `jlpt` field using the **pre-2010 scale** (levels 1–4). That value is stored as-is in `raw_kanjidic.jlpt` for reference only. The pipeline **ignores** `raw_kanjidic.jlpt` when populating `kanji.min_jlpt_level` — it uses `source_jlpt_levels` exclusively.

See [raw_kanjidic.md](../entities/raw_kanjidic.md) and [kanjidic_format.md](kanjidic_format.md#jlpt-level) for details on the pre-2010 field.

## Related Docs

- [raw_kanjidic.md](../entities/raw_kanjidic.md) — Staging table (stores old JLPT 1–4 for reference)
- [kanjidic_format.md](kanjidic_format.md) — KANJIDIC2 format reference (JLPT field explanation)
- [kanji_composition.md](../technical/kanji_composition.md) — How `source_jlpt_levels` feeds into `kanji.min_jlpt_level`
- [pipeline.md](../technical/pipeline.md) — Pipeline orchestration (source loading)
- [attributions.md](../legal/attributions.md) — License and credit requirements
