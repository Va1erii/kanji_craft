# User

## Overview

A user is a person learning Japanese through the app. Each user has their own SRS progress, custom mnemonics, and preferences. Authentication is handled via OAuth providers (Google, Apple, Facebook) or email/password — the app stores a local profile linked to the external auth identity. User preferences like study path and daily goals live in a separate `UserSettings` entity to keep the core user record minimal.

## Entities

### StudyPath (Enum)

The curriculum path the user follows. Determines which content appears in the lesson queue.

| Value | Description |
|---|---|
| `jlpt` | Study by JLPT level (N5 → N1). Content filtered by `min_jlpt_level` |
| `grade` | Study by Japanese school grade (1 → 6). Content filtered by `min_grade` |

### AuthProvider (Enum)

The external authentication method used to create the account.

| Value | Description |
|---|---|
| `email` | Email and password authentication |
| `google` | Google OAuth |
| `apple` | Apple Sign In |
| `facebook` | Facebook OAuth |

### User (Entity)

The core identity of a learner. Holds authentication linkage, display info, and language preference. All per-user data (SrsCard, UserMnemonic, ReviewLog) references this entity via `user_id`.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `auth_provider` | `AuthProvider` | How the user signed up (`email`, `google`, `apple`, `facebook`) |
| `auth_provider_id` | `String` | The unique ID from the auth provider (e.g. Firebase UID, Google sub). Unique across all users |
| `email` | `String?` | User's email address. Nullable for providers that don't guarantee an email (e.g. Apple with hidden email) |
| `display_name` | `String?` | User-chosen display name. Nullable — not all providers supply one |
| `lang_code` | `String` | Preferred language for I18n content (ISO 639-1). Defaults to "en". Used to select RadicalI18n, KanjiI18n, VocabularyI18n rows |
| `created_at` | `DateTime` | When the account was created (UTC) |
| `updated_at` | `DateTime` | When the profile was last modified (UTC) |

**Why `auth_provider` + `auth_provider_id` instead of just an email?**

A user might sign in with Google (no password) or Apple (hidden email). The provider ID is the stable identifier from the OAuth system. Storing both the provider type and its ID allows the app to handle multiple auth flows and detect if the same person tries to link a second provider later.

**Why `lang_code` on User instead of deriving from device locale?**

A user may set their device to Japanese but want to study with English translations, or switch between languages across devices. Storing the preference explicitly means the app respects the user's choice regardless of device settings.

### UserSettings (Entity)

Per-user preferences that control the learning experience. Separated from User to keep the core profile stable and allow settings to evolve independently.

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `user_id` | `int` | FK to the parent User. Unique — one settings row per user |
| `study_path` | `StudyPath` | `jlpt` or `grade` — which curriculum path to follow |
| `current_level` | `int` | The level the user is currently studying. For JLPT: 5–1 (starts at 5). For grade: 1–6 (starts at 1) |
| `daily_lesson_limit` | `int` | Max new items per day. Default: 10 |
| `daily_review_limit` | `int` | Max reviews per session. Default: 100 |

**Why separate UserSettings from User?**

User holds identity data (auth, email, language) that rarely changes. Settings hold learning preferences (study path, limits) that the user tweaks regularly. Separating them avoids version conflicts when syncing and makes the settings screen a clean, isolated update.

**Why `current_level` instead of computing it from SRS progress?**

The user explicitly picks their starting level (e.g. "I already know N5, start me at N4"). Computing from progress would require bootstrapping data for known items. A simple integer lets the user jump to any level and the app filters the lesson queue accordingly.

## Relationships

```
User          ──1:1──→ UserSettings     (one user, one settings row)
User          ──1:N──→ SrsCard          (one user, many SRS cards; see srs.md)
User          ──1:N──→ UserMnemonic     (one user, many custom mnemonics; see mnemonic.md)
User          ──1:N──→ ReviewLog        (one user, many review events via SrsCard; see srs.md)
```

## Business Rules

1. `auth_provider` + `auth_provider_id` must be unique — no duplicate accounts for the same provider identity.
2. Every user must have exactly one `UserSettings` row, created on account creation with defaults.
3. `lang_code` must be a valid ISO 639-1 code. Default: "en".
4. `current_level` must be in the range 1–5 when `study_path` is `jlpt`, or 1–6 when `study_path` is `grade`.
5. `daily_lesson_limit` must be a positive integer (minimum 1).
6. `daily_review_limit` must be a positive integer (minimum 1).
7. Deleting a User must cascade-delete UserSettings, all SrsCard/ReviewLog rows, and all UserMnemonic rows.

## Edge Cases

- **Apple hidden email:** Apple allows users to hide their email. `email` will be null or a relay address. Never use email as a unique identifier — use `auth_provider_id`.
- **Provider migration:** A user signs up with email, later wants to link Google. This requires an account-linking flow (out of scope for entity spec, but `auth_provider` + `auth_provider_id` can be extended to a separate table if multi-provider linking is needed post-MVP).
- **Level mismatch after path switch:** User switches from JLPT (current_level = 3, meaning N3) to grade (current_level should be 1–6, not 3 meaning "grade 3"). The app must prompt the user to pick a new level when changing study path, or map intelligently.
- **Language not available:** If the user's `lang_code` has no I18n rows for some content, fall back to "en" (see radical.md, kanji.md, vocabulary.md edge cases).
- **Daily limits reached:** When `daily_lesson_limit` or `daily_review_limit` is hit, the app stops presenting new items/reviews for the day. The user can adjust limits in settings but not bypass them within a session.
