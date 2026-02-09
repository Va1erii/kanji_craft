import '../../domain/entities/data_import.dart';
import '../../domain/entities/kanji_component_review.dart';
import '../../domain/repositories/data_import_repository.dart';
import '../../domain/repositories/kanji_component_review_repository.dart';
import '../../domain/services/admin_state_writer.dart';

class DriftAdminStateWriter implements AdminStateWriter {
  DriftAdminStateWriter({
    required DataImportRepository imports,
    required KanjiComponentReviewRepository reviews,
  })  : _imports = imports,
        _reviews = reviews;

  final DataImportRepository _imports;
  final KanjiComponentReviewRepository _reviews;

  @override
  Future<void> saveImports(List<DataImport> imports) =>
      imports.isEmpty ? Future.value() : _imports.upsertAll(imports);

  @override
  Future<void> saveReviews(List<KanjiComponentReview> reviews) =>
      reviews.isEmpty ? Future.value() : _reviews.upsertAll(reviews);
}
