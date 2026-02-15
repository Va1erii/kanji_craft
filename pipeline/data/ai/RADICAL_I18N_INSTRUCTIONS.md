# AI Instructions: Radical I18n Generation

You are generating localized learning content for a Japanese kanji learning app. Your task is to fill in the `radical_i18n_ai.csv` file with names, mnemonics, and search tags for 777 radicals across 3 languages (EN, ES, RU).

## Input File

`radical_i18n_ai.csv` — 2,331 rows (777 radicals x 3 languages).

| Column | Description |
|---|---|
| `master_symbol` | The radical character (e.g. 水, 木, 人). **Read-only key.** |
| `en_name_seed` | English meaning from KANJIDIC dictionary. **Read-only context.** May be empty (41 radicals have no KANJIDIC entry), verbose, or multi-word — treat as a hint, not final. |
| `lang_code` | `en`, `es`, or `ru`. **Read-only key.** |
| `name` | **Fill this.** Localized name (single concrete noun). |
| `system_mnemonic` | **Fill this.** Layer 1 mnemonic story. |
| `search_tags` | **Fill this.** JSON array of synonyms. |

Only fill `name`, `system_mnemonic`, and `search_tags`. Do not modify other columns.

## Field 1: `name` — Localized Name

A single concrete noun that becomes the radical's keyword throughout the app. This name is referenced in kanji mnemonics (Layer 2), so it must be stable and memorable.

### Rules

1. **Single concrete noun.** "Water", not "water radical". "Legs", not "human legs radical (no. 10)".
2. **Capitalize** the first letter (EN/ES). Russian uses standard capitalization.
3. **EN name:** Start from the `en_name_seed` column. Clean it into a single noun. If the seed is already a clean noun (e.g. "water", "fire", "tree"), capitalize and use it. If the seed is verbose (e.g. "katakana no radical (no. 4)"), pick a better concrete noun based on the shape.
4. **ES/RU names:** Translate from the finalized EN name. Must also be a single concrete noun — no descriptive suffixes or qualifiers. "Persona", not "El radical de la persona". "Ноги", not "Радикал ноги". Just the bare noun.
5. **No KANJIDIC entry** (41 radicals with empty `en_name_seed`): Invent a name based on what the character visually resembles. These are often rare components or CJK variants (⺍, ⺤, ⻌, マ, 龰, etc.).
6. **Radical-kanji consistency (STOP AND CHECK):** Many radicals are also kanji characters (水 is both radical and kanji). Before writing the name, check: does this character also exist as a kanji? If yes, the radical name MUST match the kanji's primary meaning. The kanji meaning is the source of truth. If radical 州's kanji meaning is "Province", the radical name must be "Province" — never "Sandbar" or "River". Why: if a student learns the radical name "Sandbar" but later the kanji card for the same character says "Province", they lose trust in the app. When in doubt, the kanji meaning always wins.

### Cleaning Examples

| master_symbol | en_name_seed (from KANJIDIC) | Correct `name` (EN) |
|---|---|---|
| 水 | water | Water |
| 人 | person | Person |
| 丿 | katakana no radical (no. 4) | Slash |
| 亠 | kettle lid radical (no. 8) | Lid |
| 儿 | legs radical (no. 10) | Legs |
| 冖 | wa-shaped crown radical (no. 14) | Crown |
| 冂 | upside-down box radical (no. 13) | Box |
| 丑 | sign of the ox or cow | Ox |
| 又 | or again | Again |
| 丶 | dot | Dot |
| 㕣 | a marsh at the foot of the hills | Marsh |
| ⺍ | *(empty — no KANJIDIC)* | Horns *(visual shape)* |

## Field 2: `system_mnemonic` — Layer 1 Mnemonic

A short story (1-2 sentences) that teaches the radical's visual shape and connects it to the name keyword.

### Rules

1. **Describe the `master_symbol` form first.** The mnemonic describes the master symbol — the canonical full form. If the radical has a well-known variant (e.g. 水→氵), mention it in parentheses after.
2. **Fixed-position radicals — use position in the mnemonic.** Some radicals only ever appear in one specific position inside kanji. If a radical is locked to a single position, mention that position in the mnemonic — it's a reliable fact that helps the learner. Examples of fixed-position radicals:
   - 氵 (Water variant): always on the **left** (hen)
   - 亻 (Person variant): always on the **left** (hen)
   - ⻖ (Mound): always on the **left** (hen)
   - 灬 (Fire dots): always on the **bottom** (ashi)
   - ⺤ (Claw): always on **top** (kanmuri)
   - 飠 (Food): always on the **left** (hen)
   - Good: 氵 — "Three drops of water on the left side, like rain running down a window."
   - Bad: 氵 — "Three drops of water on top of a character." (wrong position)
3. **Do NOT reference stroke counts.** Stroke count data may contain errors. Never say "three strokes", "four lines", or any specific number of strokes in a mnemonic. Describe the shape visually instead.
   - Bad: "Four strokes splash outward like water."
   - Good: "Strokes splash outward from a central stream, like a fountain."
4. **Describe the physical shape** of the character. What does it look like? How do the strokes form the image?
5. **Describe strokes as a drawing of the keyword** — not as abstract geometry. The reader should "see" the keyword object in the strokes.
   - Bad: "A horizontal line and a vertical line." (abstract stroke inventory)
   - Bad: "See this as a cross." (forbidden "See X as Y" phrasing)
   - Good: "A cross shape, like a grave marker planted in the earth." (concrete image from the strokes)
6. **Never use "See X as Y", "Think of X as Y", or "Imagine X as Y"** phrasing. Describe the shape directly as if it IS the object.
7. **Connect shape to meaning.** The story must link the visual appearance to the keyword name.
8. **A2/B1 level language.** Simple, common words. Prefer physical actions (hit, run, eat) over abstract language.
9. **1-2 sentences max.** Keep it concise and vivid.
10. **Each language is independent.** EN, ES, RU mnemonics may tell different stories if that works better for the language. They don't need to be literal translations.
11. **Spanish:** Standard neutral (Latin American generic). No regional slang.
12. **Russian:** Standard literary. No regional colloquialisms.
13. **Positional clues (visual group radicals only):** For the 32 radicals that belong to a `visual_group`, the mnemonic MUST mention the radical's standard position inside kanji (e.g. "on the left side", "at the bottom", "always on top"). This reinforces disambiguation — the learner needs to associate both shape AND position to tell visual twins apart.

### Examples

| master_symbol | lang | name | system_mnemonic |
|---|---|---|---|
| 人 | en | Person | Two legs walking forward. |
| 人 | es | Persona | Dos piernas caminando hacia adelante. |
| 人 | ru | Человек | Две ноги шагают вперёд. |
| 木 | en | Tree | A trunk with branches spreading left and right. |
| 木 | es | Arbol | Un tronco con ramas extendiéndose a los lados. |
| 木 | ru | Дерево | Ствол с ветками, раскинувшимися в стороны. |
| 水 | en | Water | Streams splash outward from a central flow, like a fountain. |
| 氵 | en | Water | Drops of water running down the left side, like rain on a window. (Variant of 水, always on the left.) |
| 口 | en | Mouth | An open square, like a mouth seen from the front. |
| 一 | en | One | A single horizontal line — the foundation of everything. |
| ⺍ | en | Horns | Small strokes rising like horns on top of a head. |
| ⻖ | en | Mound | A bumpy cliff on the left side, representing a mound of earth. |
| ⻏ | en | City | A tall pillar on the right side, like the walls of a city. |
| 肉 | en | Flesh | The same shape as Moon, but on the left side or bottom it means flesh and body. |

## Field 3: `search_tags` — Synonyms

A JSON array of 3-8 alternative terms a learner might search for. Helps the app's search feature find this radical by related concepts.

### Rules

1. **JSON array format:** `["tag1", "tag2", "tag3"]`
2. **3-8 tags** per entry. Vary by language.
3. **Include:** alternative meanings, related concepts, visual associations, common associations.
4. **Do NOT include** the `name` itself (it's already searchable).
5. **Lowercase** all tags.
6. **Language-appropriate** — tags must be in the same language as `lang_code`.

### Examples

| master_symbol | lang | name | search_tags |
|---|---|---|---|
| 水 | en | Water | `["liquid", "splash", "ocean", "rain", "flow"]` |
| 水 | es | Agua | `["liquido", "rio", "lluvia", "fluir", "ola"]` |
| 水 | ru | Вода | `["жидкость", "река", "дождь", "поток", "океан"]` |
| 人 | en | Person | `["human", "man", "figure", "body", "walker"]` |
| 刀 | en | Sword | `["blade", "knife", "cut", "katana", "weapon"]` |

## Data Summary

| Category | Count |
|---|---|
| Total radicals | 777 |
| Total rows (777 x 3 langs) | 2,331 |
| EN with KANJIDIC seed name | 736 |
| EN without KANJIDIC seed (need visual naming) | 41 |
| Radicals with visual_group (have disambiguation_note) | 32 |

### JLPT Distribution

| Level | Radicals | Priority |
|---|---|---|
| N5 | 57 | Highest — beginner content |
| N4 | 127 | High |
| N3 | 175 | Medium |
| N2 | 108 | Medium |
| N1 | 283 | Lower |
| No JLPT | 27 | Lowest |

Process N5 first if batching.

## Disambiguation Notes (Already Handled)

32 radicals belong to visual groups — sets of radicals that look identical inside kanji (e.g. 肉 and 月 both render as the same shape). These already have `disambiguation_note` populated in the output from `visual_rules.json`. You do NOT need to generate disambiguation notes — they are curated separately and the pipeline handles them.

However, your mnemonic should acknowledge the visual similarity when relevant. For example, if 肉 (Meat/Flesh) looks like 月 (Moon) inside kanji, the mnemonic could mention: "The same shape as Moon, but here it means Flesh — found on the left side or bottom."

## Visual Groups Reference

These radicals share identical rendered forms inside kanji. The `name` and `system_mnemonic` must clearly distinguish them:

| Visual Form | Radicals | Key Distinction |
|---|---|---|
| 月 | 肉 (flesh), 月 (moon) | Position: left/bottom = flesh, right/top = moon |
| 阝 | ⻖ (mound), ⻏ (city) | Position: left = mound, right = city |
| 人-like | 人 (person full), 亻 (person side), 儿 (legs) | Form: full / left-side / bottom |
| ⺤/爫 | ⺤ (claw top), 爫 (claw alt) | Top variation vs alternate form |
| 水-like | 水 (water full), 氵 (water drops) | Full form vs 3-dot left-side form |
| 火-like | 火 (fire full), 灬 (fire dots) | Full form vs 4-dot bottom form |
| 土/士 | 土 (earth), 士 (samurai) | Top stroke: shorter = earth, longer = samurai |
| 王/玉 | 王 (king), 玉 (jewel) | Dot: 玉 has a dot, 王 doesn't |
| 礻/衤 | 礻 (spirit), 衤 (clothing) | Stroke count differs |
| 罒/⺲ | 罒 (net top), ⺲ (net alt) | Positioning variant |
| 匚/匸 | 匚 (box open), 匸 (box hidden) | Opening direction |
| 艹 variants | 艹 (grass) forms | Stroke style varies |
| 母/毋 | 母 (mother), 毋 (do not) | Internal strokes differ |
| 西/覀 | 西 (west), 覀 (west top) | Full vs top-component form |

## Quality Checklist

Before submitting, verify:

- [ ] Every row has a non-empty `name` (single concrete noun, capitalized)
- [ ] Every row has a non-empty `system_mnemonic` (1-2 sentences, describes shape)
- [ ] Every row has `search_tags` as a valid JSON array with 3-8 items
- [ ] EN names for the 41 no-KANJIDIC radicals are based on visual shape
- [ ] ES/RU names are proper translations of the EN name (single noun)
- [ ] No "See X as Y" phrasing in mnemonics
- [ ] Mnemonics use A2/B1 level vocabulary
- [ ] Visual group radicals have clearly distinguishing mnemonics
- [ ] Names are consistent with kanji meanings for dual-identity characters

## Reference: Sound Anchor Tables (Layer 2 Context)

These anchors are NOT used in Layer 1 radical mnemonics — they belong to Layer 2 (kanji mnemonics, Step 3). They are included here so you understand the full mnemonic system. The radical names you assign here will be combined with these sound anchors in kanji stories later.

Example of how it connects: If you name radical 木 "Tree", a kanji mnemonic (Layer 2) will later say: "A Person leans on a **Tree** to Rest. He uses a **Cucumber** (KYUU) as a pillow." Your radical name is the building block.

### English

| Onyomi | Best Anchor | Alternative |
|---|---|---|
| CHUU | Chew (gum) | Choo-choo (train) |
| SHUU | Shoes | Shoot (gun/camera) |
| KOU | Coat | Comb, Cone |
| KAN | Can (soda) | Khan (Genghis) |
| SEI | Saber (sword) | Saint (halo) |
| KAI | Kite | Coyote |
| SHIN | Shin (leg) | Chin |
| TOU | Toe | Toast (burnt bread) |
| KYUU | Cucumber | Cube (ice/Rubik's) |
| JYUU | Jewel | Juice (spill it) |
| GYOU | Gyoza (dumpling) | Ghoul (monster) |
| GYUU | Guitar | Glue (sticky) |
| GAN | Gun | Gong (loud sound) |
| JIN | Genie (lamp) | Jeans (clothing) |
| DOU | Donut | Door, Dough |
| GOU | Goat | Ghost, Goal |

### Spanish

| Onyomi | Best Anchor | Alternative |
|---|---|---|
| CHUU | Chupete (pacifier) | Chuleta (chop/steak) |
| SHUU | Sumo (wrestler) | Sudor (sweat) |
| KOU | Cola (glue/tail) | Coco (coconut) |
| KAN | Candado (lock) | Canguro (kangaroo) |
| SEI | Seis (6) | Sello (stamp) |
| KAI | Caimán (gator) | Caída (falling) |
| SHIN | Chinchilla | Chinche (thumbtack) |
| TOU | Toro (bull) | Torre (tower) |
| KYUU | Cubo (bucket) | Cuna (crib) |
| JYUU | Lluvia (rain) | Yudo (judo) |
| GYOU | Guillotina | Guiñol (puppet) |
| GYUU | Guitarra | Guinda (cherry) |
| GAN | Gancho (hook) | Ganso (goose) |
| JIN | Jinete (rider) | Ginebra (gin bottle) |
| DOU | Dominó | Dorado (gold object) |
| GOU | Goma (eraser) | Gorra (cap) |

### Russian

| Onyomi | Best Anchor | Alternative |
|---|---|---|
| CHUU | Чучело (scarecrow) | Чупа-чупс (lollipop) |
| SHUU | Шуба (fur coat) | Шут (jester) |
| KOU | Кот (cat) | Кол (stake) |
| KAN | Канат (rope) | Кан (jerrycan) |
| SEI | Сейф (safe) | Сейлор (Sailor Moon) |
| KAI | Кай (Snow Queen) | Гайка (nut/bolt) |
| SHIN | Шина (tire) | Шило (awl) |
| TOU | Торт (cake) | Топор (axe) |
| KYUU | Кювет (ditch) | Клюв (beak) |
| JYUU | Жук (beetle) | Журавль (crane) |
| GYOU | Гёза (gyoza) | Герб (coat of arms) |
| GYUU | Гюйс (naval jack) | Гюрза (viper) |
| GAN | Гантель (dumbbell) | Гангстер (gangster) |
| JIN | Джин (genie) | Джинсы (jeans) |
| DOU | Дом (house) | Доска (board) |
| GOU | Гора (mountain) | Гонг (gong) |

### Anchor Rules

- Use "Best Anchor" first. Only use "Alternative" if it fits the story significantly better.
- Never use abstract words as anchors — only concrete, physical, visual objects or actions.
- Once an anchor is chosen for a sound in a given language, reuse it consistently across all kanji.

## Output

Fill the 3 columns (`name`, `system_mnemonic`, `search_tags`) in `radical_i18n_ai.csv` and return the completed file. The pipeline will merge your content into the final `radical_i18n.csv`.
