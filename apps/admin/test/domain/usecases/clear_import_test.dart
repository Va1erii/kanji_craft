import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/repositories/data_import/supabase_data_import_datasource.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/repositories/data_import_repository.dart';
import 'package:kanji_craft_admin/domain/repositories/jmdict_furigana_repository.dart';
import 'package:kanji_craft_admin/domain/repositories/raw_jmdict_repository.dart';
import 'package:kanji_craft_admin/domain/repositories/raw_kanjidic_repository.dart';
import 'package:kanji_craft_admin/domain/repositories/raw_kanjivg_repository.dart';
import 'package:kanji_craft_admin/domain/usecases/clear_import.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';

class MockDataImportRepository extends Mock implements DataImportRepository {}

class MockRawKanjiVgRepository extends Mock implements RawKanjiVgRepository {}

class MockRawKanjidicRepository extends Mock
    implements RawKanjidicRepository {}

class MockRawJmdictRepository extends Mock implements RawJmdictRepository {}

class MockJmdictFuriganaRepository extends Mock
    implements JmdictFuriganaRepository {}

class MockSupabaseDataImportDataSource extends Mock
    implements SupabaseDataImportDataSource {}

void main() {
  late MockDataImportRepository mockImportRepo;
  late MockRawKanjiVgRepository mockKanjiVgRepo;
  late MockRawKanjidicRepository mockKanjidicRepo;
  late MockRawJmdictRepository mockJmdictRepo;
  late MockJmdictFuriganaRepository mockJmdictFuriganaRepo;
  late MockSupabaseDataImportDataSource mockSupabaseDs;
  late ClearImport useCase;

  setUp(() {
    resetFixtureIds();
    mockImportRepo = MockDataImportRepository();
    mockKanjiVgRepo = MockRawKanjiVgRepository();
    mockKanjidicRepo = MockRawKanjidicRepository();
    mockJmdictRepo = MockRawJmdictRepository();
    mockJmdictFuriganaRepo = MockJmdictFuriganaRepository();
    mockSupabaseDs = MockSupabaseDataImportDataSource();
    useCase = ClearImport(
      importRepository: mockImportRepo,
      kanjiVgRepository: mockKanjiVgRepo,
      kanjidicRepository: mockKanjidicRepo,
      jmdictRepository: mockJmdictRepo,
      jmdictFuriganaRepository: mockJmdictFuriganaRepo,
      supabaseDataImportDataSource: mockSupabaseDs,
    );
  });

  void stubDeletesForSource(ImportSource source) {
    when(() => mockImportRepo.delete(any())).thenAnswer((_) async {});
    when(() => mockSupabaseDs.delete(any())).thenAnswer((_) async {});
    when(() => mockKanjiVgRepo.deleteByImportId(any()))
        .thenAnswer((_) async {});
    when(() => mockKanjidicRepo.deleteByImportId(any()))
        .thenAnswer((_) async {});
    when(() => mockJmdictRepo.deleteByImportId(any()))
        .thenAnswer((_) async {});
    when(() => mockJmdictFuriganaRepo.deleteByImportId(any()))
        .thenAnswer((_) async {});
  }

  group('ClearImport', () {
    test('deletes kanjivg raw rows, local import, and supabase import',
        () async {
      const importId = 42;
      final dataImport = fakeDataImport(
        id: importId,
        source: ImportSource.kanjivg,
      );
      when(() => mockImportRepo.getById(importId))
          .thenAnswer((_) async => dataImport);
      stubDeletesForSource(ImportSource.kanjivg);

      await useCase.call(importId);

      verify(() => mockKanjiVgRepo.deleteByImportId(importId)).called(1);
      verify(() => mockImportRepo.delete(importId)).called(1);
      verify(() => mockSupabaseDs.delete(importId)).called(1);
      verifyNever(() => mockKanjidicRepo.deleteByImportId(any()));
      verifyNever(() => mockJmdictRepo.deleteByImportId(any()));
      verifyNever(() => mockJmdictFuriganaRepo.deleteByImportId(any()));
    });

    test('deletes kanjidic raw rows for kanjidic import', () async {
      const importId = 7;
      final dataImport = fakeDataImport(
        id: importId,
        source: ImportSource.kanjidic,
      );
      when(() => mockImportRepo.getById(importId))
          .thenAnswer((_) async => dataImport);
      stubDeletesForSource(ImportSource.kanjidic);

      await useCase.call(importId);

      verify(() => mockKanjidicRepo.deleteByImportId(importId)).called(1);
      verify(() => mockImportRepo.delete(importId)).called(1);
      verify(() => mockSupabaseDs.delete(importId)).called(1);
      verifyNever(() => mockKanjiVgRepo.deleteByImportId(any()));
      verifyNever(() => mockJmdictRepo.deleteByImportId(any()));
      verifyNever(() => mockJmdictFuriganaRepo.deleteByImportId(any()));
    });

    test('deletes jmdict raw rows for jmdict import', () async {
      const importId = 10;
      final dataImport = fakeDataImport(
        id: importId,
        source: ImportSource.jmdict,
      );
      when(() => mockImportRepo.getById(importId))
          .thenAnswer((_) async => dataImport);
      stubDeletesForSource(ImportSource.jmdict);

      await useCase.call(importId);

      verify(() => mockJmdictRepo.deleteByImportId(importId)).called(1);
      verify(() => mockImportRepo.delete(importId)).called(1);
      verify(() => mockSupabaseDs.delete(importId)).called(1);
      verifyNever(() => mockKanjiVgRepo.deleteByImportId(any()));
      verifyNever(() => mockKanjidicRepo.deleteByImportId(any()));
      verifyNever(() => mockJmdictFuriganaRepo.deleteByImportId(any()));
    });

    test('deletes jmdictFurigana raw rows for jmdictFurigana import',
        () async {
      const importId = 15;
      final dataImport = fakeDataImport(
        id: importId,
        source: ImportSource.jmdictFurigana,
      );
      when(() => mockImportRepo.getById(importId))
          .thenAnswer((_) async => dataImport);
      stubDeletesForSource(ImportSource.jmdictFurigana);

      await useCase.call(importId);

      verify(() => mockJmdictFuriganaRepo.deleteByImportId(importId))
          .called(1);
      verify(() => mockImportRepo.delete(importId)).called(1);
      verify(() => mockSupabaseDs.delete(importId)).called(1);
      verifyNever(() => mockKanjiVgRepo.deleteByImportId(any()));
      verifyNever(() => mockKanjidicRepo.deleteByImportId(any()));
      verifyNever(() => mockJmdictRepo.deleteByImportId(any()));
    });

    test('is a no-op when import does not exist', () async {
      when(() => mockImportRepo.getById(999))
          .thenAnswer((_) async => null);

      await useCase.call(999);

      verifyNever(() => mockImportRepo.delete(any()));
      verifyNever(() => mockSupabaseDs.delete(any()));
      verifyNever(() => mockKanjiVgRepo.deleteByImportId(any()));
      verifyNever(() => mockKanjidicRepo.deleteByImportId(any()));
      verifyNever(() => mockJmdictRepo.deleteByImportId(any()));
      verifyNever(() => mockJmdictFuriganaRepo.deleteByImportId(any()));
    });
  });
}
