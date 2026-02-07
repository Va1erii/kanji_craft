---
name: doc-entity
description: Generates or updates entity group documentation following the project's entity doc standard. Use when the user runs /doc-entity.
---

# Entity Documentation Skill

Generate or update a Markdown doc for a domain entity group following the project standard.

## Arguments

- `/doc-entity <group>` — Generate or update docs for the named entity group (e.g. `/doc-entity radical`, `/doc-entity kanji`).

## Workflow

This is a **docs-first** skill. The doc is a design spec — it is written *before* code exists, not generated from it. The user describes the entity group they want to design and the skill produces the spec that will later guide implementation.

1. **Gather intent from the user.** Use the argument and conversation context to understand what entity group the user wants to design. Ask clarifying questions if the domain concept is unclear.
2. **Read existing docs** in `docs/entities/` for context on related groups and to stay consistent with established conventions, naming, and cross-references.
3. **Draft the doc** following the template and rules below. The doc defines the entities, fields, relationships, and business rules that code must later implement.
4. **Write the file** to `docs/entities/<group>.md`.
5. **Check cross-references.** If the entity group references other groups, verify those doc files exist and mention them. Do not create docs for other groups — just note if a referenced doc is missing.
6. **Update the glossary.** Read `docs/glossary.md` and add any new domain terms, abbreviations, or concepts introduced by this entity group. Remove terms that no longer apply. Do not duplicate definitions — keep entries concise and link to the entity doc for details.

## File Location

```
docs/
  entities/
    radical.md
    kanji.md
    vocabulary.md
    srs.md
    ...
```

Each file covers a **logical group** of related entities, not a single class. For example, `kanji.md` covers `Kanji`, `KanjiReading`, `KanjiRadical`, and `KanjiTranslation` together because they only make sense as a unit.

## Template

Every entity group doc must include the following sections in this order.

### 1. Title

The name of the entity group. Use the primary entity's name.

```markdown
# Kanji
```

### 2. Overview

Two to three sentences explaining what this entity group represents in the real world and why it exists in our app. Write for someone who might not know Japanese — avoid assuming domain knowledge.

**Good:** "A kanji is a logographic character borrowed from Chinese and used in the Japanese writing system. Each kanji has one or more readings (pronunciations) and meanings. Our app teaches kanji through spaced repetition, broken down by JLPT level or school grade."

**Bad:** "This is the kanji model."

### 3. Entities

List each entity and value object in the group. Order them by dependency — define a type before any entity that references it. The reader should never encounter a forward reference. For each one, include:

#### a. Name and Classification

State whether it is an **entity** (has identity), a **value object** (defined by its data), or an **enum** (fixed set of constants).

```markdown
### KanjiReading (Entity)
```

#### b. Purpose

One sentence on what it represents and why it's a separate class.

#### c. Field Table

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `character` | `String` | The kanji character, e.g. "人" |

Rules for the field table:
- List fields in logical order: identifiers first, then core data, then metadata (timestamps, sort orders).
- Use snake_case for field names (e.g. `master_symbol`, `min_jlpt_level`).
- Use Dart types.
- Descriptions should be concrete — include an example value where helpful.
- Mark nullable fields with `?` in the type column.
- Keep descriptions domain-focused. Do not mention storage details (primary keys, database engines, etc.).

#### d. Design Decisions

Explain non-obvious choices using a **"Why...?"** format. Only include these when there's something worth explaining — don't force them.

```markdown
**Why is `jlpt_level` nullable?**

Not all kanji are classified under JLPT. Rare or advanced kanji outside
the ~2,200 commonly tested ones have no JLPT assignment.
```

#### e. Enum Table (enums only)

For enums, use a value table instead of a field table. List each constant with its description. If the enum carries fields (e.g. a `description` property), add a separate field table below.

```markdown
| Value | Description |
|---|---|
| `hen` | Left side (e.g. 亻 in 休) |
| `tsukuri` | Right side (e.g. 力 in 助) |

| Field | Type | Description |
|---|---|---|
| `description` | `String` | Human-readable label, e.g. "Left Side" |
```

### 4. Relationships

A text-based relationship diagram showing how entities in this group connect to each other and to entities in other groups. Use this format:

```
EntityA ──1:N──→ EntityB       (description)
EntityA ──N:M──→ EntityC       (via JoinEntity, see other_doc.md)
```

Always link to the other entity group's doc when referencing external entities.

### 5. Business Rules

Numbered list of domain rules that govern this entity group's behavior. These are the rules that any developer working on this feature must understand. They inform repository contracts, use case logic, and UI behavior.

```markdown
1. A kanji cannot enter `lesson` status until all its radicals are at `guru1` or above.
2. Kanji are tested on both meaning and reading.
```

Rules should be:
- **Specific** — not "kanji has readings" but "a kanji must have at least one primary reading."
- **Testable** — each rule should map to a unit test.
- **Numbered** — for easy reference in code comments and PR reviews (e.g. "implements rule #3 from kanji.md").

### 6. Edge Cases

Bullet list of known edge cases, quirks, or exceptions. These are things that might trip up a developer or cause bugs if not handled explicitly.

```markdown
- **Kanji with no JLPT level:** Some valid jouyou kanji are not assigned a JLPT level.
  These are invisible to users on the JLPT path but appear for grade-path users.
- **Multiple primary readings:** Should not happen. If data contains this, treat the
  first one as primary.
```

Each edge case should name the scenario in bold followed by how the app should handle it.

## Section Applicability

Not every section will be equally relevant for every entity group. Use this as a guide:

| Section | Required? | Notes |
|---|---|---|
| Title | Always | — |
| Overview | Always | — |
| Entities | Always | Include every class in the group |
| → Field Table | Always | For every entity and value object |
| → Enum Table | For enums | Value table + optional field table for enum properties |
| → Design Decisions | When applicable | Skip if all fields are self-explanatory |
| Relationships | Always | Even if it's just "none" |
| Business Rules | Always | Even simple groups have at least one rule |
| Edge Cases | When applicable | Skip only if there are genuinely none |

## Writing Guidelines

- **Audience.** Write for a mid-level developer joining the project. They know Dart and Flutter but not the domain (Japanese language learning) or the architecture decisions.
- **Tone.** Direct and concrete. Explain *why*, not just *what*. Use examples with real data ("人", "じん", "N5") instead of abstract placeholders.
- **Length.** Aim for 80–150 lines. If significantly longer, consider splitting the group.
- **Cross-references.** Link to other group docs: `(see kanji.md)`, `(see srs.md)`. Don't duplicate — explain in one place and point from others.
