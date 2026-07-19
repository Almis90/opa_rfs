import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_rfs/opa_rfs.dart';

import '../fixtures/rfs_parity.dart';

void main() {
  test('matches vendored RFS parity fixtures', () {
    for (final fixture in rfsParityFixtures) {
      expect(
        Rfs.value(fixture.max, width: fixture.width, config: fixture.config),
        closeTo(fixture.expected, 0.000001),
      );
    }
  });

  test('matches two-dimensional parity fixtures', () {
    for (final fixture in rfsTwoDimensionalFixtures) {
      expect(
        Rfs.valueForSize(
          fixture.max,
          size: fixture.size,
          dimension: fixture.dimension,
          config: fixture.config,
        ),
        closeTo(fixture.expected, 0.000001),
      );
    }
  });

  test('interpolates and clamps at the breakpoint', () {
    expect(Rfs.value(64, width: 0), 24.4);
    expect(Rfs.value(64, width: 600), 44.2);
    expect(Rfs.value(64, width: 1200), 64);
    expect(Rfs.value(64, width: 1600), 64);
  });

  test('supports explicit minimums and custom configuration', () {
    const config = RfsConfig(breakpoint: 1000, factor: 5, baseValue: 10);
    expect(Rfs.value(50, width: 0, config: config), 18);
    expect(Rfs.value(50, width: 500, min: 20, config: config), 35);
  });

  test('handles fixed, zero, and negative values', () {
    expect(Rfs.value(20, width: 0), 20);
    expect(Rfs.value(20, width: 0, min: 1), 20);
    expect(Rfs.value(19, width: 600, min: 1), 19);
    expect(Rfs.value(0, width: 500), 0);
    expect(Rfs.value(-64, width: 0), -24.4);
    expect(Rfs.value(-64, width: 600), -44.2);
    expect(Rfs.value(-64, width: 1200), -64);
    expect(Rfs.value(-8, width: 0), -8);
    expect(Rfs.values([0, 48], width: 600), [0, 35.4]);
  });

  test('supports explicit minimums for negative values', () {
    expect(Rfs.value(-64, width: 0, min: -32), -32);
    expect(Rfs.value(-64, width: 600, min: -32), -48);
  });

  test('rejects non-finite values', () {
    expect(() => Rfs.value(double.infinity, width: 100), throwsArgumentError);
    expect(() => Rfs.value(10, width: double.nan), throwsArgumentError);
  });

  test('supports disabled, two-dimensional, batch, and reusable values', () {
    const config = RfsConfig(enabled: false);
    expect(Rfs.value(64, width: 0, config: config), 64);
    expect(
      Rfs.valueForSize(
        64,
        size: const Size(800, 400),
        dimension: RfsDimension.shortestSide,
      ),
      closeTo(37.6, 0.000001),
    );
    expect(Rfs.values([64, 32], width: 600), [44.2, 26.6]);
    expect(const RfsValue(max: 64, min: 32).resolve(width: 600), 48);
    expect(
      () => Rfs.valueForSize(
        64,
        size: const Size(double.nan, 400),
        dimension: RfsDimension.shortestSide,
      ),
      throwsArgumentError,
    );
    expect(
      () => Rfs.valueForSize(64, size: const Size(400, double.infinity)),
      throwsArgumentError,
    );
  });
}
