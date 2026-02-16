# SRS

## Overview

The app uses FSRS (Free Spaced Repetition Scheduler) to schedule reviews for radicals, kanji, and vocabulary. FSRS is a modern algorithm based on the DSR memory model — each item tracks its own **difficulty**, **stability**, and computed **retrievability**. Unlike fixed-stage systems (WaniKani) or simple multiplier systems (Anki's SM-2), FSRS adapts per card and can be optimized per user. The Dart package [`fsrs`](https://pub.dev/packages/fsrs) provides the scheduling engine; this spec defines the data model around it.

## Entities

### Rating (Enum)

The grade a user gives after reviewing an item. Determines how stability and difficulty are updated.

| Value | Int | Description |
|---|---|---|
| `again` | 1 | Forgot the answer — triggers a lapse |
| `hard` | 2 | Recalled with serious difficulty |
| `good` | 3 | Recalled after some hesitation |
| `easy` | 4 | Effortless recall |

### CardState (Enum)

The lifecycle state of an SRS card. Drives which queue the card appears in.

| Value | Int | Description |
|---|---|---|
| `new_card` | 0 | Never reviewed — waiting in the lesson queue |
| `learning` | 1 | Being learned for the first time (short-interval steps) |
| `review` | 2 | Graduated to the normal review schedule |
| `relearning` | 3 | Lapsed (forgotten) and being re-learned |

### SrsCard (Entity)

The per-item FSRS state. One card per user per item. This is the core scheduling record — it stores everything FSRS needs to compute the next review date.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `user_id` | `UUID` | FK to the user |
| `item_type` | `ItemType` | `radical`, `kanji`, or `vocabulary` (see shared_types.md) |
| `item_id` | `int` | FK to the Radical, Kanji, or Vocabulary |
| `state` | `CardState` | Current lifecycle state |
| `due` | `DateTime` | When the next review is scheduled (UTC) |
| `stability` | `double` | Memory stability in days — the interval at which retrievability drops to 90% |
| `difficulty` | `double` | Card difficulty. `0` for unreviewed cards; [1, 10] after first review. Higher = harder to grow stability |
| `elapsed_days` | `int` | Days since the last review |
| `scheduled_days` | `int` | Days the card was scheduled to wait before this review |
| `reps` | `int` | Total number of reviews performed |
| `lapses` | `int` | Number of times the card was forgotten (rated `again` from `review` state) |
| `last_review` | `DateTime?` | Timestamp of the most recent review. Null for new cards |

**Why store `elapsed_days` and `scheduled_days` when they could be derived?**

FSRS uses both values in its stability formulas. `scheduled_days` records what the algorithm planned; `elapsed_days` records what actually happened (the user may review early or late). Storing both avoids recomputing from review logs and keeps the card self-contained for scheduling.

**Why one card per user per item, not one global card?**

Each user progresses independently. Stability and difficulty are personal — one user may find 水 trivial while another struggles. The `user_id` + `item_type` + `item_id` triple uniquely identifies a card.

### ReviewLog (Entity)

A record of a single review event. Used for analytics, undo, and future parameter optimization.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `card_id` | `int` | FK to the SrsCard that was reviewed |
| `rating` | `Rating` | The grade given (`again`, `hard`, `good`, `easy`) |
| `state_before` | `CardState` | The card's state before this review |
| `stability_before` | `double` | Stability before this review |
| `difficulty_before` | `double` | Difficulty before this review |
| `reviewed_at` | `DateTime` | When the review occurred (UTC) |

**Why store `state_before`, `stability_before`, `difficulty_before`?**

Enables undo (restore previous state) and parameter optimization (FSRS can retrain its weights from review history). Without pre-review snapshots, both operations require replaying the entire history.

## Relationships

```
User       ──1:N──→ SrsCard        (one user, many cards across all item types; see user.md)
SrsCard    ──1:N──→ ReviewLog      (one card, many review events)
SrsCard    ──N:1──→ Radical        (when item_type = radical; see radical.md)
SrsCard    ──N:1──→ Kanji          (when item_type = kanji; see kanji.md)
SrsCard    ──N:1──→ Vocabulary     (when item_type = vocabulary; see vocabulary.md)
```

## Business Rules

1. `user_id` + `item_type` + `item_id` must be unique — one SrsCard per user per item.
2. A card starts in `new_card` state with `stability = 0`, `difficulty = 0`, `reps = 0`, `lapses = 0`.
3. The first review transitions the card from `new_card` to `learning`. FSRS computes initial stability from the rating: `S_0(rating) = w[rating - 1]`.
4. A card graduates from `learning` to `review` after completing all learning steps (default: 1 min, 10 min).
5. Rating `again` on a `review` card triggers a lapse: the card moves to `relearning`, `lapses` increments by 1.
6. A card graduates from `relearning` to `review` after completing all relearning steps (default: 10 min).
7. **Unlock gate:** all components of a kanji must reach `stability >= 7.0` days before the kanji can enter the lesson queue. For radical components (`component_type=radical`), check `srs_cards WHERE item_type='radical' AND item_id=component_id`. For kanji components (`component_type=kanji`), check `srs_cards WHERE item_type='kanji' AND item_id=component_id`. This ensures the learner knows every building block before encountering the compound character. See [component_model.md](../adr/component_model.md).
8. Radicals are reviewed on meaning only. Kanji and vocabulary are reviewed on both meaning and reading.
9. After the first review, `difficulty` is clamped to the range [1, 10]. New cards use `0` as a sentinel (see rule #2).
10. `stability` must be non-negative. After a lapse, `stability` is recalculated but never increases from a forget event.
11. ReviewLog rows are append-only — never updated or deleted (except by explicit user data wipe).
12. SrsCard rows cannot be deleted by users — only reset (update state back to `new_card`). Deletion only occurs via account deletion cascade (`users` → `srs_cards` → `review_logs`). This protects the append-only review history.
13. FSRS scheduler parameters (the `w` array, `desired_retention`, learning/relearning steps) are global configuration, not per-card. Store them in app settings.

## Edge Cases

- **Review before due date:** The user reviews early. `elapsed_days < scheduled_days`. FSRS handles this — retrievability is higher than 90%, so stability grows less. No special logic needed.
- **Review long after due date:** The user is overdue. `elapsed_days >> scheduled_days`. Retrievability is very low. FSRS will likely recommend a shorter interval than before. This is correct behavior — the card needs refreshing.
- **Leech detection:** A card with high `lapses` (e.g. >= 8) may indicate a problematic item. The app should surface a hint to revisit the mnemonic (see mnemonic.md) rather than suspending the card automatically.
- **New user, no review history:** FSRS defaults apply. No parameter optimization is possible until the user has enough review data (~1000 reviews recommended for meaningful optimization).
- **Item deleted:** Deleting a Radical or Kanji should cascade-delete associated `SrsCard` and `ReviewLog` rows.
- **Clock manipulation:** `due` and `reviewed_at` use UTC. If the device clock is wrong, reviews may be incorrectly timed. The app should use server time when available.
