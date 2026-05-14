import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicity_app/main.dart';

void main() {
  testWidgets('renders the app shell', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
