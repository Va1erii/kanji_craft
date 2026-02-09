import 'dart:isolate';

import '../../domain/entities/import_source.dart';
import '../../domain/services/parse_result.dart';
import '../../domain/services/source_parser.dart';
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
    };
