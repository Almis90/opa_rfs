import '../core/rfs_value.dart';

void validateNonNegativeValues(Iterable<RfsValue> values, String name) {
  for (final value in values) {
    if (!value.max.isFinite ||
        value.max < 0 ||
        (value.min != null && (!value.min!.isFinite || value.min! < 0))) {
      throw ArgumentError.value(
        value,
        name,
        'must use finite, nonnegative endpoints',
      );
    }
  }
}
