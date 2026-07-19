# Configuration

`RfsConfig` controls the scaling curve.

| Setting | Default | Purpose |
| --- | ---: | --- |
| `baseValue` | `20` | Values at or below this magnitude stay fixed |
| `breakpoint` | `1200` | Extent at which values reach their maximum |
| `factor` | `10` | Controls the derived minimum when `min` is omitted |
| `enabled` | `true` | Returns every maximum unchanged when disabled |

## Configure one calculation

```dart
final value = Rfs.value(
  64,
  width: 600,
  config: const RfsConfig(
    baseValue: 16,
    breakpoint: 1000,
    factor: 8,
  ),
);
```

## Configure a subtree

Wrap a section—or the complete app—in `RfsScope`:

```dart
RfsScope(
  config: const RfsConfig(baseValue: 16, breakpoint: 1000),
  dimension: RfsDimension.shortestSide,
  child: MaterialApp(...),
)
```

Scope-aware widgets, `RfsTypography.of`, and context-based resolution inherit
these settings. Explicit arguments always win.

Typed values do not have a `BuildContext`; pass a configuration and dimension
explicitly when resolving them directly.

## Disable a region

`RfsEnabled` toggles scaling without replacing the surrounding curve settings:

```dart
RfsEnabled(
  enabled: false,
  child: pixelPerfectChart,
)
```

This is useful for golden tests and for UI regions that must keep fixed values.
