import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs_value.dart';
import '../core/extent.dart';
import 'validation.dart';

/// Fluid box constraints with normalized minimum and maximum endpoints.
///
/// Omitted bounds behave like [BoxConstraints] defaults: minimums fall
/// back to zero and maximums to infinity. Resolved minimums are clamped so
/// they never exceed their resolved maximums.
class RfsBoxConstraints {
  /// Creates fluid constraints; omitted bounds stay unconstrained.
  const RfsBoxConstraints({
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
  });

  /// The fluid lower bound on width, or null for zero.
  final RfsValue? minWidth;

  /// The fluid upper bound on width, or null for unbounded.
  final RfsValue? maxWidth;

  /// The fluid lower bound on height, or null for zero.
  final RfsValue? minHeight;

  /// The fluid upper bound on height, or null for unbounded.
  final RfsValue? maxHeight;

  /// Resolves all bounds for an available [width].
  ///
  /// Throws an [ArgumentError] when any endpoint is negative or not
  /// finite.
  BoxConstraints resolve({
    required double width,
    RfsConfig config = const RfsConfig(),
  }) {
    validateNonNegativeValues(
      [minWidth, maxWidth, minHeight, maxHeight].whereType<RfsValue>(),
      'constraints',
    );
    final minimumWidth = minWidth?.resolve(width: width, config: config) ?? 0;
    final maximumWidth =
        maxWidth?.resolve(width: width, config: config) ?? double.infinity;
    final minimumHeight = minHeight?.resolve(width: width, config: config) ?? 0;
    final maximumHeight =
        maxHeight?.resolve(width: width, config: config) ?? double.infinity;
    return BoxConstraints(
      minWidth: minimumWidth.clamp(0, maximumWidth),
      maxWidth: maximumWidth,
      minHeight: minimumHeight.clamp(0, maximumHeight),
      maxHeight: maximumHeight,
    );
  }

  /// Resolves all bounds using the extent selected from [size] by
  /// [dimension].
  BoxConstraints resolveForSize({
    required Size size,
    RfsDimension dimension = RfsDimension.width,
    RfsConfig config = const RfsConfig(),
  }) => resolve(width: resolveExtent(size, dimension), config: config);
}
