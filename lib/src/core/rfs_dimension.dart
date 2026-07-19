/// Selects which extent of a two-dimensional size drives a responsive
/// calculation.
enum RfsDimension {
  /// Resolve against the available width.
  width,

  /// Resolve against the smaller of width and height.
  ///
  /// Useful when orientation changes should not inflate sizes: a phone in
  /// landscape keeps the sizing of its portrait width.
  shortestSide,
}
