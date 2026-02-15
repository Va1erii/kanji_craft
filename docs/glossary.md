# Glossary

Quick reference for domain terms, Japanese concepts, and abbreviations used across the entity docs.

## Japanese Language

| Term | Japanese | Meaning |
|---|---|---|
| **kanji** | 漢字 | Logographic character borrowed from Chinese and used in Japanese writing. Each kanji has meanings and multiple pronunciations. e.g. 日, 人, 水 |
| **radical** | 部首 | The smallest meaningful building block of a kanji. e.g. 亻 (person), 木 (tree). Most kanji are composed of one or more radicals |
| **onyomi** | 音読み | Sino-Japanese reading — pronunciation derived from Chinese. Written in katakana. e.g. ニチ for 日 |
| **kunyomi** | 訓読み | Native Japanese reading. Written in hiragana. e.g. ひ for 日 |
| **kana** | 仮名 | Japanese phonetic writing systems: hiragana (ひらがな) and katakana (カタカナ) |
| **jouyou kanji** | 常用漢字 | The ~2,136 kanji designated for everyday use, taught in Japanese schools across grades 1–6 (elementary, ~1,026 kyouiku kanji) and secondary school (~1,130 additional) |
| **stroke count** | 画数 | Number of brush strokes needed to write a character. Determines writing order |
| **stroke order** | 筆順 | The prescribed sequence of strokes when writing a character |

### Radical Positions

Traditional names for where a radical sits inside a kanji character (see radical.md `Position` enum).

| Term | Japanese | Position |
|---|---|---|
| **hen** | 偏 | Left side (e.g. 亻 in 休) |
| **tsukuri** | 旁 | Right side (e.g. 力 in 助) |
| **kanmuri** | 冠 | Top crown (e.g. 宀 in 家) |
| **ashi** | 脚 | Bottom legs (e.g. 灬 in 点) |
| **kamae** | 構 | Enclosure (e.g. 囗 in 国) |
| **tare** | 垂 | Hanging top-left (e.g. 广 in 店) |
| **nyo** | 繞 | Wrapping bottom-left (e.g. 辶 in 道) |

## App Concepts

| Term | Meaning |
|---|---|
| **master symbol** | The canonical, simplest full form of a radical (e.g. 水). All variants and translations anchor to it. Unique per radical |
| **variant** | A specific visual shape a radical takes at a given position (e.g. 水 → 氵 when on the left). Modeled as `RadicalVariant` |
| **logic hint** | Whether a radical contributes meaning (*semantic*) or sound (*phonetic*) inside a specific kanji. Stored per kanji-radical pair on `KanjiComponent` |
| **system mnemonic** | App-provided learning story shipped with the content, stored in I18n tables. Shared by all users, translated per language |
| **user mnemonic** | A personal memory aid written by the user. Overrides the system mnemonic in the UI. Stored in `UserMnemonic` |
| **impact score** | 1–10 rating of how many kanji use a radical. Higher = more valuable to learn early. On `Radical` |
| **vocabulary** | A Japanese word or compound using one or more kanji (e.g. 日本). Final stage of the SRS progression. Modeled as `Vocabulary` (see vocabulary.md) |
| **frequency rank** | Integer rank of usage frequency (1 = most common). On both `Kanji` (newspaper corpus) and `Vocabulary` |
| **study path** | The curriculum path a user follows: JLPT-based (N5 → N1) or grade-based (1 → 8, where 8 = secondary school). Stored in `UserSettings` (see user.md) |
| **daily lesson limit** | Max new items the app presents per day. User-configurable in `UserSettings`. Default: 10 |
| **unlock gate** | A radical must reach stability >= 7.0 days before kanji containing it enter the lesson queue. See srs.md rule #7 |
| **lesson queue** | The queue of new items waiting for their first review. Items enter after prerequisites are met |
| **leech** | A card with many lapses (e.g. >= 8) indicating the user keeps forgetting it. The app suggests revisiting the mnemonic |

## Pipeline Concepts

| Term | Meaning |
|---|---|
| **scope set** | The set of educationally relevant kanji (Jōyō grades 1–8 ∪ all JLPT levels). Only radicals appearing in scope kanji are considered for extraction |
| **keep set** | The set of elements registered as radicals: scope set ∪ official Kangxi ∪ high-frequency components ∪ manual_keep − manual_flatten |
| **ghost radical** | A KanjiVG intermediate element NOT in the keep set. Flattened by promoting its children into the parent kanji's component list |
| **ghost flattening** | Recursive algorithm that replaces ghost radicals with their sub-components. Depth-limited to prevent infinite loops |
| **force drop** | Elements in `manual_flatten.txt` are silently discarded during ghost flattening, even if unflattenable (no KanjiVG entry) |
| **visual group** | A nullable string on `Radical` grouping radicals that render as the same shape (e.g. 肉 and 月 both render as 月). Sourced from curated `visual_rules.json` |
| **disambiguation note** | Per-language teaching text on `RadicalI18n` explaining how to distinguish visual group siblings. Curated in `visual_rules.json`, not AI-generated |
| **phonetic anchor** | A radical in `manual_keep.txt` that carries a consistent onyomi across multiple kanji (e.g. 袁 → EN in 遠/園/猿) |

## FSRS & SRS

| Term | Meaning |
|---|---|
| **FSRS** | Free Spaced Repetition Scheduler — the algorithm used to schedule reviews. Based on the DSR memory model. Dart package: `fsrs` |
| **DSR model** | Difficulty-Stability-Retrievability — the three-component memory model underlying FSRS |
| **stability** | Memory stability in days. The time it takes for retrievability to drop from 100% to 90%. Higher = slower forgetting |
| **difficulty** | How hard it is to increase a card's stability. Range [1, 10]. Uses mean reversion to avoid drifting to extremes |
| **retrievability** | Probability of successful recall right now. Computed from stability and elapsed time, not stored |
| **desired retention** | Target recall probability (default 0.9 = 90%). Global FSRS setting that determines review intervals |
| **w parameters** | Array of 19–21 weights that control FSRS behavior. Global configuration, not per-card. Can be optimized from review history |
| **lapse** | A forget event — user rates `again` on a `review`-state card. Increments the lapses counter and moves card to `relearning` |
| **learning steps** | Short intervals for new cards (default: 1 min, 10 min). Card graduates to `review` after completing all steps |
| **relearning steps** | Short intervals for lapsed cards (default: 10 min). Card returns to `review` after completing |
| **elapsed days** | Actual days since the last review. May differ from scheduled if the user reviews early or late |
| **scheduled days** | Days the algorithm planned between reviews. Compared with elapsed days to assess recall conditions |

### Card States

| State | Meaning |
|---|---|
| **new_card** | Never reviewed. Waiting in the lesson queue |
| **learning** | Being learned for the first time through short-interval steps |
| **review** | Graduated to the normal review schedule with FSRS-computed intervals |
| **relearning** | Lapsed (forgotten) and going through relearning steps before returning to review |

### Ratings

| Rating | Meaning |
|---|---|
| **again** (1) | Forgot — triggers a lapse |
| **hard** (2) | Recalled with serious difficulty |
| **good** (3) | Recalled after some hesitation |
| **easy** (4) | Effortless recall |

## Progression

The app teaches items in a fixed dependency order:

```
radical → kanji → vocabulary
```

A radical must be stable (>= 7.0 days) before kanji containing it unlock. All kanji in a word must be stable before its vocabulary unlocks. Radicals are reviewed on meaning only; kanji and vocabulary on both meaning and reading.

## Abbreviations

| Abbr | Expansion |
|---|---|
| **FSRS** | Free Spaced Repetition Scheduler |
| **SRS** | Spaced Repetition System |
| **DSR** | Difficulty-Stability-Retrievability |
| **JLPT** | Japanese Language Proficiency Test (N5 = easiest, N1 = hardest) |
| **I18n** | Internationalization (I + 18 letters + n) |
| **SVG** | Scalable Vector Graphics |
| **FK** | Foreign Key |
| **UTC** | Coordinated Universal Time |
| **RLS** | Row Level Security (Supabase/Postgres access control) |
| **JWT** | JSON Web Token (auth token from Supabase) |
