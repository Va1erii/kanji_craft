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
            for (final batchType in EnrichmentBatchType.values)
              _BatchRow(
                batchType: batchType,
                status: state.batches[batchType] ?? const BatchIdle(),
                hasOutputDir: state.outputDir.isNotEmpty,
              ),
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

class _BatchRow extends StatelessWidget {
  const _BatchRow({
    required this.batchType,
    required this.status,
    required this.hasOutputDir,
  });

  final EnrichmentBatchType batchType;
  final BatchStatus status;
  final bool hasOutputDir;

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
            _actionArea(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(ColorScheme colorScheme) {
    return switch (status) {
      BatchIdle() =>
        Icon(Icons.circle_outlined, size: 20, color: colorScheme.outline),
      BatchReady() =>
        Icon(Icons.edit_note, size: 20, color: colorScheme.primary),
      BatchExporting() || BatchImporting() => SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
      BatchExported() =>
        Icon(Icons.file_download_done, size: 20, color: colorScheme.tertiary),
      BatchImported() =>
        Icon(Icons.check_circle, size: 20, color: colorScheme.tertiary),
      BatchFailed() =>
        Icon(Icons.error, size: 20, color: colorScheme.error),
    };
  }

  Widget _actionArea(BuildContext context, ColorScheme colorScheme) {
    final textStyle = Theme.of(context).textTheme.labelSmall;

    return switch (status) {
      BatchIdle() => Chip(
          label: Text('Needs source data',
              style: textStyle?.copyWith(color: colorScheme.outline)),
          backgroundColor: Colors.transparent,
          side: BorderSide(color: colorScheme.outlineVariant),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      BatchReady(:final totalCount) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (totalCount > 0)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text('$totalCount radicals',
                    style: textStyle?.copyWith(
                        color: colorScheme.onSurfaceVariant)),
              ),
            FilledButton.tonal(
              onPressed: hasOutputDir
                  ? () => context.read<EnrichmentBloc>().add(
                        EnrichmentEvent.exportBatch(batchType: batchType),
                      )
                  : null,
              child: const Text('Export'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => _pickAndImport(context),
              child: const Text('Import'),
            ),
          ],
        ),
      BatchExporting() || BatchImporting() => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            Text(
              status is BatchExporting ? 'Exporting...' : 'Importing...',
              style: textStyle,
            ),
          ],
        ),
      BatchExported(
        :final exportedCount,
        :final totalCount,
        :final warnings,
      ) =>
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                'Exported $exportedCount / $totalCount',
                style: textStyle?.copyWith(
                    color: colorScheme.onTertiaryContainer),
              ),
              backgroundColor: colorScheme.tertiaryContainer,
              side: BorderSide.none,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            if (warnings.isNotEmpty) ...[
              const SizedBox(width: 8),
              _warningChip(context, warnings, textStyle, colorScheme),
            ],
            const SizedBox(width: 8),
            if (exportedCount < totalCount)
              FilledButton.tonal(
                onPressed: hasOutputDir
                    ? () => context.read<EnrichmentBloc>().add(
                          EnrichmentEvent.exportBatch(batchType: batchType),
                        )
                    : null,
                child: const Text('Export Next'),
              ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => _pickAndImport(context),
              child: const Text('Import'),
            ),
          ],
        ),
      BatchImported(:final importedCount, :final rejectedCount, :final warnings) =>
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            if (warnings.isNotEmpty) ...[
              const SizedBox(width: 8),
              _warningChip(context, warnings, textStyle, colorScheme),
            ],
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => _pickAndImport(context),
              child: const Text('Import Another'),
            ),
          ],
        ),
      BatchFailed(:final error) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                error,
                style: textStyle?.copyWith(
                    color: colorScheme.onErrorContainer),
              ),
              backgroundColor: colorScheme.errorContainer,
              side: BorderSide.none,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: hasOutputDir
                  ? () => context.read<EnrichmentBloc>().add(
                        EnrichmentEvent.exportBatch(batchType: batchType),
                      )
                  : null,
              child: const Text('Retry Export'),
            ),
          ],
        ),
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

  Future<void> _pickAndImport(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select enriched CSV file',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null && result.files.single.path != null && context.mounted) {
      context.read<EnrichmentBloc>().add(
            EnrichmentEvent.importBatch(
              batchType: batchType,
              filePath: result.files.single.path!,
            ),
          );
    }
  }
}
