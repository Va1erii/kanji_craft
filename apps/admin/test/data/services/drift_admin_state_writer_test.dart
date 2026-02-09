import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/services/drift_admin_state_writer.dart';
import 'package:kanji_craft_admin/domain/entities/data_import.dart';
import 'package:kanji_craft_admin/domain/entities/kanji_component_review.dart';
import 'package:kanji_craft_admin/domain/repositories/data_import_repository.dart';
import 'package:kanji_craft_admin/domain/repositories/kanji_component_review_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';

class MockDataImportRepository extends Mock implements DataImportRepository {}

class MockKanjiComponentReviewRepository extends Mock
    implements KanjiComponentReviewRepository {}

void main() {
  late MockDataImportRepository importRepo;
  late MockKanjiComponentReviewRepository reviewRepo;
  late DriftAdminStateWriter writer;

  setUp(() {
    resetFixtureIds();
    importRepo = MockDataImportRepository();
    reviewRepo = MockKanjiComponentReviewRepository();
    writer = DriftAdminStateWriter(imports: importRepo, reviews: reviewRepo);
  });

  setUpAll(() {
    registerFallbackValue(<DataImport>[]);
    registerFallbackValue(<KanjiComponentReview>[]);
  });

  group('DriftAdminStateWriter', () {
    group('saveImports', () {
      test('delegates to repository upsertAll', () async {
        final imports = [fakeDataImport(), fakeDataImport()];
        when(() => importRepo.upsertAll(any())).thenAnswer((_) async {});

        await writer.saveImports(imports);

        verify(() => importRepo.upsertAll(imports)).called(1);
      });

      test('skips upsertAll when list is empty', () async {
        await writer.saveImports([]);

        verifyNever(() => importRepo.upsertAll(any()));
      });

      test('propagates repository errors', () async {
        when(() => importRepo.upsertAll(any())).thenThrow(Exception('db'));

        expect(
          () => writer.saveImports([fakeDataImport()]),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('saveReviews', () {
      test('delegates to repository upsertAll', () async {
        final reviews = [
          fakeReview(kanjiComponentId: 10),
          fakeReview(kanjiComponentId: 20),
        ];
        when(() => reviewRepo.upsertAll(any())).thenAnswer((_) async {});

        await writer.saveReviews(reviews);

        verify(() => reviewRepo.upsertAll(reviews)).called(1);
      });

      test('skips upsertAll when list is empty', () async {
        await writer.saveReviews([]);

        verifyNever(() => reviewRepo.upsertAll(any()));
      });

      test('propagates repository errors', () async {
        when(() => reviewRepo.upsertAll(any())).thenThrow(Exception('db'));

        expect(
          () => writer.saveReviews([fakeReview()]),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
