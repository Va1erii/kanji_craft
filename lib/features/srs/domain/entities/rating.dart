/// The user's self-assessed difficulty rating for a review.
///
/// Maps to FSRS rating values:
/// - [again] (1) — complete lapse, item forgotten.
/// - [hard] (2) — recalled with significant difficulty.
/// - [good] (3) — recalled with moderate effort.
/// - [easy] (4) — recalled effortlessly.
enum Rating { again, hard, good, easy }
