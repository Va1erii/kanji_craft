import '../../domain/entities/data_import.dart';
import '../../domain/entities/kanji_component_review.dart';
import '../../domain/services/admin_state_reader.dart';
import '../datasources/supabase_data_import_datasource.dart';
import '../datasources/supabase_kanji_component_review_datasource.dart';

class SupabaseAdminStateReader implements AdminStateReader {
  SupabaseAdminStateReader({
    required SupabaseDataImportDataSource imports,
    required SupabaseKanjiComponentReviewDataSource reviews,
  })  : _imports = imports,
        _reviews = reviews;

  final SupabaseDataImportDataSource _imports;
  final SupabaseKanjiComponentReviewDataSource _reviews;

  @override
  Future<List<DataImport>> fetchImports() => _imports.listAll();

  @override
  Future<List<KanjiComponentReview>> fetchReviews() => _reviews.listAll();
}
