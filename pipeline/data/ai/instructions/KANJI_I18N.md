# AI Instructions: Kanji I18n (Batch)

Fill the template CSV `kanji_i18n_ai.csv` with mnemonics and search tags for kanji in this batch.

## CSV Format

| Column | Type | Description |
|---|---|---|
| `character` | read-only | The kanji character (e.g. 休, 日, 山) |
| `meanings_en` | read-only | English meanings JSON array from KANJIDIC |
| `components` | read-only | Component breakdown (e.g. `人(hen,semantic) + 木(tsukuri,phonetic)`) |
| `readings` | read-only | Onyomi readings (e.g. `キュウ`) |
| `lang_code` | read-only | `en`, `es`, or `ru` |
| `system_mnemonic` | **fill** | Layer 2 mnemonic story |
| `search_tags` | **fill** | JSON array of synonyms |

Only fill `system_mnemonic` and `search_tags`. Do not modify read-only columns.

## Field 1: `system_mnemonic` — Layer 2 Mnemonic

A short story (1-3 sentences) that links radical keywords to the kanji meaning via an onyomi sound anchor.

### Formula

`[Radical 1 name] + [Radical 2 name] = [Meaning]. [Sound anchor story for onyomi.]`

### Rules

1. **Must use radical names exactly as they appear in the batch's `radical_i18n.csv`.** Never invent new names for components. The `components` column shows which radicals are used — look up their names in the batch's radical i18n data.
2. **Prioritize onyomi** — 90% of compound words use onyomi. Learning it here unlocks thousands of words.
3. **Include a sound-alike word** for the primary onyomi from the language's sound anchor table (see below).
4. **Do NOT mention kunyomi** — that belongs in Layer 3 (vocabulary mnemonics).
5. **Each language is independent** — different sound anchors per language produce different stories.
6. **A2/B1 level language.** Simple words, physical actions.
7. **1-3 sentences max.**

### Worked Example

Kanji 休 (Rest) = 人 (Person) + 木 (Tree). Primary onyomi: KYUU.

| lang | system_mnemonic |
|---|---|
| en | A Person leans on a Tree to Rest. He uses a Cucumber (KYUU) as a pillow. |
| es | Una Persona se apoya en un Árbol para Descansar. Usa un Cubo (KYUU) como almohada. |
| ru | Человек прислонился к Дереву, чтобы Отдохнуть. Он упал в Кювет (KYUU) и заснул. |

### Radical-Kanji Name Consistency

When a radical is also a kanji (like 木, 力, 山), the keyword **must** match across Layer 1 (radical name) and Layer 2 (mnemonic component reference). If radical 木 = "Tree", then every mnemonic referencing 木 must say "Tree" — never "Wood" or "Timber".

## Sound Anchor Tables

Once an anchor is chosen for an onyomi in a given language, reuse it consistently across all kanji. Use "Best Anchor" first; only use "Alternative" if it fits the story significantly better.

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

## Field 2: `search_tags` — Synonyms

A JSON array of 3-8 alternative terms a learner might search for.

### Rules

1. **JSON array format:** `["tag1", "tag2", "tag3"]`
2. **3-8 tags** per entry.
3. **Include:** alternative meanings, related concepts, study-relevant associations.
4. **Do NOT include** the primary meaning itself.
5. **Lowercase** all tags.
6. **Language-appropriate** — tags must be in the same language as `lang_code`.

### Examples

| character | lang | search_tags |
|---|---|---|
| 休 | en | `["break", "holiday", "pause", "vacation", "relax"]` |
| 休 | es | `["descanso", "pausa", "vacaciones", "relajar"]` |

## CSV Formatting Rules

1. **Wrap fields containing commas in double quotes.**
2. **Double quotes inside quoted fields must be escaped** as `""`.
3. **`search_tags` always needs quoting** because the JSON array contains commas.
4. **No newlines inside fields.** Each row must be a single line.
5. **Every row must have exactly 7 columns.**
