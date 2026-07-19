import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs_value.dart';
import '../core/extent.dart';
import 'validation.dart';

/// Fluid insets for the physical edges left, top, right, and bottom.
///
/// Each edge is an [RfsValue]; [resolve] produces a regular [EdgeInsets]:
///
/// ```dart
/// final padding = RfsEdgeInsets.symmetric(
///   horizontal: const RfsValue(max: 48, min: 20),
///   vertical: const RfsValue(max: 32, min: 16),
/// ).resolve(width: 600);
/// ```
///
/// For start/end semantics that follow the text direction, use
/// `RfsEdgeInsetsDirectional`.
class RfsEdgeInsets {
  /// Creates fluid insets; edges default to zero.
  const RfsEdgeInsets({
    this.left = const RfsValue(max: 0),
    this.top = const RfsValue(max: 0),
    this.right = const RfsValue(max: 0),
    this.bottom = const RfsValue(max: 0),
  });

  /// Creates fluid insets with the same [value] on all four edges.
  factory RfsEdgeInsets.all(RfsValue value) =>
      RfsEdgeInsets(left: value, top: value, right: value, bottom: value);

  /// Creates fluid insets with [horizontal] left/right and [vertical]
  /// top/bottom endpoints.
  factory RfsEdgeInsets.symmetric({
    RfsValue horizontal = const RfsValue(max: 0),
    RfsValue vertical = const RfsValue(max: 0),
  }) => RfsEdgeInsets(
    left: horizontal,
    right: horizontal,
    top: vertical,
    bottom: vertical,
  );

  /// The fluid inset on the left edge.
  final RfsValue left;

  /// The fluid inset on the top edge.
  final RfsValue top;

  /// The fluid inset on the right edge.
  final RfsValue right;

  /// The fluid inset on the bottom edge.
  final RfsValue bottom;

  /// Resolves all four edges for an available [width].
  ///
  /// Throws an [ArgumentError] when any endpoint is negative or not
  /// finite.
  EdgeInsets resolve({
    required double width,
    RfsConfig config = const RfsConfig(),
  }) {
    validateNonNegativeValues([left, top, right, bottom], 'padding');
    return EdgeInsets.only(
      left: left.resolve(width: width, config: config),
      top: top.resolve(width: width, config: config),
      right: right.resolve(width: width, config: config),
      bottom: bottom.resolve(width: width, config: config),
    );
  }

  /// Resolves all four edges using the extent selected from [size] by
  /// [dimension].
  EdgeInsets resolveForSize({
    required Size size,
    RfsDimension dimension = RfsDimension.width,
    RfsConfig config = const RfsConfig(),
  }) => resolve(width: resolveExtent(size, dimension), config: config);
}
