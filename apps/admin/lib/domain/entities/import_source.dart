/// Which external dataset an import run targets.
///
/// - [kanjivg] — KanjiVG stroke and component data.
/// - [kanjidic] — KANJIDIC2 dictionary data.
/// - [jmdict] — JMdict vocabulary and sentence data.
/// - [jmdictFurigana] — Pre-computed furigana mappings from JmdictFurigana.
enum ImportSource { kanjivg, kanjidic, jmdict, jmdictFurigana }
