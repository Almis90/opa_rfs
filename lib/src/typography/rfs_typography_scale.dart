import '../core/rfs_value.dart';

/// Fluid endpoints for each of the 15 Material text styles.
///
/// The defaults use the standard Material type-scale sizes as maxima with
/// derived minima. Override individual styles to pin explicit endpoints:
///
/// ```dart
/// const RfsTypographyScale(
///   displayLarge: RfsValue(max: 64, min: 40),
/// )
/// ```
class RfsTypographyScale {
  /// Creates a scale; unspecified styles keep the Material defaults.
  const RfsTypographyScale({
    this.displayLarge = const RfsValue(max: 57),
    this.displayMedium = const RfsValue(max: 45),
    this.displaySmall = const RfsValue(max: 36),
    this.headlineLarge = const RfsValue(max: 32),
    this.headlineMedium = const RfsValue(max: 28),
    this.headlineSmall = const RfsValue(max: 24),
    this.titleLarge = const RfsValue(max: 22),
    this.titleMedium = const RfsValue(max: 16),
    this.titleSmall = const RfsValue(max: 14),
    this.bodyLarge = const RfsValue(max: 16),
    this.bodyMedium = const RfsValue(max: 14),
    this.bodySmall = const RfsValue(max: 12),
    this.labelLarge = const RfsValue(max: 14),
    this.labelMedium = const RfsValue(max: 12),
    this.labelSmall = const RfsValue(max: 11),
  });

  /// Endpoints for `TextTheme.displayLarge`.
  final RfsValue displayLarge;

  /// Endpoints for `TextTheme.displayMedium`.
  final RfsValue displayMedium;

  /// Endpoints for `TextTheme.displaySmall`.
  final RfsValue displaySmall;

  /// Endpoints for `TextTheme.headlineLarge`.
  final RfsValue headlineLarge;

  /// Endpoints for `TextTheme.headlineMedium`.
  final RfsValue headlineMedium;

  /// Endpoints for `TextTheme.headlineSmall`.
  final RfsValue headlineSmall;

  /// Endpoints for `TextTheme.titleLarge`.
  final RfsValue titleLarge;

  /// Endpoints for `TextTheme.titleMedium`.
  final RfsValue titleMedium;

  /// Endpoints for `TextTheme.titleSmall`.
  final RfsValue titleSmall;

  /// Endpoints for `TextTheme.bodyLarge`.
  final RfsValue bodyLarge;

  /// Endpoints for `TextTheme.bodyMedium`.
  final RfsValue bodyMedium;

  /// Endpoints for `TextTheme.bodySmall`.
  final RfsValue bodySmall;

  /// Endpoints for `TextTheme.labelLarge`.
  final RfsValue labelLarge;

  /// Endpoints for `TextTheme.labelMedium`.
  final RfsValue labelMedium;

  /// Endpoints for `TextTheme.labelSmall`.
  final RfsValue labelSmall;
}
