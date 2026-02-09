/// Lifecycle state of a pipeline run.
///
/// Transitions: pending → ingested → processing → processed.
/// Any state can transition to [failed].
enum ImportStatus { pending, ingested, processing, processed, failed }
