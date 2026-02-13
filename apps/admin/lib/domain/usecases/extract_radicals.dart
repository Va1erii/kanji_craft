import 'dart:developer';

import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../data/services/radical_scanner.dart';
import '../entities/draft_radical.dart';
import '../entities/draft_radical_variant.dart';
import '../entities/warning.dart';
import '../repositories/radical_repository.dart';
import '../repositories/raw_kanjidic_repository.dart';
import '../repositories/raw_kanjivg_repository.dart';
import '../repositories/source_jlpt_level_repository.dart';

const _tag = 'ExtractRadicals';

/// Result returned by [ExtractRadicals] after Passes 0-2.
class ExtractionResult {
  const ExtractionResult({
    required this.radicalCount,
    required this.variantCount,
    required this.scopeSize,
    required this.keepSetSize,
    this.warnings = const [],
  });

  final int radicalCount;
  final int variantCount;

  /// Number of kanji in the JLPT/grade scope set.
  final int scopeSize;

  /// Number of elements in the keep set.
  final int keepSetSize;
  final List<Warning> warnings;
}

/// Orchestrates radical extraction Passes 0-2:
///
/// 0. Builds JLPT/grade scope set from raw_kanjidic + source_jlpt_levels.
/// 1. Builds keep set (scope + official + high-frequency), then runs
///    [RadicalScanner] with ghost flattening to collect radical candidates.
/// 2. Registers draft radicals and variants via [RadicalRepository] (Pass 2).
class ExtractRadicals {
  ExtractRadicals({
    required RawKanjiVgRepository rawKanjiVgRepository,
    required RadicalRepository radicalRepository,
    required RadicalScanner scanner,
    required RawKanjidicRepository rawKanjidicRepository,
    required SourceJlptLevelRepository sourceJlptLevelRepository,
  })  : _rawKanjiVgRepository = rawKanjiVgRepository,
        _radicalRepository = radicalRepository,
        _scanner = scanner,
        _rawKanjidicRepository = rawKanjidicRepository,
        _sourceJlptLevelRepository = sourceJlptLevelRepository;

  final RawKanjiVgRepository _rawKanjiVgRepository;
  final RadicalRepository _radicalRepository;
  final RadicalScanner _scanner;
  final RawKanjidicRepository _rawKanjidicRepository;
  final SourceJlptLevelRepository _sourceJlptLevelRepository;

  Future<ExtractionResult> call({
    required int kanjivgImportId,
    required int kanjidicImportId,
  }) async {
    // Pass 0: Build scope set.
    log('Building JLPT/grade scope set...', name: _tag);
    final scopeSet = await _buildScopeSet(kanjidicImportId);
    log('Scope set: ${scopeSet.length} characters', name: _tag);

    // Load raw data and filter to scope.
    log('Loading raw_kanjivg entries...', name: _tag);
    final allEntries =
        await _rawKanjiVgRepository.getByImportId(kanjivgImportId);
    final rawEntries =
        allEntries.where((e) => scopeSet.contains(e.character)).toList();
    log(
      'Filtered ${allEntries.length} → ${rawEntries.length} in-scope entries',
      name: _tag,
    );

    // 1a. Build official set from ALL entries.
    log('Building official Kangxi radical set...', name: _tag);
    final officialSet = _scanner.buildOfficialSet(allEntries);
    log('Official Kangxi radicals: ${officialSet.length}', name: _tag);

    // 1b. Count raw frequencies from in-scope entries.
    log('Counting raw frequencies...', name: _tag);
    final frequencies = _scanner.countFrequencies(rawEntries);

    // 1c. Build keep set.
    final keepSet = RadicalScanner.buildKeepSet(
      scopeSet: scopeSet,
      officialSet: officialSet,
      frequencies: frequencies,
    );
    log('Keep set: ${keepSet.length} elements', name: _tag);

    // Build tree map for ghost lookups.
    final treeMap = _scanner.buildTreeMap(allEntries);

    // Pass 1: Scan with ghost flattening.
    log('Scanning radical candidates...', name: _tag);
    final scanResult = _scanner.scan(
      rawEntries,
      keepSet: keepSet,
      treeMap: treeMap,
      frequencies: frequencies,
    );
    log(
      'Scan complete: ${scanResult.masters.length} radicals, '
      '${scanResult.ghostsFlattenedCount} ghosts flattened',
      name: _tag,
    );

    // Build stroke count lookup from ALL raw entries (not just in-scope)
    // so variant masters outside scope can still get stroke counts.
    final strokeCountMap = {
      for (final e in allEntries) e.character: e.strokeCount,
    };

    // Clear previous draft data (idempotent).
    await _radicalRepository.deleteAllDraftRadicals();

    // Pass 2: Register.
    log('Registering ${scanResult.masters.length} radicals...', name: _tag);
    final now = DateTime.now();
    var variantCount = 0;

    for (final master in scanResult.masters.values) {
      final savedRadical = await _radicalRepository.upsertDraftRadical(
        DraftRadical(
          id: 0,
          masterSymbol: master.masterSymbol,
          strokeCount: strokeCountMap[master.masterSymbol],
          isOfficial: master.isOfficial,
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Ensure self-variant exists.
      final variants = Map<String, VariantInfo>.from(master.variants);
      if (!variants.containsKey(master.masterSymbol)) {
        variants[master.masterSymbol] = VariantInfo(
          shape: master.masterSymbol,
          isExplicitVariant: false,
          positionCounts: {Position.unknown: 1},
        );
      }

      for (final variant in variants.values) {
        final bestPosition = _bestPosition(variant.positionCounts);
        final isLocked = variant.positionCounts.length == 1;

        await _radicalRepository.upsertDraftRadicalVariant(
          DraftRadicalVariant(
            id: 0,
            draftRadicalId: savedRadical.id,
            shape: variant.shape,
            position: bestPosition,
            isLocked: isLocked,
            createdAt: now,
            updatedAt: now,
          ),
        );
        variantCount++;
      }
    }

    log(
      'Extraction complete: ${scanResult.masters.length} radicals, '
      '$variantCount variants from ${rawEntries.length} in-scope kanji',
      name: _tag,
    );

    return ExtractionResult(
      radicalCount: scanResult.masters.length,
      variantCount: variantCount,
      scopeSize: scopeSet.length,
      keepSetSize: keepSet.length,
      warnings: scanResult.warnings,
    );
  }

  /// Returns a summary if draft radical data already exists, null otherwise.
  Future<String?> checkExistingResult() async {
    final radicals = await _radicalRepository.countDraftRadicals();
    if (radicals == 0) return null;
    final variants = await _radicalRepository.countDraftRadicalVariants();
    return '$radicals radicals, $variants variants';
  }

  /// Builds the JLPT/grade scope set (Pass 0).
  ///
  /// Returns characters that have a Jōyō grade (1–8) in raw_kanjidic OR
  /// appear in source_jlpt_level_entries. Excludes Jinmeiyō (9) and
  /// variant (10) grades.
  Future<Set<String>> _buildScopeSet(int kanjidicImportId) async {
    final scope = <String>{};

    // Set A: characters with a Jōyō school grade (1–6 elementary, 8 secondary).
    // Excludes grade 9 (Jinmeiyō / name kanji) and 10 (variants).
    try {
      final kanjidicEntries =
          await _rawKanjidicRepository.getByImportId(kanjidicImportId);
      for (final entry in kanjidicEntries) {
        if (entry.grade != null && entry.grade! <= 8) {
          scope.add(entry.literal);
        }
      }
      log('Graded characters (grades 1-8): ${scope.length}', name: _tag);
    } on Exception catch (e, st) {
      log('Failed to load raw_kanjidic for scope', error: e, stackTrace: st, name: _tag);
      rethrow;
    }

    // Set B: JLPT-mapped characters.
    try {
      final jlptEntries = await _sourceJlptLevelRepository.getAll();
      final jlptChars = jlptEntries.map((e) => e.character).toSet();
      final before = scope.length;
      scope.addAll(jlptChars);
      log(
        'JLPT characters: ${jlptChars.length} '
        '(${scope.length - before} new)',
        name: _tag,
      );
    } on Exception catch (e, st) {
      log('Failed to load JLPT levels for scope', error: e, stackTrace: st, name: _tag);
      rethrow;
    }

    return scope;
  }

  /// Returns the position with the highest count, defaulting to unknown.
  static Position _bestPosition(Map<Position, int> counts) {
    if (counts.isEmpty) return Position.unknown;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}
