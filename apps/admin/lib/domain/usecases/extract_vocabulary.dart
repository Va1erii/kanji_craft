import 'dart:convert';
import 'dart:developer';

import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../entities/draft_kanji.dart';
import '../entities/jmdict_furigana.dart';
import '../entities/raw_jmdict.dart';
import '../entities/warning.dart';
import '../repositories/jmdict_furigana_repository.dart';
import '../repositories/kanji_repository.dart';
import '../repositories/raw_jmdict_repository.dart';
import '../repositories/source_vocab_level_repository.dart';
import '../repositories/vocabulary_repository.dart';

const _tag = 'ExtractVocabulary';

/// Result returned by [ExtractVocabulary].
class ExtractionResult {
  const ExtractionResult({
    required this.vocabularyCount,
    required this.readingCount,
    required this.i18nCount,
    required this.kanjiLinkCount,
    required this.sentenceCount,
    this.warnings = const [],
  });

  final int vocabularyCount;
  final int readingCount;
  final int i18nCount;
  final int kanjiLinkCount;
  final int sentenceCount;
  final List<Warning> warnings;
}

/// Orchestrates vocabulary extraction (Phase 2.5):
///
/// Transforms `raw_jmdict` entries into vocabulary rows with readings,
/// i18n, kanji links, sentences, and Ghost Kanji segments.
class ExtractVocabulary {
  ExtractVocabulary({
    required RawJmdictRepository rawJmdictRepository,
    required KanjiRepository kanjiRepository,
    required SourceVocabLevelRepository sourceVocabLevelRepository,
    required JmdictFuriganaRepository jmdictFuriganaRepository,
    required VocabularyRepository vocabularyRepository,
  })  : _rawJmdictRepository = rawJmdictRepository,
        _kanjiRepository = kanjiRepository,
        _sourceVocabLevelRepository = sourceVocabLevelRepository,
        _jmdictFuriganaRepository = jmdictFuriganaRepository,
        _vocabularyRepository = vocabularyRepository;

  final RawJmdictRepository _rawJmdictRepository;
  final KanjiRepository _kanjiRepository;
  final SourceVocabLevelRepository _sourceVocabLevelRepository;
  final JmdictFuriganaRepository _jmdictFuriganaRepository;
  final VocabularyRepository _vocabularyRepository;

  Future<ExtractionResult> call(
    int jmdictImportId,
    int furiganaImportId,
  ) async {
    final warnings = <Warning>[];

    // 1. Load source data.
    log('Loading raw_jmdict entries for import $jmdictImportId...', name: _tag);
    final rawEntries =
        await _rawJmdictRepository.getByImportId(jmdictImportId);
    log('Loaded ${rawEntries.length} raw_jmdict entries', name: _tag);

    log('Loading draft kanji...', name: _tag);
    final draftKanji = await _kanjiRepository.getAllDraftKanji();
    final kanjiIdMap = {for (final k in draftKanji) k.character: k.id};
    final draftKanjiMap = {for (final k in draftKanji) k.character: k};
    log('Loaded ${draftKanji.length} draft kanji', name: _tag);

    log('Loading source vocab levels...', name: _tag);
    final vocabLevels = await _sourceVocabLevelRepository.getAll();
    final vocabLevelMap = {
      for (final vl in vocabLevels) (vl.expression, vl.reading): vl.level,
    };
    log('Loaded ${vocabLevels.length} vocab levels', name: _tag);

    log('Loading jmdict_furigana for import $furiganaImportId...', name: _tag);
    final furiganaEntries =
        await _jmdictFuriganaRepository.getByImportId(furiganaImportId);
    final furiganaMap = {
      for (final f in furiganaEntries) (f.text, f.reading): f,
    };
    log('Loaded ${furiganaEntries.length} furigana entries', name: _tag);

    // 2. Delete previous vocabulary (idempotent).
    log('Deleting previous vocabulary data...', name: _tag);
    await _vocabularyRepository.deleteAllVocabulary();

    // 3. Process each entry.
    log('Processing entries...', name: _tag);
    final now = DateTime.now();
    final vocabularyList = <Vocabulary>[];
    final seenWords = <String>{};

    var rankCounter = 0;
    var skippedDuplicates = 0;

    for (final raw in rawEntries) {
      if (!_selectEntry(raw, vocabLevelMap)) continue;

      rankCounter++;

      // Determine headword.
      final word = raw.kanjiElements?.isNotEmpty == true
          ? raw.kanjiElements!.first.keb
          : raw.readingElements.first.reb;

      // Skip duplicate words (multiple JMdict entries can share a headword).
      if (seenWords.contains(word)) {
        skippedDuplicates++;
        continue;
      }
      seenWords.add(word);

      // Step 1: Build Vocabulary.
      final reading = raw.readingElements.first.reb;
      List<VocabularySegment> segments;
      try {
        segments = _buildSegments(
          word,
          reading,
          furiganaMap,
          kanjiIdMap,
          warnings,
        );
      } on Exception catch (e, st) {
        log('Error building segments for $word: $e',
            name: _tag, error: e, stackTrace: st);
        continue;
      }

      final jlptLevel = _resolveJlptLevel(
        raw,
        word,
        reading,
        vocabLevelMap,
        kanjiIdMap,
        draftKanjiMap,
      );
      final posTags = _extractPosTags(raw.senses);
      final frequencyRank =
          _computeFrequencyRank(raw, rankCounter, vocabLevelMap);

      final vocab = Vocabulary(
        id: 0,
        word: word,
        segments: segments,
        minJlptLevel: jlptLevel,
        posTags: posTags,
        frequencyRank: frequencyRank,
        createdAt: now,
        updatedAt: now,
      );
      vocabularyList.add(vocab);
    }

    if (skippedDuplicates > 0) {
      log('Skipped $skippedDuplicates duplicate headwords', name: _tag);
    }
    log('Built ${vocabularyList.length} vocabulary rows, inserting...',
        name: _tag);

    // 4. Batch insert vocabulary → query back → build word→ID map.
    try {
      await _vocabularyRepository.insertVocabularyBatch(vocabularyList);
    } on Exception catch (e, st) {
      log('Error inserting vocabulary batch: $e',
          name: _tag, error: e, stackTrace: st);
      rethrow;
    }

    final savedVocab = await _vocabularyRepository.getAllVocabulary();
    final wordToId = {for (final v in savedVocab) v.word: v.id};
    log('Inserted ${savedVocab.length} vocabulary rows', name: _tag);

    // 5. Build child rows using saved IDs.
    log('Building child rows (readings, i18n, kanji links, sentences)...',
        name: _tag);
    final readingList = <VocabularyReading>[];
    final i18nList = <VocabularyI18n>[];
    final kanjiLinkList = <VocabularyKanji>[];
    final sentenceList = <VocabularySentence>[];
    final sentenceI18nMap = <int, VocabularySentenceI18n>{};

    final seenWordsPass2 = <String>{};

    for (final raw in rawEntries) {
      if (!_selectEntry(raw, vocabLevelMap)) continue;

      final word = raw.kanjiElements?.isNotEmpty == true
          ? raw.kanjiElements!.first.keb
          : raw.readingElements.first.reb;

      // Same dedup as pass 1.
      if (seenWordsPass2.contains(word)) continue;
      seenWordsPass2.add(word);

      final vocabId = wordToId[word];
      if (vocabId == null) {
        log('WARNING: no saved vocab ID for word "$word"', name: _tag);
        continue;
      }

      // Step 2: Build readings.
      try {
        readingList.addAll(_buildReadings(raw, word, vocabId, now));
      } on Exception catch (e, st) {
        log('Error building readings for $word: $e',
            name: _tag, error: e, stackTrace: st);
      }

      // Step 3: Build i18n.
      try {
        i18nList.addAll(_buildI18n(raw, word, vocabId, now));
      } on Exception catch (e, st) {
        log('Error building i18n for $word: $e',
            name: _tag, error: e, stackTrace: st);
      }

      // Step 4: Build kanji links.
      try {
        final links = _buildKanjiLinks(
            word, vocabId, kanjiIdMap, warnings, vocabLevelMap, raw);
        kanjiLinkList.addAll(links);
      } on Exception catch (e, st) {
        log('Error building kanji links for $word: $e',
            name: _tag, error: e, stackTrace: st);
      }

      // Step 5: Build sentences.
      try {
        final sentencePair = _buildSentence(raw, vocabId, now);
        if (sentencePair != null) {
          sentenceList.add(sentencePair.sentence);
          sentenceI18nMap[vocabId] = sentencePair.i18n;
        }
      } on Exception catch (e, st) {
        log('Error building sentence for $word: $e',
            name: _tag, error: e, stackTrace: st);
      }
    }

    // 6. Batch insert child rows.
    log('Inserting ${readingList.length} readings...', name: _tag);
    try {
      await _vocabularyRepository.insertReadingBatch(readingList);
    } on Exception catch (e, st) {
      log('Error inserting readings batch: $e',
          name: _tag, error: e, stackTrace: st);
      rethrow;
    }

    log('Inserting ${i18nList.length} i18n rows...', name: _tag);
    try {
      await _vocabularyRepository.insertI18nBatch(i18nList);
    } on Exception catch (e, st) {
      log('Error inserting i18n batch: $e',
          name: _tag, error: e, stackTrace: st);
      rethrow;
    }

    log('Inserting ${kanjiLinkList.length} kanji links...', name: _tag);
    try {
      await _vocabularyRepository.insertKanjiBatch(kanjiLinkList);
    } on Exception catch (e, st) {
      log('Error inserting kanji links batch: $e',
          name: _tag, error: e, stackTrace: st);
      rethrow;
    }

    // Sentences need auto-generated IDs for sentence_i18n FK.
    log('Inserting ${sentenceList.length} sentences...', name: _tag);
    if (sentenceList.isNotEmpty) {
      try {
        final savedSentences =
            await _vocabularyRepository.insertSentenceBatch(sentenceList);
        final sentenceI18nList = <VocabularySentenceI18n>[];
        for (final saved in savedSentences) {
          final i18n = sentenceI18nMap[saved.vocabularyId];
          if (i18n != null) {
            sentenceI18nList.add(VocabularySentenceI18n(
              id: 0,
              vocabularySentenceId: saved.id,
              langCode: i18n.langCode,
              sentenceTranslated: i18n.sentenceTranslated,
              createdAt: now,
              updatedAt: now,
            ));
          }
        }
        if (sentenceI18nList.isNotEmpty) {
          log('Inserting ${sentenceI18nList.length} sentence i18n rows...',
              name: _tag);
          await _vocabularyRepository
              .insertSentenceI18nBatch(sentenceI18nList);
        }
      } on Exception catch (e, st) {
        log('Error inserting sentences: $e',
            name: _tag, error: e, stackTrace: st);
        rethrow;
      }
    }

    // 7. Return counts + warnings.
    log(
      'Extraction complete: ${vocabularyList.length} vocabulary, '
      '${readingList.length} readings, ${i18nList.length} i18n, '
      '${kanjiLinkList.length} kanji links, ${sentenceList.length} sentences, '
      '${warnings.length} warnings',
      name: _tag,
    );
    return ExtractionResult(
      vocabularyCount: vocabularyList.length,
      readingCount: readingList.length,
      i18nCount: i18nList.length,
      kanjiLinkCount: kanjiLinkList.length,
      sentenceCount: sentenceList.length,
      warnings: warnings,
    );
  }

  /// Returns a summary if vocabulary data already exists, null otherwise.
  Future<String?> checkExistingResult() async {
    final vocab = await _vocabularyRepository.countVocabulary();
    if (vocab == 0) return null;
    final readings = await _vocabularyRepository.countReadings();
    final i18n = await _vocabularyRepository.countI18n();
    final kanjiLinks = await _vocabularyRepository.countKanji();
    final sentences = await _vocabularyRepository.countSentences();
    return '$vocab vocabulary, $readings readings, $i18n i18n, '
        '$kanjiLinks kanji links, $sentences sentences';
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Selection: include word if it has priority flags or is in vocab levels.
  bool _selectEntry(
    RawJmdict raw,
    Map<(String, String), int> vocabLevelMap,
  ) {
    // Check priority flags on kanji elements.
    if (raw.kanjiElements != null) {
      for (final ke in raw.kanjiElements!) {
        if (ke.kePri != null && ke.kePri!.isNotEmpty) return true;
      }
    }
    // Check priority flags on reading elements.
    for (final re in raw.readingElements) {
      if (re.rePri != null && re.rePri!.isNotEmpty) return true;
    }
    // Check source_vocab_levels.
    final word = raw.kanjiElements?.isNotEmpty == true
        ? raw.kanjiElements!.first.keb
        : raw.readingElements.first.reb;
    for (final re in raw.readingElements) {
      if (vocabLevelMap.containsKey((word, re.reb))) return true;
    }
    return false;
  }

  /// Builds segments from jmdict_furigana or falls back to heuristic.
  List<VocabularySegment> _buildSegments(
    String word,
    String reading,
    Map<(String, String), JmdictFurigana> furiganaMap,
    Map<String, int> kanjiIdMap,
    List<Warning> warnings,
  ) {
    final furigana = furiganaMap[(word, reading)];
    if (furigana != null) {
      return _segmentsFromFurigana(furigana, kanjiIdMap, warnings);
    }

    // Fallback: heuristic segmentation.
    // Only warn for words containing kanji — kana-only words are expected
    // to be absent from jmdict_furigana since they don't need furigana.
    if (_containsKanji(word)) {
      warnings.add(Warning(
        '$word: not found in jmdict_furigana, using heuristic segmentation',
      ));
    }
    return _segmentsHeuristic(word, kanjiIdMap);
  }

  /// Parses jmdict_furigana JSON into segments.
  List<VocabularySegment> _segmentsFromFurigana(
    JmdictFurigana furigana,
    Map<String, int> kanjiIdMap,
    List<Warning> warnings,
  ) {
    final segments = <VocabularySegment>[];
    final List<dynamic> parsed;
    try {
      parsed = jsonDecode(furigana.furigana) as List;
    } on FormatException catch (e) {
      log('Invalid furigana JSON for "${furigana.text}": $e', name: _tag);
      warnings.add(Warning(
        '${furigana.text}: invalid furigana JSON — $e',
        severity: WarningSeverity.high,
      ));
      return _segmentsHeuristic(furigana.text, kanjiIdMap);
    }

    for (final item in parsed) {
      final map = item as Map<String, dynamic>;
      final ruby = map['ruby'] as String;
      final rt = map['rt'] as String?;

      if (rt == null) {
        // Kana segment.
        segments.add(VocabularySegment(text: ruby));
      } else if (ruby.length > 1 && _containsKanji(ruby)) {
        // Jukujikun: multiple kanji with a single reading.
        final kanjiIds = <int>[];
        for (final char in ruby.runes.map((r) => String.fromCharCode(r))) {
          final id = kanjiIdMap[char];
          if (id != null) {
            kanjiIds.add(id);
          }
        }
        segments.add(VocabularySegment(
          text: ruby,
          reading: rt,
          kanjiIds: kanjiIds.isNotEmpty ? kanjiIds : null,
        ));
      } else {
        // Single kanji segment.
        final kanjiId = kanjiIdMap[ruby];
        segments.add(VocabularySegment(
          text: ruby,
          reading: rt,
          kanjiId: kanjiId,
        ));
      }
    }

    return segments;
  }

  /// Heuristic segmentation: scan characters against kanji map.
  List<VocabularySegment> _segmentsHeuristic(
    String word,
    Map<String, int> kanjiIdMap,
  ) {
    final segments = <VocabularySegment>[];
    final buffer = StringBuffer();

    for (final char in word.runes.map((r) => String.fromCharCode(r))) {
      final kanjiId = kanjiIdMap[char];
      if (kanjiId != null) {
        // Flush kana buffer.
        if (buffer.isNotEmpty) {
          segments.add(VocabularySegment(text: buffer.toString()));
          buffer.clear();
        }
        // Kanji segment without reading (heuristic can't split readings).
        segments
            .add(VocabularySegment(text: char, reading: '', kanjiId: kanjiId));
      } else {
        buffer.write(char);
      }
    }
    // Flush remaining kana.
    if (buffer.isNotEmpty) {
      segments.add(VocabularySegment(text: buffer.toString()));
    }

    return segments;
  }

  /// Resolves JLPT level: source_vocab_levels first, then kanji-derived.
  int? _resolveJlptLevel(
    RawJmdict raw,
    String word,
    String reading,
    Map<(String, String), int> vocabLevelMap,
    Map<String, int> kanjiIdMap,
    Map<String, DraftKanji> draftKanjiMap,
  ) {
    // Primary: lookup in source_vocab_levels.
    for (final re in raw.readingElements) {
      final level = vocabLevelMap[(word, re.reb)];
      if (level != null) return level;
    }

    // Fallback: MIN(kanji.min_jlpt_level) — numerically smallest = hardest.
    int? minLevel;
    for (final char in word.runes.map((r) => String.fromCharCode(r))) {
      final kanji = draftKanjiMap[char];
      if (kanji != null && kanji.minJlptLevel != null) {
        if (minLevel == null || kanji.minJlptLevel! < minLevel) {
          minLevel = kanji.minJlptLevel!;
        }
      }
    }
    return minLevel;
  }

  /// Extracts POS tags from all senses with inheritance.
  List<PosTag> _extractPosTags(List<JmdictSense> senses) {
    final tags = <PosTag>{};
    List<String>? currentPos;

    for (final sense in senses) {
      if (sense.pos != null && sense.pos!.isNotEmpty) {
        currentPos = sense.pos;
      }

      // Map POS codes.
      if (currentPos != null) {
        for (final code in currentPos) {
          final tag = _mapPosCode(code);
          if (tag != null) tags.add(tag);
        }
      }

      // Map misc codes.
      if (sense.misc != null) {
        for (final code in sense.misc!) {
          final tag = _mapMiscCode(code);
          if (tag != null) tags.add(tag);
        }
      }
    }

    return tags.toList();
  }

  /// Maps a JMdict POS code to a PosTag.
  static PosTag? _mapPosCode(String code) => switch (code) {
        'v1' => PosTag.ichidanVerb,
        'v5u' ||
        'v5k' ||
        'v5r' ||
        'v5s' ||
        'v5t' ||
        'v5b' ||
        'v5g' ||
        'v5m' ||
        'v5n' ||
        'v5k-s' ||
        'v5r-i' ||
        'v5u-s' ||
        'v5aru' =>
          PosTag.godanVerb,
        'vs' || 'vs-i' || 'vs-s' => PosTag.suruVerb,
        'vk' => PosTag.kuruVerb,
        'vt' => PosTag.transitive,
        'vi' => PosTag.intransitive,
        'adj-i' => PosTag.iAdjective,
        'adj-na' => PosTag.naAdjective,
        'n' => PosTag.noun,
        'adv' => PosTag.adverb,
        _ => null,
      };

  /// Maps a JMdict misc code to a PosTag.
  static PosTag? _mapMiscCode(String code) => switch (code) {
        'uk' => PosTag.usuallyKana,
        'pol' => PosTag.polite,
        'hum' => PosTag.humble,
        'hon' => PosTag.honorific,
        _ => null,
      };

  /// Computes frequency rank from priority flags.
  int _computeFrequencyRank(
    RawJmdict raw,
    int index,
    Map<(String, String), int> vocabLevelMap,
  ) {
    // Collect all priority flags.
    final allPri = <String>{};
    if (raw.kanjiElements != null) {
      for (final ke in raw.kanjiElements!) {
        if (ke.kePri != null) allPri.addAll(ke.kePri!);
      }
    }
    for (final re in raw.readingElements) {
      if (re.rePri != null) allPri.addAll(re.rePri!);
    }

    if (allPri.isEmpty) {
      // JLPT-only words get synthetic rank.
      return 100000 + index;
    }

    // Tier 1: news1/ichi1.
    if (allPri.contains('news1') || allPri.contains('ichi1')) return index;

    // Tier 2: news2/ichi2/spec1/spec2.
    if (allPri.contains('news2') ||
        allPri.contains('ichi2') ||
        allPri.contains('spec1') ||
        allPri.contains('spec2')) {
      return 20000 + index;
    }

    // Tier 3: gai1/gai2/nfxx.
    return 40000 + index;
  }

  /// Builds reading rows for a vocabulary word.
  List<VocabularyReading> _buildReadings(
    RawJmdict raw,
    String headword,
    int vocabId,
    DateTime now,
  ) {
    final readings = <VocabularyReading>[];
    final headwordPri = <String>{};
    if (raw.kanjiElements != null && raw.kanjiElements!.isNotEmpty) {
      final first = raw.kanjiElements!.first;
      if (first.kePri != null) headwordPri.addAll(first.kePri!);
    }

    for (final re in raw.readingElements) {
      // Skip restricted readings that don't apply to selected headword.
      if (re.reRestr != null &&
          re.reRestr!.isNotEmpty &&
          !re.reRestr!.contains(headword)) {
        continue;
      }

      // Determine priority.
      final rePri = re.rePri ?? const [];
      final isOverlap = rePri.any((p) => headwordPri.contains(p));
      final priority = isOverlap || headwordPri.isEmpty
          ? ReadingPriority.primary
          : ReadingPriority.secondary;

      readings.add(VocabularyReading(
        id: 0,
        vocabularyId: vocabId,
        reading: re.reb,
        priority: priority,
        createdAt: now,
        updatedAt: now,
      ));
    }

    // Ensure at least one primary reading.
    if (readings.isNotEmpty &&
        !readings.any((r) => r.priority == ReadingPriority.primary)) {
      readings[0] = VocabularyReading(
        id: readings[0].id,
        vocabularyId: readings[0].vocabularyId,
        reading: readings[0].reading,
        priority: ReadingPriority.primary,
        createdAt: readings[0].createdAt,
        updatedAt: readings[0].updatedAt,
      );
    }

    return readings;
  }

  /// Builds i18n rows for a vocabulary word.
  List<VocabularyI18n> _buildI18n(
    RawJmdict raw,
    String headword,
    int vocabId,
    DateTime now,
  ) {
    final result = <VocabularyI18n>[];

    // Collect glosses by language.
    final glossesByLang = <String, List<String>>{};

    for (final sense in raw.senses) {
      // Respect stagk/stagr restrictions.
      if (sense.stagk != null &&
          sense.stagk!.isNotEmpty &&
          !sense.stagk!.contains(headword)) {
        continue;
      }

      for (final entry in sense.glosses.entries) {
        final langCode = entry.key;
        final glosses = entry.value;
        if (glosses.isEmpty) continue;
        glossesByLang.putIfAbsent(langCode, () => []).addAll(glosses);
      }
    }

    for (final entry in glossesByLang.entries) {
      if (entry.value.isEmpty) continue;
      result.add(VocabularyI18n(
        id: 0,
        vocabularyId: vocabId,
        langCode: entry.key,
        meanings: entry.value,
        searchTags: const [],
        createdAt: now,
        updatedAt: now,
      ));
    }

    return result;
  }

  /// Builds kanji link rows for a vocabulary word.
  List<VocabularyKanji> _buildKanjiLinks(
    String word,
    int vocabId,
    Map<String, int> kanjiIdMap,
    List<Warning> warnings,
    Map<(String, String), int> vocabLevelMap,
    RawJmdict raw,
  ) {
    final links = <VocabularyKanji>[];
    final now = DateTime.now();
    var position = 0;

    for (final char in word.runes.map((r) => String.fromCharCode(r))) {
      if (_isKanjiChar(char)) {
        final kanjiId = kanjiIdMap[char];
        if (kanjiId != null) {
          links.add(VocabularyKanji(
            id: 0,
            vocabularyId: vocabId,
            kanjiId: kanjiId,
            position: position,
            createdAt: now,
            updatedAt: now,
          ));
        } else {
          // Orphan kanji — determine severity.
          final hasJlpt = _wordHasJlptLevel(raw, word, vocabLevelMap);
          warnings.add(Warning(
            '$word: kanji $char not found in draft kanji table',
            severity: hasJlpt ? WarningSeverity.high : WarningSeverity.low,
          ));
        }
      }
      position++;
    }

    return links;
  }

  /// Builds a sentence and its i18n from examples.
  _SentencePair? _buildSentence(
    RawJmdict raw,
    int vocabId,
    DateTime now,
  ) {
    if (raw.examples == null || raw.examples!.isEmpty) return null;

    // Pick shortest example.
    final examples = raw.examples!.toList()
      ..sort((a, b) => a.sentenceJa.length.compareTo(b.sentenceJa.length));
    final example = examples.first;

    return _SentencePair(
      sentence: VocabularySentence(
        id: 0,
        vocabularyId: vocabId,
        originalText: example.sentenceJa,
        verificationStatus: VerificationStatus.verified,
        createdAt: now,
        updatedAt: now,
      ),
      i18n: VocabularySentenceI18n(
        id: 0,
        vocabularySentenceId: 0, // Resolved after insert.
        langCode: 'en',
        sentenceTranslated: example.sentenceEn,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  /// Checks if a word has JLPT level via vocab levels.
  bool _wordHasJlptLevel(
    RawJmdict raw,
    String word,
    Map<(String, String), int> vocabLevelMap,
  ) {
    for (final re in raw.readingElements) {
      if (vocabLevelMap.containsKey((word, re.reb))) return true;
    }
    return false;
  }

  /// Returns true if the character is a CJK Unified Ideograph (kanji).
  static bool _isKanjiChar(String char) {
    final code = char.codeUnitAt(0);
    return (code >= 0x4E00 && code <= 0x9FFF) || // CJK Unified
        (code >= 0x3400 && code <= 0x4DBF); // CJK Extension A
  }

  /// Returns true if the string contains any kanji characters.
  static bool _containsKanji(String s) {
    for (final char in s.runes.map((r) => String.fromCharCode(r))) {
      if (_isKanjiChar(char)) return true;
    }
    return false;
  }
}

class _SentencePair {
  const _SentencePair({required this.sentence, required this.i18n});
  final VocabularySentence sentence;
  final VocabularySentenceI18n i18n;
}
