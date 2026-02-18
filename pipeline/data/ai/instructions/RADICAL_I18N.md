# AI Instructions: Radical I18n (Batch)

Fill the template CSV `radical_i18n_ai.csv` with names, mnemonics, and search tags for radicals in this batch.

## CSV Format

| Column | Type | Description |
|---|---|---|
| `master_symbol` | read-only | The radical character (e.g. 水, 木, 人) |
| `en_name_seed` | read-only | English meaning from KANJIDIC (may be empty) |
| `lang_code` | read-only | `en`, `es`, or `ru` |
| `name` | **fill** | Localized name (single concrete noun) |
| `system_mnemonic` | **fill** | Layer 1 mnemonic story |
| `search_tags` | **fill** | JSON array of synonyms |

Only fill `name`, `system_mnemonic`, and `search_tags`. Do not modify read-only columns.

## Field 1: `name` — Localized Name

A single concrete noun that becomes the radical's keyword throughout the app. This name is referenced in kanji mnemonics (Layer 2), so it must be stable and memorable.

### Rules

1. **STRICT SOURCE OF TRUTH:** If a radical is also a standalone kanji, you MUST use its primary kanji meaning as the name.
   - DO NOT use visual mnemonics as names: No "Bird" for 不 — use "Negative". No "Ceiling" for 一 — use "One".
   - The `en_name_seed` column IS the kanji meaning when present. Use it.
   - You MAY simplify archaic/verbose seeds into a cleaner modern noun (e.g. "a marsh at the foot of the hills" → "Marsh"), but the core meaning must stay the same.
   - **EXCEPTION:** Only invent a visual name if `en_name_seed` is empty OR is a technical description like "radical number 4".
2. **Single concrete noun.** "Water", not "water radical". "Legs", not "human legs radical".
3. **Capitalize** the first letter (EN/ES). Russian uses standard capitalization.
4. **EN name:** Start from the `en_name_seed` column. Clean it into a single noun.
5. **ES/RU names:** Translate from the finalized EN name. Must also be a single concrete noun.
6. **No KANJIDIC entry** (empty `en_name_seed`): Invent a name based on what the character visually resembles.

### Cleaning Examples

| master_symbol | en_name_seed | Correct `name` (EN) | Why |
|---|---|---|---|
| 水 | water | Water | Clean seed → capitalize |
| 不 | negative | Negative | Kanji meaning wins — NOT "Bird" |
| 丿 | katakana no radical (no. 4) | Slash | Technical seed → invent from shape |
| 亠 | kettle lid radical (no. 8) | Lid | Technical seed → simplify |
| ⺍ | *(empty)* | Horns | Empty seed → invent from shape |

## Field 2: `system_mnemonic` — Layer 1 Mnemonic

A short story (1-2 sentences) that teaches the radical's visual shape and connects it to the name keyword.

### Rules

1. **Describe the `master_symbol` form first.** If the radical has a well-known variant (e.g. 水→氵), mention it in parentheses.
2. **Fixed-position radicals — use position in the mnemonic.** If a radical is locked to a single position (e.g. 氵 always left, 灬 always bottom), mention it.
3. **Do NOT reference stroke counts.** Describe the shape visually instead.
4. **Describe the physical shape** of the character. What does it look like?
5. **Describe strokes as a drawing of the keyword** — not as abstract geometry.
6. **Never use "See X as Y", "Think of X as Y", or "Imagine X as Y"** phrasing.
7. **Connect shape to meaning.** The story must link the visual appearance to the keyword name.
8. **A2/B1 level language.** Simple, common words.
9. **1-2 sentences max.**
10. **Each language is independent.** EN, ES, RU mnemonics may tell different stories.
11. **Spanish:** Standard neutral (Latin American generic).
12. **Russian:** Standard literary.

### Examples

| master_symbol | lang | name | system_mnemonic |
|---|---|---|---|
| 人 | en | Person | Two legs walking forward. |
| 木 | en | Tree | A trunk with branches spreading left and right. |
| 水 | en | Water | Streams splash outward from a central flow, like a fountain. |
| 氵 | en | Water | Drops of water running down the left side, like rain on a window. (Variant of 水, always on the left.) |

## Field 3: `search_tags` — Synonyms

A JSON array of 3-8 alternative terms a learner might search for.

### Rules

1. **JSON array format:** `["tag1", "tag2", "tag3"]`
2. **3-8 tags** per entry.
3. **Include:** alternative meanings, related concepts, visual associations.
4. **Do NOT include** the `name` itself.
5. **Lowercase** all tags.
6. **Language-appropriate** — tags must be in the same language as `lang_code`.

### Examples

| master_symbol | lang | search_tags |
|---|---|---|
| 水 | en | `["liquid", "splash", "ocean", "rain", "flow"]` |
| 水 | es | `["liquido", "rio", "lluvia", "fluir", "ola"]` |

## Sound Anchor Tables (Layer 2 Context)

These anchors are NOT used in Layer 1 radical mnemonics — they belong to Layer 2 (kanji mnemonics). They are included here so you understand the full mnemonic system. The radical names you assign will be combined with these sound anchors in kanji stories later.

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

## CSV Formatting Rules

**CRITICAL:** Fields containing commas, quotes, or newlines MUST be properly quoted per RFC 4180:

1. **Wrap fields containing commas in double quotes.**
2. **Double quotes inside quoted fields must be escaped** as `""`.
3. **`search_tags` always needs quoting** because the JSON array contains commas: `"[""liquid"",""splash""]"`
4. **No newlines inside fields.** Each row must be a single line.
5. **Every row must have exactly 6 columns.**
