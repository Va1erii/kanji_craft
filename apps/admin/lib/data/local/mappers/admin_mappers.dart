import 'package:drift/drift.dart';

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
        errorMessage: errorMessage,
        metadata: metadata,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- RawKanjiVg ↔ RawKanjiVgEntry --

extension RawKanjiVgToCompanion on RawKanjiVg {
  RawKanjiVgEntriesCompanion toCompanion() => RawKanjiVgEntriesCompanion(
        importId: Value(importId),
        character: Value(character),
        unicodeHex: Value(unicodeHex),
        viewBox: Value(viewBox),
        strokeCount: Value(strokeCount),
        strokes: Value(strokes),
        components: Value(components),
        // createdAt omitted — uses DB default (currentDateAndTime).
      );
}

extension RawKanjiVgEntryToDomain on RawKanjiVgEntry {
  RawKanjiVg toDomain() => RawKanjiVg(
        importId: importId,
        character: character,
        unicodeHex: unicodeHex,
        viewBox: viewBox,
        strokeCount: strokeCount,
        strokes: strokes,
        components: components,
      );
}

// -- RawKanjidic ↔ RawKanjidicEntry --

extension RawKanjidicToCompanion on RawKanjidic {
  RawKanjidicEntriesCompanion toCompanion() => RawKanjidicEntriesCompanion(
        importId: Value(importId),
        literal: Value(literal),
        strokeCount: Value(strokeCount),
        strokeCountMisstrokes: Value(strokeCountMisstrokes),
        grade: Value(grade),
        jlpt: Value(jlpt),
        frequency: Value(frequency),
        codepoints: Value(codepoints),
        radicals: Value(radicals),
        dictRefs: Value(dictRefs),
        queryCodes: Value(queryCodes),
        readings: Value(readings),
        nanori: Value(nanori),
        meanings: Value(meanings),
        variants: Value(variants),
        radicalNames: Value(radicalNames),
        // createdAt omitted — uses DB default (currentDateAndTime).
      );
}

extension RawKanjidicEntryToDomain on RawKanjidicEntry {
  RawKanjidic toDomain() => RawKanjidic(
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
      );
}

// -- RawJmdict ↔ RawJmdictEntry --

extension RawJmdictToCompanion on RawJmdict {
  RawJmdictEntriesCompanion toCompanion() => RawJmdictEntriesCompanion(
        importId: Value(importId),
        entSeq: Value(entSeq),
        kanjiElements: Value(kanjiElements),
        readingElements: Value(readingElements),
        senses: Value(senses),
        examples: Value(examples),
        // createdAt omitted — uses DB default (currentDateAndTime).
      );
}

extension RawJmdictEntryToDomain on RawJmdictEntry {
  RawJmdict toDomain() => RawJmdict(
        importId: importId,
        entSeq: entSeq,
        kanjiElements: kanjiElements,
        readingElements: readingElements,
        senses: senses,
        examples: examples,
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
