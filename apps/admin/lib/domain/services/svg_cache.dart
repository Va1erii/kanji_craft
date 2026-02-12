import 'dart:typed_data';

/// Persistent cache for SVG file bytes, keyed by filename.
///
/// Extracted SVG bytes are stored during Phase 2.4 so they survive
/// app relaunches without re-reading the KanjiVG ZIP.
abstract class SvgCache {
  /// Stores [bytes] under [filename], overwriting if it already exists.
  Future<void> put(String filename, Uint8List bytes);

  /// Stores all entries in [map] concurrently.
  Future<void> putAll(Map<String, Uint8List> map);

  /// Returns the cached bytes for [filename], or null if not cached.
  Future<Uint8List?> get(String filename);

  /// Returns the absolute file path for [filename], or null if not cached.
  Future<String?> getPath(String filename);

  /// Returns true if [filename] exists in the cache.
  Future<bool> contains(String filename);

  /// Returns the number of cached SVG files.
  Future<int> count();

  /// Removes all cached SVG files.
  Future<void> clear();
}
