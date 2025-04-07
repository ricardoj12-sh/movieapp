import 'package:flutter/material.dart'; 
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/src/features/account/view/screens/edit_profile_screen.dart';

void main() {
  testWidgets('EditProfileScreen muestra campos y botón', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: EditProfileScreen(),
        ),
      ),
    );

    // Verifica que los campos de texto existen
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Nuevo nombre'), findsOneWidget);
    expect(find.text('Nueva contraseña'), findsOneWidget);

    // Verifica que el botón existe
    expect(find.text('Guardar cambios'), findsOneWidget);

    // Simula escritura
    await tester.enterText(find.byType(TextField).first, 'Nuevo Usuario');
    await tester.tap(find.text('Guardar cambios'));
    await tester.pump();

    // No se espera error visual (aquí sería más útil con mocking)
  });
}