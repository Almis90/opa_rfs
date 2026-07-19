import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs.dart';
import '../core/rfs_value.dart';
import '../inherited/rfs_scope.dart';
import '../values/rfs_size.dart';

/// Measurements and resolvers passed to an [RfsBuilder] callback.
class RfsMetrics {
  /// Creates metrics for a measured layout area.
  const RfsMetrics({
    required this.width,
    required this.height,
    required this.dimension,
    required this.config,
  });

  /// The measured available width.
  final double width;

  /// The measured available height.
  final double height;

  /// Which extent [resolve] and [resolveSize] use.
  final RfsDimension dimension;

  /// The effective configuration for this layout area.
  final RfsConfig config;

  /// The extent selected from [width] and [height] by [dimension].
  double get extent => dimension == RfsDimension.width
      ? width
      : (width < height ? width : height);

  /// Resolves a fluid value against [extent].
  double resolve({required double max, double? min}) =>
      Rfs.value(max, width: extent, min: min, config: config);

  /// Resolves a fluid [Size] against [extent].
  Size resolveSize({required Size max, Size? min}) => RfsSize(
    width: RfsValue(max: max.width, min: min?.width),
    height: RfsValue(max: max.height, min: min?.height),
  ).resolve(width: extent, config: config);
}

/// Builds custom content with fluid-sizing metrics.
///
/// The low-level escape hatch behind `RfsText` and `RfsBox`: it measures
/// the local layout and hands the builder an [RfsMetrics] to resolve any
/// number of values against.
///
/// ```dart
/// RfsBuilder(
///   builder: (context, metrics) {
///     final blur = metrics.resolve(max: 40, min: 12);
///     return CustomPaint(painter: MyPainter(blur));
///   },
/// )
/// ```
///
/// Bounded constraints from the surrounding layout take precedence;
/// unbounded axes fall back to the current [MediaQuery] size.
class RfsBuilder extends StatelessWidget {
  /// Creates a builder that exposes fluid-sizing metrics.
  const RfsBuilder({
    super.key,
    required this.builder,
    this.config,
    this.dimension,
  });

  /// Called with the measured [RfsMetrics] to build the content.
  final Widget Function(BuildContext context, RfsMetrics metrics) builder;

  /// Overrides the configuration from the nearest [RfsScope].
  final RfsConfig? config;

  /// Overrides the dimension from the nearest [RfsScope].
  final RfsDimension? dimension;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scope = RfsScope.maybeOf(context);
      final size = MediaQuery.sizeOf(context);
      final effectiveConfig =
          config ?? scope?.effectiveConfig ?? const RfsConfig();
      final effectiveDimension =
          dimension ?? scope?.dimension ?? RfsDimension.width;
      return builder(
        context,
        RfsMetrics(
          width: constraints.hasBoundedWidth
              ? constraints.maxWidth
              : size.width,
          height: constraints.hasBoundedHeight
              ? constraints.maxHeight
              : size.height,
          dimension: effectiveDimension,
          config: effectiveConfig,
        ),
      );
    },
  );
}
