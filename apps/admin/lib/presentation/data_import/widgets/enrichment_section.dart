import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/enrichment_batch_type.dart';
import '../../../domain/entities/warning.dart';
import '../bloc/enrichment_bloc.dart';
import '../bloc/enrichment_event.dart';
import '../bloc/enrichment_state.dart';

class EnrichmentSection extends StatelessWidget {
  const EnrichmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnrichmentBloc, EnrichmentState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CSV Enrichment',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _OutputDirRow(outputDir: state.outputDir),
            const SizedBox(height: 4),
            for (final batchType in EnrichmentBatchType.values) ...[
              _BatchTypeRow(
                batchType: batchType,
                status: state.batches[batchType] ?? const BatchTypeIdle(),
              ),
              if (state.batches[batchType] is BatchTypeReady)
                for (var i = 0;
                    i <
                        (state.batches[batchType] as BatchTypeReady)
                            .subBatches
                            .length;
                    i++)
                  _SubBatchRow(
                    batchType: batchType,
                    index: i,
                    totalSubBatches:
                        (state.batches[batchType] as BatchTypeReady)
                            .subBatches
                            .length,
                    totalCount:
                        (state.batches[batchType] as BatchTypeReady)
                            .totalCount,
                    status: (state.batches[batchType] as BatchTypeReady)
                        .subBatches[i],
                    batchSize: batchType.batchSize,
                    hasOutputDir: state.outputDir.isNotEmpty,
                  ),
            ],
          ],
        );
      },
    );
  }
}

class _OutputDirRow extends StatelessWidget {
  const _OutputDirRow({required this.outputDir});
  final String outputDir;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        children: [
          Icon(Icons.folder_outlined, size: 20, color: colorScheme.outline),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              outputDir.isEmpty ? 'No output directory selected' : outputDir,
              style: theme.textTheme.bodySmall?.copyWith(
                color: outputDir.isEmpty
                    ? colorScheme.outline
                    : colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            onPressed: () => _pickDirectory(context),
            child: const Text('Choose'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDirectory(BuildContext context) async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select CSV output directory',
    );
    if (result != null && context.mounted) {
      context.read<EnrichmentBloc>().add(
            EnrichmentEvent.setOutputDir(path: result),
          );
    }
  }
}

// -- Parent batch type row --

class _BatchTypeRow extends StatelessWidget {
  const _BatchTypeRow({
    required this.batchType,
    required this.status,
  });

  final EnrichmentBatchType batchType;
  final BatchTypeStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            _statusIcon(colorScheme),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Batch ${batchType.batchNumber}: ${batchType.label}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    batchType.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _summaryArea(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(ColorScheme colorScheme) {
    return switch (status) {
      BatchTypeIdle() =>
        Icon(Icons.circle_outlined, size: 20, color: colorScheme.outline),
      BatchTypeReady() =>
        Icon(Icons.edit_note, size: 20, color: colorScheme.primary),
    };
  }

  Widget _summaryArea(ThemeData theme, ColorScheme colorScheme) {
    final textStyle = theme.textTheme.labelSmall;

    return switch (status) {
      BatchTypeIdle() => Chip(
          label: Text('Needs source data',
              style: textStyle?.copyWith(color: colorScheme.outline)),
          backgroundColor: Colors.transparent,
          side: BorderSide(color: colorScheme.outlineVariant),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      BatchTypeReady(:final totalCount, :final subBatches) => Text(
          '$totalCount items, ${subBatches.length} sub-batch${subBatches.length == 1 ? '' : 'es'}',
          style: textStyle?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
    };
  }
}

// -- Sub-batch row --

class _SubBatchRow extends StatelessWidget {
  const _SubBatchRow({
    required this.batchType,
    required this.index,
    required this.totalSubBatches,
    required this.totalCount,
    required this.status,
    required this.batchSize,
    required this.hasOutputDir,
  });

  final EnrichmentBatchType batchType;
  final int index;
  final int totalSubBatches;
  final int totalCount;
  final SubBatchStatus status;
  final int batchSize;
  final bool hasOutputDir;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final start = index * batchSize + 1;
    final end = math.min((index + 1) * batchSize, totalCount);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4)
            .copyWith(left: 36),
        child: Row(
          children: [
            _statusIcon(colorScheme),
            const SizedBox(width: 12),
            Text(
              '${index + 1}/$totalSubBatches ($start\u2013$end)',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.end,
                children: _actionWidgets(context, theme, colorScheme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(ColorScheme colorScheme) {
    return switch (status) {
      SubBatchPending() =>
        Icon(Icons.circle_outlined, size: 18, color: colorScheme.outline),
      SubBatchExporting() || SubBatchImporting() => SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
      SubBatchExported() =>
        Icon(Icons.file_download_done, size: 18, color: colorScheme.tertiary),
      SubBatchImported() =>
        Icon(Icons.check_circle, size: 18, color: colorScheme.tertiary),
      SubBatchFailed() =>
        Icon(Icons.error, size: 18, color: colorScheme.error),
    };
  }

  List<Widget> _actionWidgets(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final textStyle = theme.textTheme.labelSmall;

    return switch (status) {
      SubBatchPending() => [
          FilledButton.tonal(
            onPressed: hasOutputDir ? () => _export(context) : null,
            child: const Text('Export'),
          ),
          OutlinedButton(
            onPressed: () => _pickAndImport(context),
            child: const Text('Import'),
          ),
        ],
      SubBatchExporting() => [
          Text('Exporting...', style: textStyle),
        ],
      SubBatchExported(:final warnings) => [
          Chip(
            label: Text('Exported',
                style: textStyle?.copyWith(
                    color: colorScheme.onTertiaryContainer)),
            backgroundColor: colorScheme.tertiaryContainer,
            side: BorderSide.none,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          if (warnings.isNotEmpty)
            _warningChip(context, warnings, textStyle, colorScheme),
          FilledButton.tonal(
            onPressed: hasOutputDir ? () => _export(context) : null,
            child: const Text('Re-export'),
          ),
          OutlinedButton(
            onPressed: () => _pickAndImport(context),
            child: const Text('Import'),
          ),
        ],
      SubBatchImporting() => [
          Text('Importing...', style: textStyle),
        ],
      SubBatchImported(:final importedCount, :final rejectedCount, :final warnings) => [
          Chip(
            label: Text(
              '$importedCount imported'
              '${rejectedCount > 0 ? ', $rejectedCount rejected' : ''}',
              style: textStyle?.copyWith(
                  color: colorScheme.onTertiaryContainer),
            ),
            backgroundColor: colorScheme.tertiaryContainer,
            side: BorderSide.none,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          if (warnings.isNotEmpty)
            _warningChip(context, warnings, textStyle, colorScheme),
          FilledButton.tonal(
            onPressed: hasOutputDir ? () => _export(context) : null,
            child: const Text('Re-export'),
          ),
          OutlinedButton(
            onPressed: () => _pickAndImport(context),
            child: const Text('Import Another'),
          ),
        ],
      SubBatchFailed(:final error) => [
          Chip(
            label: Text(error,
                style: textStyle?.copyWith(
                    color: colorScheme.onErrorContainer)),
            backgroundColor: colorScheme.errorContainer,
            side: BorderSide.none,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          TextButton(
            onPressed: hasOutputDir ? () => _export(context) : null,
            child: const Text('Retry'),
          ),
          OutlinedButton(
            onPressed: () => _pickAndImport(context),
            child: const Text('Import'),
          ),
        ],
    };
  }

  Widget _warningChip(
    BuildContext context,
    List<Warning> warnings,
    TextStyle? textStyle,
    ColorScheme colorScheme,
  ) {
    final high =
        warnings.where((w) => w.severity == WarningSeverity.high).length;
    final low = warnings.length - high;
    String label;
    if (high == 0) {
      label = '$low warning${low == 1 ? '' : 's'}';
    } else if (low == 0) {
      label = '$high high';
    } else {
      label = '$high high, $low low';
    }

    return ActionChip(
      avatar: Icon(Icons.warning_amber_rounded,
          size: 16, color: colorScheme.onErrorContainer),
      label: Text(label,
          style: textStyle?.copyWith(color: colorScheme.onErrorContainer)),
      backgroundColor: colorScheme.errorContainer,
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      onPressed: () => _showWarningsDialog(context, warnings),
    );
  }

  void _showWarningsDialog(BuildContext context, List<Warning> warnings) {
    final sorted = [...warnings]
      ..sort((a, b) => b.severity.index.compareTo(a.severity.index));

    showDialog<void>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Text('${batchType.label} Warnings'),
          content: SizedBox(
            width: 480,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: sorted.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final warning = sorted[index];
                final isHigh = warning.severity == WarningSeverity.high;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isHigh ? Icons.error_outline : Icons.info_outline,
                        size: 18,
                        color:
                            isHigh ? colorScheme.error : colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: SelectableText(warning.message)),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _export(BuildContext context) {
    context.read<EnrichmentBloc>().add(
          EnrichmentEvent.exportSubBatch(
            batchType: batchType,
            subBatchIndex: index,
          ),
        );
  }

  Future<void> _pickAndImport(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select enriched CSV file',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null && result.files.single.path != null && context.mounted) {
      context.read<EnrichmentBloc>().add(
            EnrichmentEvent.importSubBatch(
              batchType: batchType,
              subBatchIndex: index,
              filePath: result.files.single.path!,
            ),
          );
    }
  }
}
