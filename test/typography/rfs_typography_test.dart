import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_rfs/opa_rfs.dart';

void main() {
  testWidgets('RfsTypography creates styles from an empty base theme', (
    tester,
  ) async {
    final theme = const RfsTypography().textTheme(width: 1200);
    expect(theme.displayLarge, isNotNull);
    expect(theme.displayLarge!.fontSize, 57);
    expect(theme.titleLarge, isNotNull);
    expect(theme.titleLarge!.fontSize, 22);
  });

  testWidgets('RfsTypography preserves populated base styles', (tester) async {
    const base = TextTheme(
      displayLarge: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    );
    final theme = const RfsTypography().textTheme(width: 600, base: base);
    expect(theme.displayLarge!.fontSize, closeTo(40.35, 0.000001));
    expect(theme.displayLarge!.color, Colors.red);
    expect(theme.displayLarge!.fontWeight, FontWeight.bold);
    expect(theme.titleLarge, isNotNull);
  });

  test('RfsTypography uses shortest side for two-dimensional themes', () {
    final theme = const RfsTypography(
      dimension: RfsDimension.shortestSide,
    ).textTheme(width: 800, height: 400);
    expect(theme.displayLarge!.fontSize, closeTo(34.8, 0.000001));
  });

  test('RfsTypography populates all Material styles', () {
    final theme = const RfsTypography().textTheme(width: 1200);
    expect([
      theme.displayLarge,
      theme.displayMedium,
      theme.displaySmall,
      theme.headlineLarge,
      theme.headlineMedium,
      theme.headlineSmall,
      theme.titleLarge,
      theme.titleMedium,
      theme.titleSmall,
      theme.bodyLarge,
      theme.bodyMedium,
      theme.bodySmall,
      theme.labelLarge,
      theme.labelMedium,
      theme.labelSmall,
    ], everyElement(isNotNull));
  });
}
