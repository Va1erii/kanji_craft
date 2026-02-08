import 'package:flutter/material.dart';
import 'package:kanji_craft_admin/domain/entities/import_status.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final ImportStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ImportStatus.pending => ('Pending', Colors.orange),
      ImportStatus.ingested => ('Ingested', Colors.blue),
      ImportStatus.processing => ('Processing', Colors.purple),
      ImportStatus.processed => ('Processed', Colors.teal),
      ImportStatus.promoted => ('Promoted', Colors.green),
      ImportStatus.failed => ('Failed', Colors.red),
    };

    return Chip(
      label: Text(label, style: TextStyle(color: color, fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
