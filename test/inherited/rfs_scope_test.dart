import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_rfs/opa_rfs.dart';

void main() {
  testWidgets('RfsScope supplies configuration and dimension', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RfsScope(
          config: RfsConfig(baseValue: 10, breakpoint: 1000),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 600,
              child: RfsText('Scoped', maxFontSize: 40),
            ),
          ),
        ),
      ),
    );
    final text = tester.widget<Text>(find.text('Scoped'));
    expect(text.style!.fontSize, closeTo(29.2, 0.000001));
  });

  testWidgets('contextValue uses MediaQuery and scope precedence', (
    tester,
  ) async {
    late double scoped;
    late double explicitConfig;
    late double explicitDimension;
    late double disabled;
    late double fontSize;
    late double expectedScoped;
    late double expectedExplicitConfig;
    late double expectedExplicitDimension;
    const scopeConfig = RfsConfig(baseValue: 10, factor: 5, breakpoint: 1000);
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(800, 400);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MaterialApp(
        home: RfsScope(
          config: scopeConfig,
          dimension: RfsDimension.shortestSide,
          child: Builder(
            builder: (context) {
              final mediaSize = MediaQuery.sizeOf(context);
              scoped = Rfs.contextValue(context, 50);
              explicitConfig = Rfs.contextValue(
                context,
                50,
                config: const RfsConfig(),
              );
              explicitDimension = Rfs.contextValue(
                context,
                50,
                dimension: RfsDimension.width,
              );
              disabled = Rfs.contextValue(
                context,
                -50,
                config: const RfsConfig(enabled: false),
              );
              fontSize = Rfs.fontSize(context, 50);
              expectedScoped = Rfs.valueForSize(
                50,
                size: mediaSize,
                config: scopeConfig,
                dimension: RfsDimension.shortestSide,
              );
              expectedExplicitConfig = Rfs.valueForSize(
                50,
                size: mediaSize,
                dimension: RfsDimension.shortestSide,
              );
              expectedExplicitDimension = Rfs.valueForSize(
                50,
                size: mediaSize,
                config: scopeConfig,
                dimension: RfsDimension.width,
              );
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(find.byType(SizedBox), findsOneWidget);
    expect(scoped, expectedScoped);
    expect(explicitConfig, expectedExplicitConfig);
    expect(explicitDimension, expectedExplicitDimension);
    expect(disabled, -50);
    expect(fontSize, scoped);
  });
}
