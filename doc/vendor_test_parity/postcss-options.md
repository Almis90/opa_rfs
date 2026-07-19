# Vendor PostCSS option tests

`vendor/rfs/test/postcss/tests.js` supplies PostCSS options for the same 12
scenarios used by the preprocessor fixtures. It does not define an additional
behavior suite.

| PostCSS option | Dart equivalent | Coverage |
| --- | --- | --- |
| `enableRfs` | `RfsConfig.enabled` | Direct |
| `class` | `RfsEnabled` subtree | Flutter equivalent |
| `breakpoint` | `RfsConfig.breakpoint` | Direct |
| `baseValue` | `RfsConfig.baseValue` | Direct |
| `factor` | `RfsConfig.factor` | Direct |
| `twoDimensional` | `RfsDimension.shortestSide` | Direct |
| `unit` | None; Dart returns logical pixels | Not applicable |
| `breakpointUnit` | None; no CSS media query | Not applicable |
| `mode` | Direct runtime evaluation | Runtime equivalent |
| `safariIframeResizeBugFix` | None; browser-specific CSS output | Not applicable |

PostCSS parsing of `rfs(...)`, preservation of CSS tokens, and generated CSS
formatting are intentionally outside the Dart package.
