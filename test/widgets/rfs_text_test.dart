import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_rfs/opa_rfs.dart';

void main() {
  testWidgets('ambient text scaling remains active', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: const MaterialApp(
          home: SizedBox(
            width: 1200,
            child: RfsText('Scaled', maxFontSize: 32),
          ),
        ),
      ),
    );
    final renderParagraph = tester.renderObject<RenderParagraph>(
      find.text('Scaled'),
    );
    expect(renderParagraph.textScaler, const TextScaler.linear(2));
  });

  testWidgets('RfsText uses local width and preserves style', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 600,
            child: RfsText(
              'Title',
              maxFontSize: 64,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Title'));
    expect(text.style?.fontSize, 44.2);
    expect(text.style?.color, Colors.red);
    expect(text.style?.fontWeight, FontWeight.bold);
  });

  testWidgets('RfsText forwards text options', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(
          width: 300,
          child: RfsText(
            'Long title',
            maxFontSize: 64,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    final text = tester.widget<Text>(find.text('Long title'));
    expect(text.maxLines, 1);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.textAlign, TextAlign.center);
  });

  testWidgets('RfsText.rich preserves span styles', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(
          width: 600,
          child: RfsText.rich(
            TextSpan(
              text: 'Hello ',
              children: [
                TextSpan(
                  text: 'world',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            maxFontSize: 32,
          ),
        ),
      ),
    );
    final text = tester.widget<Text>(find.byType(Text).last);
    expect(text.textSpan, isNotNull);
    expect((text.textSpan! as TextSpan).children!.single, isA<TextSpan>());
  });

  testWidgets('RfsText.rich preserves Flutter defaults and semantics id', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RfsText.rich(
          TextSpan(text: 'Rich'),
          maxFontSize: 32,
          semanticsIdentifier: 'rich-title',
        ),
      ),
    );
    final text = tester.widget<Text>(find.byType(Text).last);
    expect(text.overflow, isNull);
    expect(text.textWidthBasis, isNull);
    expect(text.semanticsIdentifier, 'rich-title');
  });
}
