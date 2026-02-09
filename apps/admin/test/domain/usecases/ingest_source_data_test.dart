import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/services/ingestion_service.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/repositories/data_import_repository.dart';
import 'package:kanji_craft_admin/domain/usecases/ingest_source_data.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';

class MockDataImportRepository extends Mock implements DataImportRepository {}

class MockIngestionService extends Mock implements IngestionService {}

/// Creates a subdirectory with an exact name inside the system temp dir.
Directory _createDir(String name) {
  final parent = Directory.systemTemp.createTempSync('isd_test_');
  final dir = Directory('${parent.path}/$name')..createSync();
  return dir;
}

void main() {
  late MockDataImportRepository mockImportRepo;
  late MockIngestionService mockService;
  late IngestSourceData useCase;

  setUp(() {
    resetFixtureIds();
    mockImportRepo = MockDataImportRepository();
    mockService = MockIngestionService();
    useCase = IngestSourceData(
      importRepository: mockImportRepo,
      ingestionService: mockService,
    );
  });

  group('IngestSourceData', () {
    group('folder validation', () {
      test('throws when folder does not exist', () async {
        expect(
          () => useCase.call(
            folderPath: '/nonexistent/kanjivg-2024.1',
            source: ImportSource.kanjivg,
          ),
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

        expect(
          () => useCase.call(
            folderPath: dir.path,
            source: ImportSource.kanjivg,
          ),
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

        expect(
          () => useCase.call(
            folderPath: dir.path,
            source: ImportSource.kanjivg,
          ),
          throwsA(isA<IngestionValidationException>().having(
            (e) => e.message,
            'message',
            contains('No required data file'),
          )),
        );
      });
    });

    group('version extraction', () {
      test('extracts version from kanjivg folder name', () async {
        final dir = _createDir('kanjivg-20240401');
        File('${dir.path}/kanjivg.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final result = fakeDataImport();
        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.hasPromotedVersion(
              source: ImportSource.kanjivg,
              sourceVersion: '20240401',
            )).thenAnswer((_) async => false);
        when(() => mockService.ingestKanjiVg(
              filePath: any(named: 'filePath'),
              sourceVersion: '20240401',
              onProgress: any(named: 'onProgress'),
            )).thenAnswer((_) async => result);

        await useCase.call(
          folderPath: dir.path,
          source: ImportSource.kanjivg,
        );

        verify(() => mockService.ingestKanjiVg(
              filePath: any(named: 'filePath'),
              sourceVersion: '20240401',
              onProgress: any(named: 'onProgress'),
            )).called(1);
      });

      test('extracts version from kanjidic folder name', () async {
        final dir = _createDir('kanjidic-2024-04-01');
        File('${dir.path}/kanjidic2.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final result = fakeDataImport(source: ImportSource.kanjidic);
        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjidic))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.hasPromotedVersion(
              source: ImportSource.kanjidic,
              sourceVersion: '2024-04-01',
            )).thenAnswer((_) async => false);
        when(() => mockService.ingestKanjidic(
              filePath: any(named: 'filePath'),
              sourceVersion: '2024-04-01',
              onProgress: any(named: 'onProgress'),
            )).thenAnswer((_) async => result);

        await useCase.call(
          folderPath: dir.path,
          source: ImportSource.kanjidic,
        );

        verify(() => mockService.ingestKanjidic(
              filePath: any(named: 'filePath'),
              sourceVersion: '2024-04-01',
              onProgress: any(named: 'onProgress'),
            )).called(1);
      });

      test('extracts version from jmdict folder name', () async {
        final dir = _createDir('jmdict-2024.12.1');
        File('${dir.path}/jmdict-english.zip').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final result = fakeDataImport(source: ImportSource.jmdict);
        when(() => mockImportRepo.getActiveBySource(ImportSource.jmdict))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.hasPromotedVersion(
              source: ImportSource.jmdict,
              sourceVersion: '2024.12.1',
            )).thenAnswer((_) async => false);
        when(() => mockService.ingestJmdict(
              filePath: any(named: 'filePath'),
              sourceVersion: '2024.12.1',
              onProgress: any(named: 'onProgress'),
            )).thenAnswer((_) async => result);

        await useCase.call(
          folderPath: dir.path,
          source: ImportSource.jmdict,
        );

        verify(() => mockService.ingestJmdict(
              filePath: any(named: 'filePath'),
              sourceVersion: '2024.12.1',
              onProgress: any(named: 'onProgress'),
            )).called(1);
      });
    });

    group('active import guard', () {
      test('throws when an active import exists for the source', () async {
        final dir = _createDir('kanjivg-1.0');
        File('${dir.path}/data.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => fakeDataImport());

        expect(
          () => useCase.call(
            folderPath: dir.path,
            source: ImportSource.kanjivg,
          ),
          throwsA(isA<IngestionValidationException>().having(
            (e) => e.message,
            'message',
            contains('active'),
          )),
        );
      });
    });

    group('promoted version guard', () {
      test('throws when a promoted import with same version exists', () async {
        final dir = _createDir('kanjivg-1.0');
        File('${dir.path}/data.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.hasPromotedVersion(
              source: ImportSource.kanjivg,
              sourceVersion: '1.0',
            )).thenAnswer((_) async => true);

        expect(
          () => useCase.call(
            folderPath: dir.path,
            source: ImportSource.kanjivg,
          ),
          throwsA(isA<IngestionValidationException>().having(
            (e) => e.message,
            'message',
            contains('promoted'),
          )),
        );
      });

      test('allows re-import when previous import of same version failed',
          () async {
        final dir = _createDir('kanjivg-1.0');
        File('${dir.path}/data.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final result = fakeDataImport();
        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.hasPromotedVersion(
              source: ImportSource.kanjivg,
              sourceVersion: '1.0',
            )).thenAnswer((_) async => false);
        when(() => mockService.ingestKanjiVg(
              filePath: any(named: 'filePath'),
              sourceVersion: '1.0',
              onProgress: any(named: 'onProgress'),
            )).thenAnswer((_) async => result);

        final actual = await useCase.call(
          folderPath: dir.path,
          source: ImportSource.kanjivg,
        );

        expect(actual, result);
      });
    });

    group('happy path', () {
      test('KanjiVG: delegates to ingestKanjiVg with resolved file path',
          () async {
        final dir = _createDir('kanjivg-2024.1');
        final file = File('${dir.path}/kanjivg.xml.gz');
        file.writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final result = fakeDataImport();
        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.hasPromotedVersion(
              source: ImportSource.kanjivg,
              sourceVersion: '2024.1',
            )).thenAnswer((_) async => false);
        when(() => mockService.ingestKanjiVg(
              filePath: file.path,
              sourceVersion: '2024.1',
              onProgress: any(named: 'onProgress'),
            )).thenAnswer((_) async => result);

        final actual = await useCase.call(
          folderPath: dir.path,
          source: ImportSource.kanjivg,
        );

        expect(actual, result);
        verify(() => mockService.ingestKanjiVg(
              filePath: file.path,
              sourceVersion: '2024.1',
              onProgress: any(named: 'onProgress'),
            )).called(1);
      });

      test('KANJIDIC: delegates to ingestKanjidic', () async {
        final dir = _createDir('kanjidic2024');
        final file = File('${dir.path}/kanjidic2.xml.gz');
        file.writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final result = fakeDataImport(source: ImportSource.kanjidic);
        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjidic))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.hasPromotedVersion(
              source: ImportSource.kanjidic,
              sourceVersion: '2024',
            )).thenAnswer((_) async => false);
        when(() => mockService.ingestKanjidic(
              filePath: file.path,
              sourceVersion: '2024',
              onProgress: any(named: 'onProgress'),
            )).thenAnswer((_) async => result);

        final actual = await useCase.call(
          folderPath: dir.path,
          source: ImportSource.kanjidic,
        );

        expect(actual, result);
      });

      test('JMDict: delegates to ingestJmdict', () async {
        final dir = _createDir('jmdict-2024.12');
        final file = File('${dir.path}/jmdict-english.zip');
        file.writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final result = fakeDataImport(source: ImportSource.jmdict);
        when(() => mockImportRepo.getActiveBySource(ImportSource.jmdict))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.hasPromotedVersion(
              source: ImportSource.jmdict,
              sourceVersion: '2024.12',
            )).thenAnswer((_) async => false);
        when(() => mockService.ingestJmdict(
              filePath: file.path,
              sourceVersion: '2024.12',
              onProgress: any(named: 'onProgress'),
            )).thenAnswer((_) async => result);

        final actual = await useCase.call(
          folderPath: dir.path,
          source: ImportSource.jmdict,
        );

        expect(actual, result);
      });

      test('progress callback is forwarded', () async {
        final dir = _createDir('kanjivg-1.0');
        File('${dir.path}/data.xml.gz').writeAsBytesSync([]);
        addTearDown(() => dir.parent.deleteSync(recursive: true));

        final result = fakeDataImport();
        when(() => mockImportRepo.getActiveBySource(ImportSource.kanjivg))
            .thenAnswer((_) async => null);
        when(() => mockImportRepo.hasPromotedVersion(
              source: ImportSource.kanjivg,
              sourceVersion: '1.0',
            )).thenAnswer((_) async => false);
        when(() => mockService.ingestKanjiVg(
              filePath: any(named: 'filePath'),
              sourceVersion: '1.0',
              onProgress: any(named: 'onProgress'),
            )).thenAnswer((invocation) async {
          final onProgress = invocation.namedArguments[#onProgress]
              as void Function(int, int)?;
          onProgress?.call(50, 100);
          return result;
        });

        final progressCalls = <(int, int)>[];
        await useCase.call(
          folderPath: dir.path,
          source: ImportSource.kanjivg,
          onProgress: (inserted, total) =>
              progressCalls.add((inserted, total)),
        );

        expect(progressCalls, [(50, 100)]);
      });
    });
  });
}
