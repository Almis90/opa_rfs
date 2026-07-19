---
layout: home

hero:
  name: opa_rfs
  text: Fluid responsive sizing for Flutter
  tagline: Scale typography, spacing, radii, shadows, and complete text themes smoothly between intentional endpoints.
  image:
    src: /logo.svg
    alt: opa_rfs
  actions:
    - theme: brand
      text: Get started
      link: /guide/getting-started
    - theme: alt
      text: Open playground
      link: /playground
    - theme: alt
      text: View on GitHub
      link: https://github.com/Almis90/opa_rfs

features:
  - title: Smooth, bounded scaling
    details: Values interpolate continuously between a deliberate minimum and maximum instead of jumping at visual breakpoints.
  - title: One system for the whole UI
    details: Use the same curve for text, spacing, dimensions, radii, offsets, constraints, and shadows.
  - title: Flutter-native
    details: Runtime logical-pixel calculations, local layout constraints, inherited configuration, and no code generation.
  - title: Accessibility preserved
    details: opa_rfs chooses the responsive base font size while Flutter's ambient TextScaler remains in control.
---

## A responsive value in one line

```dart
Text(
  'Fluid headline',
  style: TextStyle(
    fontSize: Rfs.contextValue(context, 64, min: 36),
  ),
)
```

At wide layouts the headline reaches `64`. As space narrows, it eases toward
`36` and never overshoots either endpoint.

Use the [getting-started guide](/guide/getting-started) for installation, visit
the [interactive playground](/playground) to see the curve change live, or jump
straight to the generated [API reference](/api/).
