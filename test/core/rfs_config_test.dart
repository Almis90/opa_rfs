import 'package:flutter_test/flutter_test.dart';
import 'package:opa_rfs/opa_rfs.dart';

void main() {
  test('validates custom configurations', () {
    const config = RfsConfig(breakpoint: 800, factor: 4, baseValue: 12);
    expect(Rfs.value(32, width: 0, config: config), 17);
    expect(Rfs.value(20, width: 0, config: config), 14);
    expect(
      () => Rfs.value(32, width: 100, config: RfsConfig(factor: 1)),
      throwsAssertionError,
    );
    expect(
      () => Rfs.value(32, width: 100, config: RfsConfig(breakpoint: 0)),
      throwsAssertionError,
    );
  });
}
