import 'package:drift/drift.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../../domain/entities/data_import.dart';
import '../../../domain/entities/jlpt_level.dart';
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

// -- JlptLevel <-> SourceJlptLevelEntry --

extension JlptLevelToCompanion on JlptLevel {
  SourceJlptLevelEntriesCompanion toCompanion() =>
      SourceJlptLevelEntriesCompanion(
        character: Value(character),
        level: Value(level),
      );
}

extension SourceJlptLevelEntryToDomain on SourceJlptLevelEntry {
  JlptLevel toDomain() => JlptLevel(character: character, level: level);
}

// -- Radical ↔ RadicalEntry --

extension RadicalToCompanion on Radical {
  RadicalEntriesCompanion toCompanion() => RadicalEntriesCompanion(
        masterSymbol: Value(masterSymbol),
        strokeCount: Value(strokeCount),
        impactScore: Value(impactScore),
        minJlptLevel: Value(minJlptLevel),
        minGrade: Value(minGrade),
        svgFileName: Value(svgFileName),
        svgFileUrl: Value(svgFileUrl),
        svgHash: Value(svgHash),
        isOfficial: Value(isOfficial),
      );
}

extension RadicalEntryToDomain on RadicalEntry {
  Radical toDomain() => Radical(
        id: id,
        masterSymbol: masterSymbol,
        strokeCount: strokeCount,
        impactScore: impactScore,
        minJlptLevel: minJlptLevel,
        minGrade: minGrade,
        svgFileName: svgFileName,
        svgFileUrl: svgFileUrl,
        svgHash: svgHash,
        isOfficial: isOfficial,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- RadicalI18n ↔ RadicalI18nEntry --

extension RadicalI18nToCompanion on RadicalI18n {
  RadicalI18nEntriesCompanion toCompanion() => RadicalI18nEntriesCompanion(
        radicalId: Value(radicalId),
        langCode: Value(langCode),
        name: Value(name),
        systemMnemonic: Value(systemMnemonic),
        searchTags: Value(searchTags),
      );
}

extension RadicalI18nEntryToDomain on RadicalI18nEntry {
  RadicalI18n toDomain() => RadicalI18n(
        id: id,
        radicalId: radicalId,
        langCode: langCode,
        name: name,
        systemMnemonic: systemMnemonic,
        searchTags: searchTags,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- RadicalVariant ↔ RadicalVariantEntry --

extension RadicalVariantToCompanion on RadicalVariant {
  RadicalVariantEntriesCompanion toCompanion() =>
      RadicalVariantEntriesCompanion(
        radicalId: Value(radicalId),
        shape: Value(shape),
        position: Value(position),
        isLocked: Value(isLocked),
        svgFileName: Value(svgFileName),
        svgFileUrl: Value(svgFileUrl),
        svgHash: Value(svgHash),
      );
}

extension RadicalVariantEntryToDomain on RadicalVariantEntry {
  RadicalVariant toDomain() => RadicalVariant(
        id: id,
        radicalId: radicalId,
        shape: shape,
        position: position,
        isLocked: isLocked,
        svgFileName: svgFileName,
        svgFileUrl: svgFileUrl,
        svgHash: svgHash,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- Kanji ↔ KanjiEntry --

extension KanjiToCompanion on Kanji {
  KanjiEntriesCompanion toCompanion() => KanjiEntriesCompanion(
        character: Value(character),
        strokeCount: Value(strokeCount),
        minJlptLevel: Value(minJlptLevel),
        minGrade: Value(minGrade),
        frequencyRank: Value(frequencyRank),
        svgFileName: Value(svgFileName),
        svgFileUrl: Value(svgFileUrl),
        svgHash: Value(svgHash),
      );
}

extension KanjiEntryToDomain on KanjiEntry {
  Kanji toDomain() => Kanji(
        id: id,
        character: character,
        strokeCount: strokeCount,
        minJlptLevel: minJlptLevel,
        minGrade: minGrade,
        frequencyRank: frequencyRank,
        svgFileName: svgFileName,
        svgFileUrl: svgFileUrl,
        svgHash: svgHash,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- KanjiReading ↔ KanjiReadingEntry --

extension KanjiReadingToCompanion on KanjiReading {
  KanjiReadingEntriesCompanion toCompanion() => KanjiReadingEntriesCompanion(
        kanjiId: Value(kanjiId),
        reading: Value(reading),
        readingType: Value(readingType),
        priority: Value(priority),
      );
}

extension KanjiReadingEntryToDomain on KanjiReadingEntry {
  KanjiReading toDomain() => KanjiReading(
        id: id,
        kanjiId: kanjiId,
        reading: reading,
        readingType: readingType,
        priority: priority,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- KanjiI18n ↔ KanjiI18nEntry --

extension KanjiI18nToCompanion on KanjiI18n {
  KanjiI18nEntriesCompanion toCompanion() => KanjiI18nEntriesCompanion(
        kanjiId: Value(kanjiId),
        langCode: Value(langCode),
        meanings: Value(meanings),
        systemMnemonic: Value(systemMnemonic),
        searchTags: Value(searchTags),
      );
}

extension KanjiI18nEntryToDomain on KanjiI18nEntry {
  KanjiI18n toDomain() => KanjiI18n(
        id: id,
        kanjiId: kanjiId,
        langCode: langCode,
        meanings: meanings,
        systemMnemonic: systemMnemonic,
        searchTags: searchTags,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- KanjiComponent ↔ KanjiComponentEntry --

extension KanjiComponentToCompanion on KanjiComponent {
  KanjiComponentEntriesCompanion toCompanion() =>
      KanjiComponentEntriesCompanion(
        kanjiId: Value(kanjiId),
        radicalId: Value(radicalId),
        position: Value(position),
        logicHint: Value(logicHint),
        radicalType: Value(radicalType),
      );
}

extension KanjiComponentEntryToDomain on KanjiComponentEntry {
  KanjiComponent toDomain() => KanjiComponent(
        id: id,
        kanjiId: kanjiId,
        radicalId: radicalId,
        position: position,
        logicHint: logicHint,
        radicalType: radicalType,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- Vocabulary ↔ VocabularyEntry --

extension VocabularyToCompanion on Vocabulary {
  VocabularyEntriesCompanion toCompanion() => VocabularyEntriesCompanion(
        word: Value(word),
        segments: Value(segments),
        minJlptLevel: Value(minJlptLevel),
        frequencyRank: Value(frequencyRank),
      );
}

extension VocabularyEntryToDomain on VocabularyEntry {
  Vocabulary toDomain() => Vocabulary(
        id: id,
        word: word,
        segments: segments,
        minJlptLevel: minJlptLevel,
        frequencyRank: frequencyRank,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- VocabularyReading ↔ VocabularyReadingEntry --

extension VocabularyReadingToCompanion on VocabularyReading {
  VocabularyReadingEntriesCompanion toCompanion() =>
      VocabularyReadingEntriesCompanion(
        vocabularyId: Value(vocabularyId),
        reading: Value(reading),
        priority: Value(priority),
      );
}

extension VocabularyReadingEntryToDomain on VocabularyReadingEntry {
  VocabularyReading toDomain() => VocabularyReading(
        id: id,
        vocabularyId: vocabularyId,
        reading: reading,
        priority: priority,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- VocabularyI18n ↔ VocabularyI18nEntry --

extension VocabularyI18nToCompanion on VocabularyI18n {
  VocabularyI18nEntriesCompanion toCompanion() =>
      VocabularyI18nEntriesCompanion(
        vocabularyId: Value(vocabularyId),
        langCode: Value(langCode),
        meanings: Value(meanings),
        systemMnemonic: Value(systemMnemonic),
        searchTags: Value(searchTags),
      );
}

extension VocabularyI18nEntryToDomain on VocabularyI18nEntry {
  VocabularyI18n toDomain() => VocabularyI18n(
        id: id,
        vocabularyId: vocabularyId,
        langCode: langCode,
        meanings: meanings,
        systemMnemonic: systemMnemonic,
        searchTags: searchTags,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- VocabularyKanji ↔ VocabularyKanjiEntry --

extension VocabularyKanjiToCompanion on VocabularyKanji {
  VocabularyKanjiEntriesCompanion toCompanion() =>
      VocabularyKanjiEntriesCompanion(
        vocabularyId: Value(vocabularyId),
        kanjiId: Value(kanjiId),
        position: Value(position),
      );
}

extension VocabularyKanjiEntryToDomain on VocabularyKanjiEntry {
  VocabularyKanji toDomain() => VocabularyKanji(
        id: id,
        vocabularyId: vocabularyId,
        kanjiId: kanjiId,
        position: position,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- VocabularySentence ↔ VocabularySentenceEntry --

extension VocabularySentenceToCompanion on VocabularySentence {
  VocabularySentenceEntriesCompanion toCompanion() =>
      VocabularySentenceEntriesCompanion(
        vocabularyId: Value(vocabularyId),
        originalText: Value(originalText),
        verificationStatus: Value(verificationStatus),
      );
}

extension VocabularySentenceEntryToDomain on VocabularySentenceEntry {
  VocabularySentence toDomain() => VocabularySentence(
        id: id,
        vocabularyId: vocabularyId,
        originalText: originalText,
        verificationStatus: verificationStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

// -- VocabularySentenceI18n ↔ VocabularySentenceI18nEntry --

extension VocabularySentenceI18nToCompanion on VocabularySentenceI18n {
  VocabularySentenceI18nEntriesCompanion toCompanion() =>
      VocabularySentenceI18nEntriesCompanion(
        vocabularySentenceId: Value(vocabularySentenceId),
        langCode: Value(langCode),
        sentenceTranslated: Value(sentenceTranslated),
      );
}

extension VocabularySentenceI18nEntryToDomain on VocabularySentenceI18nEntry {
  VocabularySentenceI18n toDomain() => VocabularySentenceI18n(
        id: id,
        vocabularySentenceId: vocabularySentenceId,
        langCode: langCode,
        sentenceTranslated: sentenceTranslated,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
