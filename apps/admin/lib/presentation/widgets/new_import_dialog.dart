import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';

class NewImportResult {
  const NewImportResult({
    required this.source,
    required this.sourceVersion,
    required this.filePath,
  });

  final ImportSource source;
  final String sourceVersion;
  final String filePath;
}

class NewImportDialog extends StatefulWidget {
  const NewImportDialog({super.key});

  @override
  State<NewImportDialog> createState() => _NewImportDialogState();
}

class _NewImportDialogState extends State<NewImportDialog> {
  ImportSource _source = ImportSource.kanjivg;
  final _versionController = TextEditingController();
  String? _filePath;
  String? _fileName;

  bool get _canSubmit =>
      _source != ImportSource.jmdict &&
      _versionController.text.trim().isNotEmpty &&
      _filePath != null;

  @override
  void dispose() {
    _versionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path;
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Import'),
      content: SizedBox(
        width: 400,
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
                    enabled: source != ImportSource.jmdict,
                    child: Text(
                      source == ImportSource.jmdict
                          ? '${source.name} (coming soon)'
                          : source.name,
                      style: source == ImportSource.jmdict
                          ? TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.38),
                            )
                          : null,
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _source = value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _versionController,
              decoration: const InputDecoration(
                labelText: 'Source Version',
                hintText: 'e.g. 20220427',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _fileName ?? 'No file selected',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _fileName == null
                              ? Theme.of(context).colorScheme.outline
                              : null,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: _pickFile,
                  child: const Text('Choose File'),
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
                      sourceVersion: _versionController.text.trim(),
                      filePath: _filePath!,
                    ),
                  )
              : null,
          child: const Text('Start Ingestion'),
        ),
      ],
    );
  }
}
