/// Warning severity levels, ordered from lowest to highest.
///
/// Index order matters — UI sorts by descending index (high first).
enum WarningSeverity { low, medium, high }

class Warning {
  const Warning(this.message, {this.severity = WarningSeverity.low});
  final String message;
  final WarningSeverity severity;
}
