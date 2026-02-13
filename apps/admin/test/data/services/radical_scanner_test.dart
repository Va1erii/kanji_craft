import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_craft_admin/data/services/radical_scanner.dart';
import 'package:kanji_craft_admin/domain/entities/raw_kanjivg.dart';
import 'package:kanji_craft_core/kanji_craft_core.dart';

import '../../helpers/admin_fixtures.dart';

void main() {
  late RadicalScanner scanner;

  setUp(() {
    scanner = RadicalScanner();
  });

  /// Scan with a keep set that keeps all elements (no ghost flattening).
  /// Used by existing tests that don't exercise ghost flattening.
  RadicalScanResult scanKeepAll(List<RawKanjiVg> entries) {
    // Collect every element seen in any tree to build a universal keep set.
    final keepSet = <String>{};
    void walk(KanjiVgComponent c) {
      if (c.element.isNotEmpty) keepSet.add(c.element);
      if (c.original != null) keepSet.add(c.original!);
      for (final child in c.children) {
        walk(child);
      }
    }
    for (final e in entries) {
      keepSet.add(e.character);
      walk(e.components);
    }

    final treeMap = scanner.buildTreeMap(entries);
    return scanner.scan(entries, keepSet: keepSet, treeMap: treeMap);
  }

  group('RadicalScanner', () {
    group('simple decomposition', () {
      test('休 = 亻 (variant of 人) + 木', () {
        // 休 root with two direct children
        final entries = [
          fakeRawKanjiVg(
            character: '休',
            components: fakeComponent(
              element: '休',
              children: [
                fakeComponent(
                  element: '亻',
                  position: 'left',
                  variant: true,
                  original: '人',
                  radical: 'general',
                ),
                fakeComponent(
                  element: '木',
                  position: 'right',
                ),
              ],
            ),
          ),
        ];

        final result = scanKeepAll(entries);

        expect(result.masters, hasLength(2));

        // 人 master (from variant 亻)
        final jin = result.masters['人']!;
        expect(jin.isOfficial, isTrue);
        expect(jin.variants, contains('亻'));
        expect(jin.variants['亻']!.isExplicitVariant, isTrue);
        expect(jin.variants['亻']!.positionCounts, {Position.hen: 1});

        // 木 master (self)
        final ki = result.masters['木']!;
        expect(ki.isOfficial, isFalse);
        expect(ki.variants, contains('木'));
        expect(ki.variants['木']!.isExplicitVariant, isFalse);
        expect(ki.variants['木']!.positionCounts, {Position.tsukuri: 1});
      });
    });

    group('progressive decomposition', () {
      test('語 records only direct children 言 + 吾 (not 五, 口)', () {
        final entries = [
          fakeRawKanjiVg(
            character: '語',
            components: fakeComponent(
              element: '語',
              children: [
                fakeComponent(element: '言', position: 'left'),
                fakeComponent(
                  element: '吾',
                  position: 'right',
                  children: [
                    fakeComponent(element: '五', position: 'top'),
                    fakeComponent(element: '口', position: 'bottom'),
                  ],
                ),
              ],
            ),
          ),
        ];

        final result = scanKeepAll(entries);

        // Only direct children: 言 and 吾
        expect(result.masters, hasLength(2));
        expect(result.masters, contains('言'));
        expect(result.masters, contains('吾'));
        // 五 and 口 are NOT extracted (they're deeper children)
        expect(result.masters, isNot(contains('五')));
        expect(result.masters, isNot(contains('口')));
      });
    });

    group('variant handling', () {
      test('清 maps 氵 variant to master 水', () {
        final entries = [
          fakeRawKanjiVg(
            character: '清',
            components: fakeComponent(
              element: '清',
              children: [
                fakeComponent(
                  element: '氵',
                  position: 'left',
                  variant: true,
                  original: '水',
                ),
                fakeComponent(element: '青', position: 'right'),
              ],
            ),
          ),
        ];

        final result = scanKeepAll(entries);

        expect(result.masters, contains('水'));
        expect(result.masters['水']!.variants, contains('氵'));
        expect(
          result.masters['水']!.variants['氵']!.isExplicitVariant,
          isTrue,
        );
        // Master 水 should not have a self-variant (not seen directly)
        expect(result.masters['水']!.variants, isNot(contains('水')));
      });

      test('variant without original logs warning and treats as own master',
          () {
        final entries = [
          fakeRawKanjiVg(
            character: '某',
            components: fakeComponent(
              element: '某',
              children: [
                fakeComponent(
                  element: '甘',
                  position: 'top',
                  variant: true,
                  // no original
                ),
              ],
            ),
          ),
        ];

        final result = scanKeepAll(entries);

        // 甘 becomes its own master
        expect(result.masters, contains('甘'));
        expect(result.masters['甘']!.variants['甘']!.isExplicitVariant, isFalse);
        expect(result.warnings, isNotEmpty);
        expect(result.warnings.first.message, contains('甘'));
      });
    });

    group('split parts', () {
      test('道 merges two 辶 parts into one component', () {
        final entries = [
          fakeRawKanjiVg(
            character: '道',
            components: fakeComponent(
              element: '道',
              children: [
                fakeComponent(
                  element: '辶',
                  position: 'nyo',
                  part: 1,
                ),
                fakeComponent(element: '首', position: 'top'),
                fakeComponent(
                  element: '辶',
                  part: 2,
                ),
              ],
            ),
          ),
        ];

        final result = scanKeepAll(entries);

        expect(result.masters, hasLength(2));
        expect(result.masters, contains('辶'));
        expect(result.masters, contains('首'));

        // 辶 is only counted once (merged parts)
        final shinnyou = result.masters['辶']!;
        expect(shinnyou.variants['辶']!.positionCounts, {Position.nyo: 1});
      });

      test('split part takes position from first part that carries it', () {
        final entries = [
          fakeRawKanjiVg(
            character: '遠',
            components: fakeComponent(
              element: '遠',
              children: [
                fakeComponent(element: '辶', part: 1),
                fakeComponent(element: '袁', position: 'right'),
                fakeComponent(element: '辶', part: 2, position: 'nyo'),
              ],
            ),
          ),
        ];

        final result = scanKeepAll(entries);

        // Position should come from part 2 (first non-null position)
        final shinnyou = result.masters['辶']!;
        expect(shinnyou.variants['辶']!.positionCounts, {Position.nyo: 1});
      });
    });

    group('leaf kanji', () {
      test('kanji with no children produces no candidates', () {
        final entries = [
          fakeRawKanjiVg(
            character: '一',
            components: fakeComponent(element: '一', children: []),
          ),
        ];

        final result = scanKeepAll(entries);

        expect(result.masters, isEmpty);
      });
    });

    group('structural flattening', () {
      test('empty element groups are flattened (children promoted)', () {
        // Root has a structural group with empty element containing real children
        final entries = [
          fakeRawKanjiVg(
            character: '花',
            components: fakeComponent(
              element: '花',
              children: [
                fakeComponent(
                  element: '', // structural group
                  children: [
                    fakeComponent(element: '艹', position: 'top'),
                    fakeComponent(element: '化', position: 'bottom'),
                  ],
                ),
              ],
            ),
          ),
        ];

        final result = scanKeepAll(entries);

        // Both children should be promoted past the empty group
        expect(result.masters, hasLength(2));
        expect(result.masters, contains('艹'));
        expect(result.masters, contains('化'));
      });

      test('nested empty element groups are recursively flattened', () {
        final entries = [
          fakeRawKanjiVg(
            character: '某',
            components: fakeComponent(
              element: '某',
              children: [
                fakeComponent(
                  element: '',
                  children: [
                    fakeComponent(
                      element: '',
                      children: [
                        fakeComponent(element: '木', position: 'bottom'),
                      ],
                    ),
                  ],
                ),
                fakeComponent(element: '口', position: 'top'),
              ],
            ),
          ),
        ];

        final result = scanKeepAll(entries);

        expect(result.masters, hasLength(2));
        expect(result.masters, contains('木'));
        expect(result.masters, contains('口'));
      });
    });

    group('position mapping', () {
      test('maps all KanjiVG position strings correctly', () {
        expect(mapKanjiVgPosition('left'), Position.hen);
        expect(mapKanjiVgPosition('right'), Position.tsukuri);
        expect(mapKanjiVgPosition('top'), Position.kanmuri);
        expect(mapKanjiVgPosition('bottom'), Position.ashi);
        expect(mapKanjiVgPosition('kamae'), Position.kamae);
        expect(mapKanjiVgPosition('tare'), Position.tare);
        expect(mapKanjiVgPosition('nyo'), Position.nyo);
        expect(mapKanjiVgPosition(null), Position.unknown);
        expect(mapKanjiVgPosition('tarec'), Position.unknown);
        expect(mapKanjiVgPosition('nyoc'), Position.unknown);
        expect(mapKanjiVgPosition('other'), Position.unknown);
      });
    });

    group('aggregation across multiple entries', () {
      test('accumulates position counts across kanji trees', () {
        final entries = [
          // 休: 亻(left, variant of 人) + 木(right)
          fakeRawKanjiVg(
            character: '休',
            components: fakeComponent(
              element: '休',
              children: [
                fakeComponent(
                  element: '亻',
                  position: 'left',
                  variant: true,
                  original: '人',
                ),
                fakeComponent(element: '木', position: 'right'),
              ],
            ),
          ),
          // 体: 亻(left, variant of 人) + 本(right)
          fakeRawKanjiVg(
            character: '体',
            components: fakeComponent(
              element: '体',
              children: [
                fakeComponent(
                  element: '亻',
                  position: 'left',
                  variant: true,
                  original: '人',
                ),
                fakeComponent(element: '本', position: 'right'),
              ],
            ),
          ),
          // 林: 木(left) + 木(right) — same element twice, no parts
          fakeRawKanjiVg(
            character: '林',
            components: fakeComponent(
              element: '林',
              children: [
                fakeComponent(element: '木', position: 'left'),
                fakeComponent(element: '木', position: 'right'),
              ],
            ),
          ),
        ];

        final result = scanKeepAll(entries);

        // 亻 appears 2 times at hen
        final jin = result.masters['人']!;
        expect(jin.variants['亻']!.positionCounts, {Position.hen: 2});

        // 木 appears: 1x right (休) + 1x left (林) + 1x right (林)
        final ki = result.masters['木']!;
        expect(ki.variants['木']!.positionCounts[Position.tsukuri], 2);
        expect(ki.variants['木']!.positionCounts[Position.hen], 1);
      });

      test('is_official propagates if any occurrence has radical=general', () {
        final entries = [
          fakeRawKanjiVg(
            character: '休',
            components: fakeComponent(
              element: '休',
              children: [
                fakeComponent(element: '木', position: 'right'),
              ],
            ),
          ),
          fakeRawKanjiVg(
            character: '村',
            components: fakeComponent(
              element: '村',
              children: [
                fakeComponent(
                  element: '木',
                  position: 'left',
                  radical: 'general',
                ),
                fakeComponent(element: '寸', position: 'right'),
              ],
            ),
          ),
        ];

        final result = scanKeepAll(entries);

        // 木 should be official (seen with radical=general in 村)
        expect(result.masters['木']!.isOfficial, isTrue);
      });
    });

    group('edge cases', () {
      test('empty entries list produces empty result', () {
        final result = scanner.scan([], keepSet: {}, treeMap: {});
        expect(result.masters, isEmpty);
      });

      test('nelson radical marker does not affect is_official', () {
        final entries = [
          fakeRawKanjiVg(
            character: '化',
            components: fakeComponent(
              element: '化',
              children: [
                fakeComponent(
                  element: '亻',
                  position: 'left',
                  variant: true,
                  original: '人',
                  radical: 'nelson',
                ),
                fakeComponent(element: '匕', position: 'right'),
              ],
            ),
          ),
        ];

        final result = scanKeepAll(entries);

        // nelson does not set isOfficial
        expect(result.masters['人']!.isOfficial, isFalse);
      });
    });

    group('keep set helpers', () {
      test('buildOfficialSet collects radical=general from all entries', () {
        final entries = [
          fakeRawKanjiVg(
            character: '休',
            components: fakeComponent(
              element: '休',
              children: [
                fakeComponent(
                  element: '亻',
                  variant: true,
                  original: '人',
                  radical: 'general',
                ),
                fakeComponent(element: '木'),
              ],
            ),
          ),
          fakeRawKanjiVg(
            character: '村',
            components: fakeComponent(
              element: '村',
              children: [
                fakeComponent(element: '木', radical: 'general'),
                fakeComponent(element: '寸'),
              ],
            ),
          ),
        ];

        final officials = scanner.buildOfficialSet(entries);
        expect(officials, containsAll(['人', '木']));
        expect(officials, isNot(contains('寸')));
      });

      test('countFrequencies deduplicates per kanji', () {
        final entries = [
          // 林 has 木 twice — should count as 1
          fakeRawKanjiVg(
            character: '林',
            components: fakeComponent(
              element: '林',
              children: [
                fakeComponent(element: '木', position: 'left'),
                fakeComponent(element: '木', position: 'right'),
              ],
            ),
          ),
          // 休 also has 木
          fakeRawKanjiVg(
            character: '休',
            components: fakeComponent(
              element: '休',
              children: [
                fakeComponent(element: '木', position: 'right'),
              ],
            ),
          ),
        ];

        final freq = scanner.countFrequencies(entries);
        expect(freq['木'], 2); // appears in 2 kanji, not 3
      });

      test('buildKeepSet merges scope, official, and high-frequency', () {
        final keepSet = RadicalScanner.buildKeepSet(
          scopeSet: {'A', 'B'},
          officialSet: {'C'},
          frequencies: {'D': 3, 'E': 2, 'F': 5},
          threshold: 3,
        );
        expect(keepSet, containsAll(['A', 'B', 'C', 'D', 'F']));
        expect(keepSet, isNot(contains('E'))); // freq 2 < threshold 3
      });
    });

    group('ghost flattening in scan', () {
      test('flattens ghost radical during scan', () {
        // X has child G (ghost, not in keep set).
        // G's tree has children A and B (in keep set).
        final entries = [
          fakeRawKanjiVg(
            character: 'X',
            components: fakeComponent(
              element: 'X',
              children: [
                fakeComponent(element: 'G', position: 'right'),
              ],
            ),
          ),
        ];

        // G's tree (for ghost lookup)
        final gEntry = fakeRawKanjiVg(
          character: 'G',
          components: fakeComponent(
            element: 'G',
            children: [
              fakeComponent(element: 'A', position: 'top'),
              fakeComponent(element: 'B', position: 'bottom'),
            ],
          ),
        );

        final treeMap = scanner.buildTreeMap([...entries, gEntry]);
        final keepSet = {'X', 'A', 'B'}; // G not in keep set

        final result = scanner.scan(entries, keepSet: keepSet, treeMap: treeMap);

        expect(result.masters.keys, containsAll(['A', 'B']));
        expect(result.masters.keys, isNot(contains('G')));
        expect(result.ghostsFlattenedCount, 1);
      });

      test('unflattenable ghost becomes leaf', () {
        final entries = [
          fakeRawKanjiVg(
            character: 'X',
            components: fakeComponent(
              element: 'X',
              children: [
                fakeComponent(element: 'G', position: 'right'),
              ],
            ),
          ),
        ];

        // G has no entry → unflattenable
        final treeMap = scanner.buildTreeMap(entries);
        final keepSet = {'X'}; // G not in keep set

        final result = scanner.scan(entries, keepSet: keepSet, treeMap: treeMap);

        // G is kept as unflattenable leaf
        expect(result.masters, contains('G'));
        expect(result.warnings.any((w) => w.message.contains('unflattenable')),
            isTrue);
      });
    });
  });
}
