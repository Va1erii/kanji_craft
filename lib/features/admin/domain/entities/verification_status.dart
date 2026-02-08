/// Review state for a kanji component's logic_hint.
///
/// - [draft] — newly generated, not ready for remote sync.
/// - [verified] — confirmed by human review or auto-rule, ready for sync.
/// - [flagged] — identified as problematic, excluded from sync.
enum VerificationStatus { draft, verified, flagged }
