# Accessibility

Fluid layout sizing and accessibility text scaling solve different problems.
`opa_rfs` keeps them separate.

## What opa_rfs controls

The package resolves an unscaled logical-pixel font size from the available
layout. This establishes the design's responsive base size.

## What Flutter controls

Flutter's ambient `TextScaler` remains responsible for applying the user's
system font-size preference, including nonlinear platform scaling. The package
does not multiply, clamp, replace, or disable it.

The result is the same composition Flutter uses with fixed font sizes:

```text
responsive base font size → ambient TextScaler → text layout
```

## Practical guidance

- Test the smallest layout together with increased system text sizes.
- Allow text to wrap and avoid tight fixed-height containers around text.
- Keep meaningful minimums for display and headline styles.
- Use structural breakpoints when content must change from a row to a column.
- Treat `RfsEnabled(enabled: false)` as a layout tool, not an accessibility
  override.
