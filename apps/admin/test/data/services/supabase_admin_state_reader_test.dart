import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/repositories/data_import/supabase_data_import_datasource.dart';
import 'package:kanji_craft_admin/data/repositories/kanji_component_review/supabase_kanji_component_review_datasource.dart';
import 'package:kanji_craft_admin/data/services/supabase_admin_state_reader.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';

class MockSupabaseDataImportDataSource extends Mock
    implements SupabaseDataImportDataSource {}

class MockSupabaseKanjiComponentReviewDataSource extends Mock
    implements SupabaseKanjiComponentReviewDataSource {}

void main() {
  late MockSupabaseDataImportDataSource imports;
  late MockSupabaseKanjiComponentReviewDataSource reviews;
  late SupabaseAdminStateReader reader;

  setUp(() {
    resetFixtureIds();
    imports = MockSupabaseDataImportDataSource();
    reviews = MockSupabaseKanjiComponentReviewDataSource();
    reader = SupabaseAdminStateReader(imports: imports, reviews: reviews);
  });

  group('SupabaseAdminStateReader', () {
    group('fetchImports', () {
      test('delegates to datasource listAll', () async {
        final data = [fakeDataImport(), fakeDataImport()];
        when(() => imports.listAll()).thenAnswer((_) async => data);

        final result = await reader.fetchImports();

        expect(result, data);
        verify(() => imports.listAll()).called(1);
      });

      test('returns empty list when no imports exist', () async {
        when(() => imports.listAll()).thenAnswer((_) async => []);

        final result = await reader.fetchImports();

        expect(result, isEmpty);
      });

      test('propagates datasource errors', () async {
        when(() => imports.listAll()).thenThrow(Exception('network'));

        expect(() => reader.fetchImports(), throwsA(isA<Exception>()));
      });
    });

    group('fetchReviews', () {
      test('delegates to datasource listAll', () async {
        final data = [
          fakeReview(kanjiComponentId: 10),
          fakeReview(kanjiComponentId: 20),
        ];
        when(() => reviews.listAll()).thenAnswer((_) async => data);

        final result = await reader.fetchReviews();

        expect(result, data);
        verify(() => reviews.listAll()).called(1);
      });

      test('returns empty list when no reviews exist', () async {
        when(() => reviews.listAll()).thenAnswer((_) async => []);

        final result = await reader.fetchReviews();

        expect(result, isEmpty);
      });

      test('propagates datasource errors', () async {
        when(() => reviews.listAll()).thenThrow(Exception('network'));

        expect(() => reader.fetchReviews(), throwsA(isA<Exception>()));
      });
    });
  });
}
