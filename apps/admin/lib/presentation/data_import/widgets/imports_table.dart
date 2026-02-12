import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanji_craft_admin/domain/entities/data_import.dart';
import 'package:kanji_craft_admin/domain/usecases/ingest_source_data.dart';
import 'status_badge.dart';

class ImportsTable extends StatelessWidget {
  const ImportsTable({
    required this.imports,
    this.activeIngestions = const {},
    this.onClear,
    super.key,
  });

  final List<DataImport> imports;
  final Map<int, IngestionProgress?> activeIngestions;
  final void Function(int importId)? onClear;

  static final _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  Widget build(BuildContext context) {
    if (imports.isEmpty && activeIngestions.isEmpty) {
      return Center(
        child: Text(
          'No imports yet. Click "New Import" to get started.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Source')),
          DataColumn(label: Text('Version')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Records'), numeric: true),
          DataColumn(label: Text('Skipped'), numeric: true),
          DataColumn(label: Text('Started')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          for (final entry in imports)
            DataRow(cells: [
              DataCell(Text('${entry.id}')),
              DataCell(Text(entry.source.name)),
              DataCell(Text(entry.sourceVersion)),
              DataCell(_statusCell(entry)),
              DataCell(Text(entry.recordCount?.toString() ?? '-')),
              DataCell(Text(_skippedCount(entry))),
              DataCell(Text(_dateFormat.format(entry.startedAt))),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Clear import',
                  onPressed: onClear != null
                      ? () => onClear!(entry.id)
                      : null,
                ),
              ),
            ]),
        ],
      ),
    );
  }

  String _skippedCount(DataImport entry) {
    final skipped = entry.metadata?['skipped'];
    if (skipped is List) return '${skipped.length}';
    return '-';
  }

  Widget _statusCell(DataImport entry) {
    final trackingKey = -entry.source.index - 1;
    if (!activeIngestions.containsKey(trackingKey)) {
      return StatusBadge(status: entry.status);
    }

    final progress = activeIngestions[trackingKey];
    if (progress == null) {
      return SizedBox(
        width: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parsing...',
              style: const TextStyle(fontSize: 11, color: Colors.orange),
            ),
            const SizedBox(height: 4),
            const LinearProgressIndicator(),
          ],
        ),
      );
    }

    final fraction =
        progress.total > 0 ? progress.inserted / progress.total : 0.0;
    return SizedBox(
      width: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingesting ${progress.inserted} / ${progress.total}',
            style: const TextStyle(fontSize: 11, color: Colors.orange),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: fraction),
        ],
      ),
    );
  }
}
