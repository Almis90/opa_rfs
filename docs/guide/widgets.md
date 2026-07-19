# Widgets

The widget APIs measure local constraints and inherit configuration from the
nearest `RfsScope`.

## RfsText

`RfsText` forwards Flutter's regular text options and replaces only the font
size with a resolved value:

```dart
const RfsText(
  'Fluid headline',
  maxFontSize: 64,
  minFontSize: 36,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

Use `RfsText.rich` for an `InlineSpan` tree.

## RfsBox

`RfsBox` is a fluid container with scalar shortcuts and typed values:

```dart
RfsBox(
  maxPadding: 32,
  minPadding: 16,
  maxBorderRadius: 24,
  boxShadow: const RfsBoxShadow(
    blurRadius: RfsValue(max: 40, min: 12),
  ),
  decoration: const BoxDecoration(color: Colors.white),
  child: content,
)
```

It also supports fluid width, height, margins, constraints, layered shadows,
per-edge insets, and physical or directional corner radii.

## RfsBuilder

Use the low-level builder for custom layout and painting:

```dart
RfsBuilder(
  builder: (context, metrics) {
    final blur = metrics.resolve(max: 40, min: 12);
    final size = metrics.resolveSize(
      max: const Size(320, 200),
      min: const Size(200, 120),
    );
    return CustomPaint(
      size: size,
      painter: GlowPainter(blur),
    );
  },
)
```

Bounded local constraints take precedence. Unbounded axes fall back to the
current application-window size.
