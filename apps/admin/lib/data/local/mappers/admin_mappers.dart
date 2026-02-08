import '../../../domain/entities/data_import.dart';
import '../../../domain/entities/kanji_component_review.dart';
import '../../../domain/entities/raw_jmdict.dart';
import '../../../domain/entities/raw_kanjidic.dart';
import '../../../domain/entities/raw_kanjivg.dart';
import '../admin_database.dart';

// -- DataImport ↔ DataImportEntry --

extension DataImportToEntry on DataImport {
  DataImportEntry toEntry() => DataImportEntry(
        id: id,
        source: source,
        sourceVersion: sourceVersion,
        status: status,
        recordCount: recordCount,
        startedAt: startedAt,
        ingestedAt: ingestedAt,
        processedAt: processedAt,
        promotedAt: promotedAt,
        errorMessage: errorMessage,
        metadata: metadata,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension DataImportEntryToDomain on DataImportEntry {
  DataImport toDomain() => DataImport(
        id: id,
        source: source,
        sourceVersion: sourceVersion,
        status: status,
        recordCount: recordCount,
        startedAt: startedAt,
        ingestedAt: ingestedAt,
        processedAt: processedAt,
        promotedAt: promotedAt,
        errorMessage: errorMessage,
        metadata: metadata,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- RawKanjiVg ↔ RawKanjiVgEntry --

extension RawKanjiVgToEntry on RawKanjiVg {
  RawKanjiVgEntry toEntry() => RawKanjiVgEntry(
        id: id,
        importId: importId,
        character: character,
        unicodeHex: unicodeHex,
        viewBox: viewBox,
        strokeCount: strokeCount,
        strokes: strokes,
        components: components,
        createdAt: createdAt,
      );
}

extension RawKanjiVgEntryToDomain on RawKanjiVgEntry {
  RawKanjiVg toDomain() => RawKanjiVg(
        id: id,
        importId: importId,
        character: character,
        unicodeHex: unicodeHex,
        viewBox: viewBox,
        strokeCount: strokeCount,
        strokes: strokes,
        components: components,
        createdAt: createdAt,
      );
}

// -- RawKanjidic ↔ RawKanjidicEntry --

extension RawKanjidicToEntry on RawKanjidic {
  RawKanjidicEntry toEntry() => RawKanjidicEntry(
        id: id,
        importId: importId,
        literal: literal,
        strokeCount: strokeCount,
        strokeCountMisstrokes: strokeCountMisstrokes,
        grade: grade,
        jlpt: jlpt,
        frequency: frequency,
        codepoints: codepoints,
        radicals: radicals,
        dictRefs: dictRefs,
        queryCodes: queryCodes,
        readings: readings,
        nanori: nanori,
        meanings: meanings,
        variants: variants,
        radicalNames: radicalNames,
        createdAt: createdAt,
      );
}

extension RawKanjidicEntryToDomain on RawKanjidicEntry {
  RawKanjidic toDomain() => RawKanjidic(
        id: id,
        importId: importId,
        literal: literal,
        strokeCount: strokeCount,
        strokeCountMisstrokes: strokeCountMisstrokes,
        grade: grade,
        jlpt: jlpt,
        frequency: frequency,
        codepoints: codepoints,
        radicals: radicals,
        dictRefs: dictRefs,
        queryCodes: queryCodes,
        readings: readings,
        nanori: nanori,
        meanings: meanings,
        variants: variants,
        radicalNames: radicalNames,
        createdAt: createdAt,
      );
}

// -- RawJmdict ↔ RawJmdictEntry --

extension RawJmdictToEntry on RawJmdict {
  RawJmdictEntry toEntry() => RawJmdictEntry(
        id: id,
        importId: importId,
        entSeq: entSeq,
        kanjiElements: kanjiElements,
        readingElements: readingElements,
        senses: senses,
        createdAt: createdAt,
      );
}

extension RawJmdictEntryToDomain on RawJmdictEntry {
  RawJmdict toDomain() => RawJmdict(
        id: id,
        importId: importId,
        entSeq: entSeq,
        kanjiElements: kanjiElements,
        readingElements: readingElements,
        senses: senses,
        createdAt: createdAt,
      );
}

// -- KanjiComponentReview ↔ KanjiComponentReviewEntry --

extension KanjiComponentReviewToEntry on KanjiComponentReview {
  KanjiComponentReviewEntry toEntry() => KanjiComponentReviewEntry(
        id: id,
        kanjiComponentId: kanjiComponentId,
        verificationStatus: verificationStatus,
        aiConfidence: aiConfidence,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension KanjiComponentReviewEntryToDomain on KanjiComponentReviewEntry {
  KanjiComponentReview toDomain() => KanjiComponentReview(
        id: id,
        kanjiComponentId: kanjiComponentId,
        verificationStatus: verificationStatus,
        aiConfidence: aiConfidence,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
