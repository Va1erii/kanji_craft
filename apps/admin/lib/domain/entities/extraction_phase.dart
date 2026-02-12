import 'import_source.dart';

/// Phases of the extraction pipeline (Phase 2).
///
/// Enum values are declared in dependency order — earlier phases never
/// depend on later ones, which lets [ExtractionBloc] iterate in
/// `ExtractionPhase.values` order when recomputing statuses.
enum ExtractionPhase {
  radicalExtraction(
    label: 'Radical Extraction',
    description: 'Scan KanjiVG for radical masters and shape variants',
    phaseNumber: '2.2',
    isImplemented: true,
    requiredSources: {ImportSource.kanjivg},
  ),
  kanjiComposition(
    label: 'Kanji Composition',
    description: 'Create kanji rows, readings, and i18n from KANJIDIC',
    phaseNumber: '2.3',
    isImplemented: true,
    requiredSources: {ImportSource.kanjidic},
  ),
  svgProcessing(
    label: 'SVG Processing',
    description: 'Match SVG files to radicals, variants, and kanji',
    phaseNumber: '2.4',
    isImplemented: true,
    requiredSources: {ImportSource.kanjivg},
  ),
  vocabularyExtraction(
    label: 'Vocabulary Extraction',
    description: 'Extract vocabulary, readings, and kanji links from JMdict',
    phaseNumber: '2.5',
    isImplemented: true,
    requiredSources: {ImportSource.jmdict, ImportSource.jmdictFurigana},
  ),
  aiEnrichment(
    label: 'AI Enrichment',
    description: 'Logic hints, mnemonics, translations, and furigana',
    phaseNumber: '2.6',
    isImplemented: false,
    requiredSources: {},
  );

  const ExtractionPhase({
    required this.label,
    required this.description,
    required this.phaseNumber,
    required this.isImplemented,
    required this.requiredSources,
  });

  final String label;
  final String description;
  final String phaseNumber;
  final bool isImplemented;
  final Set<ImportSource> requiredSources;

  /// Phases that must complete before this one can run.
  ///
  /// Expressed as a getter to avoid forward references within the enum.
  Set<ExtractionPhase> get requiredPhases => switch (this) {
        radicalExtraction => const {},
        kanjiComposition => const {},
        svgProcessing => const {radicalExtraction, kanjiComposition},
        vocabularyExtraction => const {kanjiComposition},
        aiEnrichment => const {kanjiComposition, svgProcessing, vocabularyExtraction},
      };
}
