import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kanji_craft_admin/domain/entities/import_source.dart';

class NewImportResult {
  const NewImportResult({
    required this.source,
    required this.sourceVersion,
    required this.filePath,
    this.svgArchivePath,
  });

  final ImportSource source;
  final String sourceVersion;
  final String filePath;

  /// Path to the KanjiVG `main.zip` for SVG extraction (KanjiVG only).
  final String? svgArchivePath;
}

typedef _SourceConfig = ({
  String label,
  RegExp folderPattern,
  bool Function(String) isIngestionFile,
  bool Function(String)? isSvgArchive,
});

_SourceConfig _sourceConfig(ImportSource source) => switch (source) {
      ImportSource.kanjivg => (
          label: 'KanjiVG',
          folderPattern: RegExp(r'kanjivg[_-](.+)'),
          isIngestionFile: (String name) => name.endsWith('.xml.gz'),
          isSvgArchive: (String name) =>
              name.endsWith('.zip') && name.contains('main'),
        ),
      ImportSource.kanjidic => (
          label: 'KANJIDIC',
          folderPattern: RegExp(r'kanjidic[_-]?(.+)'),
          isIngestionFile: (String name) => name.endsWith('.xml.gz'),
          isSvgArchive: null,
        ),
      ImportSource.jmdict => (
          label: 'JMDict',
          folderPattern: RegExp(r'jmdict[_-]?(.+)'),
          isIngestionFile: (String name) =>
              name.endsWith('.zip') && name.contains('english'),
          isSvgArchive: null,
        ),
    };

class NewImportDialog extends StatefulWidget {
  const NewImportDialog({super.key});

  @override
  State<NewImportDialog> createState() => _NewImportDialogState();
}

class _NewImportDialogState extends State<NewImportDialog> {
  ImportSource _source = ImportSource.kanjivg;
  final _versionController = TextEditingController();
  String? _folderPath;
  List<FileSystemEntity> _detectedFiles = [];
  String? _ingestionFilePath;
  String? _svgArchivePath;

  bool get _canSubmit =>
      _versionController.text.trim().isNotEmpty && _ingestionFilePath != null;

  @override
  void dispose() {
    _versionController.dispose();
    super.dispose();
  }

  void _onSourceChanged(ImportSource source) {
    setState(() {
      _source = source;
      _folderPath = null;
      _detectedFiles = [];
      _ingestionFilePath = null;
      _svgArchivePath = null;
      _versionController.clear();
    });
  }

  Future<void> _pickFolder() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path == null) return;

    final config = _sourceConfig(_source);
    final dir = Directory(path);
    final folderName = dir.uri.pathSegments
        .lastWhere((s) => s.isNotEmpty, orElse: () => '');

    // Extract version from folder name.
    final match = config.folderPattern.firstMatch(folderName);
    if (match != null && match.groupCount >= 1) {
      _versionController.text = match.group(1)!;
    }

    // List files and detect relevant ones.
    final entries = dir.listSync().whereType<File>().toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    String? ingestionPath;
    String? svgPath;
    final relevant = <FileSystemEntity>[];

    for (final file in entries) {
      final name = file.uri.pathSegments.last;
      if (config.isIngestionFile(name)) {
        ingestionPath ??= file.path;
        relevant.add(file);
      } else if (config.isSvgArchive != null && config.isSvgArchive!(name)) {
        svgPath ??= file.path;
        relevant.add(file);
      }
    }

    setState(() {
      _folderPath = path;
      _detectedFiles = relevant;
      _ingestionFilePath = ingestionPath;
      _svgArchivePath = svgPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _sourceConfig(_source);

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
                    child: Text(_sourceConfig(source).label),
                  ),
              ],
              onChanged: (value) {
                if (value != null) _onSourceChanged(value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _versionController,
              decoration: InputDecoration(
                labelText: 'Source Version',
                hintText: 'Auto-filled from folder name',
                helperText: 'Expected folder: ${config.label.toLowerCase()}-<version>',
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
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
            if (_detectedFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Detected files', style: theme.textTheme.labelLarge),
              const SizedBox(height: 4),
              for (final file in _detectedFiles)
                _FileRow(
                  name: file.uri.pathSegments.last,
                  isPrimary: file.path == _ingestionFilePath,
                ),
            ] else if (_folderPath != null) ...[
              const SizedBox(height: 12),
              Text(
                'No relevant files found in this folder.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
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
                      filePath: _ingestionFilePath!,
                      svgArchivePath: _svgArchivePath,
                    ),
                  )
              : null,
          child: const Text('Start Ingestion'),
        ),
      ],
    );
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({required this.name, required this.isPrimary});

  final String name;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isPrimary ? Icons.arrow_right : Icons.check,
            size: 18,
            color: isPrimary
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: isPrimary ? FontWeight.bold : null,
                  ),
            ),
          ),
          if (isPrimary) ...[
            const SizedBox(width: 6),
            Text(
              '(primary)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
