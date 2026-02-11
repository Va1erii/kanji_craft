import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../entities/draft_kanji.dart';
import '../entities/draft_kanji_i18n.dart';
import '../entities/draft_kanji_reading.dart';
import '../entities/warning.dart';
import '../repositories/kanji_repository.dart';
import '../repositories/raw_kanjidic_repository.dart';
import '../repositories/source_jlpt_level_repository.dart';

/// Result returned by [ComposeKanji] after Steps 1-3.
class CompositionResult {
  const CompositionResult({
    required this.kanjiCount,
    required this.readingCount,
    required this.i18nCount,
    this.warnings = const [],
  });

  final int kanjiCount;
  final int readingCount;
  final int i18nCount;
  final List<Warning> warnings;
}

/// Orchestrates kanji composition Steps 1-3:
///
/// 1. Creates draft kanji rows from raw KANJIDIC entries.
/// 2. Creates draft kanji reading rows (onyomi + kunyomi).
/// 3. Creates draft kanji i18n rows for each language.
class ComposeKanji {
  ComposeKanji({
    required RawKanjidicRepository rawKanjidicRepository,
    required KanjiRepository kanjiRepository,
    required SourceJlptLevelRepository sourceJlptLevelRepository,
  })  : _rawKanjidicRepository = rawKanjidicRepository,
        _kanjiRepository = kanjiRepository,
        _sourceJlptLevelRepository = sourceJlptLevelRepository;

  final RawKanjidicRepository _rawKanjidicRepository;
  final KanjiRepository _kanjiRepository;
  final SourceJlptLevelRepository _sourceJlptLevelRepository;

  Future<CompositionResult> call(int importId) async {
    final warnings = <Warning>[];

    // 1. Load raw entries + JLPT levels.
    final rawEntries = await _rawKanjidicRepository.getByImportId(importId);
    final jlptLevels = await _sourceJlptLevelRepository.getAll();
    final jlptMap = {for (final jl in jlptLevels) jl.character: jl.level};

    // 2. Delete previous drafts (idempotent).
    await _kanjiRepository.deleteAllDraftKanji();

    // 3. Step 1 — Build DraftKanji list.
    //    Sort unranked characters by code point for synthetic frequency.
    final unranked =
        rawEntries.where((e) => e.frequency == null).toList()
          ..sort((a, b) => a.literal.codeUnitAt(0) - b.literal.codeUnitAt(0));
    final syntheticBase = 10001;
    final syntheticMap = {
      for (var i = 0; i < unranked.length; i++)
        unranked[i].literal: syntheticBase + i,
    };

    final now = DateTime.now();
    final draftKanjiList = <DraftKanji>[];

    for (final raw in rawEntries) {
      final grade = _normalizeGrade(raw.grade);
      final jlpt = jlptMap[raw.literal];
      final frequency = raw.frequency ?? syntheticMap[raw.literal]!;

      draftKanjiList.add(DraftKanji(
        id: 0,
        character: raw.literal,
        strokeCount: raw.strokeCount,
        frequencyRank: frequency,
        minJlptLevel: jlpt,
        minGrade: grade,
        createdAt: now,
        updatedAt: now,
      ));
    }

    // 3b. Check for JLPT kanji missing from KANJIDIC import.
    final importedChars = {for (final raw in rawEntries) raw.literal};
    for (final entry in jlptLevels) {
      if (!importedChars.contains(entry.character)) {
        warnings.add(Warning(
          '${entry.character}: in JLPT N${entry.level} mapping but missing from KANJIDIC import',
          severity: WarningSeverity.high,
        ));
      }
    }

    // 4. Batch insert kanji → query back → build character→ID map.
    await _kanjiRepository.insertDraftKanjiBatch(draftKanjiList);
    final savedKanji = await _kanjiRepository.getAllDraftKanji();
    final charToId = {for (final k in savedKanji) k.character: k.id};

    // 5. Step 2 — Build DraftKanjiReading list.
    final readings = <DraftKanjiReading>[];

    for (final raw in rawEntries) {
      final kanjiId = charToId[raw.literal];
      if (kanjiId == null) {
        warnings.add(Warning(
          'No draft kanji ID for ${raw.literal}',
          severity: WarningSeverity.high,
        ));
        continue;
      }

      if (raw.readings.jaOn.isEmpty && raw.readings.jaKun.isEmpty) {
        final severity = jlptMap.containsKey(raw.literal)
            ? WarningSeverity.high
            : WarningSeverity.low;
        warnings.add(Warning(
          '${raw.literal}: no readings (empty ja_on and ja_kun)',
          severity: severity,
        ));
      }

      for (final on in raw.readings.jaOn) {
        readings.add(DraftKanjiReading(
          id: 0,
          draftKanjiId: kanjiId,
          reading: on,
          readingType: ReadingType.onyomi,
          priority: ReadingPriority.primary,
          createdAt: now,
          updatedAt: now,
        ));
      }

      for (final kun in raw.readings.jaKun) {
        readings.add(DraftKanjiReading(
          id: 0,
          draftKanjiId: kanjiId,
          reading: kun,
          readingType: ReadingType.kunyomi,
          priority: ReadingPriority.primary,
          createdAt: now,
          updatedAt: now,
        ));
      }
    }

    // 6. Batch insert readings.
    await _kanjiRepository.insertDraftKanjiReadingBatch(readings);

    // 7. Step 3 — Build DraftKanjiI18n list.
    final i18nList = <DraftKanjiI18n>[];

    for (final raw in rawEntries) {
      final kanjiId = charToId[raw.literal];
      if (kanjiId == null) continue;

      var hasEnglish = false;

      for (final entry in raw.meanings.entries) {
        final langCode = entry.key;
        final meanings = entry.value;
        if (meanings.isEmpty) continue;

        if (langCode == 'en') hasEnglish = true;

        i18nList.add(DraftKanjiI18n(
          id: 0,
          draftKanjiId: kanjiId,
          langCode: langCode,
          meanings: meanings,
          systemMnemonic: '',
          searchTags: const [],
          createdAt: now,
          updatedAt: now,
        ));
      }

      if (!hasEnglish) {
        final severity = jlptMap.containsKey(raw.literal)
            ? WarningSeverity.high
            : WarningSeverity.low;
        warnings.add(Warning(
          '${raw.literal}: missing English (en) meanings',
          severity: severity,
        ));
      }
    }

    // 8. Batch insert i18n.
    await _kanjiRepository.insertDraftKanjiI18nBatch(i18nList);

    // 9. Return counts + warnings.
    return CompositionResult(
      kanjiCount: draftKanjiList.length,
      readingCount: readings.length,
      i18nCount: i18nList.length,
      warnings: warnings,
    );
  }

  /// Returns a summary if draft kanji data already exists, null otherwise.
  Future<String?> checkExistingResult() async {
    final kanji = await _kanjiRepository.countDraftKanji();
    if (kanji == 0) return null;
    final readings = await _kanjiRepository.countDraftKanjiReadings();
    final i18n = await _kanjiRepository.countDraftKanjiI18n();
    return '$kanji kanji, $readings readings, $i18n i18n';
  }

  /// Normalizes KANJIDIC grade: 1-6,8 → keep; 9,10 → null; null → null.
  static int? _normalizeGrade(int? grade) {
    if (grade == null) return null;
    if (grade >= 1 && grade <= 6) return grade;
    if (grade == 8) return grade;
    // Grades 9,10 (jinmeiyō variants) → null.
    return null;
  }
}
