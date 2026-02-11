import 'package:drift/drift.dart';

import '../../../domain/entities/jlpt_level.dart';
import '../../../domain/repositories/source_jlpt_level_repository.dart';
import '../../database/admin_database.dart';
import '../../database/mappers/admin_mappers.dart';

class DriftSourceJlptLevelRepository implements SourceJlptLevelRepository {
  DriftSourceJlptLevelRepository(this._db);

  final AdminDatabase _db;

  @override
  Future<void> replaceAll(List<JlptLevel> levels) async {
    await _db.transaction(() async {
      await _db.delete(_db.sourceJlptLevelEntries).go();
      await _db.batch((b) {
        for (final level in levels) {
          b.insert(_db.sourceJlptLevelEntries, level.toCompanion());
        }
      });
    });
  }

  @override
  Future<int> count() async {
    final c = countAll();
    final query = _db.selectOnly(_db.sourceJlptLevelEntries)
      ..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c)!;
  }

  @override
  Future<List<JlptLevel>> getAll() async {
    final entries = await _db.select(_db.sourceJlptLevelEntries).get();
    return entries.map((e) => e.toDomain()).toList();
  }
}
