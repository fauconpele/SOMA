import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:soma_platform/app.dart';

void main() {
  testWidgets('SOMA app builds (smoke test)', (WidgetTester tester) async {
    await tester.pumpWidget(const SomaApp());
    await tester.pumpAndSettle();

    // L’app doit contenir un MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
