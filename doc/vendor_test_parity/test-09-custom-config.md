# Vendor test 9: Combined custom configuration

## Vendor setup

Combines a 12px base, pixel output, breakpoint 800 with REM serialization,
two-dimensional sizing, factor 5, class output, and the Safari iframe fix.

## Dart comparison

| Vendor option | Dart coverage | Status |
| --- | --- | --- |
| Base value 12 | Configurable and exercised in validation/parity work | Direct behavior |
| Breakpoint 800 | Dedicated parity fixture | Direct |
| Factor 5 | Custom-config core tests | Direct |
| Two-dimensional | Dedicated fixtures and widgets | Direct |
| Enable/disable region | `RfsEnabled` widget tests | Equivalent |
| Pixel and REM serialization | No CSS output | Not applicable |
| Safari iframe workaround | Browser-specific CSS | Not applicable |

**Status: Partial aggregate coverage.** Every meaningful runtime option is
implemented and tested, but there is no single Dart fixture combining custom
base, factor, breakpoint, and shortest-side sizing. Adding one would protect
configuration composition.
