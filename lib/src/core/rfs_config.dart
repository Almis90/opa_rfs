/// Configuration for the fluid-sizing calculation.
///
/// The defaults produce a curve where a value reaches its maximum at a
/// 1200-pixel extent and shrinks smoothly below it, while values of 20
/// logical pixels or less never scale:
///
/// ```dart
/// const RfsConfig(); // breakpoint: 1200, factor: 10, baseValue: 20
/// ```
///
/// Pass a configuration to any `resolve` call, or provide one to a whole
/// subtree with `RfsScope`.
class RfsConfig {
  /// Creates a fluid-sizing configuration.
  ///
  /// [breakpoint] must be positive, [factor] greater than one, and
  /// [baseValue] nonnegative.
  const RfsConfig({
    this.breakpoint = 1200,
    this.factor = 10,
    this.baseValue = 20,
    this.enabled = true,
  }) : assert(breakpoint > 0, 'breakpoint must be greater than zero'),
       assert(factor > 1, 'factor must be greater than one'),
       assert(baseValue >= 0, 'baseValue must not be negative');

  /// The extent at which values reach their maximum.
  ///
  /// At or above this extent a value resolves to exactly its `max`; below
  /// it the value interpolates linearly toward its minimum.
  final double breakpoint;

  /// Steepness of the derived minimum when no explicit `min` is given.
  ///
  /// The derived minimum is `baseValue + (|max| - baseValue) / factor`, so
  /// a higher factor keeps values closer to [baseValue] on small layouts.
  final double factor;

  /// The cutoff below which values never scale.
  ///
  /// A value whose absolute maximum is at or below this stays fixed, even
  /// when an explicit `min` is supplied. Lower it if small values should
  /// scale too.
  final double baseValue;

  /// Whether fluid scaling is active.
  ///
  /// When `false`, every value resolves to its `max` unchanged.
  final bool enabled;

  @override
  bool operator ==(Object other) =>
      other is RfsConfig &&
      other.breakpoint == breakpoint &&
      other.factor == factor &&
      other.baseValue == baseValue &&
      other.enabled == enabled;

  @override
  int get hashCode => Object.hash(breakpoint, factor, baseValue, enabled);

  /// Returns a copy with selected settings replaced.
  RfsConfig copyWith({
    double? breakpoint,
    double? factor,
    double? baseValue,
    bool? enabled,
  }) => RfsConfig(
    breakpoint: breakpoint ?? this.breakpoint,
    factor: factor ?? this.factor,
    baseValue: baseValue ?? this.baseValue,
    enabled: enabled ?? this.enabled,
  );
}
