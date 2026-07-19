import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs_value.dart';
import '../core/extent.dart';
import 'validation.dart';

/// Fluid insets with start/end semantics that follow the text direction.
///
/// Resolves to an [EdgeInsetsDirectional], so `start` maps to the left
/// edge in LTR layouts and the right edge in RTL layouts. Use
/// `RfsEdgeInsets` when the edges should not flip.
class RfsEdgeInsetsDirectional {
  /// Creates fluid directional insets; edges default to zero.
  const RfsEdgeInsetsDirectional({
    this.start = const RfsValue(max: 0),
    this.top = const RfsValue(max: 0),
    this.end = const RfsValue(max: 0),
    this.bottom = const RfsValue(max: 0),
  });

  /// The fluid inset on the leading edge.
  final RfsValue start;

  /// The fluid inset on the top edge.
  final RfsValue top;

  /// The fluid inset on the trailing edge.
  final RfsValue end;

  /// The fluid inset on the bottom edge.
  final RfsValue bottom;

  /// Resolves all four edges for an available [width].
  ///
  /// Throws an [ArgumentError] when any endpoint is negative or not
  /// finite.
  EdgeInsetsDirectional resolve({
    required double width,
    RfsConfig config = const RfsConfig(),
  }) {
    validateNonNegativeValues([start, top, end, bottom], 'padding');
    return EdgeInsetsDirectional.only(
      start: start.resolve(width: width, config: config),
      top: top.resolve(width: width, config: config),
      end: end.resolve(width: width, config: config),
      bottom: bottom.resolve(width: width, config: config),
    );
  }

  /// Resolves all four edges using the extent selected from [size] by
  /// [dimension].
  EdgeInsetsDirectional resolveForSize({
    required Size size,
    RfsDimension dimension = RfsDimension.width,
    RfsConfig config = const RfsConfig(),
  }) => resolve(width: resolveExtent(size, dimension), config: config);
}
