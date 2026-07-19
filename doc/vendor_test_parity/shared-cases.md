# Shared vendor input cases

Every numbered vendor scenario processes the same 28 inputs from the Sass,
Less, Stylus, and PostCSS `main` fixture. Configuration changes alter their
expected output.

| Vendor selector | Vendor behavior | Dart equivalent | Status |
| --- | --- | --- | --- |
| 1 | `32px` font size while preserving unrelated declarations | `RfsText` and `Rfs.value(32, ...)` | Direct |
| 2 | `2rem` font size | Callers pass the resolved 32 logical pixels | Equivalent |
| 3 | Preserve `!important` | No Flutter equivalent | Not applicable |
| 4 | Generic `rfs()` font-size shorthand | `Rfs.value` or `Rfs.fontSize` | Direct |
| 5 | Preserve unsupported `em` input | Typed Dart APIs do not accept CSS units | Not applicable |
| 6 | Preserve `inherit` | Flutter style/theme inheritance | Equivalent; style preservation is tested |
| 7 | Work inside `@supports` | No CSS at-rule generation | Not applicable |
| 8 | Mixed unitless and responsive list | `Rfs.values` for numeric lists | Direct |
| 9 | Generic responsive padding property | `RfsEdgeInsets` or `RfsBox` | Direct |
| 10 | Padding shorthand | `RfsEdgeInsets.all` or scalar `RfsBox` padding | Direct |
| 11–14 | Individual padding sides | `RfsEdgeInsets` fields | Direct through typed-inset tests |
| 15–19 | Margin and individual margin sides | Physical/directional typed margin on `RfsBox` | Direct |
| 20 | Two responsive values | `Rfs.values` and typed multi-field values | Direct |
| 21 | Multiple values with `!important` | No Flutter equivalent for importance | Not applicable |
| 22 | Zero remains fixed | `Rfs.value(0, ...)` | Direct |
| 23 | Mixed zero and responsive value | `Rfs.values` | Direct |
| 24 | Multiple responsive box shadows | `RfsBoxShadow` and `RfsBox.boxShadows` | Direct for supported responsive shadow properties |
| 25 | Custom CSS property | `Rfs.value` or `RfsBuilder` for any numeric Flutter property | Direct |
| 26 | Small value remains fixed | Base-value cutoff | Direct |
| 27 | Negative responsive value | Generic `Rfs.value` | Direct |
| 28 | Small negative value remains fixed | Signed base-value cutoff | Direct |

CSS parsing, unit conversion, declaration preservation, `!important`, at-rules,
and output formatting are intentionally outside the Flutter runtime port.
