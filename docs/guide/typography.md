# Typography

`RfsTypography` builds all 15 Material text styles with fluid font sizes while
preserving color, weight, height, letter spacing, and other base properties.

## Apply a fluid text theme

```dart
MaterialApp(
  builder: (context, child) => Theme(
    data: Theme.of(context).copyWith(
      textTheme: RfsTypography.of(context),
    ),
    child: child!,
  ),
  // ...
)
```

`RfsTypography.of` reads the ambient `Theme`, `MediaQuery`, and nearest
`RfsScope`.

## Customize the scale

```dart
final theme = const RfsTypography(
  dimension: RfsDimension.shortestSide,
).textTheme(
  width: 600,
  height: 900,
  scale: const RfsTypographyScale(
    displayLarge: RfsValue(max: 64, min: 40),
    bodyLarge: RfsValue(max: 18, min: 15),
  ),
);
```

Styles with maxima at or below the configured `baseValue` remain fixed unless
you lower the cutoff. This protects body and label text by default.
