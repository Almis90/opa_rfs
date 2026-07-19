import 'package:flutter/widgets.dart';

import 'rfs_dimension.dart';

/// Selects and validates the responsive extent for size-based resolution.
double resolveExtent(Size size, RfsDimension dimension) {
  if (!size.width.isFinite || size.width < 0) {
    throw ArgumentError.value(
      size.width,
      'size.width',
      'must be finite and nonnegative',
    );
  }
  if (!size.height.isFinite || size.height < 0) {
    throw ArgumentError.value(
      size.height,
      'size.height',
      'must be finite and nonnegative',
    );
  }
  return dimension == RfsDimension.width
      ? size.width
      : (size.width < size.height ? size.width : size.height);
}
