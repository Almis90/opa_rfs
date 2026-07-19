import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs_value.dart';
import 'corner_validation.dart';
import '../core/extent.dart';
import 'rfs_radius.dart';
import 'validation.dart';

/// A fluid border radius with start/end corners that follow the text
/// direction.
///
/// Resolves to a [BorderRadiusDirectional], so `topStart` maps to the
/// top-left corner in LTR layouts and the top-right corner in RTL
/// layouts. Use `RfsBorderRadius` when the corners should not flip.
class RfsBorderRadiusDirectional {
  /// Creates a fluid directional border radius; corners default to zero.
  const RfsBorderRadiusDirectional({
    this.topStart = const RfsRadius(RfsValue(max: 0)),
    this.topEnd = const RfsRadius(RfsValue(max: 0)),
    this.bottomEnd = const RfsRadius(RfsValue(max: 0)),
    this.bottomStart = const RfsRadius(RfsValue(max: 0)),
  });

  /// The fluid radius of the top leading corner.
  final RfsRadius topStart;

  /// The fluid radius of the top trailing corner.
  final RfsRadius topEnd;

  /// The fluid radius of the bottom trailing corner.
  final RfsRadius bottomEnd;

  /// The fluid radius of the bottom leading corner.
  final RfsRadius bottomStart;

  /// Resolves all four corners for an available [width].
  ///
  /// Throws an [ArgumentError] when any endpoint is negative or not
  /// finite.
  BorderRadiusDirectional resolve({
    required double width,
    RfsConfig config = const RfsConfig(),
  }) {
    validateNonNegativeValues(
      cornerValues([topStart, topEnd, bottomEnd, bottomStart]),
      'borderRadius',
    );
    return BorderRadiusDirectional.only(
      topStart: topStart.resolve(width: width, config: config),
      topEnd: topEnd.resolve(width: width, config: config),
      bottomEnd: bottomEnd.resolve(width: width, config: config),
      bottomStart: bottomStart.resolve(width: width, config: config),
    );
  }

  /// Resolves all four corners using the extent selected from [size] by
  /// [dimension].
  BorderRadiusDirectional resolveForSize({
    required Size size,
    RfsDimension dimension = RfsDimension.width,
    RfsConfig config = const RfsConfig(),
  }) => resolve(width: resolveExtent(size, dimension), config: config);
}
