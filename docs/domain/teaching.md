# Teaching Strategy

## Overview

This doc covers how the app teaches Japanese through SRS cards, question types, and visual strategies. The learning progression is radical → kanji → vocabulary — each stage unlocks the next when stability reaches >= 7.0 days (see srs.md).

## Phono-Semantic Patterns

About 80% of Jōyō kanji are phono-semantic compounds (形声文字, keisei moji). The app teaches users to recognize these patterns so they can predict readings for unfamiliar kanji.

### Position-based prediction

| Structure | Semantic (meaning) | Phonetic (sound) | Example |
|---|---|---|---|
| Left-Right (⿰) | Left | Right | 江 (River): 氵 Water + 工 KOU → reading KOU |
| Top-Bottom (⿱) | Top | Bottom | 花 (Flower): 艹 Grass + 化 KA → reading KA |
| Enclosure (⿴) | Outside | Inside | 聞 (Hear): 門 Gate + 耳 ear → reading MON/BUN |

The left-right pattern is by far the most common. When a kanji has a recognized radical on the left (hen position), it almost always provides the meaning category, while the right side (tsukuri) provides the sound.

### Phonetic families

Radicals that act as phonetic components create "sound families" — groups of kanji that share the same reading. e.g. 青 (SEI) → 清 (SEI), 晴 (SEI), 精 (SEI). Recognizing the phonetic component lets learners predict readings for unfamiliar kanji.

### Visual hints

- **Color coding:** Semantic components in one color, phonetic in another. The user learns to spot the "meaning left / sound right" pattern at a glance.
- **Sound match indicator:** When `logic_hint == phonetic`, check if the kanji's onyomi matches the radical's onyomi. On match, show a sound icon — the user realizes the reading comes from the component, not memorization.

## SRS Card Types

TODO: Define card types per item (radical, kanji, vocabulary), question formats, and answer evaluation.

## Question Formats

TODO: Define question/answer patterns for each card type.
