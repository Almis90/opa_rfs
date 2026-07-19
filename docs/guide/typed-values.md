# Typed values

Typed values combine several `RfsValue` endpoints and resolve into familiar
Flutter objects.

| Fluid type | Flutter result |
| --- | --- |
| `RfsEdgeInsets` | `EdgeInsets` |
| `RfsEdgeInsetsDirectional` | `EdgeInsetsDirectional` |
| `RfsRadius` | `Radius` |
| `RfsBorderRadius` | `BorderRadius` |
| `RfsBorderRadiusDirectional` | `BorderRadiusDirectional` |
| `RfsOffset` | `Offset` |
| `RfsSize` | `Size` |
| `RfsBoxConstraints` | `BoxConstraints` |
| `RfsBoxShadow` | `BoxShadow` |

## Insets

```dart
final padding = RfsEdgeInsets.symmetric(
  horizontal: const RfsValue(max: 48, min: 20),
  vertical: const RfsValue(max: 32, min: 16),
).resolve(width: width);
```

## Shadows

```dart
final shadow = const RfsBoxShadow(
  offset: RfsOffset(
    dx: RfsValue(max: 16, min: 4),
    dy: RfsValue(max: 12, min: 3),
  ),
  blurRadius: RfsValue(max: 40, min: 12),
).resolve(width: width);
```

## Directional layouts

Directional insets and radii resolve into Flutter's directional geometry, so
`start`, `end`, and directional corners follow the active text direction when
used by the layout.

Each typed value provides `resolve(width: ...)` and
`resolveForSize(size: ..., dimension: ...)`.
