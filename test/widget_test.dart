import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// ✅ IMPORTANT : on teste l'app réelle (SomaApp), pas le template MyApp.
// Remplace "soma_platform" par le nom exact de ton package si besoin.
import 'package:soma_platform/app.dart';

void main() {
  testWidgets('SOMA app builds (smoke test)', (WidgetTester tester) async {
    await tester.pumpWidget(const SomaApp());
    await tester.pumpAndSettle();

    // Vérifie juste que l'app se construit sans erreur.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
