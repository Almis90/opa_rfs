# RFS JavaScript and Dart parity

This document compares the vendored RFS JavaScript implementation with the
Flutter/Dart runtime port in `opa_rfs`.

The JavaScript reference is split across:

- `vendor/rfs/lib/rfs.js`, which parses and transforms CSS values.
- `vendor/rfs/postcss.js`, which applies those transformations to PostCSS rules
  and emits media queries.

The Dart implementation is split under `lib/src`, with
`lib/opa_rfs.dart` remaining the public export barrel. It resolves numeric
values at Flutter runtime using logical pixels and layout constraints. It does not parse
or generate CSS.

## Core calculation

| JavaScript behavior | JavaScript API or option | Dart equivalent | Implemented? | Notes |
| --- | --- | --- | --- | --- |
| Default base value is `20` | `baseValue` | `RfsConfig.baseValue` | Yes | Both use 20 logical/CSS pixels by default. |
| Default breakpoint is `1200` | `breakpoint` | `RfsConfig.breakpoint` | Yes | Dart treats it as a logical-pixel extent. |
| Default factor is `10` | `factor` | `RfsConfig.factor` | Yes | Both use the same minimum-value formula. |
| Values at or below the base cutoff remain fixed | `baseValue >= Math.abs(value)` | `magnitude <= config.baseValue` | Yes | The cutoff also applies when Dart's explicit `min` extension is supplied. |
| Calculate the fluid minimum | `baseValue + ((abs(value) - baseValue) / factor)` | Same formula in `Rfs.value` | Yes | Negative maximum values receive a negative minimum in both implementations. |
| Interpolate below the breakpoint | CSS `calc()` using `vw` | Numeric interpolation using available width | Yes | JavaScript emits a formula; Dart evaluates it immediately. |
| Clamp to the maximum at or above the breakpoint | Media-query output | `width >= breakpoint` | Yes | The final runtime behavior is equivalent. |
| Preserve negative values | Negative `calc()` output | Signed numeric result | Yes | Dart also allows negative generic values for offsets and shadow spread. |
| Disable responsive sizing | `enableRfs: false` | `RfsConfig(enabled: false)` | Yes | Dart returns the maximum value unchanged. |
| Two-dimensional `vmin` sizing | `twoDimensional: true` | `RfsDimension.shortestSide` | Yes | Dart uses the smaller of width and height. |
| Reject or bypass an invalid factor | JavaScript renders a fixed value when `factor <= 1` | Dart rejects `factor <= 1` | Yes, stricter | Dart treats invalid configuration as an `ArgumentError` in release mode. |
| Process several numeric values in one expression | Multiple word nodes inside `rfs(...)` | `Rfs.values` and `Rfs.valuesForSize` | Yes | Dart accepts typed numeric lists instead of CSS tokens. |

## Configuration and value representation

| JavaScript feature | JavaScript API or option | Dart equivalent | Implemented? | Reason or difference |
| --- | --- | --- | --- | --- |
| Input values in `px` | CSS value parsing | Flutter logical pixels | Equivalent | Logical pixels are the native Flutter layout unit. |
| Input values in `rem` | `remValue` conversion | None | Not applicable | Flutter does not use CSS root-relative units. Accessibility scaling is handled by `TextScaler`. |
| Output unit selection | `unit: 'px'` or `'rem'` | None | Not applicable | Dart returns a `double`, not serialized CSS. |
| Breakpoint units | `breakpointUnit: px/rem/em` | Logical pixels | Not applicable | Flutter constraints are already resolved numeric values. |
| Configurable REM size | `remValue` | None | Not applicable | There is no Flutter REM root. |
| Output decimal precision | `unitPrecision` and `toFixed()` | Native Dart `double` precision | Equivalent | Dart does not serialize a rounded CSS string. |
| Configurable CSS function name | `functionName` | None | Not applicable | There is no CSS function parser in the Dart package. |
| Read merged options | `getOptions()` | `RfsConfig` and `copyWith()` | Yes | Dart uses an immutable typed configuration object. |
| Parse string base values such as `20px` or `1.25rem` | Constructor parsing | Numeric `baseValue` | No, intentionally | Dart APIs accept already-resolved logical-pixel numbers. |
| Parse string breakpoints | Constructor parsing | Numeric `breakpoint` | No, intentionally | Dart APIs accept already-resolved logical-pixel numbers. |
| Ignore unsupported CSS units and tokens | Value parser | Dart type system | Equivalent | Unsupported strings cannot be passed to numeric Dart APIs. |

## JavaScript methods and Dart APIs

| JavaScript method | Purpose | Dart equivalent | Implemented? |
| --- | --- | --- | --- |
| `process(value, fluid)` | Parse an entire CSS value and transform `rfs(...)` nodes | Numeric resolvers and typed helpers | Partially equivalent |
| `value(value)` | Render the non-fluid CSS value | `RfsConfig(enabled: false)` or the original maximum | Runtime equivalent |
| `fluidValue(value)` | Render a CSS `calc()` value | `Rfs.value` / `Rfs.valueForSize` | Runtime equivalent |
| App-window scalar resolution | Resolve a value against the current viewport | `Rfs.contextValue` | Flutter equivalent; uses `MediaQuery.sizeOf` and inherited `RfsScope` settings |
| `renderValue(value)` | Serialize a number as `px`, `rem`, or zero | None | Not applicable |
| `renderMediaQuery()` | Generate a PostCSS media-query node | Layout constraints and breakpoint clamping | Runtime equivalent only |
| `getOptions()` | Return merged JavaScript options | `RfsConfig` | Yes |
| `toFixed()` | Round serialized CSS output | Native double calculation | Not needed |

## PostCSS integration

The following features live primarily in `vendor/rfs/postcss.js`, rather than
the core numeric calculation in `lib/rfs.js`.

| PostCSS feature | Dart or Flutter equivalent | Implemented? | Notes |
| --- | --- | --- | --- |
| Scan declarations for `rfs(...)` | Explicit Dart API calls | Not applicable | Flutter has no stylesheet compilation step. |
| Rewrite CSS declarations | Construct Flutter values and widgets | Runtime equivalent | Typed helpers produce `EdgeInsets`, radii, sizes, constraints, offsets, and shadows. |
| Generate min-width media queries | `LayoutBuilder`, `MediaQuery`, and breakpoint clamping | Runtime equivalent | Flutter recalculates during layout instead of emitting CSS. |
| Generate max-width media queries | Same resolved runtime curve | Runtime equivalent | Output ordering differs in CSS, but the final responsive value is the same. |
| Enable or disable RFS with selector classes | `RfsScope` and `RfsConfig.enabled` | Yes, Flutter equivalent | Configuration applies to a widget subtree rather than a CSS selector subtree. |
| Rewrite selectors for `.enable-rfs` or `.disable-rfs` | Widget-tree composition | Not applicable | Flutter has no selectors. |
| Preserve arbitrary declarations and unsupported tokens | Strongly typed Flutter values | Equivalent | Non-RFS properties remain ordinary Flutter properties. |
| Safari iframe resize workaround | None | Not applicable | This is a browser-specific CSS workaround. |

## Dart-only extensions

These APIs do not exist in the JavaScript implementation and are native
extensions for Flutter:

| Dart feature | Purpose |
| --- | --- |
| Explicit minimum endpoints | Allow callers to choose the low endpoint instead of using the factor-derived default. |
| `RfsValue` | Store and reuse a maximum/minimum pair. |
| `RfsScope` | Inherit configuration, enabled state, and dimension through the widget tree. |
| `RfsEnabled` | Override only enabled state for a nested subtree while preserving inherited configuration and dimension. |
| `RfsBuilder` and `RfsMetrics` | Resolve custom values from local layout constraints. |
| `Rfs.contextValue` | Resolve arbitrary app-window-relative numeric properties from `MediaQuery.sizeOf`. |
| Typed value helpers | Resolve insets, directional insets, radii, offsets, sizes, constraints, and shadows. |
| `resolveForSize` APIs | Apply width or shortest-side sizing consistently to typed values. |
| `RfsText` and `RfsText.rich` | Apply responsive font sizes while preserving Flutter text scaling and semantics. |
| `RfsBox` | Apply responsive layout and decoration values to a container. |
| `RfsTypography` | Build all 15 responsive Material text styles. |
| Runtime validation | Reject non-finite values and invalid property-specific dimensions. |

## Summary

The Dart package implements the meaningful runtime behavior of the JavaScript
RFS engine: the cutoff, factor-derived minimum, breakpoint behavior, negative
values, disabled mode, batch values, and one- or two-dimensional sizing.

JavaScript features concerned with parsing CSS, converting units, rounding
serialized strings, rewriting selectors, and generating media queries are not
ported directly because Flutter performs these operations through typed values,
widget composition, and runtime layout. Where a meaningful Flutter equivalent
exists, the table above identifies it.
