/// Fluid responsive sizing for Flutter.
///
/// `opa_rfs` resolves numeric values at runtime so typography, spacing,
/// dimensions, radii, and shadows adapt continuously to the available
/// layout instead of jumping between breakpoints.
///
/// Every fluid value is described by a maximum and an optional minimum.
/// At or above the configured breakpoint the maximum applies unchanged;
/// below it the value shrinks smoothly toward the minimum as the layout
/// narrows. Values at or below [RfsConfig.baseValue] stay fixed, so body
/// text and fine detail keep their size while large elements scale.
///
/// ## Quick start
///
/// ```dart
/// import 'package:opa_rfs/opa_rfs.dart';
///
/// // Resolve a single value for a known width.
/// final headline = Rfs.value(64, width: 600, min: 36);
///
/// // Or let the BuildContext supply the app window size.
/// final padding = Rfs.contextValue(context, 48, min: 20);
/// ```
///
/// ## API overview
///
/// * **Core resolution** — [Rfs.value] for a known extent,
///   [Rfs.valueForSize] for a full `Size`, [Rfs.contextValue] for
///   app-window sizing, and the typography-named alias [Rfs.fontSize].
/// * **Declarative endpoints** — [RfsValue] stores a reusable `max`/`min`
///   pair that resolves on demand.
/// * **Configuration** — [RfsConfig] sets the base value, breakpoint,
///   factor, and enabled state; [RfsDimension] chooses between width and
///   shortest-side sizing.
/// * **Inherited setup** — [RfsScope] provides configuration to a
///   subtree; [RfsEnabled] toggles scaling for a nested region without
///   replacing the surrounding configuration.
/// * **Typed values** — [RfsEdgeInsets], [RfsEdgeInsetsDirectional],
///   [RfsBorderRadius], [RfsBorderRadiusDirectional], [RfsRadius],
///   [RfsOffset], [RfsSize], [RfsBoxConstraints], and [RfsBoxShadow]
///   resolve into their Flutter counterparts, including RTL-aware
///   directional variants.
/// * **Widgets** — [RfsText] for fluid plain and rich text, [RfsBox] for
///   fluid containers, and [RfsBuilder] as a low-level escape hatch that
///   exposes [RfsMetrics] for custom layouts.
/// * **Typography** — [RfsTypography] and [RfsTypographyScale] build a
///   complete fluid Material `TextTheme`.
///
/// All resolved values are unscaled logical pixels. The package never
/// multiplies, clamps, or replaces Flutter's ambient `TextScaler`, so
/// accessibility text scaling remains fully controlled by the platform.
library;

export 'src/core/rfs.dart';
export 'src/core/rfs_config.dart';
export 'src/core/rfs_dimension.dart';
export 'src/core/rfs_value.dart';
export 'src/inherited/rfs_enabled.dart';
export 'src/inherited/rfs_scope.dart';
export 'src/typography/rfs_typography.dart';
export 'src/typography/rfs_typography_scale.dart';
export 'src/values/rfs_border_radius.dart';
export 'src/values/rfs_border_radius_directional.dart';
export 'src/values/rfs_box_constraints.dart';
export 'src/values/rfs_box_shadow.dart';
export 'src/values/rfs_edge_insets.dart';
export 'src/values/rfs_edge_insets_directional.dart';
export 'src/values/rfs_offset.dart';
export 'src/values/rfs_radius.dart';
export 'src/values/rfs_size.dart';
export 'src/widgets/rfs_box.dart';
export 'src/widgets/rfs_builder.dart';
export 'src/widgets/rfs_text.dart';
