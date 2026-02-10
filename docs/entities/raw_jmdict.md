# Raw JMdict

## Overview

Raw staging table for data imported from [JMdict](http://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project) — the comprehensive Japanese–multilingual dictionary maintained by the Electronic Dictionary Research and Development Group. Each row stores the complete JMdict representation of a single dictionary entry as structured JSONB, preserving the original XML data exactly as parsed.

Two source files feed this table:
- **JMdict** — the base dictionary XML. Provides kanji elements, reading elements, and sense/gloss data.
- **JMdict_e_examp** — the same JMdict entries enriched with Tanaka Corpus example sentence pairs. Used **only** for populating the `examples` column; all other columns are identical.

See [jmdict_format.md](../sources/jmdict_format.md) for full format reference with DTD entity codes.

This is an **admin-only table** — not used by the client app. This table lives in the **Local Supabase** instance (Postgres) and is **ephemeral** — it can be rebuilt by re-ingesting the same source files (idempotent). Raw tables are local-only and disposable; they are not synced to Remote. Access is restricted to the `service_role` key (which bypasses RLS). See [pipeline.md](../technical/pipeline.md) for the stateless admin architecture.

## Entities

### RawJmdict (Entity)

One row per `<entry>` element in JMdict. JSONB columns preserve the full nested structure of kanji elements, reading elements, senses, and example sentences.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `import_id` | `int` | FK to `data_imports`. Part of composite unique constraint with `ent_seq`. Each re-import creates new rows under a new `import_id`, preserving old rows for diffing and rollback. Source version is derived via join to `data_imports.source_version` |
| `ent_seq` | `int` | JMdict entry sequence number — stable across releases, used for cross-referencing between formats |
| `kanji_elements` | `JsonList?` | Array of kanji element objects (see Kanji Element Shape below). Null for kana-only entries (DTD: `k_ele*`) |
| `reading_elements` | `JsonList` | Array of reading element objects (see Reading Element Shape below). Always non-empty (DTD: `r_ele+`) |
| `senses` | `JsonList` | Array of sense objects (see Sense Shape below). Always non-empty (DTD: `sense+`) |
| `examples` | `JsonList?` | Tanaka Corpus sentence pairs (see Example Shape below). Only populated from JMdict_e_examp; null when imported from base JMdict |
| `created_at` | `DateTime` | Row creation timestamp |

**Why JSONB for all structural fields?**

JMdict entries are deeply variable: an entry may have 0–10+ kanji headwords, 1–20+ readings, and 1–30+ senses across multiple languages. Senses themselves contain optional sub-structures (cross-references, loan source info, dialect tags). JSONB preserves the complete source structure without forcing it into a rigid relational schema at the staging layer. The content pipeline extracts exactly what it needs into normalized tables downstream.

**Why a raw staging table instead of importing directly into content tables?**

Same rationale as `raw_kanjivg` and `raw_kanjidic`: decoupled import and transformation, full source data preserved for debugging and schema evolution, independent testability of each pipeline stage.

**Why two source files?**

JMdict_e_examp is a superset of JMdict — identical entry data plus Tanaka Corpus sentence pairs. We use JMdict_e_examp when available to get example sentences for `VocabularySentence` extraction. The base JMdict serves as a fallback (no sentences, `examples` is null). The parser handles both transparently.

### Kanji Element Shape

Each element in the `kanji_elements` array represents one headword containing at least one non-kana character. Where there are multiple elements, they are orthographical variants ordered by frequency of usage.

```json
{
  "keb": "収集",
  "ke_inf": ["ateji"],
  "ke_pri": ["ichi1", "news1", "nf05"]
}
```

| Key | Type | Description |
|---|---|---|
| `keb` | `String` | The headword itself — a word or short phrase written using at least one non-kana character |
| `ke_inf` | `List<String>?` | Coded information about the orthography (e.g. `"ateji"`, `"iK"`, `"oK"`). Uses DTD entity codes. Null if none |
| `ke_pri` | `List<String>?` | Priority indicators (e.g. `"ichi1"`, `"news1"`, `"nf05"`). See [Priority Codes](../sources/jmdict_format.md#priority-codes). Null if none |

### Reading Element Shape

Each element in the `reading_elements` array represents one pronunciation in modern kanadzukai. Where there are multiple elements, they are alternative readings ordered by frequency of usage.

```json
{
  "reb": "しゅうしゅう",
  "re_nokanji": false,
  "re_restr": null,
  "re_inf": null,
  "re_pri": ["ichi1", "news1", "nf05"]
}
```

| Key | Type | Description |
|---|---|---|
| `reb` | `String` | The reading in kana |
| `re_nokanji` | `bool` | `true` if the reading cannot be regarded as a true reading of the kanji (e.g. foreign place names, gairaigo). `false` otherwise |
| `re_restr` | `List<String>?` | Restricts this reading to specific kanji headwords. Each value must exactly match a `keb`. Null when the reading applies to all headwords |
| `re_inf` | `List<String>?` | Coded information about the reading (e.g. `"gikun"`, `"ok"`). Uses DTD entity codes. Null if none |
| `re_pri` | `List<String>?` | Priority indicators. See [Priority Codes](../sources/jmdict_format.md#priority-codes). Null if none |

### Sense Shape

Each element in the `senses` array represents a distinct meaning or translational equivalent.

```json
{
  "stagk": null,
  "stagr": null,
  "pos": ["n", "vs"],
  "xref": null,
  "ant": null,
  "field": null,
  "misc": null,
  "s_inf": null,
  "lsource": null,
  "dial": null,
  "glosses": {
    "eng": ["gathering up", "collection", "accumulation"],
    "spa": ["coleccionar", "recopilar"]
  }
}
```

| Key | Type | Description |
|---|---|---|
| `stagk` | `List<String>?` | Restricts this sense to specific kanji headwords. Each value must match a `keb`. Null when the sense applies to all headwords |
| `stagr` | `List<String>?` | Restricts this sense to specific readings. Each value must match a `reb`. Null when the sense applies to all readings |
| `pos` | `List<String>?` | Part-of-speech codes (e.g. `"n"`, `"vs"`, `"adj-i"`). Uses DTD entity codes — see [Part-of-Speech Codes](../sources/jmdict_format.md#part-of-speech-pos). Null when inheriting from an earlier sense |
| `xref` | `List<String>?` | Cross-references to related entries. Format: `keb` or `reb`, optionally followed by `・reb` and/or `・sense_number`. Null if none |
| `ant` | `List<String>?` | Antonym cross-references. Content must match a `keb` or `reb` in another entry. Null if none |
| `field` | `List<String>?` | Field of application codes (e.g. `"comp"`, `"med"`, `"ling"`). Uses DTD entity codes. Null for general application |
| `misc` | `List<String>?` | Miscellaneous information codes (e.g. `"col"`, `"id"`, `"uk"`). Uses DTD entity codes. Null if none |
| `s_inf` | `String?` | Free-text additional sense information (level of currency, regional variations, etc.). Null if none |
| `lsource` | `List<LsourceObject>?` | Loan-word source language information (see Lsource Shape below). Null for native Japanese words |
| `dial` | `List<String>?` | Dialect codes (e.g. `"ksb"`, `"ktb"`). Uses DTD entity codes. Null for standard Japanese |
| `glosses` | `Map<String, List<String>>` | Translations grouped by ISO 639-2 language code. Keys are language codes (e.g. `"eng"`, `"fre"`, `"ger"`); values are ordered gloss arrays. Always present — at minimum contains `"eng"` (except pure cross-reference entries) |

### Lsource Shape

Each element in the `lsource` array describes the source language of a loan word.

```json
{
  "lang": "eng",
  "value": "collection",
  "ls_type": "full",
  "ls_wasei": false
}
```

| Key | Type | Description |
|---|---|---|
| `lang` | `String` | ISO 639-2 language code (defaults to `"eng"` in source XML). Uses bibliographic B codes |
| `value` | `String?` | The source word or phrase in the originating language. Null if the element is empty in the source XML |
| `ls_type` | `String` | `"full"` if the entry is fully derived from the source, `"part"` if only partially borrowed. Defaults to `"full"` |
| `ls_wasei` | `bool` | `true` if the Japanese word is constructed from source-language words rather than being an actual phrase (wasei-eigo). `false` otherwise |

### Example Shape

Each element in the `examples` array is a Tanaka Corpus sentence pair associated with the entry. Only populated when importing from JMdict_e_examp.

```json
{
  "sentence_ja": "切手を収集しています。",
  "sentence_en": "I collect stamps."
}
```

| Key | Type | Description |
|---|---|---|
| `sentence_ja` | `String` | The Japanese example sentence |
| `sentence_en` | `String` | The English translation from the Tanaka Corpus |

## Relationships

```
RawJmdict ··pipeline··→ vocabulary            (word, frequency_rank, jlpt)
RawJmdict ··pipeline··→ vocabulary_readings   (reb → reading rows)
RawJmdict ··pipeline··→ vocabulary_i18n       (glosses → localized meanings)
RawJmdict ··pipeline··→ vocabulary_kanji      (kanji chars extracted from keb)
RawJmdict ··pipeline··→ vocabulary_sentences  (examples → sentence rows)
```

These are **pipeline-level data flows**, not foreign keys. The content pipeline reads from `raw_jmdict` and writes to the downstream tables. There are no FK constraints between them.

## Business Rules

1. **Composite unique constraint:** `import_id` + `ent_seq` must be unique. Re-imports create new rows with a new `import_id`, leaving old rows for diffing and rollback.
2. `ent_seq` must be a positive integer.
3. `reading_elements` must be a non-empty array (DTD: `r_ele+`). Every entry has at least one reading.
4. `senses` must be a non-empty array (DTD: `sense+`). Every entry has at least one sense.
5. Each sense should have at least one gloss entry — except pure cross-reference entries that carry only `xref` with no glosses.
6. **RLS:** RLS is enabled with zero policies for `authenticated` or `anon` roles. Only `service_role` (which bypasses RLS) can read or write this table.
7. `kanji_elements` null is valid — kana-only entries have no kanji headwords.
8. Re-imports create new rows under a new `import_id`. Old rows are preserved for diffing and rollback.

## Edge Cases

- **Kana-only entries:** Entries for words written entirely in kana (e.g. すごい, ありがとう) have `kanji_elements: null`. The pipeline must handle these when populating `vocabulary` and `vocabulary_kanji`.
- **`re_nokanji` flag:** Some readings cannot be regarded as true readings of the kanji (e.g. foreign place names, gairaigo that can appear in kanji or katakana). The pipeline should not pair these readings with kanji headwords.
- **`re_restr` restricting readings:** When `re_restr` is present, the reading applies only to the listed `keb` values, not all headwords. The pipeline must respect this when generating `vocabulary_readings`.
- **`pos` inheritance across senses:** Only the first sense (or a sense that introduces a new part of speech) carries `pos`. Later senses with `pos: null` inherit from the most recent earlier sense that specified it. The parser must track this state during extraction.
- **`lsource` for loan words:** Entries borrowed from other languages carry `lsource` data. Wasei-eigo (`ls_wasei: true`) are Japanese-coined words using foreign roots (e.g. サラリーマン from "salary" + "man"), not direct borrowings.
- **Multilingual glosses:** Glosses may exist in many languages (eng, fre, ger, dut, rus, spa, hun, slv, etc.). The pipeline must handle any language code present in the data. English is the most complete; other languages have partial coverage.
- **Pure cross-reference entries:** Some senses carry only `xref` with no glosses — they point to another entry for the actual meaning. The pipeline may skip these when populating `vocabulary_i18n`.
- **Entries without example sentences:** When imported from base JMdict (not JMdict_e_examp), `examples` is null. The pipeline skips `vocabulary_sentences` extraction for these entries.
- **Re-import with updated entries:** If a new JMdict release modifies an entry, the old row remains under the previous `import_id`. The new import creates a new row with the same `ent_seq` under the new `import_id`. Diffing compares across import versions.
- **Entries with many senses and languages:** Some entries (e.g. common verbs like する) have 30+ senses across multiple languages. The JSONB structure handles this without schema changes.
