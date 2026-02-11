import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/data_import_bloc.dart';
import '../bloc/data_import_event.dart';
import '../bloc/data_import_state.dart';
import '../widgets/imports_table.dart';
import '../widgets/new_import_dialog.dart';

class DataPipelinePage extends StatelessWidget {
  const DataPipelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataImportBloc, DataImportState>(
      listenWhen: (prev, curr) => curr.mapOrNull(error: (_) => true) ?? false,
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
                    initial: () => const Center(child: CircularProgressIndicator()),
                    error: (_) => const SizedBox.shrink(),
                    loaded: (imports, activeIngestions) => ImportsTable(
                      imports: imports,
                      activeIngestions: activeIngestions,
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
