import 'dart:developer';
import 'dart:math' as math;

import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../data/services/radical_scanner.dart';
import '../entities/warning.dart';
import '../repositories/kanji_component_repository.dart';
import '../repositories/kanji_repository.dart';
import '../repositories/radical_repository.dart';
import '../repositories/raw_kanjidic_repository.dart';
import '../repositories/raw_kanjivg_repository.dart';
import '../repositories/source_jlpt_level_repository.dart';

const _tag = 'LinkComponents';

/// Result returned by [LinkComponents].
class LinkComponentsResult {
  const LinkComponentsResult({
    required this.componentCount,
    required this.kanjiProcessed,
    required this.radicalsUpdated,
    this.warnings = const [],
  });

  final int componentCount;
  final int kanjiProcessed;
  final int radicalsUpdated;
  final List<Warning> warnings;
}

/// Component linking (Phase 2.3 Steps 4–5): creates kanji_component rows
/// and derives radical metadata from kanji associations.
///
/// For each raw_kanjivg entry, resolves effective children (after ghost
/// flattening via [RadicalScanner]), then upserts `kanji_components` rows.
/// After all links are created, computes impact_score, min_grade, and
/// min_jlpt_level on each radical.
class LinkComponents {
  LinkComponents({
    required RawKanjiVgRepository rawKanjiVgRepository,
    required KanjiComponentRepository kanjiComponentRepository,
    required RadicalRepository radicalRepository,
    required KanjiRepository kanjiRepository,
    required RawKanjidicRepository rawKanjidicRepository,
    required SourceJlptLevelRepository sourceJlptLevelRepository,
    required RadicalScanner scanner,
  })  : _rawKanjiVgRepository = rawKanjiVgRepository,
        _kanjiComponentRepository = kanjiComponentRepository,
        _radicalRepository = radicalRepository,
        _kanjiRepository = kanjiRepository,
        _rawKanjidicRepository = rawKanjidicRepository,
        _sourceJlptLevelRepository = sourceJlptLevelRepository,
        _scanner = scanner;

  final RawKanjiVgRepository _rawKanjiVgRepository;
  final KanjiComponentRepository _kanjiComponentRepository;
  final RadicalRepository _radicalRepository;
  final KanjiRepository _kanjiRepository;
  final RawKanjidicRepository _rawKanjidicRepository;
  final SourceJlptLevelRepository _sourceJlptLevelRepository;
  final RadicalScanner _scanner;

  Future<LinkComponentsResult> call({
    required int kanjivgImportId,
    required int kanjidicImportId,
  }) async {
    final warnings = <Warning>[];

    // 0. Build JLPT/grade scope set.
    log('Building JLPT/grade scope set...', name: _tag);
    final scopeSet = await _buildScopeSet(kanjidicImportId);
    log('Scope set: ${scopeSet.length} characters', name: _tag);

    // 1. Load source data and filter to scope.
    log('Loading raw_kanjivg entries...', name: _tag);
    final allEntries =
        await _rawKanjiVgRepository.getByImportId(kanjivgImportId);
    final rawEntries =
        allEntries.where((e) => scopeSet.contains(e.character)).toList();
    log(
      'Filtered ${allEntries.length} → ${rawEntries.length} in-scope entries',
      name: _tag,
    );

    // Build keep set + tree map for ghost flattening (same as ExtractRadicals).
    log('Building keep set for ghost flattening...', name: _tag);
    final officialSet = _scanner.buildOfficialSet(allEntries);
    final frequencies = _scanner.countFrequencies(rawEntries);
    final keepSet = RadicalScanner.buildKeepSet(
      scopeSet: scopeSet,
      officialSet: officialSet,
      frequencies: frequencies,
    );
    final treeMap = _scanner.buildTreeMap(allEntries);
    log('Keep set: ${keepSet.length} elements', name: _tag);

    log('Loading draft kanji...', name: _tag);
    final draftKanji = await _kanjiRepository.getAllDraftKanji();
    final kanjiIdMap = {for (final k in draftKanji) k.character: k};
    log('Loaded ${draftKanji.length} draft kanji', name: _tag);

    log('Loading draft radicals...', name: _tag);
    final draftRadicals = await _radicalRepository.getAllDraftRadicals();
    final radicalIdMap = {for (final r in draftRadicals) r.masterSymbol: r.id};
    log('Loaded ${draftRadicals.length} draft radicals', name: _tag);

    // 2. Delete previous components (idempotent).
    log('Deleting previous kanji components...', name: _tag);
    await _kanjiComponentRepository.deleteAll();

    // 3. Parse and link components.
    log('Linking components...', name: _tag);
    final now = DateTime.now();
    final allComponents = <KanjiComponent>[];
    var kanjiProcessed = 0;

    for (final raw in rawEntries) {
      final kanjiEntry = kanjiIdMap[raw.character];
      if (kanjiEntry == null) {
        // Kanji not in draft table — skip silently (e.g. rare kanjivg-only chars).
        continue;
      }

      final effectiveChildren = _scanner.resolveEffectiveChildren(
        raw.components,
        keepSet: keepSet,
        treeMap: treeMap,
      );
      if (effectiveChildren.isEmpty) continue;

      kanjiProcessed++;

      // Deduplicate by master symbol — first occurrence wins (keeps position).
      final seenMasters = <String>{};
      for (final child in effectiveChildren) {
        // Resolve radical.
        final masterSymbol = (child.variant == true && child.original != null)
            ? child.original!
            : child.element;
        if (!seenMasters.add(masterSymbol)) continue;

        final radicalId = radicalIdMap[masterSymbol];
        if (radicalId == null) {
          warnings.add(Warning(
            '${raw.character}: child element "$masterSymbol" not found in '
            'radicals table',
            severity: WarningSeverity.high,
          ));
          continue;
        }

        final position = _mapPosition(child.position);
        final radicalType = _mapRadicalType(child.radical);

        allComponents.add(KanjiComponent(
          id: 0,
          kanjiId: kanjiEntry.id,
          radicalId: radicalId,
          position: position,
          logicHint: LogicHint.semantic, // default, refined by Phase 2.6
          radicalType: radicalType,
          createdAt: now,
          updatedAt: now,
        ));
      }
    }

    // 4. Batch upsert all components.
    log('Upserting ${allComponents.length} components...', name: _tag);
    try {
      await _kanjiComponentRepository.upsertBatch(allComponents);
    } on Exception catch (e, st) {
      log('Error upserting components', error: e, stackTrace: st, name: _tag);
      rethrow;
    }

    // 5. Derive radical metadata (Step 3).
    log('Deriving radical metadata...', name: _tag);
    final radicalsUpdated = await _deriveRadicalMetadata(
      allComponents,
      kanjiIdMap,
      draftRadicals,
    );

    log(
      'Linking complete: ${allComponents.length} components, '
      '$kanjiProcessed kanji processed, $radicalsUpdated radicals updated, '
      '${warnings.length} warnings',
      name: _tag,
    );

    return LinkComponentsResult(
      componentCount: allComponents.length,
      kanjiProcessed: kanjiProcessed,
      radicalsUpdated: radicalsUpdated,
      warnings: warnings,
    );
  }

  /// Returns a summary if component data already exists, null otherwise.
  Future<String?> checkExistingResult() async {
    final componentCount = await _kanjiComponentRepository.count();
    if (componentCount == 0) return null;
    return '$componentCount components';
  }

  // ---------------------------------------------------------------------------
  // Position and RadicalType mapping
  // ---------------------------------------------------------------------------

  /// Maps KanjiVG position string to [Position] enum.
  static Position _mapPosition(String? kanjivgPosition) =>
      switch (kanjivgPosition) {
        'left' => Position.hen,
        'right' => Position.tsukuri,
        'top' => Position.kanmuri,
        'bottom' => Position.ashi,
        'kamae' => Position.kamae,
        'tare' => Position.tare,
        'nyo' => Position.nyo,
        _ => Position.unknown,
      };

  /// Maps KanjiVG radical attribute to [RadicalType] enum.
  static RadicalType _mapRadicalType(String? kanjivgRadical) =>
      switch (kanjivgRadical) {
        'general' => RadicalType.general,
        'tradit' => RadicalType.tradit,
        'nelson' => RadicalType.nelson,
        'jis' => RadicalType.jis,
        _ => RadicalType.component,
      };

  // ---------------------------------------------------------------------------
  // Derive Radical Metadata
  // ---------------------------------------------------------------------------

  /// Computes impact_score, min_grade, and min_jlpt_level for each radical
  /// from its kanji associations.
  Future<int> _deriveRadicalMetadata(
    List<KanjiComponent> components,
    Map<String, dynamic> kanjiIdMap,
    List<dynamic> draftRadicals,
  ) async {
    // Build kanjiId → DraftKanji lookup.
    final kanjiById = <int, ({int? minGrade, int? minJlptLevel})>{};
    for (final entry in kanjiIdMap.values) {
      kanjiById[entry.id] = (
        minGrade: entry.minGrade,
        minJlptLevel: entry.minJlptLevel,
      );
    }

    // Group components by radical_id.
    final radicalKanjiMap = <int, Set<int>>{};
    for (final c in components) {
      radicalKanjiMap.putIfAbsent(c.radicalId, () => {}).add(c.kanjiId);
    }

    // Compute metadata for each radical.
    final updates =
        <({int id, int? impactScore, int? minGrade, int? minJlptLevel})>[];

    for (final entry in radicalKanjiMap.entries) {
      final radicalId = entry.key;
      final kanjiIds = entry.value;

      // impact_score: count → 1-10 scale.
      final impactScore = _computeImpactScore(kanjiIds.length);

      // min_grade: MIN(kanji.min_grade) — earliest school grade.
      int? minGrade;
      for (final kid in kanjiIds) {
        final kanji = kanjiById[kid];
        if (kanji != null && kanji.minGrade != null) {
          minGrade = minGrade == null
              ? kanji.minGrade!
              : math.min(minGrade, kanji.minGrade!);
        }
      }

      // min_jlpt_level: MAX(kanji.min_jlpt_level) — easiest JLPT level.
      int? minJlptLevel;
      for (final kid in kanjiIds) {
        final kanji = kanjiById[kid];
        if (kanji != null && kanji.minJlptLevel != null) {
          minJlptLevel = minJlptLevel == null
              ? kanji.minJlptLevel!
              : math.max(minJlptLevel, kanji.minJlptLevel!);
        }
      }

      updates.add((
        id: radicalId,
        impactScore: impactScore,
        minGrade: minGrade,
        minJlptLevel: minJlptLevel,
      ));
    }

    if (updates.isNotEmpty) {
      log('Updating metadata for ${updates.length} radicals...', name: _tag);
      try {
        await _radicalRepository.batchUpdateDraftRadicalMetadata(updates);
      } on Exception catch (e, st) {
        log('Error updating radical metadata',
            error: e, stackTrace: st, name: _tag);
        rethrow;
      }
    }

    return updates.length;
  }

  /// Builds the JLPT/grade scope set.
  ///
  /// Same logic as ExtractRadicals Pass 0 — characters with Jōyō grade (1–8)
  /// in raw_kanjidic OR appearing in source_jlpt_level_entries.
  /// Excludes grade 9 (Jinmeiyō) and 10 (variants).
  Future<Set<String>> _buildScopeSet(int kanjidicImportId) async {
    final scope = <String>{};

    final kanjidicEntries =
        await _rawKanjidicRepository.getByImportId(kanjidicImportId);
    for (final entry in kanjidicEntries) {
      if (entry.grade != null && entry.grade! <= 8) {
        scope.add(entry.literal);
      }
    }

    final jlptEntries = await _sourceJlptLevelRepository.getAll();
    for (final entry in jlptEntries) {
      scope.add(entry.character);
    }

    return scope;
  }

  /// Maps kanji count to impact_score on a 1–10 scale.
  static int _computeImpactScore(int kanjiCount) {
    if (kanjiCount <= 5) return 1;
    if (kanjiCount <= 15) return 2;
    if (kanjiCount <= 30) return 3;
    if (kanjiCount <= 50) return 4;
    if (kanjiCount <= 80) return 5;
    if (kanjiCount <= 120) return 6;
    if (kanjiCount <= 180) return 7;
    if (kanjiCount <= 260) return 8;
    if (kanjiCount <= 400) return 9;
    return 10;
  }
}
