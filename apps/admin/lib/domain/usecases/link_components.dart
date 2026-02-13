import 'dart:developer';
import 'dart:math' as math;

import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../entities/raw_kanjivg.dart';
import '../entities/warning.dart';
import '../repositories/kanji_component_repository.dart';
import '../repositories/kanji_repository.dart';
import '../repositories/radical_repository.dart';
import '../repositories/raw_kanjivg_repository.dart';

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
/// For each raw_kanjivg entry, parses the component tree to identify
/// direct child radicals, then upserts `kanji_components` rows. After
/// all links are created, computes impact_score, min_grade, and
/// min_jlpt_level on each radical.
class LinkComponents {
  LinkComponents({
    required RawKanjiVgRepository rawKanjiVgRepository,
    required KanjiComponentRepository kanjiComponentRepository,
    required RadicalRepository radicalRepository,
    required KanjiRepository kanjiRepository,
  })  : _rawKanjiVgRepository = rawKanjiVgRepository,
        _kanjiComponentRepository = kanjiComponentRepository,
        _radicalRepository = radicalRepository,
        _kanjiRepository = kanjiRepository;

  final RawKanjiVgRepository _rawKanjiVgRepository;
  final KanjiComponentRepository _kanjiComponentRepository;
  final RadicalRepository _radicalRepository;
  final KanjiRepository _kanjiRepository;

  Future<LinkComponentsResult> call(int kanjivgImportId) async {
    final warnings = <Warning>[];

    // 1. Load source data.
    log('Loading raw_kanjivg entries...', name: _tag);
    final rawEntries =
        await _rawKanjiVgRepository.getByImportId(kanjivgImportId);
    log('Loaded ${rawEntries.length} raw_kanjivg entries', name: _tag);

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

      final directChildren = _parseDirectChildren(raw.components);
      if (directChildren.isEmpty) continue;

      kanjiProcessed++;

      for (final child in directChildren) {
        // Resolve radical.
        final masterSymbol = (child.variant == true && child.original != null)
            ? child.original!
            : child.element;

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
  // Step 1: Parse Direct Children
  // ---------------------------------------------------------------------------

  /// Extracts direct children from the root component tree.
  ///
  /// 1. Flattens structural groups (empty element nodes).
  /// 2. Merges split parts (same element, different part values).
  List<_DirectChild> _parseDirectChildren(KanjiVgComponent root) {
    // Get root's children.
    var children = root.children.toList();

    // Flatten structural groups — promote children of empty-element nodes.
    children = _flattenStructuralGroups(children);

    // Merge split parts.
    return _mergeSplitParts(children);
  }

  /// Recursively promotes children of nodes with empty elements.
  List<KanjiVgComponent> _flattenStructuralGroups(
    List<KanjiVgComponent> children,
  ) {
    final result = <KanjiVgComponent>[];
    for (final child in children) {
      if (child.element.isEmpty) {
        // Promote this node's children.
        result.addAll(_flattenStructuralGroups(child.children));
      } else {
        result.add(child);
      }
    }
    return result;
  }

  /// Groups nodes by element (+ optional number) and merges split parts.
  List<_DirectChild> _mergeSplitParts(List<KanjiVgComponent> children) {
    // Group by (element, number) for split-part detection.
    final groups = <(String, int?), List<KanjiVgComponent>>{};
    final insertionOrder = <(String, int?)>[];

    for (final child in children) {
      final key = (child.element, child.number);
      if (!groups.containsKey(key)) {
        groups[key] = [];
        insertionOrder.add(key);
      }
      groups[key]!.add(child);
    }

    final result = <_DirectChild>[];
    for (final key in insertionOrder) {
      final parts = groups[key]!;

      if (parts.length == 1 && parts.first.part == null) {
        // Single node, no splitting — use as-is.
        final node = parts.first;
        result.add(_DirectChild(
          element: node.element,
          position: node.position,
          variant: node.variant,
          original: node.original,
          radical: node.radical,
        ));
      } else {
        // Multiple parts or explicit part attribute — merge.
        // Use position from the first part that carries one.
        String? position;
        String? radical;
        bool? variant;
        String? original;
        for (final p in parts) {
          position ??= p.position;
          radical ??= p.radical;
          variant ??= p.variant;
          original ??= p.original;
        }
        result.add(_DirectChild(
          element: key.$1,
          position: position,
          variant: variant,
          original: original,
          radical: radical,
        ));
      }
    }

    return result;
  }

  // ---------------------------------------------------------------------------
  // Step 2 helpers: Position and RadicalType mapping
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
  // Step 3: Derive Radical Metadata
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

/// Intermediate representation of a direct child after flattening/merging.
class _DirectChild {
  const _DirectChild({
    required this.element,
    this.position,
    this.variant,
    this.original,
    this.radical,
  });

  final String element;
  final String? position;
  final bool? variant;
  final String? original;
  final String? radical;
}
