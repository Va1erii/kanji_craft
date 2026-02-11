import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/extraction_phase.dart';
import '../bloc/extraction_bloc.dart';
import '../bloc/extraction_state.dart';
import 'phase_row.dart';

class ExtractionSection extends StatelessWidget {
  const ExtractionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtractionBloc, ExtractionState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Extraction',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final phase in ExtractionPhase.values)
              PhaseRow(
                phase: phase,
                status: state.phases[phase] ?? const PhaseIdle(),
              ),
          ],
        );
      },
    );
  }
}
