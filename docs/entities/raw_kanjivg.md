# Raw KanjiVG

## Overview

Raw staging table for data imported from the [KanjiVG](https://kanjivg.tagaini.net/) project — an open-source dataset of stroke and component decomposition data for kanji characters. Each row stores the complete KanjiVG representation of a single kanji as structured JSONB, preserving the original data exactly as parsed from the source SVG files.

This is an **admin-only table** — not used by the client app. This table lives in the **Supabase Staging Database** (Postgres) as the source of truth. The Admin Tool (Flutter/Drift) fetches this data into a local Drift database for processing/transformation before writing to the production tables. Access is restricted to the `service_role` key (which bypasses RLS).

## Entities

### RawKanjiVg (Entity)

One row per kanji character. Flat scalar fields for queryable data; JSONB columns for nested structures.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `import_id` | `int` | FK to `data_imports`. Part of composite unique constraint with `character`. Each re-import creates new rows under a new `import_id`, preserving old rows for diffing and rollback. Source version is derived via join to `data_imports.source_version` |
| `character` | `String` | The kanji character, e.g. "休" |
| `unicode_hex` | `String` | 5-char zero-padded hex code point, e.g. "04f11" |
| `view_box` | `String` | The SVG `viewBox` attribute, typically "0 0 109 109". Stored explicitly so the renderer never assumes a fixed canvas size |
| `stroke_count` | `int` | Total number of strokes (count of `<path>` elements in the source SVG) |
| `strokes` | `JsonList` | Ordered array of stroke objects (see Strokes Shape below) |
| `components` | `JsonObject` | Nested component decomposition tree (see Components Shape below) |

**Why `unicode_hex` in addition to `character`?**

KanjiVG filenames and internal identifiers use the hex code point (e.g. `04f11.svg`). Storing it explicitly avoids repeated conversion and makes joining with SVG asset filenames trivial.

**Why JSONB for `strokes` and `components`?**

KanjiVG data is deeply nested (components contain children which contain children) and variable-width (stroke counts range from 1 to 30+, component depth varies). JSONB preserves the full source structure without forcing it into a rigid relational schema at the staging layer. The content pipeline extracts exactly what it needs into normalized tables downstream.

**Why a raw staging table instead of importing directly into content tables?**

Decoupling import from transformation means: (1) re-running the content pipeline doesn't require re-parsing source files, (2) the raw data is always available for debugging or schema evolution, (3) import and transformation can be tested independently.

### Strokes Shape

Each element in the `strokes` array represents one brush stroke in writing order.

```json
[
  { "number": 1, "type": "㇐",  "path_data": "M 28.25,25.62 C 28.25,24..." },
  { "number": 2, "type": "㇑",  "path_data": "M 50.25,17.25 C 50.12,17.5..." },
  { "number": 3, "type": "㇐",  "path_data": "M 37.62,43.12 C 39.5,42.75..." },
  { "number": 4, "type": "㇑",  "path_data": "M 67.75,27.75 C 67.75,27.75..." },
  { "number": 5, "type": "㇒",  "path_data": "M 62.93,52.96 C 59.87,57.25..." },
  { "number": 6, "type": "㇐",  "path_data": "M 53.5,70.12 C 56.87,69.25..." }
]
```

| Key | Type | Description |
|---|---|---|
| `number` | `int` | 1-based stroke order index |
| `type` | `String` | CJK stroke character indicating stroke direction (㇐ horizontal, ㇑ vertical, ㇒ diagonal, etc.) |
| `path_data` | `String` | SVG `d` attribute value — the bezier curve data for rendering |

### Components Shape

A recursive tree describing how the kanji decomposes into radical/element groups. Example for 休 ("rest" = person + tree):

```json
{
  "element": "休",
  "position": null,
  "variant": null,
  "original": null,
  "part": null,
  "radical": null,
  "phon": null,
  "trad_form": null,
  "stroke_indices": [0, 1, 2, 3, 4, 5],
  "children": [
    {
      "element": "亻",
      "position": "hen",
      "variant": true,
      "original": "人",
      "part": null,
      "radical": "s",
      "phon": null,
      "trad_form": null,
      "stroke_indices": [0, 1],
      "children": []
    },
    {
      "element": "木",
      "position": "tsukuri",
      "variant": null,
      "original": null,
      "part": null,
      "radical": null,
      "phon": null,
      "trad_form": null,
      "stroke_indices": [2, 3, 4, 5],
      "children": []
    }
  ]
}
```

| Key | Type | Description |
|---|---|---|
| `element` | `String` | The character or component at this node, e.g. "休", "亻", "木" |
| `position` | `String?` | Positional role using KanjiVG values: `"left"`, `"right"`, `"top"`, `"bottom"`, `"kamae"`, `"tare"`, `"tarec"`, `"nyo"`, `"nyoc"`, or null for the root. Mapped to our Position enum during extraction (see [kanjivg_format.md](../technical/kanjivg_format.md#position-values)) |
| `variant` | `bool?` | `true` if this is a positional variant of another element (e.g. 亻 is a variant of 人) |
| `original` | `String?` | The base form this variant derives from, e.g. "人" for 亻. Null if not a variant |
| `part` | `int?` | Part number when an element is split across non-contiguous strokes |
| `number` | `int?` | Disambiguates when the same element is split into parts multiple times within one kanji (e.g. 圖 has four 口, two of which are split). Pairs with `part` to uniquely identify each fragment |
| `radical` | `String?` | Radical classification marker from KanjiVG: `"general"`, `"tradit"`, `"nelson"`, `"jis"`, or null. See [kanjivg_format.md](../technical/kanjivg_format.md#radical-values) |
| `phon` | `String?` | Phonetic marker — the on'yomi reading this component contributes, if any. Values are inconsistent in KanjiVG |
| `trad_form` | `String?` | Traditional (kyuujitai) form of the element, if different from the modern form |
| `partial` | `bool?` | `true` if this group represents the element only partially (not all strokes present). Rare |
| `radical_form` | `bool?` | `true` if `element` is a radical-specific Unicode character and `original` holds the standard CJK ideograph. Rare |
| `stroke_indices` | `JsonList` | 0-based indexes into the parent `strokes` array, identifying which strokes belong to this component. Derived from `<path>` nesting inside `<g>` groups in the source SVG |
| `children` | `JsonList` | Nested child components (recursive). Empty array for leaf nodes |

## Relationships

```
RawKanjiVg ··pipeline··→ radicals            (master_symbol, stroke data)
RawKanjiVg ··pipeline··→ radical_variants     (variant shapes, positions)
RawKanjiVg ··pipeline··→ kanji_components     (decomposition tree → flat component rows)
```

These are **pipeline-level data flows**, not foreign keys. The content pipeline reads from `raw_kanjivg` and writes to the downstream tables. There are no FK constraints between them.

## Business Rules

1. `character` must be a single Unicode code point.
2. `unicode_hex` must be exactly 5 characters, zero-padded, lowercase hex.
3. **Composite unique constraint:** `import_id` + `character` must be unique. Re-imports create new rows with a new `import_id`, leaving old rows for diffing and rollback.
4. `stroke_count` must equal the length of the `strokes` array.
5. `strokes` must be ordered by `number` (1-based, contiguous, no gaps).
6. **RLS:** RLS is enabled with zero policies for `authenticated` or `anon` roles. Only `service_role` (which bypasses RLS) can read or write this table.
7. The `components` tree root `element` must match the row's `character`.
8. `view_box` must be a valid SVG viewBox string (four space-separated numbers).

## Edge Cases

- **Kanji with no sub-components:** A few simple kanji (e.g. 一) have a flat component tree — the root element with an empty `children` array. This is valid; it means the character is itself a leaf radical.
- **Deeply nested components:** Some kanji decompose 3–4 levels deep (e.g. 鑑). The JSONB structure handles arbitrary depth without schema changes.
- **Multiple radicals marked:** A single kanji can have more than one node with a non-null `radical` field (one "s" for Kangxi, one "n" for Nelson). Both are preserved.
- **Variant without original:** If KanjiVG marks `variant: true` but omits the `original` field, the pipeline should log a warning and skip variant linkage for that node.
- **Null `position` on root:** The root node of the component tree always has `position: null` — it represents the whole character, not a positioned sub-part.
- **Re-import with fewer characters:** If a new KanjiVG release drops a character, the old row remains under the previous `import_id`. The new import simply won't have a row for that character. Orphan detection (comparing import versions) is a separate pipeline step.
