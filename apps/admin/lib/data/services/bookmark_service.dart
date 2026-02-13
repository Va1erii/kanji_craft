import 'dart:convert';
import 'dart:io';

import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:path/path.dart' as p;

/// Persists macOS security-scoped bookmarks so user-selected directories
/// remain accessible across app relaunches.
///
/// Stores bookmark data as a JSON file in the app support directory.
class BookmarkService {
  BookmarkService(this._appSupportDir)
      : _secureBookmarks = SecureBookmarks();

  final Directory _appSupportDir;
  final SecureBookmarks _secureBookmarks;

  /// Directories currently accessed via security-scoped resource.
  final _accessedPaths = <String>{};

  File get _storageFile =>
      File(p.join(_appSupportDir.path, 'bookmarks.json'));

  /// Creates a security-scoped bookmark for [directoryPath] and persists it
  /// under [key].
  Future<void> saveBookmark(String key, String directoryPath) async {
    final bookmark =
        await _secureBookmarks.bookmark(File(directoryPath));
    final data = await _readStorage();
    data[key] = bookmark;
    await _writeStorage(data);
  }

  /// Resolves a previously saved bookmark for [key].
  ///
  /// Returns the directory path if the bookmark exists and resolves
  /// successfully, or null otherwise. Automatically starts accessing the
  /// security-scoped resource.
  Future<String?> resolveBookmark(String key) async {
    final data = await _readStorage();
    final bookmark = data[key];
    if (bookmark == null) return null;

    try {
      final resolved = await _secureBookmarks.resolveBookmark(bookmark);
      await startAccess(resolved.path);
      return resolved.path;
    } on Exception {
      // Bookmark invalid or revoked — remove it.
      data.remove(key);
      await _writeStorage(data);
      return null;
    }
  }

  /// Starts accessing a security-scoped resource at [path].
  Future<void> startAccess(String path) async {
    if (_accessedPaths.contains(path)) return;
    await _secureBookmarks
        .startAccessingSecurityScopedResource(File(path));
    _accessedPaths.add(path);
  }

  /// Stops accessing a security-scoped resource at [path].
  Future<void> stopAccess(String path) async {
    if (!_accessedPaths.remove(path)) return;
    await _secureBookmarks
        .stopAccessingSecurityScopedResource(File(path));
  }

  /// Stops all active security-scoped resource accesses.
  Future<void> stopAll() async {
    for (final path in _accessedPaths.toList()) {
      await _secureBookmarks
          .stopAccessingSecurityScopedResource(File(path));
    }
    _accessedPaths.clear();
  }

  Future<Map<String, String>> _readStorage() async {
    if (!await _storageFile.exists()) return {};
    try {
      final content = await _storageFile.readAsString();
      final json = jsonDecode(content) as Map<String, Object?>;
      return json.map((k, v) => MapEntry(k, v as String));
    } on Exception {
      return {};
    }
  }

  Future<void> _writeStorage(Map<String, String> data) async {
    await _storageFile.parent.create(recursive: true);
    await _storageFile.writeAsString(jsonEncode(data));
  }
}
