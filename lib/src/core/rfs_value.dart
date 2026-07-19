import 'package:flutter/widgets.dart';

import 'rfs.dart';
import 'rfs_config.dart';
import 'rfs_dimension.dart';

/// A reusable pair of fluid endpoints: a maximum and an optional minimum.
///
/// An [RfsValue] is a declarative description of a fluid value that can be
/// stored as a `const` and resolved on demand:
///
/// ```dart
/// const headline = RfsValue(max: 64, min: 36);
/// final fontSize = headline.resolve(width: 600);
/// ```
///
/// Typed containers such as `RfsEdgeInsets` and `RfsBoxShadow` are built
/// from these values.
class RfsValue {
  /// Creates a fluid value with a [max] endpoint and an optional [min].
  const RfsValue({required this.max, this.min});

  /// The value used at or above the configured breakpoint.
  final double max;

  /// The value approached as the extent shrinks toward zero.
  ///
  /// When omitted, a minimum is derived from the configuration as
  /// `baseValue + (|max| - baseValue) / factor`.
  final double? min;

  /// Resolves this value for an available [width].
  double resolve({
    required double width,
    RfsConfig config = const RfsConfig(),
  }) => Rfs.value(max, width: width, min: min, config: config);

  /// Resolves this value using the extent selected from [size] by
  /// [dimension].
  double resolveForSize({
    required Size size,
    RfsDimension dimension = RfsDimension.width,
    RfsConfig config = const RfsConfig(),
  }) => Rfs.valueForSize(
    max,
    size: size,
    min: min,
    dimension: dimension,
    config: config,
  );
}
