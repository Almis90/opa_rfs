import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs_value.dart';
import '../core/extent.dart';
import 'validation.dart';

/// A fluid corner radius, circular or elliptical.
///
/// With only [x] the radius resolves as circular; providing [y] produces
/// an elliptical [Radius].
class RfsRadius {
  /// Creates a fluid radius from an [x] endpoint and an optional [y].
  const RfsRadius(this.x, [this.y]);

  /// The fluid radius along the horizontal axis.
  final RfsValue x;

  /// The fluid radius along the vertical axis; defaults to [x].
  final RfsValue? y;

  /// Resolves this radius for an available [width].
  ///
  /// Throws an [ArgumentError] when any endpoint is negative or not
  /// finite.
  Radius resolve({
    required double width,
    RfsConfig config = const RfsConfig(),
  }) {
    validateNonNegativeValues([x, y ?? x], 'radius');
    return Radius.elliptical(
      x.resolve(width: width, config: config),
      (y ?? x).resolve(width: width, config: config),
    );
  }

  /// Resolves this radius using the extent selected from [size] by
  /// [dimension].
  Radius resolveForSize({
    required Size size,
    RfsDimension dimension = RfsDimension.width,
    RfsConfig config = const RfsConfig(),
  }) => resolve(width: resolveExtent(size, dimension), config: config);
}
