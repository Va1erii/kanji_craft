import 'package:drift/drift.dart';

import '../../../domain/entities/vocab_level.dart';
import '../../../domain/repositories/source_vocab_level_repository.dart';
import '../../database/admin_database.dart';
import '../../database/mappers/admin_mappers.dart';

class DriftSourceVocabLevelRepository implements SourceVocabLevelRepository {
  DriftSourceVocabLevelRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<void> replaceAll(List<VocabLevel> levels) async {
    await _db.transaction(() async {
      await _db.delete(_db.sourceVocabLevelEntries).go();
      await _db.batch((b) {
        for (final level in levels) {
          b.insert(_db.sourceVocabLevelEntries, level.toCompanion());
        }
      });
    });
  }

  @override
  Future<List<VocabLevel>> getAll() async {
    final entries = await (_db.select(_db.sourceVocabLevelEntries)
          ..orderBy([
            (t) => OrderingTerm.asc(t.level),
            (t) => OrderingTerm.asc(t.expression),
          ]))
        .get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> count() async {
    final c = countAll();
    final query = _db.selectOnly(_db.sourceVocabLevelEntries)
      ..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }
}
