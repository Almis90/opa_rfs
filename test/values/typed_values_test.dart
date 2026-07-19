import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_rfs/opa_rfs.dart';

void main() {
  test('RfsEdgeInsets.symmetric resolves its axes', () {
    expect(
      RfsEdgeInsets.symmetric(
        horizontal: RfsValue(max: 48, min: 20),
        vertical: RfsValue(max: 32, min: 16),
      ).resolve(width: 600),
      const EdgeInsets.symmetric(horizontal: 34, vertical: 24),
    );
  });

  test(
    'typed helpers resolve two-dimensional sizes and validate constraints',
    () {
      const size = Size(800, 400);
      expect(
        const RfsValue(
          max: 64,
        ).resolveForSize(size: size, dimension: RfsDimension.shortestSide),
        closeTo(37.6, 0.000001),
      );
      expect(
        const RfsOffset(
          dx: RfsValue(max: 20),
          dy: RfsValue(max: 12),
        ).resolveForSize(size: size, dimension: RfsDimension.shortestSide),
        const Offset(20, 12),
      );
      expect(
        const RfsSize(
          width: RfsValue(max: 40),
          height: RfsValue(max: 20),
        ).resolveForSize(size: size, dimension: RfsDimension.shortestSide),
        const Size(28, 20),
      );
      expect(
        const RfsBoxConstraints(
          minWidth: RfsValue(max: 60),
          maxWidth: RfsValue(max: 100),
        ).resolveForSize(size: size, dimension: RfsDimension.shortestSide),
        const BoxConstraints(minWidth: 36, maxWidth: 52),
      );
      expect(
        () => const RfsEdgeInsets(left: RfsValue(max: -1)).resolve(width: 600),
        throwsArgumentError,
      );
      expect(
        () => const RfsBoxShadow(
          blurRadius: RfsValue(max: -1),
        ).resolve(width: 600),
        throwsArgumentError,
      );
      expect(
        () => const RfsEdgeInsets(
          left: RfsValue(max: 20),
        ).resolveForSize(size: Size(double.nan, 400)),
        throwsArgumentError,
      );
      expect(
        () => const RfsEdgeInsets(
          left: RfsValue(max: 20),
        ).resolveForSize(size: Size(400, -1)),
        throwsArgumentError,
      );
    },
  );
}
