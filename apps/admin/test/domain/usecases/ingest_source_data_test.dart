import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/import_status.dart';
import 'package:kanji_craft_admin/domain/repositories/data_import_repository.dart';
import 'package:kanji_craft_admin/domain/repositories/raw_jmdict_repository.dart';
import 'package:kanji_craft_admin/domain/repositories/raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/domain/repositories/raw_kanjivg_repository.dart';
import 'package:kanji_craft_admin/domain/services/parse_result.dart';
import 'package:kanji_craft_admin/domain/services/source_parser.dart';
import 'package:kanji_craft_admin/domain/usecases/ingest_source_data.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';

class MockDataImportRepository extends Mock implements DataImportRepository {}

class MockRawKanjiVgRepository extends Mock implements RawKanjiVgRepository {}

class MockRawKanjidicRepository extends Mock
    implements RawKanjidicRepository {}

class MockRawJmdictRepository extends Mock implements RawJmdictRepository {}

class MockSourceParser extends Mock implements SourceParser {}

/// Creates a subdirectory with an exact name inside the system temp dir.
Directory _createDir(String name) {
  final parent = Directory.systemTemp.createTempSync('isd_test_');
  final dir = Directory('${parent.path}/$name')..createSync();
  return dir;
}

void main() {
  late MockDataImportRepository mockImportRepo;
  late MockRawKanjiVgRepository mockKanjiVgRepo;
  late MockRawKanjidicRepository mockKanjidicRepo;
  late MockRawJmdictRepository mockJmdictRepo;
  late MockSourceParser mockParser;
  late IngestSourceData useCase;

  setUp(() {
    resetFixtureIds();
    mockImportRepo = MockDataImportRepository();
    mockKanjiVgRepo = MockRawKanjiVgRepository();
    mockKanjidicRepo = MockRawKanjidicRepository();
    mockJmdictRepo = MockRawJmdictRepository();
    mockParser = MockSourceParser();
    useCase = IngestSourceData(
      importRepository: mockImportRepo,
      kanjiVgRepository: mockKanjiVgRepo,
      kanjidicRepository: mockKanjidicRepo,
      jmdictRepository: mockJmdictRepo,
      sourceParser: mockParser,
    );
  });

  /// Sets up mocks so validation passes and the orchestration pipeline runs.
  void stubHappyPath({
    required ImportSource source,
    required ParseResult<Object> parseResult,
    int importId = 1,
  }) {
    final createdImport = fakeDataImport(id: importId, source: source);
    final ingestedImport = fakeDataImport(
      id: importId,
      source: source,
      status: ImportStatus.ingested,
      recordCount: parseResult.parsedCount,
    );

    when(() => mockImportRepo.getActiveBySource(source))
        .thenAnswer((_) async => null);
    when(() => mockImportRepo.hasProcessedVersion(
          source: source,
          sourceVersion: any(named: 'sourceVersion'),
        )).thenAnswer((_) async => false);
    when(() => mockImportRepo.create(
          source: source,
          sourceVersion: any(named: 'sourceVersion'),
        )).thenAnswer((_) async => createdImport);
    when(() => mockParser.parseFile(
          source: source,
          filePath: any(named: 'filePath'),
          importId: importId,
        )).thenAnswer((_) async => parseResult);
    when(() => mockImportRepo.updateStatus(
          id: importId,
          status: ImportStatus.ingested,
          recordCount: any(named: 'recordCount'),
          metadata: any(named: 'metadata'),
        )).thenAnswer((_) async => ingestedImport);

    // Stub raw repo insert/delete for all sources.
    when(() => mockKanjiVgRepo.insertBatch(any()))
        .thenAnswer((_) async {});
    when(() => mockKanjidicRepo.insertBatch(any()))
        .thenAnswer((_) async {});
    when(() => mockJmdictRepo.insertBatch(any()))
        .thenAnswer((_) async {});
    when(() => mockKanjiVgRepo.deleteByImportId(any()))
        .thenAnswer((_) async {});
    when(() => mockKanjidicRepo.deleteByImportId(any()))
        .thenAnswer((_) async {});
    when(() => mockJmdictRepo.deleteByImportId(any()))
        .thenAnswer((_) async {});
  }

  group('IngestSourceData', () {
    group('folder validation', () {
      test('throws when folder does not exist', () async {
        await expectLater(
          useCase
              .call(
                folderPath: '/nonexistent/kanjivg-2024.1',
                source: ImportSource.kanjivg,
              )
              .toList(),
          throwsA(isA<IngestionValidationException>().having(
            (e) => e.message,
            'message',
            contains('does not exist'),
          )),
        );
      });

      test('throws when folder name does not match source pattern', () async {
        final dir = _createDir('badname');
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        await expectLater(
          useCase
              .call(
                folderPath: dir.path,
                source: ImportSource.kanjivg,
              )
              .toList(),
          throwsA(isA<IngestionValidationException>().having(
            (e) => e.message,
            'message',
            contains('does not match expected pattern'),
          )),
        );
      });

      test('throws when required file is missing from folder', () async {
        final dir = _createDir('kanjivg-2024.1');
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        await expectLater(
          useCase
              .call(
                folderPath: dir.path,
                source: ImportSource.kanjivg,
              )
              .toList(),
          throwsA(isA<IngestionValidationException>().having(
            (e) => e.message,
            'message',
            contains('No required data file'),
          )),
        );
      });
    });

    group('active import guard', () {
      test('throws when an active import exists for the source', () async {
        final dir = _createDir('kanjivg-1.0');
        File('${dir.path}/data.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => fakeDataImport());

        await expectLater(
          useCase
              .call(
                folderPath: dir.path,
                source: ImportSource.kanjivg,
              )
              .toList(),
          throwsA(isA<IngestionValidationException>().having(
            (e) => e.message,
            'message',
            contains('active'),
          )),
        );
      });
    });

    group('processed version guard', () {
      test('throws when a processed import with same version exists',
          () async {
        final dir = _createDir('kanjivg-1.0');
        File('${dir.path}/data.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.hasProcessedVersion(
              source: ImportSource.kanjivg,
              sourceVersion: '1.0',
            )).thenAnswer((_) async => true);

        await expectLater(
          useCase
              .call(
                folderPath: dir.path,
                source: ImportSource.kanjivg,
              )
              .toList(),
          throwsA(isA<IngestionValidationException>().having(
            (e) => e.message,
            'message',
            contains('processed'),
          )),
        );
      });

      test('allows re-import when previous import of same version failed',
          () async {
        final dir = _createDir('kanjivg-1.0');
        File('${dir.path}/data.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final entries = [
          fakeRawKanjiVg(importId: 1),
        ];
        stubHappyPath(
          source: ImportSource.kanjivg,
          parseResult: ParseResult(entries: entries, totalElements: 1),
        );

        final events = await useCase
            .call(
              folderPath: dir.path,
              source: ImportSource.kanjivg,
            )
            .toList();

        final complete = events.last as IngestionComplete;
        expect(complete.dataImport.status, ImportStatus.ingested);
      });
    });

    group('happy path', () {
      test('KanjiVG: create → parse → insertBatch → updateStatus', () async {
        final dir = _createDir('kanjivg-2024.1');
        final file = File('${dir.path}/kanjivg.xml.gz');
        file.writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final entries = [
          fakeRawKanjiVg(importId: 1, character: '木'),
          fakeRawKanjiVg(importId: 1, character: '水'),
        ];
        stubHappyPath(
          source: ImportSource.kanjivg,
          parseResult: ParseResult(entries: entries, totalElements: 2),
        );

        final events = await useCase
            .call(
              folderPath: dir.path,
              source: ImportSource.kanjivg,
            )
            .toList();

        // First event: IngestionStarted with the pending import.
        expect(events.first, isA<IngestionStarted>());
        final started = events.first as IngestionStarted;
        expect(started.dataImport.source, ImportSource.kanjivg);

        final complete = events.last as IngestionComplete;
        expect(complete.dataImport.status, ImportStatus.ingested);

        // Verify orchestration order.
        verifyInOrder([
          () => mockImportRepo.create(
                source: ImportSource.kanjivg,
                sourceVersion: '2024.1',
              ),
          () => mockParser.parseFile(
                source: ImportSource.kanjivg,
                filePath: file.path,
                importId: 1,
              ),
          () => mockKanjiVgRepo.insertBatch(any()),
          () => mockImportRepo.updateStatus(
                id: 1,
                status: ImportStatus.ingested,
                recordCount: any(named: 'recordCount'),
                metadata: any(named: 'metadata'),
              ),
        ]);
      });

      test('KANJIDIC: create → parse → insertBatch → updateStatus', () async {
        final dir = _createDir('kanjidic2-2024');
        final file = File('${dir.path}/kanjidic2.xml.gz');
        file.writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final entries = [
          fakeRawKanjidic(importId: 1, literal: '木'),
        ];
        stubHappyPath(
          source: ImportSource.kanjidic,
          parseResult: ParseResult(entries: entries, totalElements: 1),
        );

        final events = await useCase
            .call(
              folderPath: dir.path,
              source: ImportSource.kanjidic,
            )
            .toList();

        final complete = events.last as IngestionComplete;
        expect(complete.dataImport.status, ImportStatus.ingested);
        verify(() => mockKanjidicRepo.insertBatch(any())).called(1);
      });

      test('JMDict: create → parse → insertBatch → updateStatus', () async {
        final dir = _createDir('jmdict-2024.12');
        final primaryFile = File('${dir.path}/JMdict.gz');
        primaryFile.writeAsBytesSync([]);
        File('${dir.path}/JMdict_e_examp.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        stubHappyPath(
          source: ImportSource.jmdict,
          parseResult: ParseResult(entries: <Object>[], totalElements: 0),
        );

        final events = await useCase
            .call(
              folderPath: dir.path,
              source: ImportSource.jmdict,
            )
            .toList();

        final complete = events.last as IngestionComplete;
        expect(complete.dataImport.status, ImportStatus.ingested);
        verify(() => mockParser.parseFile(
              source: ImportSource.jmdict,
              filePath: primaryFile.path,
              importId: 1,
            )).called(1);
      });

      test('JMDict: throws when second required file is missing', () async {
        final dir = _createDir('jmdict-2024.12');
        File('${dir.path}/JMdict.gz').writeAsBytesSync([]);
        // JMdict_e_examp.gz intentionally missing
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        await expectLater(
          useCase
              .call(
                folderPath: dir.path,
                source: ImportSource.jmdict,
              )
              .toList(),
          throwsA(isA<IngestionValidationException>().having(
            (e) => e.message,
            'message',
            contains('No required data file'),
          )),
        );
      });
    });

    group('orchestration', () {
      test('failure marks import as failed, cleans up raw rows, and rethrows',
          () async {
        final dir = _createDir('kanjivg-1.0');
        File('${dir.path}/data.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final createdImport = fakeDataImport(id: 1);
        final failedImport = fakeDataImport(
          id: 1,
          status: ImportStatus.failed,
          errorMessage: 'Exception: parse error',
        );

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.hasProcessedVersion(
              source: ImportSource.kanjivg,
              sourceVersion: any(named: 'sourceVersion'),
            )).thenAnswer((_) async => false);
        when(() => mockImportRepo.create(
              source: ImportSource.kanjivg,
              sourceVersion: any(named: 'sourceVersion'),
            )).thenAnswer((_) async => createdImport);
        when(() => mockParser.parseFile(
              source: ImportSource.kanjivg,
              filePath: any(named: 'filePath'),
              importId: 1,
            )).thenAnswer((_) async => throw Exception('parse error'));
        when(() => mockKanjiVgRepo.deleteByImportId(1))
            .thenAnswer((_) async {});
        when(() => mockImportRepo.updateStatus(
              id: 1,
              status: ImportStatus.failed,
              errorMessage: any(named: 'errorMessage'),
            )).thenAnswer((_) async => failedImport);

        await expectLater(
          useCase
              .call(
                folderPath: dir.path,
                source: ImportSource.kanjivg,
              )
              .toList(),
          throwsA(isA<Exception>()),
        );

        verify(() => mockKanjiVgRepo.deleteByImportId(1)).called(1);
        verify(() => mockImportRepo.updateStatus(
              id: 1,
              status: ImportStatus.failed,
              errorMessage: any(named: 'errorMessage'),
            )).called(1);
      });

      test('batch insert called correct number of times for large dataset',
          () async {
        final dir = _createDir('kanjivg-1.0');
        File('${dir.path}/data.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final entries = List.generate(
          1200,
          (i) => fakeRawKanjiVg(
            importId: 1,
            character: String.fromCharCode(0x4e00 + i),
            unicodeHex: (0x4e00 + i).toRadixString(16),
          ),
        );

        stubHappyPath(
          source: ImportSource.kanjivg,
          parseResult: ParseResult(entries: entries, totalElements: 1200),
        );

        await useCase
            .call(
              folderPath: dir.path,
              source: ImportSource.kanjivg,
            )
            .drain<void>();

        // 1200 entries / 500 batch size = 3 batches.
        verify(() => mockKanjiVgRepo.insertBatch(any())).called(3);
      });

      test('progress events emitted after each batch with correct values',
          () async {
        final dir = _createDir('kanjivg-1.0');
        File('${dir.path}/data.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final entries = List.generate(
          1200,
          (i) => fakeRawKanjiVg(
            importId: 1,
            character: String.fromCharCode(0x4e00 + i),
            unicodeHex: (0x4e00 + i).toRadixString(16),
          ),
        );

        stubHappyPath(
          source: ImportSource.kanjivg,
          parseResult: ParseResult(entries: entries, totalElements: 1200),
        );

        final events = await useCase
            .call(
              folderPath: dir.path,
              source: ImportSource.kanjivg,
            )
            .toList();

        // IngestionStarted comes first, then progress, then complete.
        expect(events.first, isA<IngestionStarted>());
        expect(events.last, isA<IngestionComplete>());

        final progress = events.whereType<IngestionProgress>().toList();
        expect(
          progress.map((e) => (e.inserted, e.total)).toList(),
          [(500, 1200), (1000, 1200), (1200, 1200)],
        );
      });
    });

    group('version extraction', () {
      test('extracts version from kanjivg folder name', () async {
        final dir = _createDir('kanjivg-20240401');
        File('${dir.path}/kanjivg.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        stubHappyPath(
          source: ImportSource.kanjivg,
          parseResult:
              ParseResult(entries: <Object>[], totalElements: 0),
        );

        await useCase
            .call(
              folderPath: dir.path,
              source: ImportSource.kanjivg,
            )
            .drain<void>();

        verify(() => mockImportRepo.create(
              source: ImportSource.kanjivg,
              sourceVersion: '20240401',
            )).called(1);
      });

      test('extracts version from kanjidic folder name', () async {
        final dir = _createDir('kanjidic-2024-04-01');
        File('${dir.path}/kanjidic2.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        stubHappyPath(
          source: ImportSource.kanjidic,
          parseResult:
              ParseResult(entries: <Object>[], totalElements: 0),
        );

        await useCase
            .call(
              folderPath: dir.path,
              source: ImportSource.kanjidic,
            )
            .drain<void>();

        verify(() => mockImportRepo.create(
              source: ImportSource.kanjidic,
              sourceVersion: '2024-04-01',
            )).called(1);
      });

      test('extracts version from kanjidic2 folder name', () async {
        final dir = _createDir('kanjidic2-20260208');
        File('${dir.path}/kanjidic2.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        stubHappyPath(
          source: ImportSource.kanjidic,
          parseResult:
              ParseResult(entries: <Object>[], totalElements: 0),
        );

        await useCase
            .call(
              folderPath: dir.path,
              source: ImportSource.kanjidic,
            )
            .drain<void>();

        verify(() => mockImportRepo.create(
              source: ImportSource.kanjidic,
              sourceVersion: '20260208',
            )).called(1);
      });

      test('extracts version from jmdict folder name', () async {
        final dir = _createDir('jmdict-2024.12.1');
        File('${dir.path}/JMdict.gz').writeAsBytesSync([]);
        File('${dir.path}/JMdict_e_examp.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        stubHappyPath(
          source: ImportSource.jmdict,
          parseResult:
              ParseResult(entries: <Object>[], totalElements: 0),
        );

        await useCase
            .call(
              folderPath: dir.path,
              source: ImportSource.jmdict,
            )
            .drain<void>();

        verify(() => mockImportRepo.create(
              source: ImportSource.jmdict,
              sourceVersion: '2024.12.1',
            )).called(1);
      });
    });
  });
}
