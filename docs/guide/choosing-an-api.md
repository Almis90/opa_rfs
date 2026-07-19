# Choosing an API

Start with the most local extent available. This keeps reusable components
responsive to their own space rather than accidentally coupling them to the
application window.

| Situation | API |
| --- | --- |
| You already know the width | `Rfs.value(max, width: width)` |
| You have a complete `Size` | `Rfs.valueForSize(max, size: size)` |
| You only have a `BuildContext` | `Rfs.contextValue(context, max)` |
| The call site is specifically typography | `Rfs.fontSize(context, max)` |
| Several values share one width | `Rfs.values([...], width: width)` |
| Endpoints should be reusable and `const` | `RfsValue(max: ..., min: ...)` |
| A widget should use local constraints | `RfsBuilder` |
| You need fluid text | `RfsText` or `RfsTypography` |
| You need a fluid container | `RfsBox` |

## Prefer local sizing for components

Use `LayoutBuilder`, `RfsBuilder`, `RfsText`, or `RfsBox` when a component can
appear in areas with different widths. A card in a sidebar should not resolve
as though it occupies the full application window.

## Use context sizing for application tokens

`Rfs.contextValue` is convenient for page-level values that intentionally
follow the window, such as a shell's outer padding or a global headline size.

## Batch repeated calculations

When several scalar values use the same extent and configuration, resolve them
together:

```dart
final [title, subtitle, caption] = Rfs.values(
  [48, 24, 14],
  width: width,
  mins: [30, 18, null],
);
```

A `null` minimum uses the configured derived minimum for that entry.
