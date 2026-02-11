# Attributions & Licenses

This document lists all data sources and libraries that **require in-app attribution**. The app must include a dedicated "Acknowledgments" or "Sources" screen accessible from a menu (e.g., Settings > About > Acknowledgments).

Flutter/Dart packages (Freezed, Dio, go_router, etc.) use MIT/BSD licenses — attribution is handled automatically by Flutter's built-in licenses page (`LicenseRegistry`). They are **not** listed here.

## Data Sources

### EDRDG Dictionaries (KANJIDIC2 + JMdict)

Both dictionaries are governed by the same EDRDG licence and can share a single acknowledgment entry.

| | |
|---|---|
| **License** | CC BY-SA 4.0 |
| **Copyright** | James William Breen and the Electronic Dictionary Research and Development Group |
| **Placement** | Dedicated screen (About/Sources) — a splash screen mention alone is **not** sufficient |
| **Update obligation** | Must have a procedure for regular updating from the latest versions |

**Required acknowledgment text** (from EDRDG):

> This application uses the JMdict/EDICT and KANJIDIC dictionary files. These files are the property of the Electronic Dictionary Research and Development Group, and are used in conformance with the Group's licence.

**Required links** (display in-app or link to local copies):
- KANJIDIC: https://www.edrdg.org/wiki/index.php/KANJIDIC_Project
- JMdict: https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project
- Licence: https://www.edrdg.org/edrdg/licence.html

**Note:** If SKIP codes from KANJIDIC2 are used, those are separately licensed as CC BY-NC-SA 4.0 by Jack Halpern (non-commercial restriction). We do **not** use SKIP codes.

### KanjiVG

| | |
|---|---|
| **License** | CC BY-SA 3.0 |
| **Copyright** | Ulrich Apel |
| **Source** | https://github.com/KanjiVG/kanjivg |

**Required attribution** (CC BY-SA 3.0 Section 4c — must credit author, title, and URI):

> Stroke order data from KanjiVG by Ulrich Apel, licensed under CC BY-SA 3.0.

**ShareAlike obligation:** Any modified SVGs must be released under CC BY-SA 3.0 or a compatible license.

## Community Data Sources (courtesy attribution)

These sources have no formal license requiring attribution, but crediting them is standard practice in the Japanese learning app community.

### JLPT Level Lists

| | |
|---|---|
| **Source** | Jonathan Waller's JLPT Resources |
| **URL** | https://www.tanos.co.uk/jlpt/ |
| **Used for** | Mapping kanji to current JLPT N1–N5 levels (the `ref_jlpt_levels` lookup table) |

### Kanji Data (JLPT Mapping Dataset)

| | |
|---|---|
| **License** | MIT |
| **Author** | David Luz Gouveia |
| **Source** | https://github.com/davidluzgouveia/kanji-data |
| **Used for** | Curated kanji-to-JLPT-level mapping combining KANJIDIC and Jonathan Waller's lists |

## Software Libraries (MIT — no in-app mention needed)

These only require the license text bundled with the app (Flutter's `LicenseRegistry` handles this automatically via `showLicensePage()`):

| Library | License | Why listed |
|---|---|---|
| FSRS | MIT (Open Spaced Repetition, 2022) | Core algorithm — include MIT notice in bundled licenses |

All other Dart/Flutter packages (freezed, dio, flutter_bloc, go_router, etc.) are MIT or BSD and are covered by the same mechanism. No action needed beyond the standard Flutter licenses page.

## Implementation Checklist

- [ ] Add "Acknowledgments" screen accessible from Settings > About
- [ ] Include EDRDG acknowledgment text with links
- [ ] Include KanjiVG attribution with author name
- [ ] Credit Jonathan Waller's JLPT Resources and David Luz Gouveia's kanji-data
- [ ] Ensure `showLicensePage()` is accessible (covers all Dart packages)
