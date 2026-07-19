# Getting started

`opa_rfs` is a runtime fluid-sizing engine for Flutter. It requires Dart 3.12
or newer and Flutter 3.44 or newer.

## Install

Add the package to your application:

```yaml
dependencies:
  opa_rfs: ^1.0.0
```

Then import its public library:

```dart
import 'package:opa_rfs/opa_rfs.dart';
```

No build step or configuration file is required.

## Resolve your first value

When the available width is already known, pass it directly:

```dart
final headlineSize = Rfs.value(
  64,
  width: constraints.maxWidth,
  min: 36,
);
```

When you have a `BuildContext`, `contextValue` reads the application window and
the nearest `RfsScope`:

```dart
final pagePadding = Rfs.contextValue(context, 48, min: 20);
```

For a reusable endpoint pair, declare an `RfsValue`:

```dart
abstract final class AppSizes {
  static const heroTitle = RfsValue(max: 64, min: 36);
  static const cardPadding = RfsValue(max: 32, min: 16);
}

final title = AppSizes.heroTitle.resolve(width: width);
```

## Use local constraints

Responsive components usually look best when they follow the space they are
actually given rather than the entire screen. `RfsBuilder`, `RfsText`, and
`RfsBox` use local layout constraints automatically:

```dart
RfsBuilder(
  builder: (context, metrics) {
    final gap = metrics.resolve(max: 48, min: 20);
    return Padding(
      padding: EdgeInsets.all(gap),
      child: content,
    );
  },
)
```

## Where to go next

- Learn the [scaling curve](/guide/how-it-works).
- Pick the [right API for each call site](/guide/choosing-an-api).
- Share settings with [application-wide configuration](/guide/configuration).
- Explore the result in the [interactive playground](/playground).
