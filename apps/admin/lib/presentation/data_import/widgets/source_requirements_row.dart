import 'package:flutter/material.dart';
import 'package:kanji_craft_admin/domain/entities/data_import.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';
import 'package:kanji_craft_admin/domain/entities/import_status.dart';

const _sourceLabels = {
  ImportSource.kanjivg: 'KanjiVG',
  ImportSource.kanjidic: 'KANJIDIC',
  ImportSource.jmdict: 'JMDict',
  ImportSource.jmdictFurigana: 'JMDict Furigana',
};

class SourceRequirementsRow extends StatelessWidget {
  const SourceRequirementsRow({required this.imports, super.key});

  final List<DataImport> imports;

  Set<ImportSource> get _processedSources => imports
      .where((i) => i.status == ImportStatus.processed)
      .map((i) => i.source)
      .toSet();

  @override
  Widget build(BuildContext context) {
    final processed = _processedSources;
    final allReady = ImportSource.values.every(processed.contains);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final source in ImportSource.values)
              _SourceChip(
                label: _sourceLabels[source]!,
                isReady: processed.contains(source),
                colorScheme: colorScheme,
              ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: allReady ? () {} : null,
              child: const Text('Proceed to Extraction'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({
    required this.label,
    required this.isReady,
    required this.colorScheme,
  });

  final String label;
  final bool isReady;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    if (isReady) {
      return Chip(
        avatar: Icon(Icons.check, size: 18, color: colorScheme.onPrimary),
        label: Text(label, style: TextStyle(color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        side: BorderSide.none,
      );
    }

    return Chip(
      avatar: Icon(Icons.close, size: 18, color: colorScheme.outline),
      label: Text(label, style: TextStyle(color: colorScheme.outline)),
      backgroundColor: Colors.transparent,
      side: BorderSide(color: colorScheme.outline),
    );
  }
}
