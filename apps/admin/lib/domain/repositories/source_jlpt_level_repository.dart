import '../entities/jlpt_level.dart';

abstract class SourceJlptLevelRepository {
  Future<void> replaceAll(List<JlptLevel> levels);
  Future<int> count();
  Future<List<JlptLevel>> getAll();
}
