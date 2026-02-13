import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/kanji/drift_kanji_repository.dart';
import 'package:kanji_craft_admin/data/repositories/radical/drift_radical_repository.dart';
import 'package:kanji_craft_admin/data/services/file_svg_cache.dart';
import 'package:kanji_craft_admin/domain/entities/warning.dart';
import 'package:kanji_craft_admin/domain/usecases/process_svgs.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

const _supabaseUrl = 'https://test.supabase.co';

/// Creates a ZIP archive in a temp directory with the given SVG files.
/// Returns the path to the created ZIP file.
String _createTestZip(
  Map<String, List<int>> svgFiles, {
  String zipName = 'kanjivg-test-main.zip',
}) {
  final archive = Archive();
  for (final entry in svgFiles.entries) {
    archive.addFile(ArchiveFile(
      'kanjivg-main/${entry.key}',
      entry.value.length,
      entry.value,
    ));
  }
  final zipBytes = ZipEncoder().encode(archive);
  final tempDir = Directory.systemTemp.createTempSync('svg_test_');
  final zipFile = File('${tempDir.path}/$zipName');
  zipFile.writeAsBytesSync(zipBytes);
  return zipFile.path;
}

String _expectedHash(List<int> bytes) => sha256.convert(bytes).toString();

void main() {
  late AdminDatabase db;
  late DriftRadicalRepository radicalRepo;
  late DriftKanjiRepository kanjiRepo;
  late Directory svgCacheDir;
  late FileSvgCache svgCache;
  late ProcessSvgs processSvgs;

  setUp(() {
    resetFixtureIds();
    db = createTestDatabase();
    final repos = createReposFromDb(db);
    radicalRepo = repos.radicals;
    kanjiRepo = repos.kanji;
    svgCacheDir = Directory.systemTemp.createTempSync('svg_cache_test_');
    svgCache = FileSvgCache(svgCacheDir);
    processSvgs = ProcessSvgs(
      radicalRepository: radicalRepo,
      kanjiRepository: kanjiRepo,
      svgCache: svgCache,
      supabaseUrl: _supabaseUrl,
    );
  });

  tearDown(() {
    db.close();
    if (svgCacheDir.existsSync()) {
      svgCacheDir.deleteSync(recursive: true);
    }
  });

  group('characterToSvgFilename', () {
    test('BMP character pads to 5 digits', () {
      // 水 = U+6C34
      expect(ProcessSvgs.characterToSvgFilename('水'), '06c34.svg');
    });

    test('BMP character at low code point pads correctly', () {
      // 一 = U+4E00
      expect(ProcessSvgs.characterToSvgFilename('一'), '04e00.svg');
    });

    test('supplementary plane character exceeds 5 digits', () {
      // 𠀋 = U+2000B
      expect(ProcessSvgs.characterToSvgFilename('𠀋'), '2000b.svg');
    });

    test('uses lowercase hex', () {
      // 休 = U+4F11
      expect(ProcessSvgs.characterToSvgFilename('休'), '04f11.svg');
    });
  });

  group('ProcessSvgs', () {
    test('happy path: matches radicals, variants, and kanji', () async {
      // Set up SVG content.
      final svgMizu = [60, 115, 118, 103, 62, 109, 105, 122, 117]; // fake SVG
      final svgSanzui = [60, 115, 118, 103, 62, 115, 97, 110]; // fake SVG
      final svgKi = [60, 115, 118, 103, 62, 107, 105]; // fake SVG
      final svgYasumu = [60, 115, 118, 103, 62, 121, 97, 115]; // fake SVG

      final zipPath = _createTestZip({
        '06c34.svg': svgMizu, // 水
        '06c35.svg': svgSanzui, // 氵
        '06728.svg': svgKi, // 木
        '04f11.svg': svgYasumu, // 休
      });

      // Insert draft radicals: 水, 木
      final radical1 =
          await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        masterSymbol: '水',
      ));
      final radical2 =
          await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        masterSymbol: '木',
      ));

      // Insert draft variants: 氵 (variant of 水), 木 (same shape as master)
      await radicalRepo.upsertDraftRadicalVariant(fakeDraftRadicalVariant(
        draftRadicalId: radical1.id,
        shape: '氵',
      ));
      await radicalRepo.upsertDraftRadicalVariant(fakeDraftRadicalVariant(
        draftRadicalId: radical2.id,
        shape: '木',
      ));

      // Insert draft kanji: 休, 木
      await kanjiRepo.insertDraftKanjiBatch([
        fakeDraftKanji(character: '休', frequencyRank: 100),
        fakeDraftKanji(character: '木', frequencyRank: 200),
      ]);

      final result = await processSvgs.call(zipPath);

      expect(result.radicalCount, 2);
      expect(result.variantCount, 2);
      expect(result.kanjiCount, 2);

      // Verify radical SVG fields.
      final radicals = await radicalRepo.getAllDraftRadicals();
      final mizu = radicals.firstWhere((r) => r.masterSymbol == '水');
      expect(mizu.svgFileName, '06c34.svg');
      expect(mizu.svgHash, _expectedHash(svgMizu));
      expect(
        mizu.svgFileUrl,
        '$_supabaseUrl/storage/v1/object/public/svg/06c34.svg',
      );

      // Verify variant SVG fields.
      final variants = await radicalRepo.getAllDraftRadicalVariants();
      final sanzui = variants.firstWhere((v) => v.shape == '氵');
      expect(sanzui.svgFileName, '06c35.svg');
      expect(sanzui.svgHash, _expectedHash(svgSanzui));

      // Verify kanji SVG fields.
      final kanjiList = await kanjiRepo.getAllDraftKanji();
      final yasumu = kanjiList.firstWhere((k) => k.character == '休');
      expect(yasumu.svgFileName, '04f11.svg');
      expect(yasumu.svgHash, _expectedHash(svgYasumu));
      expect(
        yasumu.svgFileUrl,
        '$_supabaseUrl/storage/v1/object/public/svg/04f11.svg',
      );
    });

    test('missing SVG for JLPT entity emits high-severity warning', () async {
      final zipPath = _createTestZip({});

      // Insert radical with JLPT level.
      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        masterSymbol: '水',
        minJlptLevel: 4,
      ));

      // Insert kanji with JLPT level.
      await kanjiRepo.insertDraftKanjiBatch([
        fakeDraftKanji(character: '休', minJlptLevel: 4),
      ]);

      final result = await processSvgs.call(zipPath);

      expect(result.radicalCount, 0);
      expect(result.kanjiCount, 0);

      final highWarnings =
          result.warnings.where((w) => w.severity == WarningSeverity.high);
      expect(highWarnings.length, greaterThanOrEqualTo(2));
      expect(
        highWarnings.any((w) => w.message.contains('水')),
        isTrue,
      );
      expect(
        highWarnings.any((w) => w.message.contains('休')),
        isTrue,
      );
    });

    test('missing SVG for non-JLPT entity emits low-severity warning',
        () async {
      final zipPath = _createTestZip({});

      // Insert radical without JLPT level.
      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        masterSymbol: '水',
        minJlptLevel: null,
      ));

      // Insert kanji without JLPT level.
      await kanjiRepo.insertDraftKanjiBatch([
        fakeDraftKanji(character: '休', minJlptLevel: null),
      ]);

      final result = await processSvgs.call(zipPath);

      final highWarnings =
          result.warnings.where((w) => w.severity == WarningSeverity.high);
      final lowWarnings =
          result.warnings.where((w) => w.severity == WarningSeverity.low);
      expect(highWarnings, isEmpty);
      expect(lowWarnings.length, greaterThanOrEqualTo(2));
    });

    test('unmatched SVG files emit low-severity warning', () async {
      final zipPath = _createTestZip({
        '06c34.svg': [1, 2, 3], // 水
        '0abcd.svg': [4, 5, 6], // no matching entity
        '0ffff.svg': [7, 8, 9], // no matching entity
      });

      // Only insert radical for 水.
      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        masterSymbol: '水',
      ));

      final result = await processSvgs.call(zipPath);

      expect(result.radicalCount, 1);
      final unmatchedWarning = result.warnings.firstWhere(
        (w) => w.message.contains('no matching entity'),
      );
      expect(unmatchedWarning.severity, WarningSeverity.low);
      expect(unmatchedWarning.message, contains('2'));
    });

    test('idempotent: running twice produces same result', () async {
      final svgBytes = [60, 115, 118, 103, 62];
      final zipPath = _createTestZip({'06c34.svg': svgBytes});

      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        masterSymbol: '水',
      ));

      final result1 = await processSvgs.call(zipPath);
      final result2 = await processSvgs.call(zipPath);

      expect(result1.radicalCount, result2.radicalCount);

      final radicals = await radicalRepo.getAllDraftRadicals();
      final mizu = radicals.firstWhere((r) => r.masterSymbol == '水');
      expect(mizu.svgHash, _expectedHash(svgBytes));
    });

    test('empty draft tables produce zero counts', () async {
      final zipPath = _createTestZip({
        '06c34.svg': [1, 2, 3],
      });

      final result = await processSvgs.call(zipPath);

      expect(result.radicalCount, 0);
      expect(result.variantCount, 0);
      expect(result.kanjiCount, 0);
    });

    test('checkExistingResult returns summary when SVG data exists', () async {
      final svgBytes = [60, 115, 118, 103, 62];
      final zipPath = _createTestZip({'06c34.svg': svgBytes});

      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        masterSymbol: '水',
      ));

      // Before processing, no SVG data.
      expect(await processSvgs.checkExistingResult(), isNull);

      // Process SVGs.
      await processSvgs.call(zipPath);

      // After processing, should return summary.
      final summary = await processSvgs.checkExistingResult();
      expect(summary, isNotNull);
      expect(summary, contains('1 radicals'));
    });

    test('checkExistingResult returns null when no SVG data', () async {
      // Insert radical without SVG fields.
      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        masterSymbol: '水',
      ));

      expect(await processSvgs.checkExistingResult(), isNull);
    });

    test('variant inherits JLPT severity from parent radical', () async {
      final zipPath = _createTestZip({});

      // Insert JLPT radical with a variant.
      final radical = await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        masterSymbol: '水',
        minJlptLevel: 4,
      ));
      await radicalRepo.upsertDraftRadicalVariant(fakeDraftRadicalVariant(
        draftRadicalId: radical.id,
        shape: '氵',
      ));

      final result = await processSvgs.call(zipPath);

      // Both radical and variant warnings should be high severity.
      final highWarnings =
          result.warnings.where((w) => w.severity == WarningSeverity.high);
      expect(
        highWarnings.any((w) => w.message.contains('水')),
        isTrue,
      );
      expect(
        highWarnings.any((w) => w.message.contains('氵')),
        isTrue,
      );
    });

    test('SVG bytes are cached during processing', () async {
      final svgMizu = [60, 115, 118, 103, 62, 109, 105, 122, 117];
      final svgKi = [60, 115, 118, 103, 62, 107, 105];

      final zipPath = _createTestZip({
        '06c34.svg': svgMizu, // 水
        '06728.svg': svgKi, // 木
      });

      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        masterSymbol: '水',
      ));

      await processSvgs.call(zipPath);

      // Both SVGs should be cached, even though only 水 matched.
      expect(await svgCache.count(), 2);
      expect(await svgCache.contains('06c34.svg'), isTrue);
      expect(await svgCache.contains('06728.svg'), isTrue);

      final cachedMizu = await svgCache.get('06c34.svg');
      expect(cachedMizu, svgMizu);
    });

    test('unmatched SVGs are also cached', () async {
      final zipPath = _createTestZip({
        '0abcd.svg': [4, 5, 6],
        '0ffff.svg': [7, 8, 9],
      });

      await processSvgs.call(zipPath);

      expect(await svgCache.count(), 2);
      expect(await svgCache.get('0abcd.svg'), [4, 5, 6]);
      expect(await svgCache.get('0ffff.svg'), [7, 8, 9]);
    });

    test('cached SVG is retrievable by path', () async {
      final svgBytes = [60, 115, 118, 103, 62];
      final zipPath = _createTestZip({'06c34.svg': svgBytes});

      await radicalRepo.upsertDraftRadical(fakeDraftRadical(
        masterSymbol: '水',
      ));

      await processSvgs.call(zipPath);

      final path = await svgCache.getPath('06c34.svg');
      expect(path, isNotNull);
      expect(File(path!).readAsBytesSync(), svgBytes);
    });

    test('re-running processing overwrites cache', () async {
      final svgV1 = [1, 2, 3];
      final svgV2 = [4, 5, 6];

      final zipPath1 = _createTestZip({'06c34.svg': svgV1});
      await processSvgs.call(zipPath1);
      expect(await svgCache.get('06c34.svg'), svgV1);

      final zipPath2 = _createTestZip({'06c34.svg': svgV2});
      await processSvgs.call(zipPath2);
      expect(await svgCache.get('06c34.svg'), svgV2);
    });

    test('empty ZIP produces empty cache', () async {
      final zipPath = _createTestZip({});

      await processSvgs.call(zipPath);

      expect(await svgCache.count(), 0);
    });
  });
}
