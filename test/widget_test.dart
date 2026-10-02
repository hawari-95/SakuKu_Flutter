import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keuangan_harian/main.dart';

void main() {
  testWidgets('Aplikasi SakuKu berhasil dimuat ke Halaman Login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SakuKuApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    
    expect(find.text('SakuKu'), findsOneWidget);
    expect(find.text('Masuk ke Beranda'), findsOneWidget);

    final TextFormField usernameField = tester.widget<TextFormField>(
      find.byType(TextFormField),
    );
    expect(usernameField.controller!.text, isEmpty);
  });
}
