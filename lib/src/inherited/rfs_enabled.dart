import 'package:flutter/widgets.dart';

import '../core/rfs_config.dart';
import '../core/rfs_dimension.dart';
import 'rfs_scope.dart';

/// Toggles fluid scaling for a subtree without replacing the surrounding
/// configuration.
///
/// Base value, factor, breakpoint, and dimension continue to come from the
/// nearest [RfsScope]; only the enabled state changes. Nest freely to
/// re-enable scaling inside a disabled region:
///
/// ```dart
/// RfsEnabled(enabled: false, child: pixelPerfectSection)
/// ```
class RfsEnabled extends StatelessWidget {
  /// Creates a region where fluid scaling is forced on or off.
  const RfsEnabled({super.key, required this.enabled, required this.child});

  /// Whether values inside [child] scale fluidly.
  ///
  /// When `false`, values resolve to their maximum unchanged.
  final bool enabled;

  /// The subtree the override applies to.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final parent = RfsScope.maybeOf(context);
    final inheritedConfig = parent?.effectiveConfig ?? const RfsConfig();
    return RfsScope(
      config: inheritedConfig,
      enabled: enabled,
      dimension: parent?.dimension ?? RfsDimension.width,
      child: child,
    );
  }
}
