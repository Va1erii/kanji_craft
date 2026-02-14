# Phase 1: Ingestion

## Purpose & Scope

This document defines the correctness rules for Phase 1 — parsing source files from `sources/` into Parquet files in `pipeline/data/parquet/`. No transformation happens here; Parquet files are a faithful columnar representation of the source data.

For the full pipeline lifecycle, see [pipeline.md](pipeline.md). For source file formats, see the docs in `docs/sources/`.

## Invariants

### Pre-Ingestion

1. **Folder validation.** Before parsing, the script validates that: (a) the source folder exists and matches the expected naming pattern, (b) all required files are present (see [pipeline.md — Folder Preparation](pipeline.md#folder-preparation)). If validation fails, the script exits with a clear error message.

### During Ingestion

2. **Faithful representation.** Parquet columns mirror the source structure. No filtering, renaming, or transformation. Language filtering, ghost flattening, JLPT mapping, etc. happen in Phase 2.

3. **Complete parsing.** Every entry in the source file becomes exactly one row in the Parquet output. The script logs the total row count after writing.

4. **Deterministic output.** Same source files always produce byte-identical Parquet files. No timestamps, random IDs, or environment-dependent values in the output.

### On Failure

5. **Atomic writes.** Parquet files are written atomically (write to temp file, then rename). A crash mid-write does not leave a corrupt Parquet file — either the previous version remains or no file exists.

6. **Clear error reporting.** Parse errors include the source file path, line/entry number, and the specific error. The script exits with a non-zero code on failure.

### On Success

7. **Output location.** All Parquet files go to `pipeline/data/parquet/`. One file per source (see Source-Specific Rules below).

8. **Idempotent.** Re-running ingestion on the same source files overwrites the Parquet output with identical content. No side effects, no accumulation.

## Source-Specific Rules

### KanjiVG

| Aspect | Value |
|---|---|
| Input | `sources/kanjivg-{version}/kanjivg-{version}.xml.gz` |
| Output | `data/parquet/kanjivg.parquet` |
| Row key | `character` (one row per kanji) |
| Decompression | gzip |
| Notes | Component tree preserved as nested structure. SVG archive (`kanjivg-{version}-main.zip`) is not parsed here — used directly in Phase 2.4 |

### KANJIDIC

| Aspect | Value |
|---|---|
| Input | `sources/kanjidic2-{version}/kanjidic2.xml.gz` |
| Output | `data/parquet/kanjidic.parquet` |
| Row key | `literal` (one row per kanji character) |
| Decompression | gzip |
| Notes | Meanings grouped by `m_lang` attribute (all languages preserved). Grade, stroke count, frequency, readings stored as-is from XML |

### JMdict

| Aspect | Value |
|---|---|
| Input | `sources/jmdict-{version}/JMdict.gz` |
| Output | `data/parquet/jmdict.parquet` |
| Row key | `ent_seq` (one row per dictionary entry) |
| Decompression | gzip |
| Notes | Senses and glosses stored as nested structures. All languages preserved |

### JMdict Examples

| Aspect | Value |
|---|---|
| Input | `sources/jmdict-{version}/JMdict_e_examp.gz` |
| Output | `data/parquet/jmdict_examples.parquet` |
| Row key | `ent_seq` + sentence index |
| Decompression | gzip |
| Notes | English example sentence pairs from the Tanaka Corpus |

### JLPT Kanji Mapping

| Aspect | Value |
|---|---|
| Input | `sources/jlpt_mapping/jlpt_mapping.csv` |
| Output | `data/parquet/jlpt_kanji.parquet` |
| Row key | `character` (one row per kanji) |
| Notes | Unversioned curated file. See [jlpt_mapping_format.md](../sources/jlpt_mapping_format.md) |

### JLPT Vocabulary Mapping

| Aspect | Value |
|---|---|
| Input | `sources/jlpt_vocab_mapping/n1.csv` through `n5.csv` |
| Output | `data/parquet/jlpt_vocab.parquet` |
| Row key | `expression` + `reading` |
| Notes | Level derived from filename. Duplicates across files resolved by keeping the easiest level. See [jlpt_vocab_mapping_format.md](../sources/jlpt_vocab_mapping_format.md) |

### JmdictFurigana

| Aspect | Value |
|---|---|
| Input | `sources/jmdictfurigana-{semver}+{date}/JmdictFurigana.json.tar.gz` |
| Output | `data/parquet/jmdict_furigana.parquet` |
| Row key | `text` + `reading` |
| Decompression | tar.gz |
| Notes | Strip UTF-8 BOM before JSON parsing. Furigana segments stored as nested list. See [jmdict_furigana_format.md](../sources/jmdict_furigana_format.md) |

## Recovery

**Corrupt or missing Parquet:** Re-run the ingestion script. It overwrites any existing output. No cleanup needed.

**Source file issues:** If a source file is corrupt or has an unexpected format, the script fails with a descriptive error. Fix the source file and re-run.
