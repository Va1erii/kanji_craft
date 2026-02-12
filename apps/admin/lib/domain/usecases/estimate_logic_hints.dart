import 'dart:developer';

import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../entities/raw_kanjidic.dart';
import '../entities/warning.dart';
import '../repositories/kanji_component_repository.dart';
import '../repositories/kanji_component_review_repository.dart';
import '../repositories/raw_kanjidic_repository.dart';

const _tag = 'EstimateLogicHints';

/// Result returned by [EstimateLogicHints].
class LogicHintResult {
  const LogicHintResult({
    required this.componentCount,
    required this.phoneticCount,
    required this.semanticCount,
    required this.skippedCount,
    this.warnings = const [],
  });

  final int componentCount;
  final int phoneticCount;
  final int semanticCount;
  final int skippedCount;
  final List<Warning> warnings;
}

/// Estimates `logic_hint` (semantic vs phonetic) for every `kanji_component`
/// row using onyomi comparison (Phase 2.6 Sub-phase A).
///
/// For each component, compares the parent kanji's onyomi readings with the
/// radical's onyomi readings (looked up as a character in `raw_kanjidic`).
/// Creates a `kanji_component_reviews` row with `draft` status for each.
class EstimateLogicHints {
  EstimateLogicHints({
    required KanjiComponentRepository kanjiComponentRepository,
    required RawKanjidicRepository rawKanjidicRepository,
    required KanjiComponentReviewRepository reviewRepository,
  })  : _kanjiComponentRepository = kanjiComponentRepository,
        _rawKanjidicRepository = rawKanjidicRepository,
        _reviewRepository = reviewRepository;

  final KanjiComponentRepository _kanjiComponentRepository;
  final RawKanjidicRepository _rawKanjidicRepository;
  final KanjiComponentReviewRepository _reviewRepository;

  Future<LogicHintResult> call(int kanjidicImportId) async {
    final warnings = <Warning>[];

    // 1. Load all components.
    log('Loading kanji components...', name: _tag);
    final components = await _kanjiComponentRepository.getAll();
    log('Loaded ${components.length} components', name: _tag);

    // 2. Build radicalId→masterSymbol map from content tables.
    log('Loading radical symbol map...', name: _tag);
    final radicalSymbolMap =
        await _kanjiComponentRepository.getRadicalSymbolMap();
    log('Loaded ${radicalSymbolMap.length} radicals', name: _tag);

    // 3. Build kanjiId→character map from content tables.
    log('Loading kanji character map...', name: _tag);
    final kanjiCharMap = await _kanjiComponentRepository.getKanjiCharMap();
    log('Loaded ${kanjiCharMap.length} kanji', name: _tag);

    // 4. Pre-fetch all raw_kanjidic entries into a map by literal.
    log('Loading raw_kanjidic entries for import $kanjidicImportId...',
        name: _tag);
    final rawEntries =
        await _rawKanjidicRepository.getByImportId(kanjidicImportId);
    final kanjidicMap = {for (final e in rawEntries) e.literal: e.readings};
    log('Loaded ${rawEntries.length} raw_kanjidic entries', name: _tag);

    // Build a JLPT lookup for high-severity warnings.
    final jlptMap = {
      for (final e in rawEntries)
        if (e.jlpt != null) e.literal: e.jlpt!,
    };

    // 5. Process each component.
    log('Processing components...', name: _tag);
    var phoneticCount = 0;
    var semanticCount = 0;
    var skippedCount = 0;

    for (final component in components) {
      // Skip if review already exists (idempotent).
      try {
        final existingReview =
            await _reviewRepository.getByComponentId(component.id);
        if (existingReview != null) {
          skippedCount++;
          warnings.add(Warning(
            'Component ${component.id}: review already exists, skipping',
          ));
          continue;
        }
      } on Exception catch (e, st) {
        log('Error checking existing review for component ${component.id}',
            error: e, stackTrace: st, name: _tag);
        continue;
      }

      // Look up kanji character and radical master symbol.
      final kanjiChar = kanjiCharMap[component.kanjiId];
      final radicalSymbol = radicalSymbolMap[component.radicalId];

      if (kanjiChar == null || radicalSymbol == null) {
        log(
          'Component ${component.id}: missing kanji ($kanjiChar) or '
          'radical ($radicalSymbol), skipping',
          name: _tag,
        );
        continue;
      }

      // Determine logic hint and confidence.
      final (:logicHint, :confidence) = _estimateHint(
        kanjiChar: kanjiChar,
        radicalSymbol: radicalSymbol,
        kanjidicMap: kanjidicMap,
        warnings: warnings,
      );

      // Update logic_hint on the component row.
      try {
        await _kanjiComponentRepository.updateLogicHint(
          id: component.id,
          logicHint: logicHint,
        );
      } on Exception catch (e, st) {
        log('Error updating logic_hint for component ${component.id}',
            error: e, stackTrace: st, name: _tag);
        continue;
      }

      // Create review row.
      try {
        await _reviewRepository.create(
          kanjiComponentId: component.id,
          verificationStatus: VerificationStatus.draft,
          aiConfidence: confidence,
        );
      } on Exception catch (e, st) {
        log('Error creating review for component ${component.id}',
            error: e, stackTrace: st, name: _tag);
        continue;
      }

      if (logicHint == LogicHint.phonetic) {
        phoneticCount++;
      } else {
        semanticCount++;
      }

      // Warn on JLPT-mapped components with low confidence.
      if (confidence < 0.5 && jlptMap.containsKey(kanjiChar)) {
        warnings.add(Warning(
          'Component ${component.id} ($radicalSymbol in $kanjiChar): '
          'JLPT-mapped with low confidence $confidence',
          severity: WarningSeverity.high,
        ));
      }
    }

    log(
      'Estimation complete: ${components.length} components, '
      '$phoneticCount phonetic, $semanticCount semantic, '
      '$skippedCount skipped, ${warnings.length} warnings',
      name: _tag,
    );

    return LogicHintResult(
      componentCount: components.length,
      phoneticCount: phoneticCount,
      semanticCount: semanticCount,
      skippedCount: skippedCount,
      warnings: warnings,
    );
  }

  /// Returns a summary if review data already exists, null otherwise.
  Future<String?> checkExistingResult() async {
    final reviewCount = await _reviewRepository.count();
    if (reviewCount == 0) return null;
    final componentCount = await _kanjiComponentRepository.count();
    return '$reviewCount reviews for $componentCount components';
  }

  /// Core onyomi matching algorithm.
  ///
  /// Returns the estimated [LogicHint] and confidence score per the
  /// confidence table in `ai_enrichment.md`.
  ({LogicHint logicHint, double confidence}) _estimateHint({
    required String kanjiChar,
    required String radicalSymbol,
    required Map<String, KanjidicReadings> kanjidicMap,
    required List<Warning> warnings,
  }) {
    final kanjiReadings = kanjidicMap[kanjiChar];
    final radicalReadings = kanjidicMap[radicalSymbol];

    // Kanji has no onyomi → semantic, 0.5.
    if (kanjiReadings == null || kanjiReadings.jaOn.isEmpty) {
      if (kanjiReadings != null) {
        warnings.add(Warning(
          '$kanjiChar: kanji has no onyomi readings',
        ));
      }
      return (logicHint: LogicHint.semantic, confidence: 0.5);
    }

    // Radical has no raw_kanjidic entry → semantic, 0.3.
    if (radicalReadings == null) {
      warnings.add(Warning(
        '$radicalSymbol: radical not found in raw_kanjidic',
      ));
      return (logicHint: LogicHint.semantic, confidence: 0.3);
    }

    // Radical has no onyomi → semantic, 0.3.
    if (radicalReadings.jaOn.isEmpty) {
      return (logicHint: LogicHint.semantic, confidence: 0.3);
    }

    // Check for onyomi match.
    final kanjiOnSet = kanjiReadings.jaOn.toSet();
    final radicalOnSet = radicalReadings.jaOn.toSet();

    if (kanjiOnSet.intersection(radicalOnSet).isNotEmpty) {
      // Match found → phonetic, 0.9.
      return (logicHint: LogicHint.phonetic, confidence: 0.9);
    }

    // No match (radical has onyomi but none overlap) → semantic, 0.6.
    return (logicHint: LogicHint.semantic, confidence: 0.6);
  }
}
