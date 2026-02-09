import '../../domain/entities/import_source.dart';
import '../../domain/services/parse_result.dart';
import '../../domain/services/source_parser.dart';
import 'jmdict_parser.dart';
import 'kanjidic_parser.dart';
import 'kanjivg_parser.dart';

class SourceParserImpl implements SourceParser {
  SourceParserImpl({
    KanjiVgParser? kanjiVgParser,
    KanjidicParser? kanjidicParser,
    JmdictParser? jmdictParser,
  })  : _kanjiVgParser = kanjiVgParser ?? KanjiVgParser(),
        _kanjidicParser = kanjidicParser ?? KanjidicParser(),
        _jmdictParser = jmdictParser ?? JmdictParser();

  final KanjiVgParser _kanjiVgParser;
  final KanjidicParser _kanjidicParser;
  final JmdictParser _jmdictParser;

  @override
  ParseResult<Object> parseFile({
    required ImportSource source,
    required String filePath,
    required int importId,
  }) =>
      switch (source) {
        ImportSource.kanjivg => _kanjiVgParser.parseFile(
            filePath: filePath,
            importId: importId,
          ),
        ImportSource.kanjidic => _kanjidicParser.parseFile(
            filePath: filePath,
            importId: importId,
          ),
        ImportSource.jmdict => _jmdictParser.parseFile(
            filePath: filePath,
            importId: importId,
          ),
      };
}
