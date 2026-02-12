import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/services/file_svg_cache.dart';

void main() {
  late Directory tempDir;
  late FileSvgCache cache;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('svg_cache_test_');
    cache = FileSvgCache(tempDir);
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('put and get round-trip', () async {
    final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
    await cache.put('06c34.svg', bytes);

    final result = await cache.get('06c34.svg');
    expect(result, bytes);
  });

  test('get returns null for missing file', () async {
    final result = await cache.get('missing.svg');
    expect(result, isNull);
  });

  test('getPath returns absolute path for cached file', () async {
    final bytes = Uint8List.fromList([1, 2, 3]);
    await cache.put('06c34.svg', bytes);

    final path = await cache.getPath('06c34.svg');
    expect(path, isNotNull);
    expect(path, contains('06c34.svg'));
    expect(File(path!).existsSync(), isTrue);
  });

  test('getPath returns null for missing file', () async {
    final path = await cache.getPath('missing.svg');
    expect(path, isNull);
  });

  test('contains returns true for cached file', () async {
    await cache.put('06c34.svg', Uint8List.fromList([1]));
    expect(await cache.contains('06c34.svg'), isTrue);
  });

  test('contains returns false for missing file', () async {
    expect(await cache.contains('missing.svg'), isFalse);
  });

  test('putAll stores multiple files concurrently', () async {
    final files = {
      '06c34.svg': Uint8List.fromList([1, 2]),
      '06c35.svg': Uint8List.fromList([3, 4]),
      '04f11.svg': Uint8List.fromList([5, 6]),
    };

    await cache.putAll(files);

    expect(await cache.count(), 3);
    expect(await cache.get('06c34.svg'), Uint8List.fromList([1, 2]));
    expect(await cache.get('06c35.svg'), Uint8List.fromList([3, 4]));
    expect(await cache.get('04f11.svg'), Uint8List.fromList([5, 6]));
  });

  test('putAll with empty map is a no-op', () async {
    await cache.putAll({});
    expect(await cache.count(), 0);
  });

  test('count returns number of cached SVG files', () async {
    expect(await cache.count(), 0);

    await cache.put('a.svg', Uint8List.fromList([1]));
    expect(await cache.count(), 1);

    await cache.put('b.svg', Uint8List.fromList([2]));
    expect(await cache.count(), 2);
  });

  test('clear removes all cached files', () async {
    await cache.put('a.svg', Uint8List.fromList([1]));
    await cache.put('b.svg', Uint8List.fromList([2]));
    expect(await cache.count(), 2);

    await cache.clear();

    expect(tempDir.existsSync(), isFalse);
    expect(await cache.count(), 0);
  });

  test('clear on non-existent directory is a no-op', () async {
    // tempDir exists but is empty — delete it to simulate non-existent.
    tempDir.deleteSync(recursive: true);

    // Should not throw.
    await cache.clear();
  });

  test('lazy directory creation on first put', () async {
    // Create cache pointing to a non-existent subdirectory.
    final nestedDir = Directory('${tempDir.path}/nested/svg_cache');
    final nestedCache = FileSvgCache(nestedDir);

    expect(nestedDir.existsSync(), isFalse);

    await nestedCache.put('06c34.svg', Uint8List.fromList([1]));

    expect(nestedDir.existsSync(), isTrue);
    expect(await nestedCache.get('06c34.svg'), Uint8List.fromList([1]));
  });

  test('put overwrites existing file', () async {
    await cache.put('06c34.svg', Uint8List.fromList([1, 2, 3]));
    await cache.put('06c34.svg', Uint8List.fromList([4, 5, 6]));

    final result = await cache.get('06c34.svg');
    expect(result, Uint8List.fromList([4, 5, 6]));
    expect(await cache.count(), 1);
  });

  test('cache is usable after clear', () async {
    await cache.put('a.svg', Uint8List.fromList([1]));
    await cache.clear();

    // Should be able to write and read again.
    await cache.put('b.svg', Uint8List.fromList([2]));
    expect(await cache.get('b.svg'), Uint8List.fromList([2]));
    expect(await cache.count(), 1);
  });

  test('count ignores non-SVG files', () async {
    await cache.put('a.svg', Uint8List.fromList([1]));
    // Manually write a non-SVG file into the cache dir.
    File('${tempDir.path}/readme.txt').writeAsBytesSync([0]);

    expect(await cache.count(), 1);
  });

  test('putAll overwrites existing entries', () async {
    await cache.put('06c34.svg', Uint8List.fromList([1, 2, 3]));

    await cache.putAll({
      '06c34.svg': Uint8List.fromList([7, 8, 9]),
      '06c35.svg': Uint8List.fromList([10, 11]),
    });

    expect(await cache.get('06c34.svg'), Uint8List.fromList([7, 8, 9]));
    expect(await cache.get('06c35.svg'), Uint8List.fromList([10, 11]));
    expect(await cache.count(), 2);
  });

  test('empty bytes round-trip', () async {
    await cache.put('empty.svg', Uint8List(0));

    final result = await cache.get('empty.svg');
    expect(result, Uint8List(0));
    expect(await cache.contains('empty.svg'), isTrue);
  });
}
