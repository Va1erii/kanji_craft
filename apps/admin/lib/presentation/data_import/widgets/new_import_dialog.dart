import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';

class NewImportResult {
  const NewImportResult({
    required this.source,
    required this.folderPath,
  });

  final ImportSource source;
  final String folderPath;
}

const _sourceLabels = {
  ImportSource.kanjivg: 'KanjiVG',
  ImportSource.kanjidic: 'KANJIDIC',
  ImportSource.jmdict: 'JMDict',
};

class NewImportDialog extends StatefulWidget {
  const NewImportDialog({super.key});

  @override
  State<NewImportDialog> createState() => _NewImportDialogState();
}

class _NewImportDialogState extends State<NewImportDialog> {
  ImportSource _source = ImportSource.kanjivg;
  String? _folderPath;

  bool get _canSubmit => _folderPath != null;

  void _onSourceChanged(ImportSource source) {
    setState(() {
      _source = source;
      _folderPath = null;
    });
  }

  Future<void> _pickFolder() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path == null) return;

    setState(() {
      _folderPath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('New Import'),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<ImportSource>(
              initialValue: _source,
              decoration: const InputDecoration(
                labelText: 'Source',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final source in ImportSource.values)
                  DropdownMenuItem(
                    value: source,
                    child: Text(_sourceLabels[source]!),
                  ),
              ],
              onChanged: (value) {
                if (value != null) _onSourceChanged(value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _folderPath ?? 'No folder selected',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _folderPath == null
                          ? theme.colorScheme.outline
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: _pickFolder,
                  child: const Text('Choose Folder'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _canSubmit
              ? () => Navigator.of(context).pop(
                    NewImportResult(
                      source: _source,
                      folderPath: _folderPath!,
                    ),
                  )
              : null,
          child: const Text('Start Ingestion'),
        ),
      ],
    );
  }
}
