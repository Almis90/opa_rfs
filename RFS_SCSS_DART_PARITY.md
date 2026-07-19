# RFS SCSS and Dart parity

This document compares the vendored Sass implementation in
`vendor/rfs/scss.scss` with the Flutter/Dart runtime implementation under
`lib/src`, exported through `lib/opa_rfs.dart`.

The SCSS implementation generates CSS declarations and media queries during a
Sass build. The Dart implementation resolves numeric values while Flutter lays
out the widget tree. The output mechanisms differ, but the responsive curve can
still be compared directly.

## Core calculation

| SCSS behavior | SCSS source or setting | Dart equivalent | Implemented? | Notes |
| --- | --- | --- | --- | --- |
| Default base value is `1.25rem` | `$rfs-base-value` | `RfsConfig.baseValue = 20` | Yes | With the upstream default of 16 pixels per REM, `1.25rem` equals 20 pixels. |
| Default breakpoint is `1200px` | `$rfs-breakpoint` | `RfsConfig.breakpoint = 1200` | Yes | Dart measures the breakpoint in Flutter logical pixels. |
| Default factor is `10` | `$rfs-factor` | `RfsConfig.factor = 10` | Yes | Both require the factor to be greater than one. |
| Values at or below the base remain fixed | `abs($value) <= $rfs-base-value` | `magnitude <= config.baseValue` | Yes | Dart preserves the cutoff even when its explicit `min` extension is supplied. |
| Calculate the fluid minimum | `$base + (abs($value) - $base) / $factor` | Same formula in `Rfs.value` | Yes | Both apply the sign after calculating the magnitude. |
| Calculate the fluid difference | `abs($value) - $value-min` | `max - minimum` interpolation | Yes | The resulting curve is equivalent. |
| Use viewport width below the breakpoint | `vw` inside `calc()` | Available width passed to `Rfs.value` | Yes | SCSS emits a formula; Dart evaluates the formula numerically. |
| Use the smaller viewport side | `$rfs-two-dimensional` and `vmin` | `RfsDimension.shortestSide` | Yes | Dart uses `min(width, height)`. |
| Use the maximum at or above the breakpoint | Media-query declaration | Explicit breakpoint clamp | Yes | The final runtime value is equivalent. |
| Preserve negative values | Negative minimum and `-` viewport term | Signed Dart calculation | Yes | Generic Dart values may be negative where the Flutter property permits it. |
| Preserve zero without a unit | Special zero branch | Return `0` | Yes | Dart returns numeric zero. |
| Disable RFS globally | `$enable-rfs: false` | `RfsConfig(enabled: false)` | Yes | Both return or emit the fixed maximum value. |
| Process value lists | Sass `@each` loop | `Rfs.values`, `Rfs.valuesForSize`, and typed helpers | Yes | Dart uses typed lists rather than mixed Sass tokens. |

## Configuration

| SCSS option | Purpose | Dart equivalent | Implemented? | Reason or difference |
| --- | --- | --- | --- | --- |
| `$rfs-base-value` | Set the responsive cutoff | `RfsConfig.baseValue` | Yes | Dart accepts an already-resolved number. |
| `$rfs-factor` | Set scaling strength | `RfsConfig.factor` | Yes | Invalid values are rejected in both implementations. |
| `$rfs-breakpoint` | Set the maximum fluid extent | `RfsConfig.breakpoint` | Yes | Dart uses logical pixels. |
| `$enable-rfs` | Globally enable or disable scaling | `RfsConfig.enabled` | Yes | Can also be inherited through `RfsScope`. |
| `$rfs-two-dimensional` | Switch from `vw` to `vmin` | `RfsDimension.shortestSide` | Yes | Available on scalar, typed, widget, scope, and typography APIs. |
| `$rfs-unit` | Select `rem` or `px` CSS output | None | Not applicable | Dart returns a `double`, not CSS text. |
| `$rfs-breakpoint-unit` | Serialize a `px`, `em`, or `rem` media query | None | Not applicable | Flutter receives resolved numeric layout constraints. |
| `$rfs-rem-value` | Define how many pixels equal one REM | None | Not applicable | Flutter has no CSS root-relative unit. Text accessibility uses `TextScaler`. |
| `$rfs-mode` | Choose min- or max-media-query output | Runtime breakpoint calculation | Runtime equivalent | The CSS declaration order changes, but the final responsive curve is the same. |
| `$rfs-class` | Generate `.enable-rfs` or `.disable-rfs` selectors | `RfsScope` and `enabled` | Flutter equivalent | Configuration applies to a widget subtree instead of a selector subtree. |
| `$rfs-safari-iframe-resize-bug-fix` | Emit `min-width: 0vw` | None | Not applicable | Browser-specific CSS workaround. |

## SCSS functions and mixins

| SCSS API | Purpose | Dart equivalent | Implemented? |
| --- | --- | --- | --- |
| `divide()` | Perform precision-controlled Sass division while retaining units | Native Dart arithmetic | Equivalent calculation |
| `rfs-value()` | Render the fixed, non-fluid CSS value | Disabled configuration or the original maximum | Runtime equivalent |
| `rfs-fluid-value()` | Render the responsive CSS `calc()` expression | `Rfs.value` and `Rfs.valueForSize` | Runtime equivalent |
| `rfs($values, $property)` | Apply RFS to an arbitrary CSS property | Pure scalar APIs and `RfsBuilder` | Yes, Flutter equivalent |
| `font-size()` | Responsive font-size shorthand | `RfsText`, `Rfs.fontSize`, and `RfsTypography` | Yes |
| `padding()` and side-specific padding mixins | Responsive padding values | `RfsEdgeInsets`, `RfsEdgeInsetsDirectional`, and `RfsBox` | Yes |
| `margin()` and side-specific margin mixins | Responsive margin values | Typed insets and `RfsBox` margin APIs | Yes |
| `_rfs-media-query` | Emit one- or two-dimensional media queries | `LayoutBuilder`, `MediaQuery`, and breakpoint clamping | Runtime equivalent |
| `_rfs-rule` | Emit base rules and optional selector overrides | Widget construction and `RfsScope` | Runtime equivalent |
| `_rfs-media-query-rule` | Emit responsive rules under the selected mode | Runtime layout recalculation | Runtime equivalent |

## Values, units, and CSS output

| SCSS feature | Dart behavior | Implemented? | Notes |
| --- | --- | --- | --- |
| Accept `px` input | Flutter logical pixels | Equivalent | Logical pixels are the native Flutter layout unit. |
| Accept `rem` input | No string or REM parser | Not applicable | Callers provide resolved numeric values. |
| Convert between `px` and `rem` | No output conversion | Not applicable | Dart does not serialize CSS. |
| Preserve unsupported units such as `em` | Dart type system rejects string values | Equivalent intent | Unsupported CSS tokens do not exist in typed numeric APIs. |
| Preserve values such as `inherit` | Use normal Flutter inheritance | Flutter equivalent | Theme and widget inheritance replace CSS keywords. |
| Preserve `!important` | Flutter composition and precedence | Not applicable | Flutter does not have CSS declaration importance. |
| Process mixed lists such as box shadows | Typed value objects and numeric lists | Partially equivalent | Common Flutter values are supported; arbitrary CSS token streams are intentionally not parsed. |
| Apply RFS to custom CSS properties | Pure numeric resolver and `RfsBuilder` | Flutter equivalent | Any Flutter property accepting a calculated number can use the core resolver. |
| Avoid media queries when fixed and fluid values match | Immediate fixed-value return | Yes | Dart does not create an alternate output path when the value is fixed. |

## Media-query and selector behavior

| SCSS behavior | Flutter equivalent | Implemented? | Notes |
| --- | --- | --- | --- |
| Min-width mode | Resolve fluid values below the breakpoint and maximum values above it | Yes | Default Dart behavior. |
| Max-width mode | Same final value curve with reversed CSS declaration placement | Runtime equivalent | No separate Dart mode is necessary. |
| Two-dimensional min-width query requires width and height | Clamp only when the shortest side reaches the breakpoint | Yes | Mathematically equivalent to the upstream `vmin` behavior. |
| `.enable-rfs` selector subtree | Enabled `RfsScope` subtree | Flutter equivalent | Widget-tree inheritance replaces selectors. |
| `.disable-rfs` selector subtree | Disabled `RfsScope` subtree | Flutter equivalent | Explicit widget configuration can override the inherited scope. |
| Selector specificity management | Flutter widget composition | Not applicable | Flutter has no CSS cascade or selector specificity. |

## Dart-only extensions

These features are native Flutter additions and do not exist in the SCSS API:

| Dart feature | Purpose |
| --- | --- |
| Explicit minimum endpoints | Override the factor-derived low endpoint while retaining the upstream cutoff. |
| `RfsValue` | Store and reuse responsive maximum/minimum pairs. |
| `RfsScope` | Inherit RFS configuration through a widget subtree. |
| `RfsBuilder` and `RfsMetrics` | Resolve arbitrary values from local layout constraints. |
| Typed resolvers | Produce insets, directional insets, radii, offsets, sizes, constraints, and shadows. |
| `resolveForSize` | Apply width or shortest-side behavior directly to typed values. |
| `RfsText` and `RfsText.rich` | Provide responsive text while preserving Flutter accessibility scaling and semantics. |
| `RfsBox` | Apply responsive layout and decoration values to a container. |
| `RfsTypography` | Resolve all 15 Material text styles. |
| Runtime validation | Reject invalid configuration and property-specific values in release builds. |

## Intentional non-goals

The following SCSS features should not be ported directly because they are CSS
build concerns rather than Flutter runtime behavior:

- Sass unit parsing and conversion.
- CSS string serialization.
- Media-query generation.
- Selector rewriting and specificity management.
- `!important` handling.
- CSS custom-property output.
- The Safari iframe workaround.
- Sass-specific precision and unit-preserving division.

## Summary

The Dart package implements the meaningful numeric and runtime behavior of the
SCSS implementation: default configuration, cutoff behavior, factor-derived
minimums, breakpoint clamping, negative values, disabled mode, lists, and
one- or two-dimensional sizing.

SCSS features that exist to parse Sass values or emit CSS are represented by
Flutter's type system, widget inheritance, and runtime layout where a meaningful
equivalent exists. They are otherwise intentionally excluded.
