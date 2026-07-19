import 'package:flutter/widgets.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';

/// Provides fluid-sizing settings to a widget subtree.
///
/// Widgets such as `RfsText`, `RfsBox`, and `RfsBuilder`, as well as
/// `Rfs.contextValue`, read the nearest scope automatically. Explicit
/// arguments always take precedence over the scope.
///
/// ```dart
/// RfsScope(
///   config: const RfsConfig(baseValue: 16, breakpoint: 1000),
///   dimension: RfsDimension.shortestSide,
///   child: app,
/// )
/// ```
class RfsScope extends InheritedWidget {
  /// Creates a scope that supplies [config] and [dimension] to [child].
  const RfsScope({
    super.key,
    this.config = const RfsConfig(),
    this.enabled,
    this.dimension = RfsDimension.width,
    required super.child,
  });

  /// The configuration supplied to descendants.
  final RfsConfig config;

  /// Overrides [RfsConfig.enabled] without replacing the rest of [config].
  ///
  /// When null, the enabled state of [config] applies. `RfsEnabled` uses
  /// this to toggle scaling for a nested region.
  final bool? enabled;

  /// The extent descendants resolve against.
  final RfsDimension dimension;

  /// The configuration with the [enabled] override applied.
  RfsConfig get effectiveConfig =>
      config.copyWith(enabled: enabled ?? config.enabled);

  /// Returns the nearest scope or throws when none exists.
  static RfsScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RfsScope>()!;

  /// Returns the nearest scope, if present.
  static RfsScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RfsScope>();

  @override
  bool updateShouldNotify(RfsScope oldWidget) =>
      effectiveConfig != oldWidget.effectiveConfig ||
      dimension != oldWidget.dimension;
}
