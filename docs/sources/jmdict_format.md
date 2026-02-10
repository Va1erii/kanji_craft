# JMdict Format Reference

## Overview

The [JMdict Project](http://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project) is maintained by the Electronic Dictionary Research and Development Group (EDRDG). It provides a comprehensive Japanese–multilingual dictionary distributed in several formats:

| File | Encoding | Description |
|---|---|---|
| **JMdict** | XML (UTF-8) | Complete dictionary in XML per the DTD. This is the file our parser will consume |
| EDICT | EUC-JP (JIS X 0208) | Legacy flat-text format — single kanji headword and reading per entry |
| EDICT2 | EUC-JP (JIS X 0208 + JIS X 0212) | Expanded flat-text — multiple headwords/readings, cross-references, sequence numbers |
| EDICT_SUB | EUC-JP | Same format as EDICT (subset or supplementary) |

None of the files have entries in any particular order.

This document is a reference for the JMdict format. No parser or staging table exists yet — this doc is written first per our docs-first approach.

**Source file:** `JMdict.gz` (gzip-compressed XML, UTF-8). The DTD is embedded in the file and heavily annotated with content and structural information.

## Entry Structure

Each dictionary entry is independent, although cross-reference fields may point to other entries. The XML has a flat structure — one `<entry>` element per dictionary entry inside a `<JMdict>` root:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE JMdict [...]>
<JMdict>
  <entry>
    <ent_seq>1594720</ent_seq>
    <k_ele>
      <keb>収集</keb>
      <ke_pri>ichi1</ke_pri>
      <ke_pri>news1</ke_pri>
      <ke_pri>nf05</ke_pri>
    </k_ele>
    <k_ele>
      <keb>蒐集</keb>
    </k_ele>
    <k_ele>
      <keb>拾集</keb>
    </k_ele>
    <k_ele>
      <keb>収輯</keb>
    </k_ele>
    <r_ele>
      <reb>しゅうしゅう</reb>
      <re_pri>ichi1</re_pri>
      <re_pri>news1</re_pri>
      <re_pri>nf05</re_pri>
    </r_ele>
    <sense>
      <pos>&n;</pos>
      <pos>&vs;</pos>
      <gloss>gathering up</gloss>
      <gloss>collection</gloss>
      <gloss>accumulation</gloss>
    </sense>
    <sense>
      <gloss xml:lang="fre">collection</gloss>
      <gloss xml:lang="fre">récolte</gloss>
    </sense>
    <!-- additional senses with dut, ger, hun, rus, slv, spa glosses -->
  </entry>
  <!-- ... -->
</JMdict>
```

Formal DTD declaration: `<!ELEMENT entry (ent_seq, k_ele*, r_ele+, sense+)>` — each entry must have at least one reading element and one sense element. Kanji elements are optional (kana-only words have none).

## Entry Elements

### Entry Sequence (`ent_seq`)

A unique numeric sequence number for the entry. This value is stable across releases and is used for cross-referencing between formats (the EDICT2 `EntLnnnnnnnnX` field maps to this value).

| XML Path | Type | Description |
|---|---|---|
| `<ent_seq>` | Integer | Unique entry identifier |

### Kanji Elements (`k_ele`)

Headwords containing at least one non-kana character (usually kanji, but can include other characters). The valid characters are kanji, kana, related characters such as chouon and kurikaeshi, and in exceptional cases, letters from other alphabets. An entry may have zero or more `k_ele` elements — entries for kana-only words have none. Where there are multiple kanji elements, they are orthographical variants of the same word (okurigana variations or alternative equivalent kanji). Common "mis-spellings" may be included with appropriate information fields. Synonyms are not included — they are indicated via cross-references in sense elements. Where there are multiple headwords, they are ordered by frequency of usage (as far as can be determined).

| XML Path | Type | Required | Description |
|---|---|---|---|
| `<keb>` | String | Yes | The headword itself — a word or short phrase written using at least one non-kana character |
| `<ke_inf>` | Entity | No | Coded information about the orthography of the `keb`, typically indicating some unusual aspect such as okurigana irregularity. See [Kanji Information Codes](#kanji-information-ke_inf) |
| `<ke_pri>` | String | No | Priority indicator for the headword. Multiple values may be present. See [Priority Codes](#priority-codes) |

### Reading Elements (`r_ele`)

Each entry has one or more reading elements. These contain the valid readings of the word(s) in the kanji element using modern kanadzukai. Where there are multiple reading elements, they are typically alternative readings of the kanji element. In the absence of a kanji element (words written entirely in kana), reading elements define the entry. Content is restricted to kana and related characters (chouon, kurikaeshi); kana usage is consistent between `keb` and `reb` (e.g. if `keb` contains katakana, so does `reb`). Where there are multiple readings, they are ordered by frequency of usage (as far as can be determined).

| XML Path | Type | Required | Description |
|---|---|---|---|
| `<reb>` | String | Yes | The reading in kana |
| `<re_nokanji>` | Flag | No | Indicates the `reb`, while associated with the `keb`, cannot be regarded as a true reading of the kanji. Typically used for foreign place names, gairaigo which can appear in kanji or katakana, etc. Usually has a null value when present |
| `<re_restr>` | String | No | Restricts this reading to specific kanji headwords. Contains the `keb` value it applies to (must exactly match). When absent, the reading applies to all kanji headwords. Multiple `re_restr` elements may be present |
| `<re_inf>` | Entity | No | Coded information pertaining to the specific reading, typically indicating some unusual aspect. See [Reading Information Codes](#reading-information-re_inf) |
| `<re_pri>` | String | No | Priority indicator for the reading. See [Priority Codes](#priority-codes) |

### Sense Elements (`sense`)

Sense elements record the translational equivalents of the Japanese word, plus related information. Where there are several distinctly different meanings, multiple sense elements are employed. As Japanese is not highly polysemous, there is often only one sense. Glosses within a sense are ordered with the most common appearing first.

| XML Path | Type | Required | Description |
|---|---|---|---|
| `<stagk>` | String | No | Restricts this sense to the lexeme represented by the `keb`. When absent, the sense applies to all headwords |
| `<stagr>` | String | No | Restricts this sense to the lexeme represented by the `reb`. When absent, the sense applies to all readings |
| `<pos>` | Entity | No | Part-of-speech information. Should use appropriate entity codes. Where there are multiple senses, the part-of-speech of an earlier sense applies to later senses unless a new one is indicated. See [Part-of-Speech Codes](#part-of-speech-pos) |
| `<xref>` | String | No | Cross-reference to another entry with a similar or related meaning. Typically contains a `keb` or `reb` from another entry. A `keb` may be followed by a `reb` and/or sense number, separated by centre-dots (・, U+30FB) |
| `<ant>` | String | No | Antonym cross-reference. Content must exactly match a `keb` or `reb` in another entry |
| `<field>` | Entity | No | Field of application. When absent, general application is implied. See [Field Codes](#field-of-application-field) |
| `<misc>` | Entity | No | Other relevant information about the sense. As with part-of-speech, information will usually apply to several senses. See [Miscellaneous Codes](#miscellaneous-information-misc) |
| `<s_inf>` | String | No | Additional sense information — things like level of currency, regional variations, etc. |
| `<lsource>` | String/Empty | No | Source language(s) of a loan-word/gairaigo. The element value (if any) is the source word or phrase. Attributes: `xml:lang` (ISO 639-2 language code, defaults to `eng`; uses bibliographic B codes), `ls_type` (`full` or `part` — defaults to `full`), `ls_wasei` (`y` if the Japanese word is constructed from source-language words rather than an actual phrase, e.g. wasei-eigo) |
| `<dial>` | Entity | No | Regional Japanese dialect. See [Dialect Codes](#dialect-dial) |
| `<gloss>` | String | No | Target-language word or phrase equivalent to the Japanese word. May be omitted in entries that are purely cross-references. Attributes: `xml:lang` (ISO 639-2 code, defaults to `eng`), `g_gend` (gender of a noun gloss in the target language), `g_type` (gloss type: `lit`, `fig`, `expl`). May contain `<pri>` child elements highlighting glosses strongly associated with the Japanese word — these establish head-words for reverse target-language/Japanese lookup |

## Priority Codes

The `ke_pri` and `re_pri` elements indicate that the headword or reading is among the most common in Japanese. The presence of priority markers is used to identify the approximately 20,000 most common entries.

Priority values come from several frequency lists:

| Prefix | Source |
|---|---|
| `news1`, `news2` | Frequency in Mainichi Shimbun newspaper data. `news1` = top 12,000 words by reading, `news2` = next 12,000 |
| `ichi1`, `ichi2` | Listed in "Ichimango goi bunruishuu" (一万語語彙分類集). `ichi1` = high-priority subset, `ichi2` = remainder |
| `spec1`, `spec2` | Designated as common but not covered by other lists. `spec1` = high-priority, `spec2` = remainder |
| `gai1`, `gai2` | Common loanwords based on wordlists from several sources |
| `nfxx` | Frequency ranking from Mainichi Shimbun corpus, in bands of 500. `nf01` = top 500, `nf02` = 501–1000, etc. |

An entry with `ichi1` and/or `news1` and/or `spec1` can be considered high-frequency. The entries with `news1`, `ichi1`, `spec1`, `spec2`, and `gai1` values are marked with `(P)` in the EDICT and EDICT2 files.

The reason both kanji and reading elements carry priority tags is that on occasion a priority is only associated with a particular kanji/reading pair.

## DTD Entity Codes

The JMdict DTD defines entity codes used as values in `ke_inf`, `re_inf`, `pos`, `field`, `misc`, and `dial` elements. Entity references (e.g. `&n;`) expand to descriptive text in the XML. The tables below list all codes from the DTD.

### Part-of-Speech (`pos`)

#### Adjectives

| Code | Description |
|---|---|
| `adj-i` | Adjective (keiyoushi) |
| `adj-ix` | Adjective (keiyoushi) — yoi/ii class |
| `adj-na` | Adjectival nouns or quasi-adjectives (keiyodoshi) |
| `adj-no` | Nouns which may take the genitive case particle "no" |
| `adj-pn` | Pre-noun adjectival (rentaishi) |
| `adj-t` | "taru" adjective |
| `adj-f` | Noun or verb acting prenominally |
| `adj-kari` | "kari" adjective (archaic) |
| `adj-ku` | "ku" adjective (archaic) |
| `adj-shiku` | "shiku" adjective (archaic) |
| `adj-nari` | Archaic/formal form of na-adjective |

#### Nouns

| Code | Description |
|---|---|
| `n` | Noun (common) (futsuumeishi) |
| `n-adv` | Adverbial noun (fukushitekimeishi) |
| `n-suf` | Noun, used as a suffix |
| `n-pref` | Noun, used as a prefix |
| `n-t` | Noun (temporal) (jisoumeishi) |
| `n-pr` | Proper noun |

#### Verbs — Ichidan

| Code | Description |
|---|---|
| `v1` | Ichidan verb |
| `v1-s` | Ichidan verb — kureru special class |

#### Verbs — Godan

| Code | Description |
|---|---|
| `v5aru` | Godan verb — -aru special class |
| `v5b` | Godan verb with "bu" ending |
| `v5g` | Godan verb with "gu" ending |
| `v5k` | Godan verb with "ku" ending |
| `v5k-s` | Godan verb — Iku/Yuku special class |
| `v5m` | Godan verb with "mu" ending |
| `v5n` | Godan verb with "nu" ending |
| `v5r` | Godan verb with "ru" ending |
| `v5r-i` | Godan verb with "ru" ending (irregular) |
| `v5s` | Godan verb with "su" ending |
| `v5t` | Godan verb with "tsu" ending |
| `v5u` | Godan verb with "u" ending |
| `v5u-s` | Godan verb with "u" ending (special class) |
| `v5uru` | Godan verb — Uru old class verb (old form of Eru) |

#### Verbs — Suru

| Code | Description |
|---|---|
| `vs` | Noun or participle which takes the aux. verb suru |
| `vs-c` | Su verb — precursor to the modern suru |
| `vs-s` | Suru verb — special class |
| `vs-i` | Suru verb — irregular |

#### Verbs — Special/Other

| Code | Description |
|---|---|
| `vk` | Kuru verb — special class |
| `vn` | Irregular nu verb |
| `vr` | Irregular ru verb, plain form ends with -ri |
| `vz` | Ichidan verb — zuru verb (alternative form of -jiru verbs) |
| `vi` | Intransitive verb |
| `vt` | Transitive verb |
| `v-unspec` | Verb unspecified |

#### Verbs — Nidan (archaic)

| Code | Description |
|---|---|
| `v2a-s` | Nidan verb with "u" ending (archaic) |
| `v2k-k` | Nidan verb (upper class) with "ku" ending (archaic) |
| `v2g-k` | Nidan verb (upper class) with "gu" ending (archaic) |
| `v2t-k` | Nidan verb (upper class) with "tsu" ending (archaic) |
| `v2d-k` | Nidan verb (upper class) with "dzu" ending (archaic) |
| `v2h-k` | Nidan verb (upper class) with "hu/fu" ending (archaic) |
| `v2b-k` | Nidan verb (upper class) with "bu" ending (archaic) |
| `v2m-k` | Nidan verb (upper class) with "mu" ending (archaic) |
| `v2y-k` | Nidan verb (upper class) with "yu" ending (archaic) |
| `v2r-k` | Nidan verb (upper class) with "ru" ending (archaic) |
| `v2k-s` | Nidan verb (lower class) with "ku" ending (archaic) |
| `v2g-s` | Nidan verb (lower class) with "gu" ending (archaic) |
| `v2s-s` | Nidan verb (lower class) with "su" ending (archaic) |
| `v2z-s` | Nidan verb (lower class) with "zu" ending (archaic) |
| `v2t-s` | Nidan verb (lower class) with "tsu" ending (archaic) |
| `v2d-s` | Nidan verb (lower class) with "dzu" ending (archaic) |
| `v2n-s` | Nidan verb (lower class) with "nu" ending (archaic) |
| `v2h-s` | Nidan verb (lower class) with "hu/fu" ending (archaic) |
| `v2b-s` | Nidan verb (lower class) with "bu" ending (archaic) |
| `v2m-s` | Nidan verb (lower class) with "mu" ending (archaic) |
| `v2y-s` | Nidan verb (lower class) with "yu" ending (archaic) |
| `v2r-s` | Nidan verb (lower class) with "ru" ending (archaic) |
| `v2w-s` | Nidan verb (lower class) with "u" ending and "we" conjugation (archaic) |

#### Verbs — Yodan (archaic)

| Code | Description |
|---|---|
| `v4h` | Yodan verb with "hu/fu" ending (archaic) |
| `v4r` | Yodan verb with "ru" ending (archaic) |
| `v4k` | Yodan verb with "ku" ending (archaic) |
| `v4g` | Yodan verb with "gu" ending (archaic) |
| `v4s` | Yodan verb with "su" ending (archaic) |
| `v4t` | Yodan verb with "tsu" ending (archaic) |
| `v4n` | Yodan verb with "nu" ending (archaic) |
| `v4b` | Yodan verb with "bu" ending (archaic) |
| `v4m` | Yodan verb with "mu" ending (archaic) |

#### Other Parts of Speech

| Code | Description |
|---|---|
| `adv` | Adverb (fukushi) |
| `adv-to` | Adverb taking the "to" particle |
| `aux` | Auxiliary |
| `aux-v` | Auxiliary verb |
| `aux-adj` | Auxiliary adjective |
| `conj` | Conjunction |
| `cop-da` | Copula |
| `ctr` | Counter |
| `exp` | Expressions (phrases, clauses, etc.) |
| `int` | Interjection (kandoushi) |
| `num` | Numeric |
| `pn` | Pronoun |
| `pref` | Prefix |
| `prt` | Particle |
| `suf` | Suffix |
| `unc` | Unclassified |

### Field of Application (`field`)

| Code | Description |
|---|---|
| `anat` | Anatomical term |
| `archit` | Architecture term |
| `astron` | Astronomy term |
| `baseb` | Baseball term |
| `biol` | Biology term |
| `bot` | Botany term |
| `bus` | Business term |
| `chem` | Chemistry term |
| `comp` | Computer terminology |
| `econ` | Economics term |
| `engr` | Engineering term |
| `finc` | Finance term |
| `food` | Food term |
| `geol` | Geology term |
| `geom` | Geometry term |
| `law` | Law term |
| `ling` | Linguistics terminology |
| `MA` | Martial arts term |
| `mahj` | Mahjong term |
| `math` | Mathematics |
| `med` | Medicine term |
| `mil` | Military |
| `music` | Music term |
| `physics` | Physics terminology |
| `Shinto` | Shinto term |
| `shogi` | Shogi term |
| `sports` | Sports term |
| `sumo` | Sumo term |
| `zool` | Zoology term |
| `Buddh` | Buddhist term |

### Miscellaneous Information (`misc`)

| Code | Description |
|---|---|
| `abbr` | Abbreviation |
| `arch` | Archaism |
| `chn` | Children's language |
| `col` | Colloquialism |
| `derog` | Derogatory |
| `fam` | Familiar language |
| `fem` | Female term or language |
| `hon` | Honorific or respectful (sonkeigo) language |
| `hum` | Humble (kenjougo) language |
| `id` | Idiomatic expression |
| `joc` | Jocular, humorous term |
| `m-sl` | Manga slang |
| `male` | Male term or language |
| `male-sl` | Male slang |
| `obs` | Obsolete term |
| `obsc` | Obscure term |
| `on-mim` | Onomatopoeic or mimetic word |
| `poet` | Poetical term |
| `pol` | Polite (teineigo) language |
| `proverb` | Proverb |
| `rare` | Rare |
| `sens` | Sensitive |
| `sl` | Slang |
| `vulg` | Vulgar expression or word |
| `X` | Rude or X-rated term (not displayed in educational software) |
| `yoji` | Yojijukugo (four-character idiom) |
| `iv` | Irregular verb |
| `eK` | Exclusively kanji |
| `ek` | Exclusively kana |
| `uK` | Word usually written using kanji alone |
| `uk` | Word usually written using kana alone |

### Kanji Information (`ke_inf`)

| Code | Description |
|---|---|
| `ateji` | Ateji (phonetic) reading |
| `iK` | Word containing irregular kanji usage |
| `ik` | Word containing irregular kana usage |
| `io` | Irregular okurigana usage |
| `oK` | Word containing out-dated kanji |
| `ok` | Out-dated or obsolete kana usage |
| `oik` | Old or irregular kana form |

### Reading Information (`re_inf`)

| Code | Description |
|---|---|
| `gikun` | Gikun (meaning as reading) or jukujikun (special kanji reading) |
| `ik` | Word containing irregular kana usage |
| `ok` | Out-dated or obsolete kana usage |
| `oik` | Old or irregular kana form |

### Dialect (`dial`)

| Code | Description |
|---|---|
| `kyb` | Kyoto-ben |
| `osb` | Osaka-ben |
| `ksb` | Kansai-ben |
| `ktb` | Kantou-ben |
| `tsb` | Tosa-ben |
| `thb` | Touhoku-ben |
| `tsug` | Tsugaru-ben |
| `kyu` | Kyuushuu-ben |
| `rkb` | Ryuukyuu-ben |
| `nab` | Nagano-ben |
| `hob` | Hokkaido-ben |

## EDICT Format

The EDICT file uses a simple flat-text format based on the text data file of the SKK input method. Each entry follows the pattern:

```
KANJI [KANA] /(general information) gloss/gloss/.../
```

Or for kana-only entries:

```
KANA /(general information) gloss/gloss/.../
```

Where there are multiple senses, these are indicated by `(1)`, `(2)`, etc. before the first gloss in each sense.

**Limitations:**
- Only a single kanji headword and reading per entry — entries are generated for each possible headword/reading combination
- Japanese characters are restricted to the kanji and kana fields — cross-reference data and other informational fields are omitted
- Distributed in JIS X 0208 coding in EUC-JP encapsulation
- Provided for legacy systems only — new systems should use JMdict XML or EDICT2

## EDICT2 Format

The EDICT2 file is an expanded form of the original EDICT format. The main differences are the inclusion of multiple kanji headwords and readings, and the inclusion of cross-reference and other information fields:

```
KANJI-1;KANJI-2 [KANA-1;KANA-2] /(general information) (see xxxx) gloss/gloss/.../
```

Multiple headwords and readings are separated by semicolons. Priority markers like `(P)` may appear after headwords and as a trailing field.

The last field is the entry sequence number, matching the `ent_seq` value in the XML edition:

```
EntLnnnnnnnnX
```

- `EntL` — fixed prefix to identify the field
- `nnnnnnnn` — the numeric sequence number
- `X` (optional) — indicates an audio clip of the entry reading is available from JapanesePod101.com

Distributed in JIS X 0208 and JIS X 0212 codings in EUC-JP encapsulation.

## Sample Entry: 収集

### JMdict XML

```xml
<entry>
  <ent_seq>1594720</ent_seq>
  <k_ele>
    <keb>収集</keb>
    <ke_pri>ichi1</ke_pri>
    <ke_pri>news1</ke_pri>
    <ke_pri>nf05</ke_pri>
  </k_ele>
  <k_ele>
    <keb>蒐集</keb>
  </k_ele>
  <k_ele>
    <keb>拾集</keb>
  </k_ele>
  <k_ele>
    <keb>収輯</keb>
  </k_ele>
  <r_ele>
    <reb>しゅうしゅう</reb>
    <re_pri>ichi1</re_pri>
    <re_pri>news1</re_pri>
    <re_pri>nf05</re_pri>
  </r_ele>
  <sense>
    <pos>&n;</pos>
    <pos>&vs;</pos>
    <gloss>gathering up</gloss>
    <gloss>collection</gloss>
    <gloss>accumulation</gloss>
  </sense>
  <sense>
    <gloss xml:lang="dut">verzamelen</gloss>
    <gloss xml:lang="dut">bijeenbrengen</gloss>
    <gloss xml:lang="dut">samenbrengen</gloss>
    <gloss xml:lang="dut">vergaren</gloss>
    <gloss xml:lang="dut">{veroud.} vergaderen</gloss>
    <gloss xml:lang="dut">inzamelen</gloss>
    <gloss xml:lang="dut">{ごみを} ophalen</gloss>
    <gloss xml:lang="dut">schooien</gloss>
  </sense>
  <sense>
    <gloss xml:lang="dut">collectioneren</gloss>
    <gloss xml:lang="dut">verzamelen</gloss>
    <gloss xml:lang="dut">sparen</gloss>
  </sense>
  <sense>
    <gloss xml:lang="dut">verzameling</gloss>
    <gloss xml:lang="dut">bijeenbrenging</gloss>
    <gloss xml:lang="dut">samenbrenging</gloss>
    <gloss xml:lang="dut">vergaring</gloss>
    <gloss xml:lang="dut">{veroud.} vergadering</gloss>
    <gloss xml:lang="dut">inzameling</gloss>
    <gloss xml:lang="dut">{ごみの} ophaling</gloss>
  </sense>
  <sense>
    <gloss xml:lang="dut">verzameling</gloss>
    <gloss xml:lang="dut">collectie</gloss>
    <gloss xml:lang="dut">bestand</gloss>
  </sense>
  <sense>
    <gloss xml:lang="fre">collection</gloss>
    <gloss xml:lang="fre">récolte</gloss>
  </sense>
  <sense>
    <gloss xml:lang="ger">sammeln</gloss>
    <gloss xml:lang="ger">(f) Sammlung</gloss>
    <gloss xml:lang="ger">(f) Kollektion</gloss>
    <gloss xml:lang="ger">(n) Sammeln</gloss>
  </sense>
  <sense>
    <gloss xml:lang="hun">gyűjtemény</gloss>
    <gloss xml:lang="hun">gyűjtés</gloss>
  </sense>
  <sense>
    <gloss xml:lang="rus">сбор</gloss>
    <gloss xml:lang="rus">собирать, коллекционировать</gloss>
    <gloss xml:lang="rus">собирание, коллекционирование</gloss>
    <gloss xml:lang="rus">{～する} собирать, коллекционировать</gloss>
  </sense>
  <sense>
    <gloss xml:lang="slv">zbiranje</gloss>
    <gloss xml:lang="slv">zbirati</gloss>
  </sense>
  <sense>
    <gloss xml:lang="spa">coleccionar</gloss>
    <gloss xml:lang="spa">recopilar</gloss>
    <gloss xml:lang="spa">hacer colección de</gloss>
    <gloss xml:lang="spa">recoger</gloss>
    <gloss xml:lang="spa">colección</gloss>
    <gloss xml:lang="spa">amontonamiento</gloss>
    <gloss xml:lang="spa">hacinamiento</gloss>
    <gloss xml:lang="spa">acumulamiento</gloss>
    <gloss xml:lang="spa">colección</gloss>
    <gloss xml:lang="spa">recopilación</gloss>
    <gloss xml:lang="spa">recolecta</gloss>
    <gloss xml:lang="spa">recogida</gloss>
  </sense>
</entry>
```

This entry has four kanji headwords (収集 being the most common, with priority markers), one reading, and eleven senses. The first sense carries `pos` (noun + suru verb); subsequent senses omit `pos`, inheriting it from sense 1. English glosses appear without `xml:lang` (defaulting to `eng`); other languages use ISO 639-2 codes (`dut`, `fre`, `ger`, `hun`, `rus`, `slv`, `spa`). German glosses show `g_gend`-style gender markers inline (e.g. `(f) Sammlung`).

### EDICT

```
収集 [しゅうしゅう] /(n,vs) gathering up/collection/accumulation/
```

In addition to equivalent entries with the 蒐集, 拾集, and 収輯 kanji compounds (one entry per headword).

### EDICT2

```
収集(P);蒐集;拾集;収輯 [しゅうしゅう] /(n,vs) gathering up/collection/accumulation/(P)/
```

All four kanji headwords in a single entry, with `(P)` indicating the primary headword is high-priority.

## Related Docs

- [JMdict DTD](http://www.edrdg.org/jmdict/jmdict_dtd_h.html) — Upstream DTD with entity definitions and field annotations
- [JMdict-EDICT Project](http://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project) — Official project page
- [pipeline.md](pipeline.md) — Full pipeline orchestration
