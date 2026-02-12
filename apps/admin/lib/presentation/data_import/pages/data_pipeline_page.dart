import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/data_import_bloc.dart';
import '../bloc/data_import_event.dart';
import '../bloc/data_import_state.dart';
import '../bloc/extraction_bloc.dart';
import '../bloc/extraction_event.dart';
import '../widgets/extraction_section.dart';
import '../widgets/imports_table.dart';
import '../widgets/new_import_dialog.dart';
import '../widgets/source_requirements_row.dart';

class DataPipelinePage extends StatefulWidget {
  const DataPipelinePage({super.key});

  @override
  State<DataPipelinePage> createState() => _DataPipelinePageState();
}

class _DataPipelinePageState extends State<DataPipelinePage> {
  @override
  void initState() {
    super.initState();
    // If DataImportBloc already has loaded state (e.g. page revisited),
    // seed ExtractionBloc immediately.
    final importState = context.read<DataImportBloc>().state;
    if (importState is DataImportLoaded) {
      context.read<ExtractionBloc>().add(
            ExtractionEvent.importsUpdated(imports: importState.imports),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DataImportBloc, DataImportState>(
          listenWhen: (prev, curr) =>
              curr.mapOrNull(error: (_) => true) ?? false,
          listener: (context, state) {
            state.mapOrNull(
              error: (e) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          },
        ),
        // Bridge import data into ExtractionBloc.
        BlocListener<DataImportBloc, DataImportState>(
          listenWhen: (prev, curr) => curr is DataImportLoaded,
          listener: (context, state) {
            if (state is DataImportLoaded) {
              context.read<ExtractionBloc>().add(
                    ExtractionEvent.importsUpdated(imports: state.imports),
                  );
            }
          },
        ),
      ],
      child: BlocBuilder<DataImportBloc, DataImportState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Data Pipeline',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () => _showNewImportDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('New Import'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: state.when(
                    initial: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_) => const SizedBox.shrink(),
                    loaded: (imports, activeIngestions) =>
                        SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SourceRequirementsRow(imports: imports),
                          const SizedBox(height: 24),
                          const ExtractionSection(),
                          const SizedBox(height: 24),
                          ImportsTable(
                            imports: imports,
                            activeIngestions: activeIngestions,
                            onClear: (importId) =>
                                context.read<DataImportBloc>().add(
                                      DataImportEvent.clearImport(
                                        importId: importId,
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showNewImportDialog(BuildContext context) async {
    final result = await showDialog<NewImportResult>(
      context: context,
      builder: (_) => const NewImportDialog(),
    );
    if (result != null && context.mounted) {
      context.read<DataImportBloc>().add(
            DataImportEvent.startIngestion(
              source: result.source,
              folderPath: result.folderPath,
            ),
          );
    }
  }
}
