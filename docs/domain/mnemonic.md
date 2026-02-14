# Mnemonic

## Overview

A mnemonic is a short story or phrase that helps a user remember a radical or kanji. The app ships with a system mnemonic for every item (stored in the I18n tables — see radical.md, kanji.md), but users often find that their own associations stick better. A user mnemonic lets a user write a personal memory aid that replaces the system one in the UI. For example, the system mnemonic for 水 might be "Three streams flowing down a mountain", but a user might prefer "The symbol on my water bottle."

## System Mnemonic Architecture

System mnemonics follow a "Lego Stack" — each layer builds on the previous, with a specific goal and formula. Progressive decomposition means the user never encounters an unexplained component.

### Language Rules

Mnemonics are generated per supported language. To ensure memorability for non-native speakers:

- **English:** CEFR A2/B1 vocabulary. Simple, common words. Prefer physical actions (hit, run, eat) over abstract language.
- **Spanish:** Standard neutral Spanish (Latin American generic). No regional slang.
- **Russian:** Standard literary Russian. No regional colloquialisms.
- **Independent stories:** Each language has its own sound anchors and mnemonics. "KYUU-cumber" works in English but not in Russian — each language must find native words that sound like the target reading. Stories will differ across languages.

### Layer 1: Radical — Shape Identity

**Goal:** Teach the radical's visual shape and meaning keyword.

**Formula:** Visual keyword (prefer official meaning > visual shape resemblance).

**Rules:**
- Name must be a single concrete noun (e.g. "Legs", not "human legs radical")
- Story must describe the shape physically — do not use "See X as Y"
- Use simple language (A2 level)

**Example:** 休 components:
- 人 → Keyword: "Person". Story: "Two legs walking forward."
- 木 → Keyword: "Tree". Story: "A trunk with branches spreading out."

### Layer 2: Kanji — System Sound (Onyomi)

**Goal:** Link radical keywords to kanji meaning via an onyomi sound anchor.

**Formula:** `[Radical 1] + [Radical 2] = [Meaning]. [Sound anchor story.]`

**Rules:**
- Must use the radical names from Layer 1 — never invent new names for components
- Prioritize onyomi (90% rule: most compound words use onyomi — learning it here unlocks thousands of words)
- Include a sound-alike English word for the onyomi
- Do not mention kunyomi — that belongs in Layer 3

**Example:** 休 (Rest) = 人 (Person) + 木 (Tree). Reading: KYUU. Story: "A Person leans on a Tree to Rest. He uses a KYUU-cumber (Cucumber) as a pillow."

### Layer 3: Vocabulary — Usage (Kunyomi/Context)

**Goal:** Teach the actual word reading (often kunyomi) in context.

**Formula:** Kanji meaning + context sentence + native reading.

**Rules:**
- Focus on the word itself — do not mention radicals
- Write a short sentence where the mnemonic explains the reading
- Kunyomi is context-heavy (it pairs with hiragana, like 食べる) — the vocabulary card provides that context

**Example:** 休む (yasumu) = to rest. Story: "I will Rest. YEA, SUMO wrestlers (Ya-sumu) need rest too."

### Sound Anchors

Each language maintains its own set of anchor words — native words that sound like the target onyomi. Once an anchor is chosen for a sound in a given language, it must be used consistently across all kanji with that reading.

**English** (optimized for concreteness):

| Onyomi | Best Anchor | Why it works | Alternative |
|---|---|---|---|
| CHUU | Chew (gum) | Action — chewing gum is sticky, stretches, and bubbles | Choo-choo (train) |
| SHUU | Shoes | Visual — wear them, throw them, fill with water | Shoot (gun/camera) |
| KOU | Coat | Visual — wrap things in it | Comb, Cone |
| KAN | Can (soda) | Visual — it explodes, fizzes, or crushes | Khan (Genghis) |
| SEI | Saber (sword) | Action — slice radicals with it | Saint (halo) |
| KAI | Kite | Visual — it flies, gets tangled, or crashes | Coyote |
| SHIN | Shin (leg) | Painful — getting kicked in the shin is memorable | Chin |
| TOU | Toe | Visual — stubbing a toe is universal pain | Toast (burnt bread) |
| KYUU | Cucumber | Visual — green, crunchy, recognizable | Cube (ice/Rubik's) |
| JYUU | Jewel | Valuable, shiny — hide it, steal it, or break it | Juice (spill it) |
| GYOU | Gyoza (dumpling) | Specific shape/food — eat it or cook it | Ghoul (monster) |
| GYUU | Guitar | Distinct shape/sound — smash it or play it | Glue (sticky) |
| GAN | Gun | Action — very memorable for mnemonics | Gong (loud sound) |
| JIN | Genie (lamp) | Character — magic explains abstract meanings easily | Jeans (clothing) |
| DOU | Donut | Shape/food — sticky, sweet, distinct hole in middle | Door, Dough |
| GOU | Goat | Animal — it eats things, headbutts things | Ghost, Goal |

**Spanish** (neutral, concrete nouns — avoid abstract verbs):

| Onyomi | Best Anchor | Why it works | Alternative |
|---|---|---|---|
| CHUU | Chupete (pacifier) | Visual — distinct shape, used by babies (funny contrast) | Chuleta (chop/steak) |
| SHUU | Sumo (wrestler) | Soft S distinguishes from CHUU (Chu-); visual — big, heavy, memorable character | Sudor (sweat) |
| KOU | Cola (glue/tail) | Sticky (glue) or wagging (tail) — very interactive | Coco (coconut) |
| KAN | Candado (lock) | Action — you lock things up, heavy object | Canguro (kangaroo) |
| SEI | Seis (6) | Shape — the number 6 is distinct | Sello (stamp) |
| KAI | Caimán (gator) | Dangerous — it bites radicals | Caída (falling) |
| SHIN | Chinchilla | Cute, furry, active | Chinche (thumbtack — painful) |
| TOU | Toro (bull) | Aggressive — it charges at things | Torre (tower) |
| KYUU | Cubo (bucket) | Useful container — fill it with water/radicals | Cuna (crib) |
| JYUU | Lluvia (rain) | Sound match in many accents — wet, covers things | Yudo (judo) |
| GYOU | Guillotina | Scary/sharp — cutting heads off radicals | Guiñol (puppet) |
| GYUU | Guitarra | Visual/sound — universal object | Guinda (cherry) |
| GAN | Gancho (hook) | Shape — hook things together | Ganso (goose) |
| JIN | Jinete (rider) | Character — a guy on a horse (or on a radical) | Ginebra (gin bottle) |
| DOU | Dominó | Visual — distinct dots/tiles | Dorado (gold object) |
| GOU | Goma (eraser) | Action — rubbing/erasing parts of the kanji | Gorra (cap) |

**Russian** (concrete nouns — avoid abstract/time words):

| Onyomi | Best Anchor | Why it works | Alternative |
|---|---|---|---|
| CHUU | Чучело (scarecrow) | Visual — creepy/funny character made of straw | Чупа-чупс (lollipop) |
| SHUU | Шуба (fur coat) | Textural — heavy, warm, funny if worn in summer | Шут (jester) |
| KOU | Кот (cat) | Character — it scratches, meows, sleeps on radicals | Кол (stake) |
| KAN | Канат (rope) | Action — tie things up, swing from it | Кан (jerrycan) |
| SEI | Сейф (safe) | Heavy — drop it on things, open it to find meaning | Сейлор (Sailor Moon) |
| KAI | Кай (Snow Queen) | Character — boy with ice shard in eye | Гайка (nut/bolt) |
| SHIN | Шина (tire) | Visual — roll it, burn it, bounce it | Шило (awl) |
| TOU | Торт (cake) | Sticky, sweet — throw it in a face | Топор (axe) |
| KYUU | Кювет (ditch) | Location — fall into it, driving context | Клюв (beak) |
| JYUU | Жук (beetle) | Visual/creepy — it crawls on the radicals | Журавль (crane) |
| GYOU | Гёза (gyoza) | Food — tasty, recognizable shape | Герб (coat of arms) |
| GYUU | Гюйс (naval jack) | Flag — visual | Гюрза (viper) |
| GAN | Гантель (dumbbell) | Heavy — drop it, lift it | Гангстер (gangster) |
| JIN | Джин (genie) | Magic character | Джинсы (jeans) |
| DOU | Дом (house) | Visual — big structure | Доска (board) |
| GOU | Гора (mountain) | Huge visual — climb it | Гонг (gong) |

These tables grow as new kanji are processed. Rules:
- Use the "Best Anchor" first. Only use the "Alternative" if it fits the story context significantly better.
- Never use abstract words.
- Once an anchor is chosen for a sound in a given language, reuse it consistently. Exceptions are allowed when the alternative makes a significantly better story, but prefer consistency.

### Critical Rule: Radical-Kanji Name Consistency

When a radical is also a kanji (like 州, 力, 木), the radical keyword **must** match the kanji meaning. If radical 州 = "River" but kanji 州 = "Province," the user's brain breaks when they see 州 in a compound. The `master_symbol` identity anchors both.

### Summary

| Layer | What it teaches | Formula |
|---|---|---|
| Radical | Shape + meaning | Visual keyword (concrete noun) |
| Kanji | Components + onyomi | Radical keywords + sound anchor = meaning |
| Vocabulary | Usage + actual reading | Kanji meaning + context + reading |

## Entities

### UserMnemonic (Entity)

A user-written mnemonic for a specific radical, kanji, or vocabulary item. At most one per user per item. When present, the UI displays this instead of the `system_mnemonic` from the I18n table.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `user_id` | `UUID` | FK to the user who created this mnemonic |
| `item_type` | `ItemType` | `radical`, `kanji`, or `vocabulary` — which kind of item this mnemonic is for (see shared_types.md). Vocabulary mnemonics are not used in MVP but the schema supports them |
| `item_id` | `int` | FK to the Radical, Kanji, or Vocabulary, depending on `item_type` |
| `text` | `String` | The user's mnemonic text |
| `created_at` | `DateTime` | When the mnemonic was first written |
| `updated_at` | `DateTime` | When the mnemonic was last edited |

**Why a polymorphic `item_type` + `item_id` instead of separate `radical_id` / `kanji_id` columns?**

A user mnemonic works identically for radicals, kanji, and vocabulary — same UI, same logic, same table. Using `ItemType` to discriminate avoids duplicating the entity and keeps the query pattern consistent with the SRS system, which already uses `ItemType` to address items generically.

**Why not store user mnemonics in the I18n tables?**

System mnemonics are content-pipeline data — written by translators, shipped with the app, shared by all users. User mnemonics are user-generated data — personal, mutable, synced per account. Mixing them in the same table would complicate the content pipeline and make it hard to reset system content without losing user data.

## Relationships

```
User          ──1:N──→ UserMnemonic    (one user, many custom mnemonics; see user.md)
UserMnemonic  ──N:1──→ Radical         (when item_type = radical; see radical.md)
UserMnemonic  ──N:1──→ Kanji           (when item_type = kanji; see kanji.md)
UserMnemonic  ──N:1──→ Vocabulary      (when item_type = vocabulary; see vocabulary.md — post-MVP)
```

The system mnemonic lives in `RadicalI18n.system_mnemonic` (see radical.md) and `KanjiI18n.system_mnemonic` (see kanji.md). `VocabularyI18n.system_mnemonic` is nullable — vocabulary mnemonics may add noise since word meanings are often self-explanatory; they are most useful for kunyomi readings but even then optional. `UserMnemonic` overrides the system mnemonic in the UI but never modifies it.

## Business Rules

1. `user_id` + `item_type` + `item_id` must be unique — one user mnemonic per item per user.
2. `text` must be non-empty. To remove a custom mnemonic, delete the row (reverts to system mnemonic).
3. `item_type` accepts all three values (`radical`, `kanji`, `vocabulary`).
4. The referenced item (`item_id`) must exist for the given `item_type`.

## Edge Cases

- **User deletes their mnemonic:** The row is removed and the UI reverts to displaying the `system_mnemonic` from the I18n table. No tombstone needed.
- **System mnemonic updated after user override:** The user keeps seeing their own mnemonic. If they delete it, they see the updated system version. No conflict resolution needed.
- **Very long user text:** Enforce a reasonable max length (e.g. 1000 characters) at the UI and validation layer to prevent abuse without restricting creativity.
- **Item deleted:** Deleting a Radical or Kanji should cascade-delete associated `UserMnemonic` rows.
