import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs_value.dart';
import 'rfs_radius.dart';
import 'corner_validation.dart';
import '../core/extent.dart';
import 'validation.dart';

/// A fluid border radius for the four physical corners.
///
/// Each corner is an [RfsRadius]; [resolve] produces a regular
/// [BorderRadius]. For start/end corners that follow the text direction,
/// use `RfsBorderRadiusDirectional`.
class RfsBorderRadius {
  /// Creates a fluid border radius; corners default to zero.
  const RfsBorderRadius({
    this.topLeft = const RfsRadius(RfsValue(max: 0)),
    this.topRight = const RfsRadius(RfsValue(max: 0)),
    this.bottomRight = const RfsRadius(RfsValue(max: 0)),
    this.bottomLeft = const RfsRadius(RfsValue(max: 0)),
  });

  /// The fluid radius of the top-left corner.
  final RfsRadius topLeft;

  /// The fluid radius of the top-right corner.
  final RfsRadius topRight;

  /// The fluid radius of the bottom-right corner.
  final RfsRadius bottomRight;

  /// The fluid radius of the bottom-left corner.
  final RfsRadius bottomLeft;

  /// Resolves all four corners for an available [width].
  ///
  /// Throws an [ArgumentError] when any endpoint is negative or not
  /// finite.
  BorderRadius resolve({
    required double width,
    RfsConfig config = const RfsConfig(),
  }) {
    validateNonNegativeValues(
      cornerValues([topLeft, topRight, bottomRight, bottomLeft]),
      'borderRadius',
    );
    return BorderRadius.only(
      topLeft: topLeft.resolve(width: width, config: config),
      topRight: topRight.resolve(width: width, config: config),
      bottomRight: bottomRight.resolve(width: width, config: config),
      bottomLeft: bottomLeft.resolve(width: width, config: config),
    );
  }

  /// Resolves all four corners using the extent selected from [size] by
  /// [dimension].
  BorderRadius resolveForSize({
    required Size size,
    RfsDimension dimension = RfsDimension.width,
    RfsConfig config = const RfsConfig(),
  }) => resolve(width: resolveExtent(size, dimension), config: config);
}
