import 'package:flutter/material.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import '../core/rfs.dart';
import '../core/rfs_value.dart';
import '../values/rfs_border_radius.dart';
import '../values/rfs_border_radius_directional.dart';
import '../values/rfs_box_constraints.dart';
import '../values/rfs_box_shadow.dart';
import '../values/rfs_edge_insets.dart';
import '../values/rfs_edge_insets_directional.dart';
import 'rfs_builder.dart';

/// A [Container] whose padding, margin, radius, shadows, and dimensions
/// scale fluidly with the available layout.
///
/// Sizing comes in two flavors that cannot be mixed per property:
///
/// * **Scalar pairs** — `maxPadding`/`minPadding`,
///   `maxMargin`/`minMargin`, `maxBorderRadius`/`minBorderRadius`, and
///   `maxWidth`/`minWidth`/`maxHeight`/`minHeight` apply one fluid value
///   uniformly.
/// * **Typed values** — [RfsEdgeInsets], [RfsBorderRadius],
///   [RfsBoxShadow], [RfsBoxConstraints], and their directional variants
///   give each edge or corner its own endpoints. Directional values
///   resolve with the surrounding [TextDirection], so the same widget
///   works in LTR and RTL layouts.
///
/// ```dart
/// RfsBox(
///   maxPadding: 32,
///   maxBorderRadius: 24,
///   boxShadow: const RfsBoxShadow(blurRadius: RfsValue(max: 40, min: 12)),
///   decoration: const BoxDecoration(color: Colors.white),
///   child: content,
/// )
/// ```
///
/// Configuration and dimension come from the nearest `RfsScope` unless
/// overridden with [config] and [dimension].
class RfsBox extends StatelessWidget {
  /// Creates a fluid container.
  ///
  /// Scalar and typed parameters for the same property are mutually
  /// exclusive, physical and directional variants are mutually exclusive,
  /// and [constraints] cannot be combined with the scalar dimension
  /// parameters.
  const RfsBox({
    super.key,
    this.child,
    this.maxPadding,
    this.minPadding,
    this.maxMargin,
    this.minMargin,
    this.maxBorderRadius,
    this.minBorderRadius,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.minHeight,
    this.padding,
    this.directionalPadding,
    this.margin,
    this.directionalMargin,
    this.borderRadius,
    this.directionalBorderRadius,
    this.boxShadow,
    this.boxShadows,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.textDirection,
    this.clipBehavior = Clip.none,
    this.foregroundDecoration,
    this.transform,
    this.transformAlignment,
    this.decoration,
    this.config,
    this.dimension,
  }) : assert(padding == null || directionalPadding == null),
       assert(margin == null || directionalMargin == null),
       assert(borderRadius == null || directionalBorderRadius == null),
       assert(
         maxPadding == null || (padding == null && directionalPadding == null),
       ),
       assert(
         maxMargin == null || (margin == null && directionalMargin == null),
       ),
       assert(
         maxBorderRadius == null ||
             (borderRadius == null && directionalBorderRadius == null),
       ),
       assert(
         constraints == null ||
             (maxWidth == null &&
                 minWidth == null &&
                 maxHeight == null &&
                 minHeight == null),
       ),
       assert(maxWidth == null || minWidth == null || minWidth <= maxWidth),
       assert(maxHeight == null || minHeight == null || minHeight <= maxHeight),
       assert(minWidth == null || maxWidth != null),
       assert(minHeight == null || maxHeight != null);

  /// The widget below this container in the tree.
  final Widget? child;

  /// Fluid uniform padding maximum, applied to all four edges.
  final double? maxPadding;

  /// Explicit minimum for [maxPadding]; derived when omitted.
  final double? minPadding;

  /// Fluid uniform margin maximum, applied to all four edges.
  final double? maxMargin;

  /// Explicit minimum for [maxMargin]; derived when omitted.
  final double? minMargin;

  /// Fluid circular border radius maximum, applied to all four corners.
  final double? maxBorderRadius;

  /// Explicit minimum for [maxBorderRadius]; derived when omitted.
  final double? minBorderRadius;

  /// Fluid maximum width constraint.
  final double? maxWidth;

  /// Fluid maximum height constraint.
  final double? maxHeight;

  /// Explicit minimum for [maxWidth]; derived when omitted.
  final double? minWidth;

  /// Explicit minimum for [maxHeight]; derived when omitted.
  final double? minHeight;

  /// Typed per-edge padding; mutually exclusive with [maxPadding] and
  /// [directionalPadding].
  final RfsEdgeInsets? padding;

  /// Typed start/end padding that follows the text direction.
  final RfsEdgeInsetsDirectional? directionalPadding;

  /// Typed per-edge margin; mutually exclusive with [maxMargin] and
  /// [directionalMargin].
  final RfsEdgeInsets? margin;

  /// Typed start/end margin that follows the text direction.
  final RfsEdgeInsetsDirectional? directionalMargin;

  /// Typed per-corner border radius; mutually exclusive with
  /// [maxBorderRadius] and [directionalBorderRadius].
  final RfsBorderRadius? borderRadius;

  /// Typed start/end border radius that follows the text direction.
  final RfsBorderRadiusDirectional? directionalBorderRadius;

  /// A single fluid shadow; combined with [boxShadows] when both are set.
  final RfsBoxShadow? boxShadow;

  /// Multiple fluid shadows, painted in list order.
  final List<RfsBoxShadow>? boxShadows;

  /// Fluid explicit width of the container.
  final RfsValue? width;

  /// Fluid explicit height of the container.
  final RfsValue? height;

  /// Typed fluid constraints; mutually exclusive with the scalar
  /// dimension parameters.
  final RfsBoxConstraints? constraints;

  /// Corresponds to [Container.alignment].
  final Alignment? alignment;

  /// Overrides the ambient [Directionality] for directional values.
  final TextDirection? textDirection;

  /// Corresponds to [Container.clipBehavior].
  final Clip clipBehavior;

  /// Corresponds to [Container.foregroundDecoration].
  final Decoration? foregroundDecoration;

  /// Corresponds to [Container.transform].
  final Matrix4? transform;

  /// Corresponds to [Container.transformAlignment].
  final AlignmentGeometry? transformAlignment;

  /// The base decoration; resolved radius and shadows are applied on top.
  final BoxDecoration? decoration;

  /// Overrides the configuration from the nearest `RfsScope`.
  final RfsConfig? config;

  /// Overrides the dimension from the nearest `RfsScope`.
  final RfsDimension? dimension;

  @override
  Widget build(BuildContext context) => RfsBuilder(
    config: config,
    dimension: dimension,
    builder: (context, metrics) {
      final effectiveConfig = metrics.config;
      _validateRfsBox(
        maxWidth: maxWidth,
        minWidth: minWidth,
        maxHeight: maxHeight,
        minHeight: minHeight,
        maxPadding: maxPadding,
        minPadding: minPadding,
        maxMargin: maxMargin,
        minMargin: minMargin,
        maxBorderRadius: maxBorderRadius,
        minBorderRadius: minBorderRadius,
        padding: padding,
        directionalPadding: directionalPadding,
        margin: margin,
        directionalMargin: directionalMargin,
        borderRadius: borderRadius,
        directionalBorderRadius: directionalBorderRadius,
        constraints: constraints,
      );
      final direction =
          textDirection != null ||
              directionalPadding != null ||
              directionalMargin != null ||
              directionalBorderRadius != null
          ? _effectiveTextDirection(context, textDirection)
          : TextDirection.ltr;
      final resolvedPadding = _resolveInsets(
        physical: padding,
        directional: directionalPadding,
        scalarMax: maxPadding,
        scalarMin: minPadding,
        width: metrics.extent,
        config: effectiveConfig,
        direction: direction,
      );
      final resolvedMargin = _resolveInsets(
        physical: margin,
        directional: directionalMargin,
        scalarMax: maxMargin,
        scalarMin: minMargin,
        width: metrics.extent,
        config: effectiveConfig,
        direction: direction,
      );
      final radius = _resolveRadius(
        physical: borderRadius,
        directional: directionalBorderRadius,
        scalarMax: maxBorderRadius,
        scalarMin: minBorderRadius,
        width: metrics.extent,
        config: effectiveConfig,
        direction: direction,
      );
      final resolvedConstraints = _resolveConstraints(
        constraints: constraints,
        maxWidth: maxWidth,
        minWidth: minWidth,
        maxHeight: maxHeight,
        minHeight: minHeight,
        width: metrics.extent,
        config: effectiveConfig,
      );
      final effectiveDecoration = _resolveDecoration(
        decoration: decoration,
        radius: radius,
        boxShadow: boxShadow,
        boxShadows: boxShadows,
        width: metrics.extent,
        config: effectiveConfig,
      );
      return Container(
        alignment: alignment,
        clipBehavior: clipBehavior,
        padding: resolvedPadding,
        margin: resolvedMargin,
        constraints: resolvedConstraints,
        width: width?.resolve(width: metrics.extent, config: effectiveConfig),
        height: height?.resolve(width: metrics.extent, config: effectiveConfig),
        decoration: effectiveDecoration,
        foregroundDecoration: foregroundDecoration,
        transform: transform,
        transformAlignment: transformAlignment,
        child: child,
      );
    },
  );

  static void _validateDimension(double? value, String name) {
    if (value != null && (!value.isFinite || value < 0)) {
      throw ArgumentError.value(value, name, 'must be finite and nonnegative');
    }
  }

  static void _validatePair(double? min, double? max, String name) {
    if (min != null && max == null) {
      throw ArgumentError('$name minimum requires a maximum endpoint');
    }
    if (min != null && max != null && min > max) {
      throw ArgumentError('$name minimum must not exceed its maximum endpoint');
    }
  }

  static void _validateScalarPair(double? max, double? min, String name) {
    _validateDimension(max, 'max$name');
    _validateDimension(min, 'min$name');
    _validatePair(min, max, name);
  }
}

TextDirection _effectiveTextDirection(
  BuildContext context,
  TextDirection? override,
) => override ?? Directionality.maybeOf(context) ?? TextDirection.ltr;

EdgeInsetsGeometry? _resolveInsets({
  required RfsEdgeInsets? physical,
  required RfsEdgeInsetsDirectional? directional,
  required double? scalarMax,
  required double? scalarMin,
  required double width,
  required RfsConfig config,
  required TextDirection direction,
}) {
  if (physical != null) return physical.resolve(width: width, config: config);
  if (directional != null) {
    return directional.resolve(width: width, config: config).resolve(direction);
  }
  if (scalarMax != null) {
    return EdgeInsets.all(
      Rfs.value(scalarMax, width: width, min: scalarMin, config: config),
    );
  }
  return null;
}

BorderRadiusGeometry? _resolveRadius({
  required RfsBorderRadius? physical,
  required RfsBorderRadiusDirectional? directional,
  required double? scalarMax,
  required double? scalarMin,
  required double width,
  required RfsConfig config,
  required TextDirection direction,
}) {
  if (physical != null) return physical.resolve(width: width, config: config);
  if (directional != null) {
    return directional.resolve(width: width, config: config).resolve(direction);
  }
  if (scalarMax != null) {
    return BorderRadius.circular(
      Rfs.value(scalarMax, width: width, min: scalarMin, config: config),
    );
  }
  return null;
}

BoxConstraints _resolveConstraints({
  required RfsBoxConstraints? constraints,
  required double? maxWidth,
  required double? minWidth,
  required double? maxHeight,
  required double? minHeight,
  required double width,
  required RfsConfig config,
}) =>
    (constraints ??
            RfsBoxConstraints(
              maxWidth: maxWidth == null
                  ? null
                  : RfsValue(max: maxWidth, min: minWidth),
              maxHeight: maxHeight == null
                  ? null
                  : RfsValue(max: maxHeight, min: minHeight),
            ))
        .resolve(width: width, config: config);

Decoration? _resolveDecoration({
  required BoxDecoration? decoration,
  required BorderRadiusGeometry? radius,
  required RfsBoxShadow? boxShadow,
  required List<RfsBoxShadow>? boxShadows,
  required double width,
  required RfsConfig config,
}) {
  final hasShadows = boxShadow != null || (boxShadows?.isNotEmpty ?? false);
  if (decoration == null && radius == null && !hasShadows) return null;
  return (decoration ?? const BoxDecoration()).copyWith(
    borderRadius: radius,
    boxShadow: hasShadows
        ? [
            if (boxShadow != null)
              boxShadow.resolve(width: width, config: config),
            ...?boxShadows?.map(
              (shadow) => shadow.resolve(width: width, config: config),
            ),
          ]
        : null,
  );
}

void _validateRfsBox({
  required double? maxWidth,
  required double? minWidth,
  required double? maxHeight,
  required double? minHeight,
  required double? maxPadding,
  required double? minPadding,
  required double? maxMargin,
  required double? minMargin,
  required double? maxBorderRadius,
  required double? minBorderRadius,
  required RfsEdgeInsets? padding,
  required RfsEdgeInsetsDirectional? directionalPadding,
  required RfsEdgeInsets? margin,
  required RfsEdgeInsetsDirectional? directionalMargin,
  required RfsBorderRadius? borderRadius,
  required RfsBorderRadiusDirectional? directionalBorderRadius,
  required RfsBoxConstraints? constraints,
}) {
  RfsBox._validateDimension(maxWidth, 'maxWidth');
  RfsBox._validateDimension(minWidth, 'minWidth');
  RfsBox._validateDimension(maxHeight, 'maxHeight');
  RfsBox._validateDimension(minHeight, 'minHeight');
  RfsBox._validatePair(minWidth, maxWidth, 'width');
  RfsBox._validatePair(minHeight, maxHeight, 'height');
  RfsBox._validateScalarPair(maxPadding, minPadding, 'padding');
  RfsBox._validateScalarPair(maxMargin, minMargin, 'margin');
  RfsBox._validateScalarPair(maxBorderRadius, minBorderRadius, 'borderRadius');
  if (padding != null && directionalPadding != null) {
    throw ArgumentError(
      'padding and directionalPadding are mutually exclusive',
    );
  }
  if (margin != null && directionalMargin != null) {
    throw ArgumentError('margin and directionalMargin are mutually exclusive');
  }
  if (borderRadius != null && directionalBorderRadius != null) {
    throw ArgumentError(
      'borderRadius and directionalBorderRadius are mutually exclusive',
    );
  }
  if (maxPadding != null && (padding != null || directionalPadding != null)) {
    throw ArgumentError('maxPadding cannot be combined with typed padding');
  }
  if (maxMargin != null && (margin != null || directionalMargin != null)) {
    throw ArgumentError('maxMargin cannot be combined with typed margin');
  }
  if (maxBorderRadius != null &&
      (borderRadius != null || directionalBorderRadius != null)) {
    throw ArgumentError('maxBorderRadius cannot be combined with typed radius');
  }
  if (constraints != null &&
      (maxWidth != null ||
          minWidth != null ||
          maxHeight != null ||
          minHeight != null)) {
    throw ArgumentError(
      'constraints cannot be combined with legacy dimensions',
    );
  }
}
