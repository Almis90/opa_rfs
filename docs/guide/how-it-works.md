# How it works

Every fluid value has a maximum for large layouts and either an explicit or
derived minimum for small layouts.

## The curve

With an explicit minimum, resolution is linear and clamped:

```text
progress = clamp(extent / breakpoint, 0, 1)
resolved = minimum + (maximum - minimum) × progress
```

At or above the breakpoint, the maximum is returned exactly. At an extent of
zero, the minimum is returned exactly.

```dart
Rfs.value(64, width: 0, min: 36);    // 36
Rfs.value(64, width: 600, min: 36);  // 50
Rfs.value(64, width: 1200, min: 36); // 64
```

## Derived minimums

When `min` is omitted, the configuration derives a minimum magnitude:

```text
minimumMagnitude = baseValue + (|max| - baseValue) / factor
minimum = sign(max) × minimumMagnitude
```

The default configuration uses a base value of `20`, a factor of `10`, and a
breakpoint of `1200`.

## Small-value cutoff

Values whose absolute maximum is at or below `baseValue` remain fixed. This
keeps body text, borders, and fine visual details from shrinking by default.

```dart
Rfs.value(18, width: 320); // 18 with the default baseValue
```

Lower `baseValue` when smaller design tokens should participate in the curve.

## Negative values

Negative maxima preserve their sign and mirror the same curve, which makes
fluid negative offsets and margins predictable:

```dart
Rfs.value(-64, width: 600); // -44.2 with the default configuration
```

## Width or shortest side

Width drives resolution by default. For layouts where a short landscape height
should constrain scaling, use `RfsDimension.shortestSide`:

```dart
Rfs.valueForSize(
  64,
  size: const Size(800, 500),
  dimension: RfsDimension.shortestSide,
);
```
