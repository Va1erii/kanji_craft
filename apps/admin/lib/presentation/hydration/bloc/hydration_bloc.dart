import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/hydrate_local_db.dart';
import 'hydration_event.dart';
import 'hydration_state.dart';

class HydrationBloc extends Bloc<HydrationEvent, HydrationState> {
  HydrationBloc({required HydrateLocalDb hydrateLocalDb})
      : _hydrateLocalDb = hydrateLocalDb,
        super(const HydrationState.inProgress('Starting...')) {
    on<HydrationEvent>(_onEvent);
  }

  final HydrateLocalDb _hydrateLocalDb;

  Future<void> _onEvent(
    HydrationEvent event,
    Emitter<HydrationState> emit,
  ) async {
    await event.when(
      started: () => _onStarted(emit),
    );
  }

  Future<void> _onStarted(Emitter<HydrationState> emit) async {
    try {
      emit(const HydrationState.inProgress('Starting...'));
      await for (final step in _hydrateLocalDb.call()) {
        switch (step) {
          case HydrationPullingImports():
            emit(const HydrationState.inProgress('Pulling imports...'));
          case HydrationPullingReviews():
            emit(const HydrationState.inProgress('Pulling reviews...'));
        }
      }
      emit(const HydrationState.completed());
    } on Exception catch (e) {
      emit(HydrationState.failed(e.toString()));
    }
  }
}
