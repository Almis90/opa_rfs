import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_rfs/opa_rfs.dart';

void main() {
  testWidgets('typed helpers and RfsBuilder resolve local metrics', (
    tester,
  ) async {
    late RfsMetrics metrics;
    await tester.pumpWidget(
      MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 600,
            height: 400,
            child: RfsBuilder(
              builder: (context, value) {
                metrics = value;
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    expect(metrics.extent, 600);
    expect(metrics.resolve(max: 64, min: 32), 48);
  });
}
