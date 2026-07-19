import 'package:example/example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_rfs/opa_rfs.dart';

void main() {
  testWidgets('showcase renders representative RFS values', (tester) async {
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const MaterialApp(home: RfsExampleShowcase()));
    final titleFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          widget.data == 'Build calmer, clearer workflows for your team.',
    );
    final narrowTitle = tester.widget<Text>(titleFinder);
    expect(narrowTitle.style!.fontSize, closeTo(48, 0.000001));

    tester.view.physicalSize = const Size(1200, 800);
    await tester.pumpAndSettle();
    final wideTitle = tester.widget<Text>(titleFinder);
    expect(wideTitle.style!.fontSize, closeTo(68, 0.000001));
    expect(
      wideTitle.style!.fontSize,
      greaterThan(narrowTitle.style!.fontSize!),
    );
  });

  testWidgets('home navigates between showcase and laboratory', (tester) async {
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const MaterialApp(home: RfsExampleHome()));

    expect(find.byType(RfsExampleShowcase), findsOneWidget);
    expect(find.byKey(const ValueKey('lab-width-slider')), findsNothing);

    final nav = find.byKey(const ValueKey('example-nav'));
    await tester.tap(
      find.descendant(of: nav, matching: find.byIcon(Icons.science_outlined)),
    );
    await tester.pumpAndSettle();
    expect(find.byType(RfsLaboratoryPage), findsOneWidget);
    expect(find.byKey(const ValueKey('lab-width-slider')), findsOneWidget);

    await tester.tap(
      find.descendant(of: nav, matching: find.byIcon(Icons.waves_rounded)),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('open-lab-button')),
      500,
      maxScrolls: 20,
    );
    tester
        .widget<FilledButton>(find.byKey(const ValueKey('open-lab-button')))
        .onPressed!();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('lab-width-slider')), findsOneWidget);
  });

  testWidgets('app destinations have named routes with browser history', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const RfsExampleApp());

    expect(
      ModalRoute.settingsOf(
        tester.element(find.byType(RfsExampleShowcase)),
      )?.name,
      RfsExampleApp.demoRoute,
    );

    final nav = find.byKey(const ValueKey('example-nav'));
    await tester.tap(
      find.descendant(of: nav, matching: find.byIcon(Icons.science_outlined)),
    );
    await tester.pumpAndSettle();

    expect(
      ModalRoute.settingsOf(
        tester.element(find.byType(RfsLaboratoryPage)),
      )?.name,
      RfsExampleApp.laboratoryRoute,
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(RfsExampleShowcase), findsOneWidget);
  });

  testWidgets('laboratory keeps its result beside desktop controls', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const MaterialApp(home: RfsLaboratoryPage()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('lab-details')), findsOneWidget);
    expect(find.byKey(const ValueKey('lab-preview')), findsOneWidget);
    expect(find.byKey(const ValueKey('lab-width-slider')), findsOneWidget);
    expect(_resolvedValue(tester), isNotEmpty);
    expect(
      tester.getBottomRight(find.byKey(const ValueKey('lab-details'))).dy,
      lessThanOrEqualTo(1000),
    );
  });

  testWidgets('viewport presets apply a simulated size', (tester) async {
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const MaterialApp(home: RfsLaboratoryPage()));
    await tester.pumpAndSettle();

    final initial = _resolvedValue(tester);
    tester
        .widget<ChoiceChip>(find.byKey(const ValueKey('lab-preset-laptop')))
        .onSelected!(true);
    await tester.pump();

    expect(
      tester.widget<Text>(find.byKey(const ValueKey('lab-preview-size'))).data,
      '1366 × 768',
    );
    expect(_resolvedValue(tester), isNot(initial));
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const ValueKey('lab-preset-laptop')))
          .selected,
      isTrue,
    );
  });

  testWidgets('laboratory controls update the calculation and preview', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const MaterialApp(home: RfsLaboratoryPage()));
    await tester.pumpAndSettle();

    final initial = _resolvedValue(tester);
    final initialFontSize = tester
        .widget<Text>(find.byKey(const ValueKey('lab-preview-text')))
        .style!
        .fontSize!;
    final initialPadding =
        tester
                .widget<Container>(find.byKey(const ValueKey('lab-preview')))
                .padding
            as EdgeInsets;
    final initialThumbnailSize = tester.getSize(
      find.byKey(const ValueKey('lab-viewport-thumbnail')),
    );

    await _changeSlider(tester, 'lab-width-slider', 900);
    expect(_resolvedValue(tester), isNot(initial));
    expect(
      tester
          .getSize(find.byKey(const ValueKey('lab-viewport-thumbnail')))
          .width,
      isNot(initialThumbnailSize.width),
    );

    final widthModeResult = _resolvedValue(tester);
    await _changeSlider(tester, 'lab-height-slider', 360);
    expect(_resolvedValue(tester), widthModeResult);
    expect(
      tester
          .getSize(find.byKey(const ValueKey('lab-viewport-thumbnail')))
          .height,
      isNot(initialThumbnailSize.height),
    );

    final widthChanged = _resolvedValue(tester);
    final selector = tester.widget<SegmentedButton<RfsDimension>>(
      find.byKey(const ValueKey('lab-dimension-selector')),
    );
    selector.onSelectionChanged!({RfsDimension.shortestSide});
    await tester.pump();
    final shortestBeforeHeight = _resolvedValue(tester);
    final extentBeforeHeight = tester
        .widget<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('lab-stat-extent')),
            matching: find.byType(Text),
          ),
        )
        .data;
    expect(shortestBeforeHeight, isNot(widthChanged));

    await _changeSlider(tester, 'lab-height-slider', 420);
    final shortestAfterHeight = _resolvedValue(tester);
    final extentAfterHeight = tester
        .widget<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('lab-stat-extent')),
            matching: find.byType(Text),
          ),
        )
        .data;
    expect(shortestAfterHeight, isNot(shortestBeforeHeight));
    expect(extentAfterHeight, isNot(extentBeforeHeight));

    final shortestChanged = _resolvedValue(tester);
    await _changeSlider(tester, 'lab-base-slider', 28);
    expect(_resolvedValue(tester), isNot(shortestChanged));

    final baseChanged = _resolvedValue(tester);
    await _changeSlider(tester, 'lab-factor-slider', 4);
    expect(_resolvedValue(tester), isNot(baseChanged));

    final factorChanged = _resolvedValue(tester);
    await _changeSlider(tester, 'lab-breakpoint-slider', 800);
    expect(_resolvedValue(tester), isNot(factorChanged));

    final enabledSwitch = tester.widget<Switch>(
      find.byKey(const ValueKey('lab-enabled-switch')),
    );
    enabledSwitch.onChanged!(false);
    await tester.pump();
    expect(_resolvedValue(tester), contains('72.0'));

    final previewText = tester.widget<Text>(
      find.byKey(const ValueKey('lab-preview-text')),
    );
    final preview = tester.widget<Container>(
      find.byKey(const ValueKey('lab-preview')),
    );
    expect(previewText.style!.fontSize, isNot(initialFontSize));
    expect((preview.padding as EdgeInsets), isNot(initialPadding));
    expect((preview.decoration! as BoxDecoration).borderRadius, isNotNull);
    expect((preview.decoration! as BoxDecoration).boxShadow, hasLength(1));
    expect(
      find.byKey(const ValueKey('lab-breakpoint-feedback')),
      findsOneWidget,
    );
  });
}

String _resolvedValue(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const ValueKey('lab-resolved-value'))).data!;

Future<void> _changeSlider(
  WidgetTester tester,
  String key,
  double value,
) async {
  final slider = tester.widget<Slider>(
    find.descendant(
      of: find.byKey(ValueKey(key)),
      matching: find.byType(Slider),
    ),
  );
  slider.onChanged!(value);
  await tester.pump();
}
