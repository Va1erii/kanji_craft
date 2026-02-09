import 'package:freezed_annotation/freezed_annotation.dart';

part 'hydration_state.freezed.dart';

@freezed
sealed class HydrationState with _$HydrationState {
  const factory HydrationState.inProgress(String step) = HydrationInProgress;
  const factory HydrationState.completed() = _Completed;
  const factory HydrationState.failed(String message) = _Failed;
}
