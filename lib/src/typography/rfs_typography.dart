import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs.dart';
import '../core/rfs_value.dart';
import '../inherited/rfs_scope.dart';
import 'rfs_typography_scale.dart';

/// Builds a complete fluid Material [TextTheme].
///
/// All 15 Material text styles receive fluid font sizes while every other
/// property of the base theme — color, weight, height, letter spacing —
/// is preserved. Empty base styles receive a fallback [TextStyle].
///
/// ```dart
/// final textTheme = RfsTypography.of(context, width: 600);
/// ```
class RfsTypography {
  /// Creates a typography builder with an explicit [config] and
  /// [dimension].
  const RfsTypography({
    this.config = const RfsConfig(),
    this.dimension = RfsDimension.width,
  });

  /// The configuration used to resolve font sizes; null falls back to the
  /// defaults.
  final RfsConfig? config;

  /// Which extent of the available size drives the font sizes.
  final RfsDimension dimension;

  /// Resolves a fluid text theme from the current [BuildContext].
  ///
  /// Configuration and dimension come from the nearest [RfsScope], the
  /// base styles from the ambient [Theme], and the available size from
  /// [MediaQuery] — with [width] overriding the measured width when
  /// given. [scale] supplies per-style endpoints.
  static TextTheme of(
    BuildContext context, {
    double? width,
    RfsTypographyScale scale = const RfsTypographyScale(),
  }) {
    final scope = RfsScope.maybeOf(context);
    final theme = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);
    return RfsTypography(
      config: scope?.effectiveConfig,
      dimension: scope?.dimension ?? RfsDimension.width,
    ).textTheme(
      width: width ?? size.width,
      height: size.height,
      base: theme,
      scale: scale,
    );
  }

  /// Builds a fluid [TextTheme] for an explicit layout size.
  ///
  /// [width] and optional [height] describe the available area, or pass a
  /// full [availableSize] directly. Font-size endpoints come from
  /// [scale]; styles from [base] keep every property except their font
  /// size. The individual named parameters ([displayLarge] through
  /// [titleLarge]) override the corresponding scale maximum and use a
  /// derived minimum.
  TextTheme textTheme({
    required double width,
    double? height,
    Size? availableSize,
    TextTheme base = const TextTheme(),
    RfsTypographyScale scale = const RfsTypographyScale(),
    double? displayLarge,
    double? displayMedium,
    double? displaySmall,
    double? headlineLarge,
    double? headlineMedium,
    double? headlineSmall,
    double? titleLarge,
  }) {
    final effectiveConfig = config ?? const RfsConfig();
    final available = availableSize ?? Size(width, height ?? width);
    TextStyle size(TextStyle? style, RfsValue value, double? legacyMax) =>
        (style ?? const TextStyle()).copyWith(
          fontSize: Rfs.valueForSize(
            legacyMax ?? value.max,
            size: available,
            min: legacyMax == null ? value.min : null,
            config: effectiveConfig,
            dimension: dimension,
          ),
        );
    return base.copyWith(
      displayLarge: size(base.displayLarge, scale.displayLarge, displayLarge),
      displayMedium: size(
        base.displayMedium,
        scale.displayMedium,
        displayMedium,
      ),
      displaySmall: size(base.displaySmall, scale.displaySmall, displaySmall),
      headlineLarge: size(
        base.headlineLarge,
        scale.headlineLarge,
        headlineLarge,
      ),
      headlineMedium: size(
        base.headlineMedium,
        scale.headlineMedium,
        headlineMedium,
      ),
      headlineSmall: size(
        base.headlineSmall,
        scale.headlineSmall,
        headlineSmall,
      ),
      titleLarge: size(base.titleLarge, scale.titleLarge, titleLarge),
      titleMedium: size(base.titleMedium, scale.titleMedium, null),
      titleSmall: size(base.titleSmall, scale.titleSmall, null),
      bodyLarge: size(base.bodyLarge, scale.bodyLarge, null),
      bodyMedium: size(base.bodyMedium, scale.bodyMedium, null),
      bodySmall: size(base.bodySmall, scale.bodySmall, null),
      labelLarge: size(base.labelLarge, scale.labelLarge, null),
      labelMedium: size(base.labelMedium, scale.labelMedium, null),
      labelSmall: size(base.labelSmall, scale.labelSmall, null),
    );
  }
}
