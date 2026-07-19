import '../core/rfs_value.dart';
import 'rfs_radius.dart';

Iterable<RfsValue> cornerValues(Iterable<RfsRadius> corners) sync* {
  for (final corner in corners) {
    yield corner.x;
    if (corner.y != null) yield corner.y!;
  }
}
