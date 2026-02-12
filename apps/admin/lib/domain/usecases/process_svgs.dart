import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

import '../entities/warning.dart';
import '../repositories/kanji_repository.dart';
import '../repositories/radical_repository.dart';
import '../services/svg_cache.dart';

/// Result returned by [ProcessSvgs] after matching SVGs to entities.
class SvgProcessingResult {
  const SvgProcessingResult({
    required this.radicalCount,
    required this.variantCount,
    required this.kanjiCount,
    this.warnings = const [],
  });

  final int radicalCount;
  final int variantCount;
  final int kanjiCount;
  final List<Warning> warnings;
}

/// Orchestrates SVG processing (Phase 2.4):
///
/// 1. Reads the KanjiVG ZIP archive.
/// 2. Builds a filename → bytes map for all SVG files.
/// 3. Computes SHA-256 hashes for each file.
/// 4. Matches draft radicals, variants, and kanji to their SVGs.
/// 5. Populates svg_file_name, svg_hash, svg_file_url on draft rows.
class ProcessSvgs {
  ProcessSvgs({
    required RadicalRepository radicalRepository,
    required KanjiRepository kanjiRepository,
    required SvgCache svgCache,
    required String supabaseUrl,
  })  : _radicalRepository = radicalRepository,
        _kanjiRepository = kanjiRepository,
        _svgCache = svgCache,
        _supabaseUrl = supabaseUrl;

  final RadicalRepository _radicalRepository;
  final KanjiRepository _kanjiRepository;
  final SvgCache _svgCache;
  final String _supabaseUrl;

  Future<SvgProcessingResult> call(String archivePath) async {
    final warnings = <Warning>[];

    // Step 1: Read ZIP and build filename → bytes map.
    final zipBytes = File(archivePath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(zipBytes);

    final svgBytesMap = <String, Uint8List>{};
    for (final file in archive.files) {
      if (file.isFile && file.name.endsWith('.svg')) {
        final basename =
            file.name.contains('/') ? file.name.split('/').last : file.name;
        svgBytesMap[basename] = file.content;
      }
    }

    // Step 1b: Persist SVG bytes to local cache.
    await _svgCache.putAll(svgBytesMap);

    // Step 2: Compute SHA-256 hashes.
    final svgHashMap = <String, String>{};
    for (final entry in svgBytesMap.entries) {
      svgHashMap[entry.key] = sha256.convert(entry.value).toString();
    }

    // Track matched filenames to detect unmatched SVGs.
    final matchedFilenames = <String>{};

    // Step 3a: Process radicals — collect batch updates.
    final radicals = await _radicalRepository.getAllDraftRadicals();
    final radicalUpdates =
        <({int id, String svgFileName, String svgFileUrl, String svgHash})>[];

    for (final radical in radicals) {
      final filename = characterToSvgFilename(radical.masterSymbol);
      final hash = svgHashMap[filename];

      if (hash != null) {
        radicalUpdates.add((
          id: radical.id,
          svgFileName: filename,
          svgFileUrl: _buildUrl(filename),
          svgHash: hash,
        ));
        matchedFilenames.add(filename);
      } else {
        final severity = radical.minJlptLevel != null
            ? WarningSeverity.high
            : WarningSeverity.low;
        warnings.add(Warning(
          '${radical.masterSymbol}: no SVG file found ($filename)',
          severity: severity,
        ));
      }
    }

    if (radicalUpdates.isNotEmpty) {
      await _radicalRepository.batchUpdateDraftRadicalSvg(radicalUpdates);
    }

    // Step 3b: Process radical variants — collect batch updates.
    final variants = await _radicalRepository.getAllDraftRadicalVariants();
    final variantUpdates =
        <({int id, String svgFileName, String svgFileUrl, String svgHash})>[];

    for (final variant in variants) {
      final filename = characterToSvgFilename(variant.shape);
      final hash = svgHashMap[filename];

      if (hash != null) {
        variantUpdates.add((
          id: variant.id,
          svgFileName: filename,
          svgFileUrl: _buildUrl(filename),
          svgHash: hash,
        ));
        matchedFilenames.add(filename);
      } else {
        // Inherit JLPT status from parent radical.
        final parentRadical = radicals
            .where((r) => r.id == variant.draftRadicalId)
            .firstOrNull;
        final severity = parentRadical?.minJlptLevel != null
            ? WarningSeverity.high
            : WarningSeverity.low;
        warnings.add(Warning(
          '${variant.shape}: no SVG file found ($filename)',
          severity: severity,
        ));
      }
    }

    if (variantUpdates.isNotEmpty) {
      await _radicalRepository
          .batchUpdateDraftRadicalVariantSvg(variantUpdates);
    }

    // Step 3c: Process kanji — collect batch updates.
    final kanjiList = await _kanjiRepository.getAllDraftKanji();
    final kanjiUpdates =
        <({int id, String svgFileName, String svgFileUrl, String svgHash})>[];

    for (final kanji in kanjiList) {
      final filename = characterToSvgFilename(kanji.character);
      final hash = svgHashMap[filename];

      if (hash != null) {
        kanjiUpdates.add((
          id: kanji.id,
          svgFileName: filename,
          svgFileUrl: _buildUrl(filename),
          svgHash: hash,
        ));
        matchedFilenames.add(filename);
      } else {
        final severity = kanji.minJlptLevel != null
            ? WarningSeverity.high
            : WarningSeverity.low;
        warnings.add(Warning(
          '${kanji.character}: no SVG file found ($filename)',
          severity: severity,
        ));
      }
    }

    if (kanjiUpdates.isNotEmpty) {
      await _kanjiRepository.batchUpdateDraftKanjiSvg(kanjiUpdates);
    }

    // Report unmatched SVG files.
    final unmatchedCount = svgBytesMap.length - matchedFilenames.length;
    if (unmatchedCount > 0) {
      warnings.add(Warning(
        '$unmatchedCount SVG files in archive with no matching entity',
        severity: WarningSeverity.low,
      ));
    }

    return SvgProcessingResult(
      radicalCount: radicalUpdates.length,
      variantCount: variantUpdates.length,
      kanjiCount: kanjiUpdates.length,
      warnings: warnings,
    );
  }

  /// Returns a summary if SVG data already exists on draft rows, null otherwise.
  Future<String?> checkExistingResult() async {
    final radicals = await _radicalRepository.countDraftRadicalsWithSvg();
    final variants = await _radicalRepository.countDraftRadicalVariantsWithSvg();
    final kanji = await _kanjiRepository.countDraftKanjiWithSvg();
    if (radicals == 0 && variants == 0 && kanji == 0) return null;
    return '$radicals radicals, $variants variants, $kanji kanji';
  }

  /// Converts a character to its KanjiVG SVG filename.
  ///
  /// Takes the first rune's code point, formats as lowercase hex,
  /// zero-pads to at least 5 digits, and appends `.svg`.
  static String characterToSvgFilename(String character) {
    final codePoint = character.runes.first;
    final hex = codePoint.toRadixString(16).toLowerCase();
    final padded = hex.length < 5 ? hex.padLeft(5, '0') : hex;
    return '$padded.svg';
  }

  String _buildUrl(String filename) =>
      '$_supabaseUrl/storage/v1/object/public/svg/$filename';
}
