import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../data/services/radical_scanner.dart';
import '../entities/draft_radical.dart';
import '../entities/draft_radical_variant.dart';
import '../repositories/radical_repository.dart';
import '../repositories/raw_kanjivg_repository.dart';

/// Result returned by [ExtractRadicals] after Passes 1-2.
class ExtractionResult {
  const ExtractionResult({
    required this.radicalCount,
    required this.variantCount,
    this.warnings = const [],
  });

  final int radicalCount;
  final int variantCount;
  final List<String> warnings;
}

/// Orchestrates radical extraction Passes 1-2:
///
/// 1. Loads raw KanjiVG data for the given import.
/// 2. Runs [RadicalScanner] (Pass 1) to collect radical candidates.
/// 3. Registers draft radicals and variants via [RadicalRepository] (Pass 2).
class ExtractRadicals {
  ExtractRadicals({
    required RawKanjiVgRepository rawKanjiVgRepository,
    required RadicalRepository radicalRepository,
    required RadicalScanner scanner,
  })  : _rawKanjiVgRepository = rawKanjiVgRepository,
        _radicalRepository = radicalRepository,
        _scanner = scanner;

  final RawKanjiVgRepository _rawKanjiVgRepository;
  final RadicalRepository _radicalRepository;
  final RadicalScanner _scanner;

  Future<ExtractionResult> call(int importId) async {
    // Load raw data.
    final rawEntries = await _rawKanjiVgRepository.getByImportId(importId);

    // Pass 1: Scan.
    final scanResult = _scanner.scan(rawEntries);

    // Build stroke count lookup from raw entries.
    final strokeCountMap = {
      for (final e in rawEntries) e.character: e.strokeCount,
    };

    // Clear previous draft data (idempotent).
    await _radicalRepository.deleteAllDraftRadicals();

    // Pass 2: Register.
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

    return ExtractionResult(
      radicalCount: scanResult.masters.length,
      variantCount: variantCount,
      warnings: scanResult.warnings,
    );
  }

  /// Returns the position with the highest count, defaulting to unknown.
  static Position _bestPosition(Map<Position, int> counts) {
    if (counts.isEmpty) return Position.unknown;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}
