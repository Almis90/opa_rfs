import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs_value.dart';
import 'rfs_offset.dart';
import '../core/extent.dart';
import 'validation.dart';

/// A fluid box shadow whose offset, blur, and spread scale together.
///
/// ```dart
/// const RfsBoxShadow(
///   offset: RfsOffset(
///     dx: RfsValue(max: 16, min: 4),
///     dy: RfsValue(max: 12, min: 3),
///   ),
///   blurRadius: RfsValue(max: 40, min: 12),
/// ).resolve(width: 600);
/// ```
class RfsBoxShadow {
  /// Creates a fluid shadow; components default to zero.
  const RfsBoxShadow({
    this.color = const Color(0x33000000),
    this.offset = const RfsOffset(dx: RfsValue(max: 0), dy: RfsValue(max: 0)),
    this.blurRadius = const RfsValue(max: 0),
    this.spreadRadius = const RfsValue(max: 0),
  });

  /// The shadow color; not affected by scaling.
  final Color color;

  /// The fluid displacement of the shadow.
  final RfsOffset offset;

  /// The fluid blur radius; endpoints must be nonnegative.
  final RfsValue blurRadius;

  /// The fluid spread distance; may be negative to inset the shadow.
  final RfsValue spreadRadius;

  /// Resolves this shadow for an available [width].
  ///
  /// Throws an [ArgumentError] when a blur endpoint is negative or not
  /// finite.
  BoxShadow resolve({
    required double width,
    RfsConfig config = const RfsConfig(),
  }) {
    validateNonNegativeValues([blurRadius], 'shadow.blurRadius');
    return BoxShadow(
      color: color,
      offset: offset.resolve(width: width, config: config),
      blurRadius: blurRadius.resolve(width: width, config: config),
      spreadRadius: spreadRadius.resolve(width: width, config: config),
    );
  }

  /// Resolves this shadow using the extent selected from [size] by
  /// [dimension].
  BoxShadow resolveForSize({
    required Size size,
    RfsDimension dimension = RfsDimension.width,
    RfsConfig config = const RfsConfig(),
  }) => resolve(width: resolveExtent(size, dimension), config: config);
}
