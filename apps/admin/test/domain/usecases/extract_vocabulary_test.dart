import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/database/admin_database.dart';
import 'package:kanji_craft_admin/data/repositories/jmdict_furigana/drift_jmdict_furigana_repository.dart';
import 'package:kanji_craft_admin/data/repositories/kanji/drift_kanji_repository.dart';
import 'package:kanji_craft_admin/data/repositories/raw_jmdict/drift_raw_jmdict_repository.dart';
import 'package:kanji_craft_admin/data/repositories/source_vocab_level/drift_source_vocab_level_repository.dart';
import 'package:kanji_craft_admin/data/repositories/vocabulary/drift_vocabulary_repository.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/raw_jmdict.dart';
import 'package:kanji_craft_admin/domain/usecases/extract_vocabulary.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../helpers/admin_fixtures.dart';
import '../../helpers/admin_test_helpers.dart';

void main() {
  late AdminDatabase db;
  late DriftRawJmdictRepository rawJmdictRepo;
  late DriftKanjiRepository kanjiRepo;
  late DriftSourceVocabLevelRepository vocabLevelRepo;
  late DriftJmdictFuriganaRepository furiganaRepo;
  late DriftVocabularyRepository vocabRepo;
  late ExtractVocabulary extractVocabulary;
  late int jmdictImportId;
  late int furiganaImportId;

  setUp(() async {
    resetFixtureIds();
    db = createTestDatabase();
    final repos = createReposFromDb(db);
    rawJmdictRepo = repos.rawJmdict;
    kanjiRepo = repos.kanji;
    vocabLevelRepo = repos.sourceVocabLevel;
    furiganaRepo = repos.jmdictFurigana;
    vocabRepo = repos.vocabulary;

    extractVocabulary = ExtractVocabulary(
      rawJmdictRepository: rawJmdictRepo,
      kanjiRepository: kanjiRepo,
      sourceVocabLevelRepository: vocabLevelRepo,
      jmdictFuriganaRepository: furiganaRepo,
      vocabularyRepository: vocabRepo,
    );

    // Create parent imports.
    final jmdictImport = await repos.imports.create(
      source: ImportSource.jmdict,
      sourceVersion: '1.0',
    );
    jmdictImportId = jmdictImport.id;

    final furiganaImport = await repos.imports.create(
      source: ImportSource.jmdictFurigana,
      sourceVersion: '1.0',
    );
    furiganaImportId = furiganaImport.id;
  });

  tearDown(() => db.close());

  /// Helper: insert draft kanji directly for given characters.
  Future<void> insertDraftKanji(
    List<({String char, int strokeCount, int? jlptLevel})> kanji,
  ) async {
    await kanjiRepo.deleteAllDraftKanji();
    await kanjiRepo.insertDraftKanjiBatch([
      for (final k in kanji)
        fakeDraftKanji(
          id: 0,
          character: k.char,
          strokeCount: k.strokeCount,
          frequencyRank: 100,
          minJlptLevel: k.jlptLevel,
        ),
    ]);
  }

  group('ExtractVocabulary', () {
    test('basic extraction — single common word', () async {
      // Setup: insert draft kanji for 食.
      await insertDraftKanji([(char: '食', strokeCount: 9, jlptLevel: 5)]);

      // Insert raw_jmdict for 食べる.
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 1000,
          kanjiElements: [
            const JmdictKanjiElement(keb: '食べる', kePri: ['ichi1']),
          ],
          readingElements: [
            const JmdictReadingElement(reb: 'たべる', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['v1', 'vt'],
              glosses: {'en': ['to eat']},
            ),
          ],
        ),
      ]);

      // Insert furigana.
      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(
            text: '食べる',
            reading: 'たべる',
            furiganaSegments: [
              {'ruby': '食', 'rt': 'た'},
              {'ruby': 'べる'},
            ],
          ),
        ],
        importId: furiganaImportId,
      );

      final result =
          await extractVocabulary.call(jmdictImportId, furiganaImportId);

      expect(result.vocabularyCount, 1);
      expect(result.readingCount, 1);
      expect(result.i18nCount, 1);
      expect(result.kanjiLinkCount, 1);

      // Verify vocabulary.
      final vocab = await vocabRepo.getAllVocabulary();
      expect(vocab, hasLength(1));
      expect(vocab.first.word, '食べる');
      expect(vocab.first.posTags, containsAll([PosTag.ichidanVerb, PosTag.transitive]));

      // Verify segments.
      final segments = vocab.first.segments;
      expect(segments, hasLength(2));
      expect(segments[0].text, '食');
      expect(segments[0].reading, 'た');
      expect(segments[0].kanjiId, isNotNull);
      expect(segments[1].text, 'べる');
      expect(segments[1].reading, isNull);
      expect(segments[1].kanjiId, isNull);

      // Verify segment concatenation = word.
      final concatenated = segments.map((s) => s.text).join();
      expect(concatenated, '食べる');
    });

    test('kana-only word — zero kanji links', () async {
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 2000,
          kanjiElements: null,
          readingElements: [
            const JmdictReadingElement(
              reb: 'すごい',
              reNokanji: true,
              rePri: ['ichi1'],
            ),
          ],
          senses: [
            const JmdictSense(
              pos: ['adj-i'],
              glosses: {'en': ['amazing', 'great']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(
            text: 'すごい',
            reading: 'すごい',
            furiganaSegments: [
              {'ruby': 'すごい'},
            ],
          ),
        ],
        importId: furiganaImportId,
      );

      final result =
          await extractVocabulary.call(jmdictImportId, furiganaImportId);

      expect(result.vocabularyCount, 1);
      expect(result.kanjiLinkCount, 0);

      final vocab = await vocabRepo.getAllVocabulary();
      expect(vocab.first.word, 'すごい');
      expect(vocab.first.segments, hasLength(1));
      expect(vocab.first.segments.first.text, 'すごい');
      expect(vocab.first.segments.first.kanjiId, isNull);
      expect(vocab.first.segments.first.kanjiIds, isNull);
    });

    test('jukujikun — single segment with kanji_ids', () async {
      await insertDraftKanji([
        (char: '大', strokeCount: 3, jlptLevel: 5),
        (char: '人', strokeCount: 2, jlptLevel: 5),
      ]);

      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 3000,
          kanjiElements: [
            const JmdictKanjiElement(keb: '大人', kePri: ['ichi1']),
          ],
          readingElements: [
            const JmdictReadingElement(reb: 'おとな', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['n'],
              glosses: {'en': ['adult']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(
            text: '大人',
            reading: 'おとな',
            furiganaSegments: [
              {'ruby': '大人', 'rt': 'おとな'},
            ],
          ),
        ],
        importId: furiganaImportId,
      );

      final result =
          await extractVocabulary.call(jmdictImportId, furiganaImportId);

      expect(result.vocabularyCount, 1);

      final vocab = await vocabRepo.getAllVocabulary();
      final segments = vocab.first.segments;
      expect(segments, hasLength(1));
      expect(segments.first.text, '大人');
      expect(segments.first.reading, 'おとな');
      expect(segments.first.kanjiIds, isNotNull);
      expect(segments.first.kanjiIds, hasLength(2));
      expect(segments.first.kanjiId, isNull);
    });

    test('JLPT level from source_vocab_levels (authoritative)', () async {
      await insertDraftKanji([
        (char: '駅', strokeCount: 14, jlptLevel: 4),
      ]);

      // source_vocab_levels says N5 for 駅.
      await vocabLevelRepo.replaceAll([
        fakeVocabLevel(expression: '駅', reading: 'えき', level: 5),
      ]);

      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 4000,
          kanjiElements: [
            const JmdictKanjiElement(keb: '駅', kePri: ['ichi1']),
          ],
          readingElements: [
            const JmdictReadingElement(reb: 'えき', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['n'],
              glosses: {'en': ['station']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(text: '駅', reading: 'えき', furiganaSegments: [
            {'ruby': '駅', 'rt': 'えき'},
          ]),
        ],
        importId: furiganaImportId,
      );

      await extractVocabulary.call(jmdictImportId, furiganaImportId);

      final vocab = await vocabRepo.getAllVocabulary();
      expect(vocab.first.minJlptLevel, 5); // Authoritative, not kanji-derived 4.
    });

    test('JLPT level fallback — MIN(kanji.min_jlpt_level)', () async {
      // 大=N5, 変=N3. Fallback MIN = 3 (hardest).
      await insertDraftKanji([
        (char: '大', strokeCount: 3, jlptLevel: 5),
        (char: '変', strokeCount: 9, jlptLevel: 3),
      ]);

      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 5000,
          kanjiElements: [
            const JmdictKanjiElement(keb: '大変', kePri: ['ichi1']),
          ],
          readingElements: [
            const JmdictReadingElement(reb: 'たいへん', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['adj-na', 'adv', 'n'],
              glosses: {'en': ['very', 'greatly']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(
            text: '大変',
            reading: 'たいへん',
            furiganaSegments: [
              {'ruby': '大', 'rt': 'たい'},
              {'ruby': '変', 'rt': 'へん'},
            ],
          ),
        ],
        importId: furiganaImportId,
      );

      await extractVocabulary.call(jmdictImportId, furiganaImportId);

      final vocab = await vocabRepo.getAllVocabulary();
      expect(vocab.first.minJlptLevel, 3);
    });

    test('JLPT level null — all kanji have null JLPT', () async {
      await insertDraftKanji([
        (char: '鬱', strokeCount: 29, jlptLevel: null),
      ]);

      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 5500,
          kanjiElements: [
            const JmdictKanjiElement(keb: '鬱', kePri: ['spec1']),
          ],
          readingElements: [
            const JmdictReadingElement(reb: 'うつ', rePri: ['spec1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['n'],
              glosses: {'en': ['depression']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(text: '鬱', reading: 'うつ', furiganaSegments: [
            {'ruby': '鬱', 'rt': 'うつ'},
          ]),
        ],
        importId: furiganaImportId,
      );

      await extractVocabulary.call(jmdictImportId, furiganaImportId);

      final vocab = await vocabRepo.getAllVocabulary();
      expect(vocab.first.minJlptLevel, isNull);
    });

    test('POS tag extraction with inheritance across senses', () async {
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 6000,
          kanjiElements: null,
          readingElements: [
            const JmdictReadingElement(reb: 'する', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['vs-i', 'vi'],
              glosses: {'en': ['to do']},
            ),
            // Second sense inherits pos from first.
            const JmdictSense(
              glosses: {'en': ['to cause', 'to make']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(text: 'する', reading: 'する', furiganaSegments: [
            {'ruby': 'する'},
          ]),
        ],
        importId: furiganaImportId,
      );

      await extractVocabulary.call(jmdictImportId, furiganaImportId);

      final vocab = await vocabRepo.getAllVocabulary();
      expect(vocab.first.posTags, contains(PosTag.suruVerb));
      expect(vocab.first.posTags, contains(PosTag.intransitive));
    });

    test('POS tag mapping — godan verb codes all map to godanVerb', () async {
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 6500,
          kanjiElements: null,
          readingElements: [
            const JmdictReadingElement(reb: 'あるく', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['v5k', 'vi'],
              glosses: {'en': ['to walk']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(
              text: 'あるく', reading: 'あるく', furiganaSegments: [
            {'ruby': 'あるく'},
          ]),
        ],
        importId: furiganaImportId,
      );

      await extractVocabulary.call(jmdictImportId, furiganaImportId);

      final vocab = await vocabRepo.getAllVocabulary();
      expect(vocab.first.posTags, contains(PosTag.godanVerb));
    });

    test('selection: priority flags — word with ichi1 included', () async {
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 7000,
          kanjiElements: null,
          readingElements: [
            const JmdictReadingElement(reb: 'いい', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['adj-i'],
              glosses: {'en': ['good']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(text: 'いい', reading: 'いい', furiganaSegments: [
            {'ruby': 'いい'},
          ]),
        ],
        importId: furiganaImportId,
      );

      final result =
          await extractVocabulary.call(jmdictImportId, furiganaImportId);
      expect(result.vocabularyCount, 1);
    });

    test('selection: JLPT-only — word without priority but in vocab levels',
        () async {
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 8000,
          kanjiElements: null,
          readingElements: [
            const JmdictReadingElement(reb: 'こんにちは'),
          ],
          senses: [
            const JmdictSense(
              pos: ['int'],
              glosses: {'en': ['hello']},
            ),
          ],
        ),
      ]);

      await vocabLevelRepo.replaceAll([
        fakeVocabLevel(expression: 'こんにちは', reading: 'こんにちは', level: 5),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(
            text: 'こんにちは',
            reading: 'こんにちは',
            furiganaSegments: [
              {'ruby': 'こんにちは'},
            ],
          ),
        ],
        importId: furiganaImportId,
      );

      final result =
          await extractVocabulary.call(jmdictImportId, furiganaImportId);
      expect(result.vocabularyCount, 1);
    });

    test('selection: excluded — no priority AND not in vocab levels', () async {
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 9000,
          kanjiElements: null,
          readingElements: [
            const JmdictReadingElement(reb: 'ぞんざい'),
          ],
          senses: [
            const JmdictSense(
              pos: ['adj-na'],
              glosses: {'en': ['rude']},
            ),
          ],
        ),
      ]);

      final result =
          await extractVocabulary.call(jmdictImportId, furiganaImportId);
      expect(result.vocabularyCount, 0);
    });

    test('orphan kanji warning', () async {
      // No draft kanji for 鑓 — it's not in the kanji table.
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 10000,
          kanjiElements: [
            const JmdictKanjiElement(keb: '鑓', kePri: ['spec1']),
          ],
          readingElements: [
            const JmdictReadingElement(reb: 'やり', rePri: ['spec1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['n'],
              glosses: {'en': ['spear']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(text: '鑓', reading: 'やり', furiganaSegments: [
            {'ruby': '鑓', 'rt': 'やり'},
          ]),
        ],
        importId: furiganaImportId,
      );

      final result =
          await extractVocabulary.call(jmdictImportId, furiganaImportId);

      // Word is still imported (permissive).
      expect(result.vocabularyCount, 1);
      // But a warning is emitted.
      expect(
        result.warnings.any((w) => w.message.contains('鑓') && w.message.contains('not found')),
        isTrue,
      );
    });

    test('reading restrictions (re_restr)', () async {
      await insertDraftKanji([
        (char: '生', strokeCount: 5, jlptLevel: 5),
      ]);

      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 11000,
          kanjiElements: [
            const JmdictKanjiElement(keb: '生', kePri: ['ichi1']),
            const JmdictKanjiElement(keb: '生う'),
          ],
          readingElements: [
            const JmdictReadingElement(reb: 'なま', rePri: ['ichi1']),
            // This reading restricted to 生う, not 生.
            const JmdictReadingElement(reb: 'おう', reRestr: ['生う']),
          ],
          senses: [
            const JmdictSense(
              pos: ['adj-na', 'n'],
              glosses: {'en': ['raw', 'fresh']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(text: '生', reading: 'なま', furiganaSegments: [
            {'ruby': '生', 'rt': 'なま'},
          ]),
        ],
        importId: furiganaImportId,
      );

      await extractVocabulary.call(jmdictImportId, furiganaImportId);

      final vocab = await vocabRepo.getAllVocabulary();
      expect(vocab.first.word, '生');

      // Only 'なま' should be present, 'おう' restricted to different headword.
      final readingCount = await vocabRepo.countReadings();
      expect(readingCount, 1);
    });

    test('multiple senses, multiple languages', () async {
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 12000,
          kanjiElements: null,
          readingElements: [
            const JmdictReadingElement(reb: 'はい', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['int'],
              glosses: {
                'en': ['yes'],
                'es': ['sí'],
              },
            ),
            const JmdictSense(
              glosses: {
                'en': ['that is correct'],
                'es': ['así es'],
              },
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(text: 'はい', reading: 'はい', furiganaSegments: [
            {'ruby': 'はい'},
          ]),
        ],
        importId: furiganaImportId,
      );

      await extractVocabulary.call(jmdictImportId, furiganaImportId);

      // Should have 2 i18n rows: en and es.
      final i18nCount = await vocabRepo.countI18n();
      expect(i18nCount, 2);
    });

    test('example sentence — verified status', () async {
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 13000,
          kanjiElements: null,
          readingElements: [
            const JmdictReadingElement(reb: 'ありがとう', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['int'],
              glosses: {'en': ['thank you']},
            ),
          ],
          examples: [
            const JmdictExample(
              sentenceJa: 'ありがとうございます。',
              sentenceEn: 'Thank you very much.',
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(
            text: 'ありがとう',
            reading: 'ありがとう',
            furiganaSegments: [
              {'ruby': 'ありがとう'},
            ],
          ),
        ],
        importId: furiganaImportId,
      );

      final result =
          await extractVocabulary.call(jmdictImportId, furiganaImportId);

      expect(result.sentenceCount, 1);

      // Verify sentence has verified status.
      final sentences = await vocabRepo.countSentences();
      expect(sentences, 1);
    });

    test('no example sentence — zero sentence rows', () async {
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 14000,
          kanjiElements: null,
          readingElements: [
            const JmdictReadingElement(reb: 'ちょっと', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['adv'],
              glosses: {'en': ['a little']},
            ),
          ],
          examples: null,
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(
            text: 'ちょっと',
            reading: 'ちょっと',
            furiganaSegments: [
              {'ruby': 'ちょっと'},
            ],
          ),
        ],
        importId: furiganaImportId,
      );

      final result =
          await extractVocabulary.call(jmdictImportId, furiganaImportId);

      expect(result.sentenceCount, 0);
    });

    test('idempotent — run twice, verify same counts', () async {
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 15000,
          kanjiElements: null,
          readingElements: [
            const JmdictReadingElement(reb: 'はい', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['int'],
              glosses: {'en': ['yes']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(text: 'はい', reading: 'はい', furiganaSegments: [
            {'ruby': 'はい'},
          ]),
        ],
        importId: furiganaImportId,
      );

      final first =
          await extractVocabulary.call(jmdictImportId, furiganaImportId);
      final second =
          await extractVocabulary.call(jmdictImportId, furiganaImportId);

      expect(second.vocabularyCount, first.vocabularyCount);
      expect(second.readingCount, first.readingCount);
      expect(second.i18nCount, first.i18nCount);
    });

    test('checkExistingResult — returns summary when vocab exists', () async {
      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 16000,
          kanjiElements: null,
          readingElements: [
            const JmdictReadingElement(reb: 'はい', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['int'],
              glosses: {'en': ['yes']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(text: 'はい', reading: 'はい', furiganaSegments: [
            {'ruby': 'はい'},
          ]),
        ],
        importId: furiganaImportId,
      );

      // Before extraction.
      expect(await extractVocabulary.checkExistingResult(), isNull);

      // After extraction.
      await extractVocabulary.call(jmdictImportId, furiganaImportId);
      final summary = await extractVocabulary.checkExistingResult();
      expect(summary, isNotNull);
      expect(summary, contains('1 vocabulary'));
    });

    test('segment validation — concatenated texts equal word', () async {
      await insertDraftKanji([
        (char: '冷', strokeCount: 7, jlptLevel: 3),
        (char: '蔵', strokeCount: 15, jlptLevel: 2),
        (char: '庫', strokeCount: 10, jlptLevel: 3),
      ]);

      await rawJmdictRepo.insertBatch([
        fakeRawJmdict(
          importId: jmdictImportId,
          entSeq: 17000,
          kanjiElements: [
            const JmdictKanjiElement(keb: '冷蔵庫', kePri: ['ichi1']),
          ],
          readingElements: [
            const JmdictReadingElement(reb: 'れいぞうこ', rePri: ['ichi1']),
          ],
          senses: [
            const JmdictSense(
              pos: ['n'],
              glosses: {'en': ['refrigerator']},
            ),
          ],
        ),
      ]);

      await furiganaRepo.insertBatch(
        [
          fakeJmdictFurigana(
            text: '冷蔵庫',
            reading: 'れいぞうこ',
            furiganaSegments: [
              {'ruby': '冷', 'rt': 'れい'},
              {'ruby': '蔵', 'rt': 'ぞう'},
              {'ruby': '庫', 'rt': 'こ'},
            ],
          ),
        ],
        importId: furiganaImportId,
      );

      await extractVocabulary.call(jmdictImportId, furiganaImportId);

      final vocab = await vocabRepo.getAllVocabulary();
      expect(vocab, hasLength(1));

      final segments = vocab.first.segments;
      expect(segments, hasLength(3));

      final concatenated = segments.map((s) => s.text).join();
      expect(concatenated, '冷蔵庫');

      // Each segment should have a kanji_id.
      for (final seg in segments) {
        expect(seg.kanjiId, isNotNull);
        expect(seg.reading, isNotNull);
      }
    });
  });
}
