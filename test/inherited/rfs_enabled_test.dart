import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_rfs/opa_rfs.dart';

void main() {
  testWidgets('RfsEnabled overrides only nested enable state', (tester) async {
    late double enabledValue;
    late double disabledValue;
    late double expectedValue;
    late RfsConfig inheritedConfig;
    await tester.pumpWidget(
      MaterialApp(
        home: RfsScope(
          config: const RfsConfig(baseValue: 10, factor: 5, breakpoint: 1000),
          dimension: RfsDimension.shortestSide,
          child: RfsEnabled(
            enabled: false,
            child: RfsEnabled(
              enabled: true,
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      final size = MediaQuery.sizeOf(context);
                      inheritedConfig = RfsScope.of(context).effectiveConfig;
                      enabledValue = Rfs.contextValue(context, 50);
                      expectedValue = Rfs.valueForSize(
                        50,
                        size: size,
                        config: const RfsConfig(
                          baseValue: 10,
                          factor: 5,
                          breakpoint: 1000,
                        ),
                        dimension: RfsDimension.shortestSide,
                      );
                      return const SizedBox();
                    },
                  ),
                  RfsEnabled(
                    enabled: false,
                    child: Builder(
                      builder: (context) {
                        disabledValue = Rfs.contextValue(context, 50);
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    expect(enabledValue, expectedValue);
    expect(disabledValue, 50);
    expect(inheritedConfig.baseValue, 10);
    expect(inheritedConfig.factor, 5);
    expect(inheritedConfig.breakpoint, 1000);
    expect(inheritedConfig.enabled, isTrue);
  });

  testWidgets('explicit widget configuration overrides RfsEnabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(
          width: 600,
          child: RfsEnabled(
            enabled: false,
            child: RfsText('Explicit', maxFontSize: 40, config: RfsConfig()),
          ),
        ),
      ),
    );
    final text = tester.widget<Text>(find.text('Explicit'));
    expect(text.style!.fontSize, isNot(40));
  });
}
