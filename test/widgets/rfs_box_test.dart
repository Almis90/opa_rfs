import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_rfs/opa_rfs.dart';

void main() {
  testWidgets('RfsBox applies responsive padding and radius', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 600,
            child: RfsBox(
              maxPadding: 40,
              maxBorderRadius: 24,
              child: SizedBox(width: 10, height: 10),
            ),
          ),
        ),
      ),
    );
    final container = tester.widget<Container>(find.byType(Container).last);
    expect(container.padding, const EdgeInsets.all(31));
    expect(
      (container.decoration as BoxDecoration).borderRadius,
      BorderRadius.circular(22.2),
    );
  });

  testWidgets('RfsBox resolves responsive physical margins', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 600,
            child: RfsBox(
              maxMargin: 40,
              minMargin: 22,
              child: SizedBox(width: 10, height: 10),
            ),
          ),
        ),
      ),
    );
    final container = tester.widget<Container>(find.byType(Container).last);
    expect(container.margin, const EdgeInsets.all(31));
  });

  testWidgets('RfsBox resolves directional margins under RTL', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 600,
              child: RfsBox(
                directionalMargin: RfsEdgeInsetsDirectional(
                  start: RfsValue(max: 40, min: 22),
                  end: RfsValue(max: 60, min: 24),
                ),
                child: SizedBox(width: 10, height: 10),
              ),
            ),
          ),
        ),
      ),
    );
    final container = tester.widget<Container>(find.byType(Container).last);
    expect(container.margin, const EdgeInsets.fromLTRB(42, 0, 31, 0));
  });

  testWidgets('RfsBox resolves responsive shadows and preserves color', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 600,
            child: RfsBox(
              boxShadow: RfsBoxShadow(
                color: Colors.red,
                offset: RfsOffset(
                  dx: RfsValue(max: 40, min: 22),
                  dy: RfsValue(max: 30, min: 21),
                ),
                blurRadius: RfsValue(max: 50, min: 23),
                spreadRadius: RfsValue(max: 30, min: 21),
              ),
              child: SizedBox(width: 10, height: 10),
            ),
          ),
        ),
      ),
    );
    final container = tester.widget<Container>(find.byType(Container).last);
    final shadow = (container.decoration! as BoxDecoration).boxShadow!.single;
    expect(shadow.color, Colors.red);
    expect(shadow.offset, const Offset(31, 25.5));
    expect(shadow.blurRadius, 36.5);
    expect(shadow.spreadRadius, 25.5);
  });

  testWidgets('RfsBox resolves directional values and multiple shadows', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: 600,
            child: RfsBox(
              directionalPadding: RfsEdgeInsetsDirectional(
                start: RfsValue(max: 40),
                end: RfsValue(max: 20),
              ),
              directionalBorderRadius: RfsBorderRadiusDirectional(
                topStart: RfsRadius(RfsValue(max: 24)),
              ),
              boxShadows: [
                RfsBoxShadow(blurRadius: RfsValue(max: 20)),
                RfsBoxShadow(blurRadius: RfsValue(max: 10)),
              ],
            ),
          ),
        ),
      ),
    );
    final container = tester.widget<Container>(find.byType(Container).last);
    final padding = container.padding! as EdgeInsets;
    expect(padding.left, 20);
    expect(padding.right, greaterThan(20));
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.boxShadow, hasLength(2));
    expect(decoration.borderRadius, isNotNull);
  });

  testWidgets('RfsBox uses responsive width and height endpoints', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 600,
            child: RfsBox(
              maxWidth: 100,
              minWidth: 40,
              maxHeight: 80,
              minHeight: 30,
            ),
          ),
        ),
      ),
    );
    final container = tester.widget<Container>(find.byType(Container).last);
    expect(container.constraints!.maxWidth, 70);
    expect(container.constraints!.maxHeight, 55);
    expect(container.constraints!.minWidth, 0);
    expect(container.constraints!.minHeight, 0);
  });

  testWidgets('RfsBox falls back to app width for unbounded layout', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: UnconstrainedBox(child: RfsBox(maxWidth: 100, minWidth: 40)),
      ),
    );
    final container = tester.widget<Container>(find.byType(Container).last);
    expect(container.constraints!.maxWidth, 80);
  });

  testWidgets('RfsBox rejects invalid responsive endpoints', (tester) async {
    expect(() => RfsBox(maxWidth: 20, minWidth: 30), throwsAssertionError);
    expect(() => RfsBox(minWidth: 20), throwsAssertionError);
    expect(
      () => RfsBox(maxPadding: 20, padding: const RfsEdgeInsets()),
      throwsAssertionError,
    );
    expect(
      () => RfsBox(
        maxWidth: 100,
        constraints: const RfsBoxConstraints(maxWidth: RfsValue(max: 100)),
      ),
      throwsAssertionError,
    );
  });

  test('RfsBox rejects physical and directional conflicts', () {
    expect(
      () => RfsBox(
        padding: const RfsEdgeInsets(),
        directionalPadding: const RfsEdgeInsetsDirectional(),
      ),
      throwsAssertionError,
    );
    expect(
      () => RfsBox(
        borderRadius: const RfsBorderRadius(),
        directionalBorderRadius: const RfsBorderRadiusDirectional(),
      ),
      throwsAssertionError,
    );
  });
}
