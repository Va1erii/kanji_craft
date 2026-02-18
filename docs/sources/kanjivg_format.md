# KanjiVG SVG Format

## Overview

[KanjiVG](https://kanjivg.tagaini.net/) encodes kanji stroke order and component decomposition as SVG files with custom XML namespace extensions. Each file represents one kanji character. All extensions use the `kvg:` namespace prefix (`xmlns:kvg="http://kanjivg.tagaini.net"`).

This document is a reference for the KanjiVG format as consumed by the pipeline ingestion scripts and radical extraction algorithm ([ph2_1_radical_extraction.md](ph2_1_radical_extraction.md)).

## File Structure

Each SVG contains two root-level groups:

```xml
<svg xmlns="http://www.w3.org/2000/svg" ...>
  <g id="kvg:StrokePaths_04eee" style="...">
    <!-- Component tree + stroke paths -->
  </g>
  <g id="kvg:StrokeNumbers_04eee">
    <!-- Positioned stroke-order numbers (optional) -->
  </g>
</svg>
```

| Group | ID pattern | Purpose |
|---|---|---|
| **StrokePaths** | `kvg:StrokePaths_{hex}` | Nested `<g>` groups encoding the component tree, containing `<path>` elements for each stroke |
| **StrokeNumbers** | `kvg:StrokeNumbers_{hex}` | `<text>` elements with `transform` attributes, positioned to the side of the beginning of each stroke. Each text element contains the stroke number in digits (1 to total strokes), corresponding to the stroke `id` values. Optional; useful for printed materials |

The `{hex}` segment is the Unicode code point as a 5-digit lowercase hexadecimal number (e.g. `04eee` for 仮 U+4EEE).

**Our parser uses StrokePaths only.** StrokeNumbers are ignored.

## StrokePaths: Component Tree

Kanji decompose into components (called *elements* in KanjiVG). Nested `<g>` groups reflect this structure — each group represents a component, and its child `<path>` elements are the strokes that draw it.

### Example: 仮 (U+4EEE)

```xml
<g id="kvg:04eee" kvg:element="仮">
  <g id="kvg:04eee-g1" kvg:element="亻" kvg:variant="true"
     kvg:original="人" kvg:position="left" kvg:radical="general">
    <path id="kvg:04eee-s1" kvg:type="㇒" d="M32.01,17c0.22,..."/>
    <path id="kvg:04eee-s2" kvg:type="㇑" d="M25.48,37.5c0.57,..."/>
  </g>
  <g id="kvg:04eee-g2" kvg:element="反" kvg:position="right"
     kvg:phon="叚V/反">
    <g id="kvg:04eee-g3" kvg:element="厂">
      <path id="kvg:04eee-s3" kvg:type="㇐" d="M47.34,22.01c1.27,..."/>
      <path id="kvg:04eee-s4" kvg:type="㇒" d="M52.65,23.81c1.14,..."/>
    </g>
    <g id="kvg:04eee-g4" kvg:element="又">
      <path id="kvg:04eee-s5" kvg:type="㇇" d="M56.7,41.74c1.51,..."/>
      <path id="kvg:04eee-s6" kvg:type="㇏" d="M56.12,52.12c5.64,..."/>
    </g>
  </g>
</g>
```

This encodes:

```
仮 (root)
├── 亻 — left, variant of 人, radical (general)
│   ├── stroke 1 (㇒ diagonal)
│   └── stroke 2 (㇑ vertical)
└── 反 — right, phonetic marker
    ├── 厂
    │   ├── stroke 3 (㇐ horizontal)
    │   └── stroke 4 (㇒ diagonal)
    └── 又
        ├── stroke 5 (㇇ turning)
        └── stroke 6 (㇏ right sweep)
```

## Group Attributes

### General

| Attribute | Format | Description |
|---|---|---|
| `id` | `kvg:{hex}-g{n}` | Unique group ID. `{hex}` is the kanji's 5-digit hex code point, `{n}` is a consecutive integer from 1 to total group count |

### `kvg:` Namespace Attributes

| Attribute | Type | Required | Description |
|---|---|---|---|
| `element` | `String` | Yes (on meaningful groups) | The Unicode character that best represents the group physically — the character that resembles the group as much as possible. The outermost group's `element` matches the kanji itself |
| `position` | `String?` | No | Where this group sits relative to siblings. See [Position Values](#position-values) |
| `variant` | `"true"?` | No | Undocumented in the KanjiVG source. Possibly indicates that the shape of the element is unlike the usual grapheme. In practice, often present on groups where `original` provides the base character (e.g. `element="亻" variant="true" original="人"`) |
| `original` | `String?` | No | The kanji that represents the group from a semantic point of view. Present when the semantic representation differs from the physical one (the `element`). E.g. `element="亻" original="人"` — ninben is physically 亻 but semantically 人 |
| `radical` | `String?` | No | Marks this group as a radical. See [Radical Values](#radical-values) |
| `phon` | `String?` | No | Marks the part indicating the Sino-Japanese pronunciation (phoneticum). Values are inconsistent and many are undocumented — see [KanjiVG issue #312](https://github.com/KanjiVG/kanjivg/issues/312) |
| `part` | `int?` | No | When a component's strokes are non-contiguous, it's split across multiple groups sharing the same `element` but with different `part` numbers (1, 2, ...) |
| `number` | `int?` | No | Disambiguates when the same element appears multiple times AND more than one of those is split into parts. Rare — e.g. 圖 (05716.svg) has four 口, two of which are split |
| `partial` | `"true"?` | No | Set to `"true"` if the group only represents the element partially (not all its strokes are present) |
| `tradForm` | `String?` | No | Related to cases where the Nelson character dictionary radicals differ from those in traditional Japanese dictionaries. Historical context: the original Kanjidic file that KanjiVG was based on favored Nelson radicals |
| `radicalForm` | `"true"?` | No | Set to `"true"` for groups where a radical-like form is provided as the `element` while `original` holds the standard kanji |

### Position Values

| Value | Japanese | Description | Example |
|---|---|---|---|
| `left` | 偏 (hen) | Left side | 亻 in 休 |
| `right` | 旁 (tsukuri) | Right side | 力 in 助 |
| `top` | 冠 (kanmuri) | Top crown | 宀 in 家 |
| `bottom` | 脚 (ashi) | Bottom legs | 灬 in 点 |
| `kamae` | 構 (kamae) | Wrapped around another part (e.g. 門). Used very inconsistently in KanjiVG as a grab-bag for various different structures | 囗 in 国 |
| `tare` | 垂 (tare) | Left and above another part | 广 in 店 |
| `tarec` | — | Complement/counterpart of a `tare` part | The enclosed portion under 广 |
| `nyo` | 繞 (nyo) | Left and under another part | 辶 in 道 |
| `nyoc` | — | Complement/counterpart of a `nyo` part | The enclosed portion above 辶 |
| `kamaec` | — | Complement/counterpart of a `kamae` part | The enclosed portion inside 囗 |

**Mapping to our Position enum:** Our schema uses traditional names plus complement values. The parser maps KanjiVG values:

| KanjiVG | Our enum |
|---|---|
| `left` | `hen` |
| `right` | `tsukuri` |
| `top` | `kanmuri` |
| `bottom` | `ashi` |
| `kamae` | `kamae` |
| `tare` | `tare` |
| `tarec` | `tarec` |
| `nyo` | `nyo` |
| `nyoc` | `nyoc` |
| `kamaec` | `kamaec` |
| (absent) | `unknown` |

### Radical Values

| Value | Description |
|---|---|
| `general` | The generally accepted radical which authors agree on |
| `tradit` | The "traditional" radical — the Kangxi radical where it disagrees with Nelson |
| `nelson` | The Nelson dictionary radical |
| `jis` | The radical used by JIS Kanji Jiten (used by KANJIDIC). Added to deal with inconsistencies between KanjiVG and KANJIDIC; sometimes differs from general or tradit |

**Mapping to our schema:** Our `radicals.is_official` is `true` only when any occurrence carries `radical` with value `general` (the consensus Kangxi radical). The `tradit`, `nelson`, and `jis` values are preserved as `radical_type` on `kanji_components` but do not set `is_official` on the radical itself.

**Note on radical code points:** Unicode has multiple code points for the same radical (e.g. Kangxi Radicals block U+2F00–U+2FD5 vs CJK Unified Ideographs). KanjiVG chooses specific code points for each radical — see the [KanjiVG Radicals page](https://github.com/KanjiVG/kanjivg/wiki/Radicals) for the full mapping.

## Strokes (`<path>` Elements)

Each stroke is a single `<path>` element. Strokes appear in writing order within their parent `<g>` group.

### Attributes

| Attribute | Format | Description |
|---|---|---|
| `id` | `kvg:{hex}[-variant]-s{n}` | Unique stroke ID. `{hex}` is the 5-digit hex code point, optional variant info may follow, `{n}` is a consecutive 1-based stroke number corresponding to the stroke order. E.g. `kvg:053ec-s3` |
| `d` | SVG path data | Cubic bezier curves only (`M`/`m`, `C`/`c`, `S`/`s` commands). No other SVG path elements are used. Each stroke is a single sub-path (one `moveto`) |
| `kvg:type` | CJK Stroke character | Stroke shape using Unicode CJK Strokes (U+31C0–U+31EF), whose names (D, HZ, etc.) are initials of Chinese stroke names. E.g. `㇐` (horizontal), `㇑` (vertical), `㇒` (diagonal). May have a lowercase letter suffix for sub-variants (e.g. `㇑a`). See the [KanjiVG Stroke types page](https://github.com/KanjiVG/kanjivg/wiki/Stroke-types) |

### Canvas

All kanji are drawn on a `109 × 109` viewBox (`viewBox="0 0 109 109"`). Path coordinates are absolute within this canvas.

## Split Components (`part` Attribute)

When a component's strokes are non-contiguous in writing order (another element's strokes interleave), the component is split into multiple `<g>` groups sharing the same `element` but with ascending `part` numbers.

### Example: 五 (U+4E94)

```xml
<g id="kvg:04e94" kvg:element="五">
  <g id="kvg:04e94-g1" kvg:element="二" kvg:part="1" kvg:radical="tradit">
    <g id="kvg:04e94-g2" kvg:element="一" kvg:radical="nelson">
      <path id="kvg:04e94-s1" kvg:type="㇐" d="M31.75,23.15c2.8,..."/>
    </g>
  </g>
  <path id="kvg:04e94-s2" kvg:type="㇑a" d="M55.75,25.25c0.62,..."/>
  <path id="kvg:04e94-s3" kvg:type="㇕c" d="M25.5,55.25c2.07,..."/>
  <g id="kvg:04e94-g3" kvg:element="二" kvg:part="2" kvg:radical="tradit">
    <path id="kvg:04e94-s4" kvg:type="㇐" d="M11.25,90.5c3.04,..."/>
  </g>
</g>
```

The radical 二 (traditional Kangxi) is split into part 1 (top horizontal stroke) and part 2 (bottom horizontal stroke), with 五's own strokes in between. The Nelson radical is 一 (just the top stroke).

**Pipeline handling:** Our parser merges parts with the same `element` (and `number`, if present) into a single component. Stroke indices from all parts are combined. See [ph2_1_radical_extraction.md — Pass 1](ph2_1_radical_extraction.md#pass-1-scan--collect-radical-candidates).

## Phonetic Markers (`phon`)

The `phon` attribute marks components that contribute to the kanji's Sino-Japanese pronunciation (on'yomi). This is valuable for our `logic_hint` estimation (semantic vs phonetic).

**Caveat:** The `phon` values in KanjiVG are inconsistent and many are completely undocumented (see [KanjiVG issue #312](https://github.com/KanjiVG/kanjivg/issues/312)). Some contain reading values (e.g. `ボウ`), others contain element references with notation (e.g. `叚V/反`), and many phonetic components have no `phon` attribute at all. Our AI Heuristics phase ([pipeline.md §2.5](pipeline.md#25-ai-heuristics-logic-hint-estimation)) uses onyomi matching as the primary signal rather than relying solely on `phon`.

**Where `phon` is present and clean**, it can boost `ai_confidence` on the phonetic classification.

## Data Quality Notes

These are known inconsistencies in the KanjiVG dataset that our pipeline must handle:

| Issue | Impact | Handling |
|---|---|---|
| `kamae` position used inconsistently | Various enclosing structures are lumped together | Accept as-is; `kamae` is a valid position in our enum |
| `phon` values inconsistent in format | Cannot be reliably parsed as readings | Use as a supplementary signal only, not as primary phonetic classifier |
| `variant="true"` without `original` | Cannot determine the master radical | Log warning, treat element as its own master symbol |
| Some elements lack `position` | Position unknown for the component | Default to `unknown` in our Position enum |
| Radical code point choices vary | Same radical may use different Unicode code points across entries | Normalize via `original` attribute and master symbol resolution |
| `partial="true"` groups | Incomplete element representation | Rare; log and include strokes but flag for review |

## Related Docs

- [ph2_1_radical_extraction.md](ph2_1_radical_extraction.md) — Algorithm that consumes KanjiVG component trees
- [raw_kanjivg.md](../domain/raw_kanjivg.md) — Staging table schema (how parsed KanjiVG data is stored)
- [pipeline.md](pipeline.md) — Full pipeline orchestration
- [KanjiVG Wiki](https://github.com/KanjiVG/kanjivg/wiki) — Upstream documentation
