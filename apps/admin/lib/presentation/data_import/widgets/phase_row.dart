import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/extraction_phase.dart';
import '../bloc/extraction_bloc.dart';
import '../bloc/extraction_event.dart';
import '../bloc/extraction_state.dart';

class PhaseRow extends StatelessWidget {
  const PhaseRow({
    required this.phase,
    required this.status,
    super.key,
  });

  final ExtractionPhase phase;
  final PhaseStatus status;

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
                    '${phase.phaseNumber}  ${phase.label}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    phase.description,
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
      PhaseIdle() => Icon(Icons.circle_outlined,
          size: 20, color: colorScheme.outline),
      PhaseBlocked() => Icon(Icons.lock_outline,
          size: 20, color: colorScheme.outline),
      PhaseReady() => Icon(Icons.play_circle_outline,
          size: 20, color: colorScheme.primary),
      PhaseRunning() => SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
      PhaseCompleted() => Icon(Icons.check_circle,
          size: 20, color: colorScheme.tertiary),
      PhaseFailed() => Icon(Icons.error,
          size: 20, color: colorScheme.error),
    };
  }

  Widget _actionArea(BuildContext context, ColorScheme colorScheme) {
    final textStyle = Theme.of(context).textTheme.labelSmall;

    return switch (status) {
      PhaseIdle() => const SizedBox.shrink(),
      PhaseBlocked(:final reason) => Chip(
          label: Text(reason, style: textStyle?.copyWith(
            color: colorScheme.outline,
          )),
          backgroundColor: Colors.transparent,
          side: BorderSide(color: colorScheme.outlineVariant),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      PhaseReady() => FilledButton.tonal(
          onPressed: () => context
              .read<ExtractionBloc>()
              .add(ExtractionEvent.runPhase(phase: phase)),
          child: const Text('Run'),
        ),
      PhaseRunning(:final message) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            if (message != null) ...[
              const SizedBox(width: 8),
              Text(message, style: textStyle),
            ],
          ],
        ),
      PhaseCompleted(:final summary, :final warnings) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(summary, style: textStyle?.copyWith(
                color: colorScheme.onTertiaryContainer,
              )),
              backgroundColor: colorScheme.tertiaryContainer,
              side: BorderSide.none,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            if (warnings.isNotEmpty) ...[
              const SizedBox(width: 8),
              ActionChip(
                avatar: Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: colorScheme.onErrorContainer,
                ),
                label: Text(
                  '${warnings.length} warning${warnings.length == 1 ? '' : 's'}',
                  style: textStyle?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                backgroundColor: colorScheme.errorContainer,
                side: BorderSide.none,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                onPressed: () => _showWarningsDialog(context, warnings),
              ),
            ],
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => context
                  .read<ExtractionBloc>()
                  .add(ExtractionEvent.runPhase(phase: phase)),
              child: const Text('Re-run'),
            ),
          ],
        ),
      PhaseFailed(:final error) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(error, style: textStyle?.copyWith(
                color: colorScheme.onErrorContainer,
              )),
              backgroundColor: colorScheme.errorContainer,
              side: BorderSide.none,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => context
                  .read<ExtractionBloc>()
                  .add(ExtractionEvent.runPhase(phase: phase)),
              child: const Text('Retry'),
            ),
          ],
        ),
    };
  }

  void _showWarningsDialog(BuildContext context, List<String> warnings) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Warnings'),
        content: SizedBox(
          width: 480,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: warnings.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SelectableText(warnings[index]),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
