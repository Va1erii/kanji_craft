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

  Set<ImportSource> get _ingestedSources => imports
      .where((i) => i.status == ImportStatus.ingested)
      .map((i) => i.source)
      .toSet();

  @override
  Widget build(BuildContext context) {
    final ingested = _ingestedSources;
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
                isReady: ingested.contains(source),
                colorScheme: colorScheme,
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
    final style = Theme.of(context).textTheme.labelSmall;

    if (isReady) {
      return Chip(
        avatar: Icon(Icons.check, size: 14, color: colorScheme.onSecondaryContainer),
        label: Text(label, style: style?.copyWith(color: colorScheme.onSecondaryContainer)),
        backgroundColor: colorScheme.secondaryContainer,
        side: BorderSide.none,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      );
    }

    return Chip(
      avatar: Icon(Icons.close, size: 14, color: colorScheme.outline),
      label: Text(label, style: style?.copyWith(color: colorScheme.outline)),
      backgroundColor: Colors.transparent,
      side: BorderSide(color: colorScheme.outlineVariant),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
