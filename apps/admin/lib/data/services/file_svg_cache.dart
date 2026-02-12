import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

import '../../domain/services/svg_cache.dart';

/// File-system backed [SvgCache].
///
/// Stores each SVG as an individual file under [_cacheDir]/svg_cache/.
/// The directory is created lazily on first write.
class FileSvgCache implements SvgCache {
  FileSvgCache(this._cacheDir);

  final Directory _cacheDir;

  String _filePath(String filename) => p.join(_cacheDir.path, filename);

  Future<void> _ensureDir() async {
    if (!_cacheDir.existsSync()) {
      await _cacheDir.create(recursive: true);
    }
  }

  @override
  Future<void> put(String filename, Uint8List bytes) async {
    await _ensureDir();
    await File(_filePath(filename)).writeAsBytes(bytes);
  }

  @override
  Future<void> putAll(Map<String, Uint8List> map) async {
    if (map.isEmpty) return;
    await _ensureDir();
    await Future.wait(
      map.entries.map((e) => File(_filePath(e.key)).writeAsBytes(e.value)),
    );
  }

  @override
  Future<Uint8List?> get(String filename) async {
    final file = File(_filePath(filename));
    if (await file.exists()) return file.readAsBytes();
    return null;
  }

  @override
  Future<String?> getPath(String filename) async {
    final path = _filePath(filename);
    if (await File(path).exists()) return path;
    return null;
  }

  @override
  Future<bool> contains(String filename) =>
      File(_filePath(filename)).exists();

  @override
  Future<int> count() async {
    if (!_cacheDir.existsSync()) return 0;
    return _cacheDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.svg'))
        .length;
  }

  @override
  Future<void> clear() async {
    if (_cacheDir.existsSync()) {
      await _cacheDir.delete(recursive: true);
    }
  }
}
