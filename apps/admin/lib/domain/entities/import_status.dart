/// Lifecycle state of a pipeline run.
///
/// Transitions: pending → ingested → processing → processed → promoted.
/// Any state can transition to [failed].
enum ImportStatus { pending, ingested, processing, processed, promoted, failed }
