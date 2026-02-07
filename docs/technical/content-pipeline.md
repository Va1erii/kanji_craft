# Content Pipeline

## Overview

The content pipeline populates the 12 content tables (radicals, kanji, vocabulary and their children) from external XML/data sources. No content is entered directly into Supabase — everything flows through a structured pipeline that ensures consistency, cross-referencing, and review before data reaches production.

**Flow:**

```
External XML sources
        ↓
   Python parser         → tools/parser/
        ↓
   AI suggestion pass    → LLM fills draft values for manual-entry fields
        ↓
   seed.json             → tools/parser/output/seed.json
        ↓
   Admin review (Flutter) → debug-only UI (review AI suggestions + fill remaining gaps)
        ↓
   Push to Supabase      → populates content tables + uploads SVGs
```

## Data Sources

### KANJIDIC2 (XML)

The standard kanji dictionary file maintained by the Electronic Dictionary Research and Development Group (EDRDG).

**Provides:**
- `character` — the kanji character
- `stroke_count` — number of strokes
- `grade` — Japanese school grade (1–6 for jouyou)
- `jlpt` — old JLPT level (4-level scale; requires mapping to new 5-level scale)
- `freq` — newspaper frequency rank
- Onyomi and kunyomi readings (with okurigana in kunyomi)
- English meanings

**Does not provide:** SVGs, system mnemonics, search tags, reading priorities.

### KanjiVG (XML/SVG)

KanjiVG provides stroke-order SVG files and component decomposition trees for kanji characters.

**Provides:**
- SVG stroke-order files for each kanji (by Unicode code point)
- Component decomposition tree — nested elements showing how a character breaks down
- `kvg:element` — the character/radical at each node
- `kvg:position` — spatial position within the parent (left, right, top, bottom, etc.)

**Does not provide:** Radical identity mapping (its elements are visual, not semantically matched to our `radicals` table), logic hints (semantic vs phonetic), reading data.

### JMdict (XML)

The Japanese-Multilingual Dictionary maintained by EDRDG. Contains vocabulary entries with readings and translations.

**Provides:**
- `keb` — kanji written form(s) of a word
- `reb` — kana reading(s) of a word
- `gloss` — English (and other language) meanings
- `ke_pri`/`re_pri` — frequency/priority markers (nf01–nf48, ichi1, news1, etc.)

**Does not provide:** JLPT level (JMdict has no JLPT tags), system mnemonics, search tags, example sentences, kanji decomposition into positions.

### Tatoeba / Manual

Example sentences are sourced from the Tatoeba corpus or written manually.

**Provides:**
- Japanese sentences using target vocabulary
- English (and other language) translations

**Does not provide:** Furigana annotations (must be generated/reviewed manually).

### Fields Requiring Manual Entry

These fields have no fully automated source. The AI suggestion pass (see Step 1b) pre-fills draft values for most of them, but all require human review before push:

| Table | Field | Notes |
|---|---|---|
| `radicals` | `master_symbol` | Curated — not all come from standard sources |
| `radicals` | `impact_score` | Computed from kanji frequency data, but requires review |
| `radicals` | `is_official` | `true` for 214 Kangxi radicals, `false` for custom |
| `radical_i18n` | `name` | English name for the radical |
| `radical_i18n` | `system_mnemonic` | Hand-written learning story |
| `radical_i18n` | `search_tags` | Synonyms for search |
| `radical_variants` | `position` | Mapped from KanjiVG position strings |
| `radical_variants` | `is_locked` | Whether this shape is fixed to one position |
| `kanji_readings` | `priority` | primary/secondary classification |
| `kanji_i18n` | `system_mnemonic` | Hand-written learning story |
| `kanji_i18n` | `search_tags` | Synonyms for search |
| `kanji_components` | `logic_hint` | semantic/phonetic — defaults to `semantic` |
| `vocabulary_readings` | `priority` | primary/secondary classification |
| `vocabulary_i18n` | `system_mnemonic` | Optional learning story |
| `vocabulary_i18n` | `search_tags` | Synonyms for search |
| `vocabulary_sentences` | `sentence_furigana` | `[kanji|reading]` annotation format |
| `vocabulary_sentences` | `sentence_translated` | Translation (if not from Tatoeba) |
| All SVG entities | `svg_file_url` | Populated during push (Supabase Storage URL) |
| All SVG entities | `svg_hash` | Computed during push (hash of SVG file contents) |

## Seed JSON Schema

The parser outputs a single `seed.json` file containing all content for a given scope (e.g., N5 + Grade 1). Nested structures mirror the entity hierarchy. Cross-entity references use `_ref` keys (resolved to real IDs during push).

### Conventions

- `null` — field still needs entry (no value yet, not even an AI suggestion)
- `""` (empty string) — field will be computed later (e.g., `svg_file_url` populated during push)
- `_ref` — symbolic reference to another entity's `_ref` value (resolved to real DB ID after insert)
- `_is_ai_suggested` — boolean flag on objects that contain AI-generated draft values. `true` = at least one field was pre-filled by the AI pass and needs human review. The admin UI highlights these differently from human-confirmed values

### Structure

```jsonc
{
  "meta": {
    "version": "1.0.0",
    "scope": "n5_grade1",
    "generated_at": "2026-02-07T12:00:00Z",
    "stats": {
      "radicals": 50,
      "kanji": 80,
      "vocabulary": 200
    }
  },

  "radicals": [
    {
      "_ref": "radical:水",           // symbolic ref for cross-linking
      "_is_ai_suggested": true,      // AI pre-filled some fields; needs review
      "master_symbol": "水",
      "stroke_count": 4,
      "impact_score": 9,              // AI-suggested from kanji frequency data
      "min_jlpt_level": 5,
      "min_grade": 1,
      "svg_file_name": "06c34.svg",
      "svg_file_url": "",             // populated during push
      "svg_hash": "",                 // computed during push
      "is_official": true,
      "i18n": [
        {
          "_is_ai_suggested": true,
          "lang_code": "en",
          "name": "Water",            // AI-suggested
          "system_mnemonic": "Picture a river flowing down a mountainside — three streams of water rushing left.", // AI draft
          "search_tags": ["liquid", "river", "flow"]  // AI-suggested
        }
      ],
      "variants": [
        {
          "shape": "氵",
          "position": "hen",
          "is_locked": true,           // AI-suggested (氵 is always hen)
          "svg_file_name": "06c35.svg",
          "svg_file_url": "",
          "svg_hash": ""
        }
      ]
    }
  ],

  "kanji": [
    {
      "_ref": "kanji:日",
      "_is_ai_suggested": true,
      "character": "日",
      "stroke_count": 4,
      "min_jlpt_level": 5,
      "min_grade": 1,
      "frequency_rank": 1,
      "svg_file_name": "065e5.svg",
      "svg_file_url": "",
      "svg_hash": "",
      "readings": [
        {
          "reading": "ニチ",
          "reading_type": "onyomi",
          "priority": "primary"       // AI-suggested: ichi1 frequency marker
        },
        {
          "reading": "ひ",
          "reading_type": "kunyomi",
          "priority": "primary"       // AI-suggested: ichi1 frequency marker
        }
      ],
      "i18n": [
        {
          "_is_ai_suggested": true,
          "lang_code": "en",
          "meanings": ["day", "sun"],
          "system_mnemonic": "A window with the sun shining through — you can see the bright day outside.", // AI draft
          "search_tags": ["solar", "daily", "sunshine"]  // AI-suggested
        }
      ],
      "components": [
        {
          "radical_ref": "radical:日", // resolved to radicals.id during push
          "logic_hint": "semantic"     // AI-suggested; reviewed manually
        }
      ]
    }
  ],

  "vocabulary": [
    {
      "_ref": "vocab:日本",
      "_is_ai_suggested": true,
      "word": "日本",
      "min_jlpt_level": 5,
      "frequency_rank": 1,
      "readings": [
        {
          "reading": "にほん",
          "priority": "primary"       // AI-suggested: ichi1 frequency marker
        }
      ],
      "i18n": [
        {
          "_is_ai_suggested": true,
          "lang_code": "en",
          "meanings": ["Japan"],
          "system_mnemonic": null,    // AI left null — meaning is self-explanatory
          "search_tags": ["Japanese", "Nihon", "Nippon"]  // AI-suggested
        }
      ],
      "kanji_links": [
        {
          "kanji_ref": "kanji:日",    // resolved to kanji.id during push
          "position": 0
        },
        {
          "kanji_ref": "kanji:本",
          "position": 1
        }
      ],
      "sentences": [
        {
          "lang_code": "en",
          "sentence_ja": "日本に行きたい。",
          "sentence_furigana": null,   // needs manual annotation
          "sentence_translated": "I want to go to Japan."
        }
      ]
    }
  ]
}
```

## Step 1: Python Parser

Location: `tools/parser/`

The parser reads external XML sources and produces `seed.json`. It runs locally (not in CI) and is invoked manually.

### Environment Setup

The parser uses a Python virtual environment. On a fresh checkout:

```bash
cd tools/parser
make setup          # creates .venv, installs dependencies
```

`make setup` creates `.venv/` from `requirements.txt`. All `make` targets activate the venv automatically — no manual `source .venv/bin/activate` needed.

After setup, download the data sources manually (see next section) and extract them into `data/`.

### Data Sources — Manual Download

Archives are **not** tracked in git. Download ZIP/gzip files from GitHub releases, extract into `.unpacked/` directories (gitignored), and keep stable names so parser code doesn't change between versions.

#### Sources to download

| Source | Repo / URL | Assets (MVP) | Extract to |
|---|---|---|---|
| KanjiVG | [`KanjiVG/kanjivg`](https://github.com/KanjiVG/kanjivg/releases) GitHub releases | `kanjivg-*.xml.gz`, `kanjivg-*-main.zip` | `data/kanjivg/.unpacked/` |
| JMdict + KANJIDIC | [`yomidevs/jmdict-yomitan`](https://github.com/yomidevs/jmdict-yomitan/releases) GitHub releases | `JMdict_english_with_examples.zip`, `JMdict_spanish.zip`, `KANJIDIC_english.zip`, `KANJIDIC_spanish.zip` | `data/jmdict/.unpacked/{name}/` |

**MVP languages:** English (with Tatoeba examples via `JMdict_english_with_examples.zip`) and Spanish (`JMdict_spanish.zip`, no examples).

#### Directory structure

```
tools/parser/data/
├── kanjivg/
│   └── .unpacked/
│       ├── kanjivg.xml               ← gunzip kanjivg-*.xml.gz
│       └── kanjivg/                  ← unzip kanjivg-*-main.zip
│           └── *.svg
└── jmdict/
    └── .unpacked/
        ├── jmdict-en/                ← JMdict_english_with_examples.zip
        ├── jmdict-es/                ← JMdict_spanish.zip
        ├── kanjidic-en/              ← KANJIDIC_english.zip
        └── kanjidic-es/              ← KANJIDIC_spanish.zip
```

Each ZIP extracts Yomitan-format JSON files (`index.json`, `tag_bank_*.json`, `term_bank_*.json`, `term_meta_bank_*.json`). Extract each into its own subdirectory under `.unpacked/`.

All `.unpacked/` directories are gitignored. No archives are tracked in git.

### Scope Filtering

The MVP targets **N5 + Grade 1** content. The parser accepts a scope argument to filter which characters and words to include:

```bash
python tools/parser/main.py --scope n5_grade1
```

This produces only radicals, kanji, and vocabulary that fall within JLPT N5 or school grade 1.

### KANJIDIC2 Parsing

**Input:** `tools/parser/data/jmdict/.unpacked/kanjidic-en/` (Yomitan-format JSON)

1. Filter `<character>` entries by grade (1–6) and JLPT level
2. Extract: character, stroke_count, grade, jlpt, freq, readings, meanings

**JLPT old → new mapping caveat:** KANJIDIC2 uses the pre-2010 4-level JLPT scale (1–4). The new scale has 5 levels (N5–N1). The parser maps old levels to new levels using a lookup table. Old level 4 → N5, old level 3 → N4, etc. N2 is split — some old level 2 kanji map to N3 and others to N2. This split is handled via a supplementary mapping file.

**Kunyomi okurigana stripping:** KANJIDIC2 represents kunyomi with okurigana after a dot (e.g., `た.べる` for 食). The parser strips the dot and okurigana, storing only the kana stem (`た`) as the reading. The full form including okurigana is vocabulary-level data, not kanji-level.

### KanjiVG Parsing

**Input:** `tools/parser/data/kanjivg/.unpacked/kanjivg.xml` (SVGs in `.unpacked/kanjivg/`)

The parser extracts the component decomposition tree from each KanjiVG file and flattens it into `kanji_components` rows.

**Tree flattening strategy:**

KanjiVG provides a nested tree where each node can have children. The parser walks the tree top-down:

1. For each first-level child of the root, check if its `kvg:element` matches any entry in our radicals lookup — this checks both `radicals.master_symbol` and all `radical_variants.shape` values (via `kangxi_radicals.json` + `radical_aliases.json`)
2. If it matches → record as a component (resolving variant shapes back to the parent radical's `_ref`) and stop recursing into that subtree
3. If no match → recurse into that node's children and repeat
4. Leaf nodes that don't match any radical are logged as warnings (potential missing radicals)

This strategy avoids over-decomposing (e.g., splitting 木 into 十 and 八) while still catching radicals that are nested one level deeper in the KanjiVG tree.

**False friend caveat:** KanjiVG's element labels are visual, not semantic. The same visual shape may map to a different radical in our system than what KanjiVG labels suggest. For example, KanjiVG might label a component as 匕 (Spoon), but our mnemonic system teaches it as a custom radical with a different name. The `radical_aliases.json` file handles these overrides — it maps KanjiVG element values to our canonical radical `_ref`, including cases where our decomposition intentionally differs from KanjiVG's labeling.

**Position mapping:** KanjiVG uses its own position vocabulary (`left`, `right`, `top`, `bottom`, `enclose`, etc.). The parser maps these to our `position_type` enum via `position_map.json`.

### JMdict Parsing

**Input:** `tools/parser/data/jmdict/.unpacked/jmdict-en/` (Yomitan-format JSON)

JMdict contains no JLPT tags, so N5 vocabulary filtering uses an external word list.

1. Load the N5 word list from `jlpt_vocab_n5.json` (sourced from community JLPT study lists)
2. For each JMdict `<entry>`, check if any `<keb>` (written form) matches the N5 list
3. Extract: word, readings, English glosses, frequency priority markers
4. Map `ke_pri`/`re_pri` priority markers to `frequency_rank` (lower nfNN = higher rank)
5. For each kanji character in the word, create a `kanji_links` entry referencing the kanji `_ref`

### Mapping Files

Located in `tools/parser/mappings/`:

| File | Purpose |
|---|---|
| `kangxi_radicals.json` | Maps the 214 Kangxi radicals: number, symbol, stroke count, common variants |
| `position_map.json` | Maps KanjiVG position strings to `position_type` enum values |
| `radical_aliases.json` | Maps variant shapes to their parent radical (e.g., `氵` → `水`) |
| `jlpt_vocab_n5.json` | List of N5 vocabulary words for JMdict filtering |
| `jlpt_kanji_map.json` | Old JLPT 4-level → new 5-level mapping for kanji |

### Validation Rules

The parser runs validation checks before writing `seed.json`:

- Every kanji in scope must have at least one reading
- Every kanji in scope must have at least one English meaning
- Every kanji must have at least one component (warning if none found via KanjiVG)
- Every vocabulary word must have at least one reading
- Every vocabulary word must have at least one English meaning
- Every `kanji_ref` in vocabulary `kanji_links` must point to a kanji in the seed file
- Every `radical_ref` in kanji `components` must point to a radical in the seed file
- No duplicate `_ref` values within a category
- `stroke_count > 0` for all radicals and kanji
- `frequency_rank > 0` for all kanji and vocabulary
- `min_jlpt_level` in range 1–5 when present
- `min_grade` in range 1–6 when present

Validation failures are logged with the entity and field. Warnings (e.g., missing components) don't block output; errors (e.g., missing readings) do.

### AI Suggestion Pass (Step 1b)

After the parser produces `seed.json` with `null` manual-entry fields, an optional AI pass pre-fills draft values using an LLM. This reduces the manual review burden from thousands of fields to a review-and-confirm workflow.

```bash
python tools/parser/ai_suggest.py --input output/seed.json --output output/seed.json
```

The AI pass fills:

| Field | Strategy |
|---|---|
| `impact_score` | Count how many in-scope kanji use each radical, normalize to 1–10 |
| `radical_i18n.name` | LLM: "What is the English name for the radical 水?" |
| `system_mnemonic` | LLM: generate a draft mnemonic story for the radical/kanji. Easier to edit a bad mnemonic than write from scratch |
| `search_tags` | LLM: generate 3–5 English synonyms/related terms |
| `logic_hint` | LLM: "For kanji 休, is component 木 semantic or phonetic?" |
| `priority` | Heuristic: readings with `ichi1`/`news1`/`nf01–nf10` markers → `primary`, others → `secondary` |
| `is_locked` | Heuristic: if a variant shape appears in only one `position_type` across all in-scope kanji → `true` |
| `sentence_furigana` | LLM: annotate `sentence_ja` with `[kanji\|reading]` notation |

Every object touched by the AI pass gets `_is_ai_suggested: true`. The admin UI uses this flag to:
- Highlight AI-drafted fields differently from human-confirmed values
- Allow one-click "accept" or inline editing
- Track how many AI suggestions remain unreviewed

`impact_score` and reading `priority` use deterministic heuristics (not LLM), so they are more reliable. LLM-generated fields (`system_mnemonic`, `search_tags`, `logic_hint`, `sentence_furigana`) are drafts that always require human review.

## Step 2: Admin Review (Flutter)

A debug-only feature in the Flutter app for reviewing and editing `seed.json` before push. Runs on web, macOS, or Linux.

### Access Control

Gated via `kDebugMode` — the feature is compiled out of release builds (tree-shaken by the Dart compiler). No runtime flag or feature toggle needed.

### Workflow

1. Load `seed.json` from the local filesystem
2. Display entities grouped by type (radicals → kanji → vocabulary)
3. Highlight fields that are `null` (needs manual entry) or empty (needs review)
4. Allow inline editing of any field
5. Show cross-reference validation (e.g., broken `_ref` links, missing required fields)
6. Save edits back to `seed.json`

### Key Features

- **AI suggestion review** — fields pre-filled by the AI pass (`_is_ai_suggested: true`) are highlighted in a distinct color. Reviewer can accept (clears the flag), edit (clears the flag on save), or reject (resets to `null`)
- **Null field highlighting** — remaining `null` fields (not filled by AI) are flagged separately so reviewers can fill them in
- **Cross-reference validation** — verify all `radical_ref` and `kanji_ref` point to valid entities
- **Completeness tracking** — progress indicator showing: confirmed fields, AI suggestions pending review, and unfilled `null` fields
- **Search and filter** — find entities by character, word, or meaning

## Step 3: Push to Supabase

After admin review, the completed `seed.json` is pushed to Supabase. This step handles insert ordering, `_ref` resolution, and SVG uploads.

### Insert Order

Tables must be inserted in FK dependency order. Each phase completes before the next begins, because child tables reference parent IDs.

| Phase | Table | Depends On |
|---|---|---|
| 1 | `radicals` | — |
| 2 | `radical_i18n` | `radicals` |
| 2 | `radical_variants` | `radicals` |
| 3 | `kanji` | — |
| 4 | `kanji_readings` | `kanji` |
| 4 | `kanji_i18n` | `kanji` |
| 4 | `kanji_components` | `kanji`, `radicals` |
| 5 | `vocabulary` | — |
| 6 | `vocabulary_readings` | `vocabulary` |
| 6 | `vocabulary_i18n` | `vocabulary` |
| 6 | `vocabulary_kanji` | `vocabulary`, `kanji` |
| 6 | `vocabulary_sentences` | `vocabulary` |

Tables within the same phase can be inserted in parallel.

### `_ref` → ID Resolution

After each parent insert, the database returns the generated `id`. The push tool maintains a ref-to-ID map:

```
"radical:水" → 42
"kanji:日"   → 117
"vocab:日本" → 305
```

Child rows use this map to resolve FKs. For example, a kanji component with `"radical_ref": "radical:水"` becomes `radical_id: 42`.

### SVG Upload

Before inserting rows that reference SVGs (`radicals`, `radical_variants`, `kanji`):

1. Read the SVG file from `tools/parser/data/kanjivg/.unpacked/kanjivg/` by `svg_file_name`
2. Compute SHA-256 hash → populate `svg_hash`
3. Upload to the `svg` Supabase Storage bucket (public read)
4. Get the public URL → populate `svg_file_url`

### Idempotency

The push uses `INSERT ... ON CONFLICT DO UPDATE` (upsert) so re-running the push applies corrections (e.g., fixing a typo in a meaning, updating a mnemonic). The conflict target is the natural unique key for each table:

| Table | Conflict Target |
|---|---|
| `radicals` | `master_symbol` |
| `radical_i18n` | `(radical_id, lang_code)` |
| `radical_variants` | `(radical_id, position)` |
| `kanji` | `character` |
| `kanji_readings` | `(kanji_id, reading, reading_type)` |
| `kanji_i18n` | `(kanji_id, lang_code)` |
| `kanji_components` | `(kanji_id, radical_id)` |
| `vocabulary` | `word` |
| `vocabulary_readings` | `(vocabulary_id, reading)` |
| `vocabulary_i18n` | `(vocabulary_id, lang_code)` |
| `vocabulary_kanji` | `(vocabulary_id, position)` |
| `vocabulary_sentences` | `(vocabulary_id, lang_code)` |

SVG uploads are skipped when the existing `svg_hash` matches the local file's hash — only re-uploaded when the SVG content has changed.

### Output

After a successful push, the tool generates `supabase/seed.sql` — a SQL file containing `INSERT` statements for all content tables. This file is used by `supabase db reset` for local development.

## Key Decisions

### Tree Flattening Strategy

KanjiVG decomposition trees can be deeply nested. We flatten greedily — match at the shallowest level possible against both `radicals.master_symbol` and `radical_variants.shape`. This prevents over-decomposition (splitting a known radical into sub-parts) while still catching radicals nested one level deep. Unmatched leaf nodes are flagged for manual review as potential new custom radicals. KanjiVG element labels that conflict with our radical taxonomy are overridden via `radical_aliases.json`.

### JLPT Level Mapping

KANJIDIC2 uses the pre-2010 4-level scale. The old level 2 is split across N2 and N3 in the new scale. We use a supplementary mapping file (`jlpt_kanji_map.json`) rather than a formula, since the split is not purely mechanical — it was determined by the JLPT committee.

### Default Logic Hint

`kanji_components.logic_hint` defaults to `semantic` when the parser cannot determine the role. This is the safer default — most radicals contribute meaning. Phonetic components are explicitly flagged during manual review.

### Reading Priority

The AI suggestion pass auto-classifies reading priority using KANJIDIC2/JMdict frequency markers: readings with `ichi1`, `news1`, or `nf01`–`nf10` are suggested as `primary`, others as `secondary`. These are marked `_is_ai_suggested` and can be overridden during admin review.

### Vocabulary JLPT Source

Since JMdict has no JLPT tags, we use community-maintained word lists (`jlpt_vocab_n5.json`, etc.) as the source of truth for vocabulary JLPT classification. These lists are well-established but not official — the `min_jlpt_level` field is nullable to reflect this uncertainty.
