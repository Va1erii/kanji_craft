import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import '../../domain/entities/import_source.dart';
import '../../domain/services/parse_result.dart';
import '../../domain/services/source_parser.dart';
import 'jmdict_furigana_parser.dart';
import 'jmdict_parser.dart';
import 'kanjidic_parser.dart';
import 'kanjivg_parser.dart';

class SourceParserImpl implements SourceParser {
  @override
  Future<ParseResult<Object>> parseFile({
    required ImportSource source,
    required String filePath,
    required int importId,
  }) =>
      Isolate.run(() => _parse(source, filePath, importId));
}

ParseResult<Object> _parse(
  ImportSource source,
  String filePath,
  int importId,
) =>
    switch (source) {
      ImportSource.kanjivg => KanjiVgParser().parseFile(
          filePath: filePath,
          importId: importId,
        ),
      ImportSource.kanjidic => KanjidicParser().parseFile(
          filePath: filePath,
          importId: importId,
        ),
      ImportSource.jmdict => JmdictParser().parseFile(
          filePath: filePath,
          importId: importId,
        ),
      ImportSource.jmdictFurigana => _parseJmdictFurigana(filePath),
    };

ParseResult<Object> _parseJmdictFurigana(String filePath) {
  final compressed = File(filePath).readAsBytesSync();
  final decompressed = gzip.decode(compressed);

  // Extract JSON content from the single-file tar archive.
  final jsonContent = _extractFirstTarEntry(decompressed);
  if (jsonContent == null) {
    throw FormatException('No file found in tar archive: $filePath');
  }

  return JmdictFuriganaParser.parse(jsonContent);
}

/// Extracts the content of the first regular file from a tar archive.
///
/// Tar format: 512-byte header blocks followed by data blocks (padded to 512).
/// Only needs the first file since JmdictFurigana archives contain a single
/// JSON file.
String? _extractFirstTarEntry(List<int> tarBytes) {
  if (tarBytes.length < 512) return null;

  // File size is at offset 124, 12 bytes, octal ASCII.
  final sizeField = String.fromCharCodes(tarBytes.sublist(124, 136))
      .replaceAll('\x00', '')
      .trim();
  if (sizeField.isEmpty) return null;

  final fileSize = int.parse(sizeField, radix: 8);
  if (tarBytes.length < 512 + fileSize) return null;

  return utf8.decode(tarBytes.sublist(512, 512 + fileSize));
}
