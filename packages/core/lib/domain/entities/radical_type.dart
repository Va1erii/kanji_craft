/// The role a component plays within a specific kanji, as classified by
/// KanjiVG's `kvg:radical` attribute.
///
/// - [general] — the generally accepted dictionary radical for this kanji.
/// - [tradit] — the traditional Kangxi radical (when it differs from general).
/// - [nelson] — the Nelson dictionary radical.
/// - [jis] — the JIS Kanji Jiten radical (used by KANJIDIC).
/// - [component] — a normal building block with no radical designation.
enum RadicalType {
  general,
  tradit,
  nelson,
  jis,
  component,
}
