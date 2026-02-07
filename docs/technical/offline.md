# Offline-First Architecture

## Overview

The app is designed to work fully offline. Drift (SQLite) is the local source of truth — all reads and writes happen against the local database first. Supabase (PostgreSQL) is the remote sync target. When connectivity is available, the app syncs changes bidirectionally. This means a user can do lessons, reviews, and edit mnemonics on a plane, and everything syncs when they're back online.

## Local Database

### Drift (SQLite)

Every Supabase table has a corresponding Drift table with the same schema. The app never reads from Supabase directly during normal use — all queries hit Drift. This eliminates loading spinners, network latency, and connectivity checks from the core learning flow.

### Local-Only Fields

Drift tables include additional fields not present in Supabase for sync management:

| Field | Type | Description |
|---|---|---|
| `sync_status` | `SyncStatus` | `synced`, `pending_push`, `pending_delete` |
| `remote_updated_at` | `DateTime?` | The `updated_at` from the last successful sync with Supabase |
| `local_updated_at` | `DateTime` | When the row was last modified locally |

These fields are local-only — they exist in Drift but not in Supabase tables.

### SyncStatus (Enum)

| Value | Description |
|---|---|
| `synced` | Local and remote are in agreement. No action needed |
| `pending_push` | Modified locally, not yet pushed to Supabase |
| `pending_delete` | Marked for deletion locally, not yet deleted on Supabase |

## Data Categories

Tables have different sync patterns based on who writes to them.

### Content Tables (Remote → Local)

Radicals, kanji, vocabulary, readings, I18n, components, sentences.

- **Written by:** content pipeline (admin-only on Supabase)
- **Direction:** remote → local only. Users never modify content.
- **Trigger:** first launch, manual refresh, or content version bump
- **Strategy:** full replace or incremental pull based on a content version number

### User Tables (Bidirectional)

Users, user_settings, srs_cards, review_logs, user_mnemonics.

- **Written by:** the user, via the app
- **Direction:** local ↔ remote
- **Trigger:** on connectivity change (offline → online), after review sessions, periodic background sync
- **Strategy:** per-row sync with conflict resolution

## Sync Flow

### Push (Local → Remote)

Runs when the app detects connectivity after offline changes.

```
1. Query Drift for all rows where sync_status = 'pending_push'
2. For each row:
   a. UPSERT to Supabase (INSERT ... ON CONFLICT UPDATE)
   b. On success: set sync_status = 'synced', update remote_updated_at
   c. On failure (409 conflict): trigger conflict resolution
   d. On failure (network): leave as 'pending_push', retry later
3. Query Drift for all rows where sync_status = 'pending_delete'
4. For each row:
   a. DELETE from Supabase
   b. On success: DELETE from Drift
   c. On failure: leave as 'pending_delete', retry later
```

### Pull (Remote → Local)

Runs on app launch, new device login, and periodically when online.

```
1. Query Supabase for rows where updated_at > last_sync_timestamp
2. For each remote row:
   a. If no local row exists: INSERT into Drift with sync_status = 'synced'
   b. If local row exists and sync_status = 'synced': UPDATE Drift from remote
   c. If local row exists and sync_status = 'pending_push': trigger conflict resolution
3. Update last_sync_timestamp
```

### Content Sync

Content tables use a simpler model — no per-row tracking.

```
1. Check remote content_version against local content_version
2. If remote is newer:
   a. Pull all changed content tables (delta or full, based on version gap)
   b. Replace local content rows
   c. Update local content_version
3. If equal: no-op
```

## Conflict Resolution

### When Conflicts Happen

A conflict occurs when the same row was modified both locally (while offline) and remotely (from another device or admin action). This is detected during pull when a row has `sync_status = 'pending_push'` locally but also has a newer `updated_at` on Supabase.

### Resolution Strategy

| Table | Strategy | Rationale |
|---|---|---|
| Content tables | Remote wins | Admin-managed. Users don't modify. No conflict possible |
| `srs_cards` | Last-write-wins | The most recent review is the most accurate state. Compare `local_updated_at` vs remote `updated_at` |
| `review_logs` | Merge (append both) | Review logs are append-only. Both local and remote logs are valid. Deduplicate by `reviewed_at` + `card_id` |
| `user_mnemonics` | Last-write-wins | User edits are intentional. Most recent version is what they want |
| `user_settings` | Last-write-wins | Settings are a single row per user. Latest change wins |

### Last-Write-Wins Implementation

```
if local_updated_at > remote_updated_at:
    push local to remote (local wins)
else:
    overwrite local from remote (remote wins)
    set sync_status = 'synced'
```

### ReviewLog Merge

ReviewLogs are append-only (see srs.md rule #11), so conflicts don't overwrite — they merge:

```
1. Pull remote review_logs where reviewed_at > last_sync_timestamp
2. Insert into Drift, skipping any that already exist (dedupe on card_id + reviewed_at)
3. Push local review_logs where sync_status = 'pending_push'
4. Mark all as 'synced'
```

## Offline Capabilities

| Feature | Offline? | Notes |
|---|---|---|
| Lessons | Yes | Content is cached locally in Drift |
| Reviews | Yes | SrsCards updated locally, synced later |
| SRS scheduling | Yes | FSRS runs locally, no server needed |
| Mnemonic editing | Yes | Saved locally, synced later |
| Sign in | No | Requires network for OAuth/email verification |
| Content updates | No | Requires network to pull new content |
| SVG download | No | But cached after first download; bundled assets always available |
| Settings changes | Yes | Saved locally, synced later |

## Edge Cases

- **First launch with no internet:** The app ships with bundled content (SQLite DB or asset files) for at least N5 radicals, kanji, and vocabulary. The user can begin studying immediately without any network call. Full content syncs on first connectivity.
- **Sync interrupted mid-push:** Each row is pushed individually. Rows that succeeded are marked `synced`. Rows that didn't stay as `pending_push` and retry on next sync. No partial state.
- **Clock skew between devices:** `updated_at` timestamps should use server time (Supabase `now()`) when pushing, not device time. For local changes made offline, `local_updated_at` uses device time but is only compared against other local timestamps until push.
- **Large initial sync:** First login on a new device with existing progress may pull thousands of SrsCard/ReviewLog rows. Use paginated pulls and show a progress indicator.
- **Deleted account re-login:** If a user deletes their account and signs up again, the Supabase UID changes. Old local data won't match. The app should wipe the local Drift DB on sign-out to prevent stale data.
- **ReviewLog growth:** ReviewLogs are append-only and grow indefinitely. For sync efficiency, only pull/push logs newer than the last sync timestamp, never the full history.
