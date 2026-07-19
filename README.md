<p align="center">
  <img src="https://raw.githubusercontent.com/Almis90/opa_rfs/main/docs/public/logo.svg" alt="opa_rfs responsive frame logo" width="160">
</p>

# opa_rfs

[![pub package](https://img.shields.io/pub/v/opa_rfs.svg)](https://pub.dev/packages/opa_rfs)
[![pub points](https://img.shields.io/pub/points/opa_rfs)](https://pub.dev/packages/opa_rfs/score)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![documentation](https://img.shields.io/badge/docs-GitHub%20Pages-147d92.svg)](https://almis90.github.io/opa_rfs/)

**Fluid responsive sizing for Flutter.** Give any value a maximum and an
optional minimum, and it scales smoothly with the available space —
typography, spacing, radii, shadows, and whole text themes adapt
continuously instead of jumping between breakpoints. A Flutter-native
port of [twbs/rfs](https://github.com/twbs/rfs).

```dart
Text(
  'Fluid headline',
  style: TextStyle(fontSize: Rfs.contextValue(context, 64, min: 36)),
)
```

---

- [Introduction](#introduction)
  - [What is opa_rfs?](#what-is-opa_rfs)
  - [Why opa_rfs?](#why-opa_rfs)
- [Installation](#installation)
- [Quick start](#quick-start)
- [How it works](#how-it-works)
  - [The scaling curve](#the-scaling-curve)
  - [Configuration](#configuration)
  - [Edge cases and guarantees](#edge-cases-and-guarantees)
- [Choosing the right API](#choosing-the-right-api)
- [Core API](#core-api)
  - [Resolving single values](#resolving-single-values)
  - [Reusable values with RfsValue](#reusable-values-with-rfsvalue)
  - [Batch resolution](#batch-resolution)
- [App-wide configuration](#app-wide-configuration)
  - [RfsScope](#rfsscope)
  - [RfsEnabled](#rfsenabled)
  - [Disabling scaling](#disabling-scaling)
- [Two-dimensional sizing](#two-dimensional-sizing)
- [Typed values](#typed-values)
- [Widgets](#widgets)
  - [RfsText](#rfstext)
  - [RfsBox](#rfsbox)
  - [RfsBuilder](#rfsbuilder)
- [Typography](#typography)
- [Accessibility](#accessibility)
- [Example app](#example-app)
- [FAQ](#faq)
- [Development](#development)
- [License](#license)

---

## Introduction

### What is opa_rfs?

`opa_rfs` is a runtime fluid-sizing engine. Every value you hand it is a
pair of endpoints — a maximum for large layouts and a minimum for small
ones — and it returns the interpolated value for the space you actually
have. One algorithm drives everything: font sizes, padding, margins,
corner radii, shadows, offsets, dimensions, constraints, and complete
Material text themes.

It works entirely in Flutter logical pixels against layout constraints or
the app window. There is no code generation, no build step, and no
configuration file — the default configuration is tuned to look right out
of the box.

### Why opa_rfs?

The traditional approach to responsive Flutter UI is breakpoints:

```dart
final fontSize = width >= 1200 ? 64.0 : width >= 800 ? 48.0 : 36.0;
```

This produces visible jumps while resizing, multiplies magic numbers
across the codebase, and treats every size in isolation. The common
alternative — multiplying everything by `screenWidth / designWidth` —
scales body text and paddings into unreadable extremes on small and large
screens alike.

`opa_rfs` takes a third path:

- **Continuous, not stepped.** Values interpolate smoothly, so resizing a
  window or rotating a device never snaps the layout.
- **Bounded, not proportional.** Every value has endpoints. Large
  headlines shrink meaningfully on phones; body text stays put.
- **Small values are protected.** Anything at or below the configured
  base value (20 by default) never scales, so captions, borders, and icon
  strokes remain crisp.
- **One system for everything.** Because type, spacing, radii, and
  shadows follow the same curve, whole layouts scale together and keep
  their proportions.
- **Accessibility stays intact.** Resolved values are unscaled logical
  pixels; Flutter's ambient `TextScaler` is never touched.

## Installation

```yaml
dependencies:
  opa_rfs: ^1.0.0
```

```dart
import 'package:opa_rfs/opa_rfs.dart';
```

No further setup is required. Optionally wrap your app in an
[`RfsScope`](#rfsscope) to share a custom configuration.

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:opa_rfs/opa_rfs.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RfsBox(
      maxPadding: 48,          // 48px of padding on desktop…
      minPadding: 20,          // …easing down to 20px on phones
      maxBorderRadius: 28,
      boxShadow: const RfsBoxShadow(
        blurRadius: RfsValue(max: 40, min: 12),
      ),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RfsText(
            'Build fluid layouts',
            maxFontSize: 64,
            minFontSize: 36,
          ),
          const SizedBox(height: 12),
          Text(
            'Everything above scales together.',
            style: TextStyle(fontSize: Rfs.contextValue(context, 20, min: 16)),
          ),
        ],
      ),
    );
  }
}
```

## How it works

### The scaling curve

Each value resolves along a simple, predictable curve:

```text
resolved
   ▲
64 ┤                              ╭──────────────  max, clamped
   │                        ╭─────╯
   │                  ╭─────╯
   │            ╭─────╯
36 ┤ ─ ─ ─ ─ ─ ─╯                                  min
   │
   └────────────┬─────────────────┬─────────────►  extent
                0            breakpoint (1200)
```

```text
minimumMagnitude = baseValue + (|max| - baseValue) / factor // unless min is given
minimum          = sign(max) × minimumMagnitude
resolved         = minimum + (max - minimum) × extent / breakpoint
```

- At or above `breakpoint`, the value is exactly `max`.
- Below it, the value interpolates linearly toward the minimum as the
  extent approaches zero.
- When you don't pass an explicit `min`, one is derived from the
  configuration — larger maxima get proportionally deeper scaling.

### Configuration

All knobs live on `RfsConfig`:

| Parameter    | Default | Meaning                                               |
| ------------ | ------- | ----------------------------------------------------- |
| `baseValue`  | `20`    | Cutoff below which values never scale                 |
| `breakpoint` | `1200`  | Extent at which values reach their maximum            |
| `factor`     | `10`    | Steepness of the derived minimum (higher = shallower) |
| `enabled`    | `true`  | Set `false` to always resolve to `max`                |

Pass a config to any call, or provide one app-wide with
[`RfsScope`](#rfsscope):

```dart
final value = Rfs.value(
  64,
  width: 600,
  config: const RfsConfig(baseValue: 16, breakpoint: 1000, factor: 8),
);
```

### Edge cases and guarantees

- **Small-value cutoff.** A value whose absolute maximum is at or below
  `baseValue` stays fixed — even when an explicit `min` is supplied.
  Lower `baseValue` if small values should scale too.
- **Negative values.** Negative maxima keep their sign and mirror the
  same curve, so fluid negative margins and offsets behave symmetrically.
- **Clamping.** Values never overshoot: above the breakpoint you always
  get exactly `max`.
- **Validation.** Non-finite inputs, negative insets/radii, and invalid
  configurations throw `ArgumentError` rather than propagating NaNs into
  the layout.

## Choosing the right API

| You have…                                    | Use                              |
| -------------------------------------------- | -------------------------------- |
| A known width (e.g. from a `LayoutBuilder`)  | `Rfs.value(max, width: …)`       |
| A full `Size`                                | `Rfs.valueForSize(max, size: …)` |
| A `BuildContext` (app-window sizing)         | `Rfs.contextValue(context, max)` |
| A font size and a `BuildContext`             | `Rfs.fontSize(context, max)`     |
| Many values for the same width               | `Rfs.values([…], width: …)`      |
| A value you want to declare `const` & reuse  | `RfsValue(max: …, min: …)`       |
| Text                                         | `RfsText` / `RfsTypography`      |
| A container                                  | `RfsBox`                         |
| Anything custom, sized to local constraints  | `RfsBuilder`                     |

## Core API

### Resolving single values

```dart
// Explicit extent — deterministic and test-friendly.
final headline = Rfs.value(64, width: 600, min: 36);

// From a Size, optionally by shortest side.
final gap = Rfs.valueForSize(
  24,
  size: const Size(800, 500),
  dimension: RfsDimension.shortestSide,
);

// From the BuildContext: reads MediaQuery and the nearest RfsScope.
final padding = Rfs.contextValue(context, 48, min: 20);

// Same as contextValue, named for typography call sites.
final title = Rfs.fontSize(context, 34);
```

### Reusable values with RfsValue

`RfsValue` turns an endpoint pair into a `const` you can share across the
app and resolve wherever an extent is available:

```dart
abstract final class AppSizes {
  static const heroTitle = RfsValue(max: 64, min: 36);
  static const cardPadding = RfsValue(max: 32, min: 16);
}

final fontSize = AppSizes.heroTitle.resolve(width: 600);
final forSize = AppSizes.heroTitle.resolveForSize(
  size: const Size(800, 500),
  dimension: RfsDimension.shortestSide,
);
```

All [typed values](#typed-values) are built from `RfsValue`s.

### Batch resolution

```dart
final [title, subtitle, caption] =
    Rfs.values([48, 24, 14], width: 600, mins: [30, 18, null]);

final [gap, radius] = Rfs.valuesForSize(
  [24, 16],
  size: const Size(800, 500),
  dimension: RfsDimension.shortestSide,
);
```

A `null` entry in `mins` falls back to the derived minimum for that value.

## App-wide configuration

### RfsScope

`RfsScope` is an `InheritedWidget` that supplies configuration and a
default dimension to everything below it — widgets, typography, and
`Rfs.contextValue` all read it automatically:

```dart
RfsScope(
  config: const RfsConfig(baseValue: 16, breakpoint: 1000),
  dimension: RfsDimension.shortestSide,
  child: MaterialApp(...),
)
```

Explicit arguments always take precedence over the scope. Use
`RfsScope.of(context)` / `RfsScope.maybeOf(context)` for direct access.

### RfsEnabled

`RfsEnabled` flips the enabled state for a subtree while inheriting
everything else from the surrounding scope. Nest freely — the nearest one
wins:

```dart
RfsScope(
  config: const RfsConfig(baseValue: 12, factor: 6),
  child: Column(
    children: [
      fluidContent,
      RfsEnabled(enabled: false, child: pixelPerfectChart),
    ],
  ),
)
```

### Disabling scaling

Any of these produce fixed values that resolve to `max`:

```dart
Rfs.value(64, width: 360, config: const RfsConfig(enabled: false));
RfsScope(config: const RfsConfig(enabled: false), child: app);
RfsEnabled(enabled: false, child: section);
```

This is handy for golden tests and for A/B-ing fluid vs. fixed layouts.

## Two-dimensional sizing

Width is the default driving extent. `RfsDimension.shortestSide` resolves
against the smaller of width and height instead, so rotating a phone to
landscape does not inflate the UI:

```dart
final value = Rfs.valueForSize(
  64,
  size: const Size(800, 500), // resolves against 500
  dimension: RfsDimension.shortestSide,
);
```

Every scope-aware widget accepts a `dimension` or inherits it from the
nearest `RfsScope`. Typed values have no `BuildContext`, so pass a
`dimension` explicitly to `resolveForSize` when using them directly.

## Typed values

Each typed value composes `RfsValue` endpoints and resolves into its
Flutter counterpart:

| Fluid type                   | Resolves to               |
| ---------------------------- | ------------------------- |
| `RfsEdgeInsets`              | `EdgeInsets`              |
| `RfsEdgeInsetsDirectional`   | `EdgeInsetsDirectional`   |
| `RfsRadius`                  | `Radius`                  |
| `RfsBorderRadius`            | `BorderRadius`            |
| `RfsBorderRadiusDirectional` | `BorderRadiusDirectional` |
| `RfsOffset`                  | `Offset`                  |
| `RfsSize`                    | `Size`                    |
| `RfsBoxConstraints`          | `BoxConstraints`          |
| `RfsBoxShadow`               | `BoxShadow`               |

```dart
final padding = RfsEdgeInsets.symmetric(
  horizontal: const RfsValue(max: 48, min: 20),
  vertical: const RfsValue(max: 32, min: 16),
).resolve(width: 600);

final shadow = const RfsBoxShadow(
  offset: RfsOffset(
    dx: RfsValue(max: 16, min: 4),
    dy: RfsValue(max: 12, min: 3),
  ),
  blurRadius: RfsValue(max: 40, min: 12),
).resolve(width: 600);
```

Every type offers both `resolve(width: …)` and
`resolveForSize(size: …, dimension: …)`. Directional variants resolve
with the ambient `TextDirection`, so `start`/`end` and `topStart`-style
corners flip correctly in RTL locales.

A few conveniences worth knowing:

- `RfsEdgeInsets.all(value)` and `RfsEdgeInsets.symmetric(…)` mirror
  their `EdgeInsets` counterparts.
- `RfsRadius` takes an optional second endpoint for elliptical corners:
  `RfsRadius(RfsValue(max: 24), RfsValue(max: 12))`.
- `RfsBoxConstraints` normalizes on resolve: omitted bounds behave like
  `BoxConstraints` defaults, and minimums are clamped to their maximums.

## Widgets

### RfsText

A drop-in fluid `Text` that forwards every regular text option, with a
`.rich` constructor for spans:

```dart
const RfsText(
  'Fluid headline',
  maxFontSize: 64,
  minFontSize: 36,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)

RfsText.rich(
  const TextSpan(
    text: 'Fluid ',
    children: [
      TextSpan(text: 'rich', style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: ' text'),
    ],
  ),
  maxFontSize: 22,
  minFontSize: 16,
)
```

### RfsBox

A fluid `Container`. Use scalar shorthands when one value fits all edges,
or typed values for full per-edge/per-corner control — including
directional variants for RTL:

```dart
// Scalar shorthands: uniform fluid padding, margin, and radius.
RfsBox(
  maxPadding: 32,
  minPadding: 16,
  maxBorderRadius: 24,
  decoration: const BoxDecoration(color: Colors.white),
  child: content,
)

// Typed values: per-edge insets, directional corners, layered shadows.
RfsBox(
  directionalPadding: const RfsEdgeInsetsDirectional(
    start: RfsValue(max: 28, min: 18),
    end: RfsValue(max: 20, min: 12),
    top: RfsValue(max: 24, min: 16),
    bottom: RfsValue(max: 24, min: 16),
  ),
  directionalBorderRadius: const RfsBorderRadiusDirectional(
    topStart: RfsRadius(RfsValue(max: 28, min: 16)),
    bottomEnd: RfsRadius(RfsValue(max: 28, min: 16)),
  ),
  boxShadows: const [
    RfsBoxShadow(blurRadius: RfsValue(max: 28, min: 12)),
    RfsBoxShadow(
      color: Color(0x1400a6a6),
      blurRadius: RfsValue(max: 48, min: 20),
    ),
  ],
  decoration: const BoxDecoration(color: Colors.white),
  child: content,
)
```

`RfsBox` also supports fluid `width`, `height`, and `constraints`, plus
the usual `Container` extras: `alignment`, `clipBehavior`,
`foregroundDecoration`, `transform`, and `transformAlignment`. Scalar and
typed parameters for the same property are mutually exclusive and
validated at construction.

### RfsBuilder

The low-level escape hatch behind the other widgets. It measures the
local constraints (falling back to the window size on unbounded axes) and
hands you an `RfsMetrics` — the measured `width`, `height`, active
`extent`, and effective config — to resolve any number of values:

```dart
RfsBuilder(
  builder: (context, metrics) {
    final blur = metrics.resolve(max: 40, min: 12);
    final size = metrics.resolveSize(
      max: const Size(320, 200),
      min: const Size(200, 120),
    );
    return CustomPaint(size: size, painter: GlowPainter(blur));
  },
)
```

Because it uses local constraints, the same widget scales differently in
a sidebar than in the main content area — sizing follows the space the
widget actually gets.

## Typography

`RfsTypography` builds a complete Material `TextTheme` — all 15 styles —
with fluid font sizes, while preserving every other property (color,
weight, height, letter spacing) of the base theme:

```dart
MaterialApp(
  builder: (context, child) => Theme(
    data: Theme.of(context).copyWith(
      textTheme: RfsTypography.of(context),
    ),
    child: child!,
  ),
  ...
)
```

Customize endpoints per style with `RfsTypographyScale`:

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

## Accessibility

Fluid sizing and accessibility scaling are orthogonal, and `opa_rfs`
keeps them that way:

- Resolved values are **unscaled logical pixels**.
- The ambient `TextScaler` is **never multiplied, clamped, replaced, or
  disabled** — text still honors the user's system font-size settings,
  including nonlinear platform scaling.
- The two compose naturally: fluid sizing picks the base font size for
  the layout; the user's scaler is applied on top by Flutter, exactly as
  with fixed sizes.

## Example app

The bundled example has two pages:

- **Showcase** — a marketing landing page whose hero typography, spacing,
  cards, and shadows are all fluid. Resize the window to feel it.
- **Laboratory** — an interactive simulator with device presets, width /
  shortest-side modes, and live sliders for base value, breakpoint, and
  factor, showing the calculation next to a preview card rendered at true
  scale.

```bash
cd example
flutter run -d chrome
```

## FAQ

**Does this replace breakpoint-based layouts?**
No — it complements them. Structural changes (a row becoming a column, a
rail becoming a bottom bar) still belong to breakpoints. `opa_rfs`
removes the need for breakpoints on *continuous* values: sizes, spacing,
radii, and shadows.

**How is this different from multiplying by the screen width?**
Proportional scaling has no endpoints: text becomes unreadably small on
phones and comically large on desktops. Here every value is bounded by
`min` and `max`, small values are protected by the base-value cutoff, and
everything clamps at the breakpoint.

**How is this different from `FittedBox` or auto-sizing text?**
Those shrink content to fit its box, per widget, based on overflow. This
resolves *design tokens* from the layout size — consistently across the
whole UI, whether or not anything overflows.

**Does it work on web and desktop with live window resizing?**
Yes. Values resolve from `MediaQuery` or `LayoutBuilder` constraints, so
they re-resolve continuously while the window resizes.

**Can I use it for a single value without adopting it everywhere?**
Yes. `Rfs.value(64, width: …)` is a pure function — no scope, widget, or
setup required.

**Is there a runtime cost?**
Scalar resolution is a handful of arithmetic operations per value.
`RfsBuilder`-based widgets add a `LayoutBuilder` to the tree, and batch,
typed, and typography APIs allocate the collections or Flutter value
objects they return.

## Development

```bash
dart format --set-exit-if-changed lib test example/lib example/test
flutter analyze
flutter test
(cd example && flutter analyze && flutter test)
dart doc
dart pub publish --dry-run
```

Algorithm parity with the reference implementation is tracked in
[RFS_SCSS_DART_PARITY.md](RFS_SCSS_DART_PARITY.md) and
[RFS_JS_DART_PARITY.md](RFS_JS_DART_PARITY.md).

## License

[MIT](LICENSE)
