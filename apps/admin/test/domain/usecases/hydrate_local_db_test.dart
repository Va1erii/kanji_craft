import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/domain/entities/data_import.dart';
import 'package:kanji_craft_admin/domain/entities/kanji_component_review.dart';
import 'package:kanji_craft_admin/domain/services/admin_state_reader.dart';
import 'package:kanji_craft_admin/domain/services/admin_state_writer.dart';
import 'package:kanji_craft_admin/domain/usecases/hydrate_local_db.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/admin_fixtures.dart';

class MockAdminStateReader extends Mock implements AdminStateReader {}

class MockAdminStateWriter extends Mock implements AdminStateWriter {}

void main() {
  late MockAdminStateReader reader;
  late MockAdminStateWriter writer;
  late HydrateLocalDb useCase;

  setUp(() {
    resetFixtureIds();
    reader = MockAdminStateReader();
    writer = MockAdminStateWriter();
    useCase = HydrateLocalDb(reader: reader, writer: writer);
  });

  setUpAll(() {
    registerFallbackValue(<DataImport>[]);
    registerFallbackValue(<KanjiComponentReview>[]);
  });

  group('HydrateLocalDb', () {
    test('pulls imports then reviews, saves both, stream completes', () async {
      final imports = [fakeDataImport(), fakeDataImport()];
      final reviews = [
        fakeReview(kanjiComponentId: 10),
        fakeReview(kanjiComponentId: 20),
      ];

      when(() => reader.fetchImports()).thenAnswer((_) async => imports);
      when(() => reader.fetchReviews()).thenAnswer((_) async => reviews);
      when(() => writer.saveImports(any())).thenAnswer((_) async {});
      when(() => writer.saveReviews(any())).thenAnswer((_) async {});

      final steps = await useCase.call().toList();

      expect(steps, hasLength(2));
      expect(steps[0], isA<HydrationPullingImports>());
      expect(steps[1], isA<HydrationPullingReviews>());

      verify(() => writer.saveImports(imports)).called(1);
      verify(() => writer.saveReviews(reviews)).called(1);
    });

    test('empty remote: saves empty lists, completes', () async {
      when(() => reader.fetchImports()).thenAnswer((_) async => []);
      when(() => reader.fetchReviews()).thenAnswer((_) async => []);
      when(() => writer.saveImports(any())).thenAnswer((_) async {});
      when(() => writer.saveReviews(any())).thenAnswer((_) async {});

      final steps = await useCase.call().toList();

      expect(steps, hasLength(2));
      verify(() => writer.saveImports([])).called(1);
      verify(() => writer.saveReviews([])).called(1);
    });

    test('remote failure on fetchImports: stream errors, saveImports never called', () async {
      when(() => reader.fetchImports()).thenThrow(Exception('network error'));

      expect(
        () => useCase.call().toList(),
        throwsA(isA<Exception>()),
      );

      verifyNever(() => writer.saveImports(any()));
      verifyNever(() => writer.saveReviews(any()));
    });

    test('failure on saveImports: stream errors, fetchReviews never called', () async {
      when(() => reader.fetchImports()).thenAnswer((_) async => [fakeDataImport()]);
      when(() => writer.saveImports(any())).thenThrow(Exception('db error'));

      expect(
        () => useCase.call().toList(),
        throwsA(isA<Exception>()),
      );

      verifyNever(() => reader.fetchReviews());
      verifyNever(() => writer.saveReviews(any()));
    });

    test('step ordering: pullingImports then pullingReviews', () async {
      when(() => reader.fetchImports()).thenAnswer((_) async => []);
      when(() => reader.fetchReviews()).thenAnswer((_) async => []);
      when(() => writer.saveImports(any())).thenAnswer((_) async {});
      when(() => writer.saveReviews(any())).thenAnswer((_) async {});

      final steps = <HydrationStep>[];
      await for (final step in useCase.call()) {
        steps.add(step);
      }

      expect(steps, [
        isA<HydrationPullingImports>(),
        isA<HydrationPullingReviews>(),
      ]);
    });
  });
}
