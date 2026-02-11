import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanji_craft_admin/domain/entities/import_status.dart';
import 'package:kanji_craft_admin/presentation/data_import/bloc/data_import_bloc.dart';
import 'package:kanji_craft_admin/presentation/data_import/bloc/data_import_event.dart';
import 'package:kanji_craft_admin/presentation/data_import/bloc/data_import_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataImportBloc, DataImportState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          error: (message) => _ErrorView(
              message: message,
              onRetry: () =>
                  context.read<DataImportBloc>().add(const DataImportEvent.load()),
            ),
          loaded: (imports, _) => _DashboardContent(
              statusCounts: {
                for (final status in ImportStatus.values)
                  status: imports.where((i) => i.status == status).length,
              },
              totalImports: imports.length,
            ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.statusCounts,
    required this.totalImports,
  });

  final Map<ImportStatus, int> statusCounts;
  final int totalImports;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        Text('Imports', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SummaryCard(
              label: 'Total',
              value: '$totalImports',
              icon: Icons.storage,
            ),
            for (final status in ImportStatus.values)
              _SummaryCard(
                label: status.name[0].toUpperCase() + status.name.substring(1),
                value: '${statusCounts[status] ?? 0}',
                icon: _iconForStatus(status),
              ),
          ],
        ),
        const SizedBox(height: 32),
        Text('Reviews', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SummaryCard(label: 'Draft', value: '0', icon: Icons.edit_note),
            _SummaryCard(label: 'Verified', value: '0', icon: Icons.check_circle_outline),
            _SummaryCard(label: 'Flagged', value: '0', icon: Icons.flag_outlined),
          ],
        ),
      ],
    );
  }

  IconData _iconForStatus(ImportStatus status) => switch (status) {
        ImportStatus.pending => Icons.hourglass_empty,
        ImportStatus.ingested => Icons.download_done,
        ImportStatus.processing => Icons.sync,
        ImportStatus.processed => Icons.check,
        ImportStatus.failed => Icons.error_outline,
      };
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(label, style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
