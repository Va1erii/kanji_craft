import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/parsers/kanjidic_parser.dart';
import 'package:kanji_craft_admin/data/parsers/kanjivg_parser.dart';
import 'package:kanji_craft_admin/data/services/ingestion_service.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/import_status.dart';
import 'package:kanji_craft_admin/domain/entities/raw_jmdict.dart';
import 'package:kanji_craft_admin/domain/entities/raw_kanjidic.dart';
import 'package:kanji_craft_admin/domain/entities/raw_kanjivg.dart';
import 'package:kanji_craft_admin/domain/repositories/data_import_repository.dart';
import 'package:kanji_craft_admin/domain/repositories/raw_jmdict_repository.dart';
import 'package:kanji_craft_admin/domain/repositories/raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/domain/repositories/raw_kanjivg_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';

class MockDataImportRepository extends Mock implements DataImportRepository {}

class MockRawKanjiVgRepository extends Mock implements RawKanjiVgRepository {}

class MockRawKanjidicRepository extends Mock
    implements RawKanjidicRepository {}

class MockRawJmdictRepository extends Mock implements RawJmdictRepository {}

class MockKanjiVgParser extends Mock implements KanjiVgParser {}

class MockKanjidicParser extends Mock implements KanjidicParser {}

void main() {
  late MockDataImportRepository mockImportRepo;
  late MockRawKanjiVgRepository mockKanjiVgRepo;
  late MockRawKanjidicRepository mockKanjidicRepo;
  late MockRawJmdictRepository mockJmdictRepo;
  late MockKanjiVgParser mockKanjiVgParser;
  late MockKanjidicParser mockKanjidicParser;
  late IngestionService service;

  setUpAll(() {
    registerFallbackValue(<RawKanjiVg>[]);
    registerFallbackValue(<RawKanjidic>[]);
    registerFallbackValue(<RawJmdict>[]);
    registerFallbackValue(ImportSource.kanjivg);
    registerFallbackValue(ImportStatus.pending);
  });

  setUp(() {
    resetFixtureIds();
    mockImportRepo = MockDataImportRepository();
    mockKanjiVgRepo = MockRawKanjiVgRepository();
    mockKanjidicRepo = MockRawKanjidicRepository();
    mockJmdictRepo = MockRawJmdictRepository();
    mockKanjiVgParser = MockKanjiVgParser();
    mockKanjidicParser = MockKanjidicParser();

    service = IngestionService(
      importRepository: mockImportRepo,
      kanjiVgRepository: mockKanjiVgRepo,
      kanjidicRepository: mockKanjidicRepo,
      jmdictRepository: mockJmdictRepo,
      kanjiVgParser: mockKanjiVgParser,
      kanjidicParser: mockKanjidicParser,
    );
  });

  group('IngestionService', () {
    group('ingestKanjiVg', () {
      test('success: creates import, parses, batch inserts, returns ingested',
          () async {
        final pendingImport = fakeDataImport(
          id: 1,
          source: ImportSource.kanjivg,
          sourceVersion: '2024.1',
          status: ImportStatus.pending,
        );
        final ingestedImport = fakeDataImport(
          id: 1,
          source: ImportSource.kanjivg,
          sourceVersion: '2024.1',
          status: ImportStatus.ingested,
          recordCount: 2,
        );
        final entries = [
          fakeRawKanjiVg(importId: 1, character: '木'),
          fakeRawKanjiVg(importId: 1, character: '水'),
        ];

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.create(
              source: ImportSource.kanjivg,
              sourceVersion: '2024.1',
            )).thenAnswer((_) async => pendingImport);
        when(() => mockKanjiVgParser.parseFile(
              filePath: '/path/to/kanjivg.xml.gz',
              importId: 1,
            )).thenReturn(entries);
        when(() => mockKanjiVgRepo.insertBatch(any()))
            .thenAnswer((_) async {});
        when(() => mockImportRepo.updateStatus(
              id: 1,
              status: ImportStatus.ingested,
              recordCount: 2,
            )).thenAnswer((_) async => ingestedImport);

        final result = await service.ingestKanjiVg(
          filePath: '/path/to/kanjivg.xml.gz',
          sourceVersion: '2024.1',
        );

        expect(result.status, ImportStatus.ingested);
        expect(result.recordCount, 2);
        verify(() => mockKanjiVgRepo.insertBatch(any())).called(1);
      });

      test('active import guard throws StateError', () async {
        final activeImport = fakeDataImport(
          id: 1,
          source: ImportSource.kanjivg,
          status: ImportStatus.pending,
        );

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => activeImport);

        await expectLater(
          service.ingestKanjiVg(
            filePath: '/path/to/file.xml',
            sourceVersion: '2024.1',
          ),
          throwsA(isA<StateError>()),
        );

        verifyNever(() => mockImportRepo.create(
              source: any(named: 'source'),
              sourceVersion: any(named: 'sourceVersion'),
            ));
      });

      test('failure marks import as failed and rethrows', () async {
        final pendingImport = fakeDataImport(
          id: 1,
          source: ImportSource.kanjivg,
          status: ImportStatus.pending,
        );
        final failedImport = fakeDataImport(
          id: 1,
          source: ImportSource.kanjivg,
          status: ImportStatus.failed,
          errorMessage: 'Exception: parse error',
        );

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.create(
              source: ImportSource.kanjivg,
              sourceVersion: '2024.1',
            )).thenAnswer((_) async => pendingImport);
        when(() => mockKanjiVgParser.parseFile(
              filePath: '/path/to/bad.xml',
              importId: 1,
            )).thenThrow(Exception('parse error'));
        when(() => mockImportRepo.updateStatus(
              id: 1,
              status: ImportStatus.failed,
              errorMessage: any(named: 'errorMessage'),
            )).thenAnswer((_) async => failedImport);

        await expectLater(
          service.ingestKanjiVg(
            filePath: '/path/to/bad.xml',
            sourceVersion: '2024.1',
          ),
          throwsA(isA<Exception>()),
        );

        verify(() => mockImportRepo.updateStatus(
              id: 1,
              status: ImportStatus.failed,
              errorMessage: any(named: 'errorMessage'),
            )).called(1);
      });

      test('batch insert called correct number of times for large dataset',
          () async {
        final pendingImport =
            fakeDataImport(id: 1, status: ImportStatus.pending);
        final ingestedImport = fakeDataImport(
          id: 1,
          status: ImportStatus.ingested,
          recordCount: 1200,
        );
        final entries = List.generate(
          1200,
          (i) => fakeRawKanjiVg(
            importId: 1,
            character: String.fromCharCode(0x4e00 + i),
            unicodeHex: (0x4e00 + i).toRadixString(16),
          ),
        );

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.create(
              source: ImportSource.kanjivg,
              sourceVersion: '2024.1',
            )).thenAnswer((_) async => pendingImport);
        when(() => mockKanjiVgParser.parseFile(
              filePath: '/path/to/file.xml',
              importId: 1,
            )).thenReturn(entries);
        when(() => mockKanjiVgRepo.insertBatch(any()))
            .thenAnswer((_) async {});
        when(() => mockImportRepo.updateStatus(
              id: 1,
              status: ImportStatus.ingested,
              recordCount: 1200,
            )).thenAnswer((_) async => ingestedImport);

        await service.ingestKanjiVg(
          filePath: '/path/to/file.xml',
          sourceVersion: '2024.1',
        );

        verify(() => mockKanjiVgRepo.insertBatch(any())).called(3);
      });

      test('onProgress called after each batch', () async {
        final pendingImport =
            fakeDataImport(id: 1, status: ImportStatus.pending);
        final ingestedImport = fakeDataImport(
          id: 1,
          status: ImportStatus.ingested,
          recordCount: 1200,
        );
        final entries = List.generate(
          1200,
          (i) => fakeRawKanjiVg(
            importId: 1,
            character: String.fromCharCode(0x4e00 + i),
            unicodeHex: (0x4e00 + i).toRadixString(16),
          ),
        );

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.create(
              source: ImportSource.kanjivg,
              sourceVersion: '2024.1',
            )).thenAnswer((_) async => pendingImport);
        when(() => mockKanjiVgParser.parseFile(
              filePath: '/path/to/file.xml',
              importId: 1,
            )).thenReturn(entries);
        when(() => mockKanjiVgRepo.insertBatch(any()))
            .thenAnswer((_) async {});
        when(() => mockImportRepo.updateStatus(
              id: 1,
              status: ImportStatus.ingested,
              recordCount: 1200,
            )).thenAnswer((_) async => ingestedImport);

        final progressCalls = <(int, int)>[];

        await service.ingestKanjiVg(
          filePath: '/path/to/file.xml',
          sourceVersion: '2024.1',
          onProgress: (inserted, total) =>
              progressCalls.add((inserted, total)),
        );

        expect(progressCalls, [
          (500, 1200),
          (1000, 1200),
          (1200, 1200),
        ]);
      });

      test('empty file produces zero records with ingested status', () async {
        final pendingImport =
            fakeDataImport(id: 1, status: ImportStatus.pending);
        final ingestedImport = fakeDataImport(
          id: 1,
          status: ImportStatus.ingested,
          recordCount: 0,
        );

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.create(
              source: ImportSource.kanjivg,
              sourceVersion: '2024.1',
            )).thenAnswer((_) async => pendingImport);
        when(() => mockKanjiVgParser.parseFile(
              filePath: '/path/to/empty.xml',
              importId: 1,
            )).thenReturn([]);
        when(() => mockImportRepo.updateStatus(
              id: 1,
              status: ImportStatus.ingested,
              recordCount: 0,
            )).thenAnswer((_) async => ingestedImport);

        final result = await service.ingestKanjiVg(
          filePath: '/path/to/empty.xml',
          sourceVersion: '2024.1',
        );

        expect(result.status, ImportStatus.ingested);
        expect(result.recordCount, 0);
        verifyNever(() => mockKanjiVgRepo.insertBatch(any()));
      });
    });

    group('ingestKanjidic', () {
      test('success: creates import, parses, batch inserts, returns ingested',
          () async {
        final pendingImport = fakeDataImport(
          id: 1,
          source: ImportSource.kanjidic,
          sourceVersion: '2024.1',
          status: ImportStatus.pending,
        );
        final ingestedImport = fakeDataImport(
          id: 1,
          source: ImportSource.kanjidic,
          sourceVersion: '2024.1',
          status: ImportStatus.ingested,
          recordCount: 2,
        );
        final entries = [
          fakeRawKanjidic(importId: 1, literal: '木'),
          fakeRawKanjidic(importId: 1, literal: '水'),
        ];

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjidic))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.create(
              source: ImportSource.kanjidic,
              sourceVersion: '2024.1',
            )).thenAnswer((_) async => pendingImport);
        when(() => mockKanjidicParser.parseFile(
              filePath: '/path/to/kanjidic2.xml.gz',
              importId: 1,
            )).thenReturn(entries);
        when(() => mockKanjidicRepo.insertBatch(any()))
            .thenAnswer((_) async {});
        when(() => mockImportRepo.updateStatus(
              id: 1,
              status: ImportStatus.ingested,
              recordCount: 2,
            )).thenAnswer((_) async => ingestedImport);

        final result = await service.ingestKanjidic(
          filePath: '/path/to/kanjidic2.xml.gz',
          sourceVersion: '2024.1',
        );

        expect(result.status, ImportStatus.ingested);
        expect(result.recordCount, 2);
        verify(() => mockKanjidicRepo.insertBatch(any())).called(1);
      });

      test('active import guard throws StateError', () async {
        final activeImport = fakeDataImport(
          id: 1,
          source: ImportSource.kanjidic,
          status: ImportStatus.ingested,
        );

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjidic))
            .thenAnswer((_) async => activeImport);

        await expectLater(
          service.ingestKanjidic(
            filePath: '/path/to/file.xml',
            sourceVersion: '2024.1',
          ),
          throwsA(isA<StateError>()),
        );

        verifyNever(() => mockImportRepo.create(
              source: any(named: 'source'),
              sourceVersion: any(named: 'sourceVersion'),
            ));
      });

      test('record count matches parsed entity count', () async {
        final pendingImport =
            fakeDataImport(id: 1, status: ImportStatus.pending);
        final entries = [
          fakeRawKanjidic(importId: 1, literal: '木'),
          fakeRawKanjidic(importId: 1, literal: '水'),
          fakeRawKanjidic(importId: 1, literal: '火'),
        ];

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjidic))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.create(
              source: ImportSource.kanjidic,
              sourceVersion: '2024.1',
            )).thenAnswer((_) async => pendingImport);
        when(() => mockKanjidicParser.parseFile(
              filePath: '/path/to/file.xml',
              importId: 1,
            )).thenReturn(entries);
        when(() => mockKanjidicRepo.insertBatch(any()))
            .thenAnswer((_) async {});
        when(() => mockImportRepo.updateStatus(
              id: 1,
              status: ImportStatus.ingested,
              recordCount: 3,
            )).thenAnswer((_) async => fakeDataImport(
              id: 1,
              status: ImportStatus.ingested,
              recordCount: 3,
            ));

        await service.ingestKanjidic(
          filePath: '/path/to/file.xml',
          sourceVersion: '2024.1',
        );

        verify(() => mockImportRepo.updateStatus(
              id: 1,
              status: ImportStatus.ingested,
              recordCount: 3,
            )).called(1);
      });
    });
  });
}
