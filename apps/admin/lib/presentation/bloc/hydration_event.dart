import 'package:freezed_annotation/freezed_annotation.dart';

part 'hydration_event.freezed.dart';

@freezed
sealed class HydrationEvent with _$HydrationEvent {
  const factory HydrationEvent.started() = _Started;
}
