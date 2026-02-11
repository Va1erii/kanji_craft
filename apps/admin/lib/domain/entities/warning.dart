enum WarningSeverity { low, high }

class Warning {
  const Warning(this.message, {this.severity = WarningSeverity.low});
  final String message;
  final WarningSeverity severity;
}
