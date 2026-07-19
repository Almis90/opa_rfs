import 'package:flutter/widgets.dart';

import '../inherited/rfs_scope.dart';
import 'extent.dart';
import 'rfs_config.dart';
import 'rfs_dimension.dart';

/// Static entry points for resolving fluid values.
///
/// Each method takes a maximum value and interpolates it against an
/// available extent: at or above [RfsConfig.breakpoint] the maximum is
/// returned unchanged; below it the value shrinks linearly toward a
/// minimum — explicit when given, otherwise derived as
/// `baseValue + (|max| - baseValue) / factor`.
///
/// ```dart
/// final headline = Rfs.value(64, width: 600, min: 36);
/// final padding = Rfs.contextValue(context, 48, min: 20);
/// ```
class Rfs {
  const Rfs._();

  /// Resolves [max] for an available [width].
  ///
  /// Returns [max] unchanged when the configuration is disabled, when
  /// `|max|` is at or below [RfsConfig.baseValue], or when [width] is at
  /// or above [RfsConfig.breakpoint]. Otherwise interpolates linearly
  /// between the minimum (explicit [min], or derived) and [max]. Negative
  /// maxima keep their sign and mirror the same curve.
  ///
  /// Throws an [ArgumentError] when [max], [width], [min], or the
  /// configuration values are not finite.
  static double value(
    double max, {
    required double width,
    double? min,
    RfsConfig config = const RfsConfig(),
  }) {
    _validate(max, width, min);
    _validateConfig(config);
    if (!config.enabled) return max;
    final magnitude = max.abs();
    if (magnitude <= config.baseValue || max == 0) return max;
    final minimumMagnitude =
        min?.abs() ??
        config.baseValue + (magnitude - config.baseValue) / config.factor;
    final minimum = max.isNegative ? -minimumMagnitude : minimumMagnitude;
    if (width >= config.breakpoint) return max;
    final progress = (width / config.breakpoint).clamp(0.0, 1.0);
    return minimum + (max - minimum) * progress;
  }

  /// Resolves [max] against the extent selected from [size] by
  /// [dimension].
  ///
  /// With [RfsDimension.width] this is equivalent to passing `size.width`
  /// to [value]; with [RfsDimension.shortestSide] the smaller of width and
  /// height drives the calculation.
  static double valueForSize(
    double max, {
    required Size size,
    double? min,
    RfsConfig config = const RfsConfig(),
    RfsDimension dimension = RfsDimension.width,
  }) {
    return value(
      max,
      width: resolveExtent(size, dimension),
      min: min,
      config: config,
    );
  }

  /// Resolves multiple maximum values for one available [width].
  ///
  /// When [mins] is provided it must have the same length as [maxValues];
  /// each entry supplies the explicit minimum for the value at the same
  /// index, with null entries falling back to the derived minimum.
  static List<double> values(
    List<double> maxValues, {
    required double width,
    List<double?>? mins,
    RfsConfig config = const RfsConfig(),
  }) {
    if (mins != null && mins.length != maxValues.length) {
      throw ArgumentError('mins must have the same length as maxValues');
    }
    return [
      for (var i = 0; i < maxValues.length; i++)
        value(maxValues[i], width: width, min: mins?[i], config: config),
    ];
  }

  /// Resolves multiple values using an extent selected from [size].
  static List<double> valuesForSize(
    List<double> maxValues, {
    required Size size,
    List<double?>? mins,
    RfsConfig config = const RfsConfig(),
    RfsDimension dimension = RfsDimension.width,
  }) {
    if (mins != null && mins.length != maxValues.length) {
      throw ArgumentError('mins must have the same length as maxValues');
    }
    return [
      for (var i = 0; i < maxValues.length; i++)
        valueForSize(
          maxValues[i],
          size: size,
          min: mins?[i],
          config: config,
          dimension: dimension,
        ),
    ];
  }

  /// Resolves any app-window-relative scalar using the current context.
  ///
  /// This is suitable for spacing, dimensions, radii, shadows, typography,
  /// and other numeric properties. The returned value is an unscaled logical
  /// pixel value; Flutter's ambient accessibility [TextScaler] remains owned
  /// by text layout.
  static double contextValue(
    BuildContext context,
    double max, {
    double? min,
    RfsConfig? config,
    RfsDimension? dimension,
  }) {
    final scope = RfsScope.maybeOf(context);
    return valueForSize(
      max,
      size: MediaQuery.sizeOf(context),
      min: min,
      config: config ?? scope?.effectiveConfig ?? const RfsConfig(),
      dimension: dimension ?? scope?.dimension ?? RfsDimension.width,
    );
  }

  /// Resolves a font size using the current app-window size.
  static double fontSize(
    BuildContext context,
    double max, {
    double? min,
    RfsConfig? config,
    RfsDimension? dimension,
  }) => contextValue(
    context,
    max,
    min: min,
    config: config,
    dimension: dimension,
  );

  static void _validate(double max, double width, double? min) {
    if (!max.isFinite || !width.isFinite || (min != null && !min.isFinite)) {
      throw ArgumentError('RFS values must be finite');
    }
  }

  static void _validateConfig(RfsConfig config) {
    if (!config.breakpoint.isFinite || config.breakpoint <= 0) {
      throw ArgumentError.value(config.breakpoint, 'breakpoint');
    }
    if (!config.factor.isFinite || config.factor <= 1) {
      throw ArgumentError.value(config.factor, 'factor');
    }
    if (!config.baseValue.isFinite || config.baseValue < 0) {
      throw ArgumentError.value(config.baseValue, 'baseValue');
    }
  }
}
