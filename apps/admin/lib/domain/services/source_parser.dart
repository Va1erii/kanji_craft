import '../entities/import_source.dart';
import 'parse_result.dart';

/// Parses a source data file into raw domain entities for ingestion.
///
/// Each [ImportSource] has its own file format (KanjiVG XML, KANJIDIC2 XML,
/// JMDict XML). The implementation dispatches to the appropriate format-specific
/// parser and returns a typed [ParseResult] containing the parsed entities,
/// element counts, and any skipped entries.
///
/// Used by [IngestSourceData] as the parsing step in the ingestion pipeline.
abstract class SourceParser {
  ParseResult<Object> parseFile({
    required ImportSource source,
    required String filePath,
    required int importId,
  });
}
