# Mnemonic

## Overview

A mnemonic is a short story or phrase that helps a user remember a radical or kanji. The app ships with a system mnemonic for every item (stored in the I18n tables — see radical.md, kanji.md), but users often find that their own associations stick better. A user mnemonic lets a user write a personal memory aid that replaces the system one in the UI. For example, the system mnemonic for 水 might be "Three streams flowing down a mountain", but a user might prefer "The symbol on my water bottle."

## Entities

### UserMnemonic (Entity)

A user-written mnemonic for a specific radical or kanji. At most one per user per item. When present, the UI displays this instead of the `system_mnemonic` from the I18n table.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `user_id` | `int` | FK to the user who created this mnemonic |
| `item_type` | `ItemType` | `radical` or `kanji` — which kind of item this mnemonic is for (see shared_types.md) |
| `item_id` | `int` | FK to the Radical or Kanji, depending on `item_type` |
| `text` | `String` | The user's mnemonic text |
| `created_at` | `DateTime` | When the mnemonic was first written |
| `updated_at` | `DateTime` | When the mnemonic was last edited |

**Why a polymorphic `item_type` + `item_id` instead of separate `radical_id` / `kanji_id` columns?**

A user mnemonic works identically for radicals and kanji — same UI, same logic, same table. Using `ItemType` to discriminate avoids duplicating the entity and keeps the query pattern consistent with the SRS system, which already uses `ItemType` to address items generically.

**Why not store user mnemonics in the I18n tables?**

System mnemonics are content-pipeline data — written by translators, shipped with the app, shared by all users. User mnemonics are user-generated data — personal, mutable, synced per account. Mixing them in the same table would complicate the content pipeline and make it hard to reset system content without losing user data.

## Relationships

```
User          ──1:N──→ UserMnemonic    (one user, many custom mnemonics)
UserMnemonic  ──N:1──→ Radical         (when item_type = radical; see radical.md)
UserMnemonic  ──N:1──→ Kanji           (when item_type = kanji; see kanji.md)
```

The system mnemonic lives in `RadicalI18n.system_mnemonic` (see radical.md) and `KanjiI18n.system_mnemonic` (see kanji.md). `UserMnemonic` overrides it in the UI but never modifies it.

## Business Rules

1. `user_id` + `item_type` + `item_id` must be unique — one user mnemonic per item per user.
2. `text` must be non-empty. To remove a custom mnemonic, delete the row (reverts to system mnemonic).
3. `item_type` must be `radical` or `kanji` (not `vocabulary` — vocabulary mnemonics are out of scope for now).
4. The referenced item (`item_id`) must exist for the given `item_type`.

## Edge Cases

- **User deletes their mnemonic:** The row is removed and the UI reverts to displaying the `system_mnemonic` from the I18n table. No tombstone needed.
- **System mnemonic updated after user override:** The user keeps seeing their own mnemonic. If they delete it, they see the updated system version. No conflict resolution needed.
- **Very long user text:** Enforce a reasonable max length (e.g. 1000 characters) at the UI and validation layer to prevent abuse without restricting creativity.
- **Item deleted:** Deleting a Radical or Kanji should cascade-delete associated `UserMnemonic` rows.
