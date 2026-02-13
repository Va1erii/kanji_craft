enum EnrichmentBatchType {
  radicalMnemonics(
    batchNumber: 1,
    label: 'Radical Mnemonics',
    description: 'System mnemonics and search tags for radicals',
    batchSize: 150,
  ),
  kanjiMnemonics(
    batchNumber: 2,
    label: 'Kanji Mnemonics',
    description: 'System mnemonics and search tags for kanji',
    batchSize: 1000,
  ),
  sentenceTranslation(
    batchNumber: 3,
    label: 'Sentence Translation',
    description: 'Translate example sentences into target languages',
    batchSize: 150,
  ),
  sentenceFurigana(
    batchNumber: 4,
    label: 'Sentence Furigana',
    description: 'Add furigana notation to Japanese sentences',
    batchSize: 150,
  );

  const EnrichmentBatchType({
    required this.batchNumber,
    required this.label,
    required this.description,
    required this.batchSize,
  });

  final int batchNumber;
  final String label;
  final String description;
  final int batchSize;
}
