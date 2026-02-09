import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanji_craft_admin/domain/entities/data_import.dart';
import 'package:kanji_craft_admin/presentation/bloc/data_import_state.dart';
import 'package:kanji_craft_admin/presentation/widgets/status_badge.dart';

class ImportsTable extends StatelessWidget {
  const ImportsTable({
    required this.imports,
    this.activeIngestions = const {},
    super.key,
  });

  final List<DataImport> imports;
  final Map<int, IngestionProgress> activeIngestions;

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
          DataColumn(label: Text('Started')),
        ],
        rows: [
          for (final entry in imports)
            DataRow(cells: [
              DataCell(Text('${entry.id}')),
              DataCell(Text(entry.source.name)),
              DataCell(Text(entry.sourceVersion)),
              DataCell(_statusCell(entry)),
              DataCell(Text(entry.recordCount?.toString() ?? '-')),
              DataCell(Text(_dateFormat.format(entry.startedAt))),
            ]),
        ],
      ),
    );
  }

  Widget _statusCell(DataImport entry) {
    final trackingKey = -entry.source.index - 1;
    final progress = activeIngestions[trackingKey];

    if (progress == null || progress.total == 0) {
      return StatusBadge(status: entry.status);
    }

    final fraction = progress.inserted / progress.total;
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
