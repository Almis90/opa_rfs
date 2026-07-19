import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs_value.dart';
import '../core/extent.dart';

/// A fluid two-dimensional offset.
///
/// Typically used for shadow offsets via `RfsBoxShadow`. Both components
/// may be negative.
class RfsOffset {
  /// Creates a fluid offset from [dx] and [dy] endpoints.
  const RfsOffset({required this.dx, required this.dy});

  /// The fluid horizontal component.
  final RfsValue dx;

  /// The fluid vertical component.
  final RfsValue dy;

  /// Resolves both components for an available [width].
  Offset resolve({
    required double width,
    RfsConfig config = const RfsConfig(),
  }) => Offset(
    dx.resolve(width: width, config: config),
    dy.resolve(width: width, config: config),
  );

  /// Resolves both components using the extent selected from [size] by
  /// [dimension].
  Offset resolveForSize({
    required Size size,
    RfsDimension dimension = RfsDimension.width,
    RfsConfig config = const RfsConfig(),
  }) => resolve(width: resolveExtent(size, dimension), config: config);
}
