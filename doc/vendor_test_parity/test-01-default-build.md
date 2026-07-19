# Vendor test 1: Default build

## Vendor setup

No configuration overrides. Expected defaults are a 20px base value, 1200px
breakpoint, factor 10, width-based interpolation, REM output, and min-width
media queries.

## Dart comparison

| Behavior | Dart coverage | Status |
| --- | --- | --- |
| Default base, breakpoint, and factor | Default parity fixtures for values 32 and 64 | Direct |
| Fluid values below 1200 | Widths 0, 360, 600, and 1199 | Direct |
| Maximum at and above 1200 | Widths 1200 and 1600 | Direct |
| Zero, small values, and negative values | Core `Rfs.value` tests and parity fixtures | Direct |
| Lists and typed padding | `Rfs.values`, `RfsEdgeInsets`, and `RfsBox` tests | Direct |
| Responsive margin adapter | API exists | Gap |
| Numerically responsive shadow radius | API exists; list construction is tested | Gap |
| REM/CSS/media-query text | Dart returns logical-pixel numbers | Not applicable |

See [shared-cases.md](shared-cases.md) for all 28 common inputs.
