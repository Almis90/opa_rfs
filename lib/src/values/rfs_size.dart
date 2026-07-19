import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs_value.dart';
import '../core/extent.dart';
import 'validation.dart';

/// A fluid two-dimensional size.
class RfsSize {
  /// Creates a fluid size from [width] and [height] endpoints.
  const RfsSize({required this.width, required this.height});

  /// The fluid width.
  final RfsValue width;

  /// The fluid height.
  final RfsValue height;

  /// Resolves both dimensions for an available [width].
  ///
  /// Throws an [ArgumentError] when any endpoint is negative or not
  /// finite.
  Size resolve({required double width, RfsConfig config = const RfsConfig()}) {
    validateNonNegativeValues([this.width, height], 'size');
    return Size(
      this.width.resolve(width: width, config: config),
      height.resolve(width: width, config: config),
    );
  }

  /// Resolves both dimensions using the extent selected from [size] by
  /// [dimension].
  Size resolveForSize({
    required Size size,
    RfsDimension dimension = RfsDimension.width,
    RfsConfig config = const RfsConfig(),
  }) => resolve(width: resolveExtent(size, dimension), config: config);
}
