import 'package:flutter/widgets.dart';
import 'package:opa_rfs/opa_rfs.dart';

/// Representative numeric cases cross-checked against the vendored RFS
/// formula in `vendor/rfs/lib/rfs.js` and `vendor/rfs/scss.scss`.
const rfsParityFixtures = <RfsParityFixture>[
  RfsParityFixture(max: 64, width: 0, expected: 24.4),
  RfsParityFixture(max: 64, width: 360, expected: 36.28),
  RfsParityFixture(max: 64, width: 600, expected: 44.2),
  RfsParityFixture(max: 64, width: 1199, expected: 63.967),
  RfsParityFixture(max: 64, width: 1200, expected: 64),
  RfsParityFixture(max: 64, width: 1600, expected: 64),
  RfsParityFixture(max: 18, width: 600, expected: 18),
  RfsParityFixture(max: 20, width: 0, expected: 20),
  RfsParityFixture(max: 20, width: 1200, expected: 20),
  RfsParityFixture(max: 32, width: 0, expected: 21.2),
  RfsParityFixture(max: 32, width: 600, expected: 26.6),
  RfsParityFixture(max: 100, width: 600, expected: 64),
  RfsParityFixture(max: -64, width: 0, expected: -24.4),
  RfsParityFixture(max: -64, width: 600, expected: -44.2),
  RfsParityFixture(max: -64, width: 1200, expected: -64),
  RfsParityFixture(max: 0, width: 600, expected: 0),
  RfsParityFixture(
    max: 50,
    width: 0,
    expected: 18,
    config: RfsConfig(baseValue: 10, factor: 5, breakpoint: 1000),
  ),
  RfsParityFixture(
    max: 50,
    width: 500,
    expected: 34,
    config: RfsConfig(baseValue: 10, factor: 5, breakpoint: 1000),
  ),
  RfsParityFixture(
    max: 64,
    width: 400,
    expected: 44.2,
    config: RfsConfig(breakpoint: 800),
  ),
  RfsParityFixture(
    max: 64,
    width: 400,
    expected: 64,
    config: RfsConfig(enabled: false),
  ),
];

const rfsTwoDimensionalFixtures = <RfsSizeParityFixture>[
  RfsSizeParityFixture(
    max: 64,
    size: Size(400, 800),
    dimension: RfsDimension.width,
    expected: 37.6,
  ),
  RfsSizeParityFixture(
    max: 64,
    size: Size(800, 400),
    dimension: RfsDimension.shortestSide,
    expected: 37.6,
  ),
  RfsSizeParityFixture(
    max: 64,
    size: Size(800, 800),
    dimension: RfsDimension.shortestSide,
    expected: 50.8,
  ),
  RfsSizeParityFixture(
    max: 64,
    size: Size(1200, 1200),
    dimension: RfsDimension.shortestSide,
    expected: 64,
  ),
  RfsSizeParityFixture(
    max: 64,
    size: Size(1600, 900),
    dimension: RfsDimension.shortestSide,
    expected: 54.1,
  ),
  RfsSizeParityFixture(
    max: -64,
    size: Size(400, 800),
    dimension: RfsDimension.shortestSide,
    expected: -37.6,
  ),
  RfsSizeParityFixture(
    max: -64,
    size: Size(400, 800),
    dimension: RfsDimension.shortestSide,
    expected: -64,
    config: RfsConfig(enabled: false),
  ),
  RfsSizeParityFixture(
    max: 72,
    size: Size(700, 500),
    dimension: RfsDimension.shortestSide,
    expected: 52,
    config: RfsConfig(baseValue: 12, factor: 4, breakpoint: 900),
  ),
  RfsSizeParityFixture(
    max: 72,
    size: Size(1000, 950),
    dimension: RfsDimension.shortestSide,
    expected: 72,
    config: RfsConfig(baseValue: 12, factor: 4, breakpoint: 900),
  ),
];

@immutable
class RfsParityFixture {
  const RfsParityFixture({
    required this.max,
    required this.width,
    required this.expected,
    this.config = const RfsConfig(),
  });

  final double max;
  final double width;
  final double expected;
  final RfsConfig config;
}

@immutable
class RfsSizeParityFixture {
  const RfsSizeParityFixture({
    required this.max,
    required this.size,
    required this.dimension,
    required this.expected,
    this.config = const RfsConfig(),
  });

  final double max;
  final Size size;
  final RfsDimension dimension;
  final double expected;
  final RfsConfig config;
}
