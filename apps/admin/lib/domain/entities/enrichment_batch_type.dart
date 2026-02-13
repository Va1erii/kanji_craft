enum EnrichmentBatchType {
  radicalMnemonics(
    batchNumber: 1,
    label: 'Radical Mnemonics',
    description: 'System mnemonics and search tags for radicals',
  ),
  kanjiMnemonics(
    batchNumber: 2,
    label: 'Kanji Mnemonics',
    description: 'System mnemonics and search tags for kanji',
  ),
  sentenceTranslation(
    batchNumber: 3,
    label: 'Sentence Translation',
    description: 'Translate example sentences into target languages',
  ),
  sentenceFurigana(
    batchNumber: 4,
    label: 'Sentence Furigana',
    description: 'Add furigana notation to Japanese sentences',
  );

  const EnrichmentBatchType({
    required this.batchNumber,
    required this.label,
    required this.description,
  });

  final int batchNumber;
  final String label;
  final String description;
}
