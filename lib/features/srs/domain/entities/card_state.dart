/// The learning state of an SRS card.
///
/// Maps to FSRS state values:
/// - [newCard] (0) — never reviewed.
/// - [learning] (1) — in initial learning steps.
/// - [review] (2) — graduated to long-term review.
/// - [relearning] (3) — lapsed and re-entering learning steps.
enum CardState { newCard, learning, review, relearning }
