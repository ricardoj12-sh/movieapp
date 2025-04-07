import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/src/features/account/view/widgets/favorite_button.dart';
import 'package:movies/src/features/account/repository/firestore_repository.dart';
import 'package:movies/src/features/account/viewmodel/account_viewmodel.dart';
import '../mocks/mocks_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Necesario para testWidgets

  group('FavoriteButton widget tests', () {
    testWidgets(
      'FavoriteButton muestra ícono vacío y está deshabilitado si no hay usuario',
      (WidgetTester tester) async {
        // 🔹 Mock del repositorio Firestore
        final mockFirestore = MockFirestoreRepositoryAccount();

        // 🔹 Override del repositorio y del user stream
        final firestoreOverride = firestoreRepositoryProvider.overrideWithValue(mockFirestore);
        final userStreamOverride = userStreamProvider.overrideWith((ref, uid) => Stream.value(null));
        final currentUserOverride = currentUserProvider.overrideWithValue(null); // 🔹 Simula usuario no logueado

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              firestoreOverride,
              userStreamOverride,
              currentUserOverride,
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: FavoriteButton(101),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 🔍 Verifica el ícono y que esté deshabilitado
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        expect(iconButton.onPressed, isNull);
      },
    );
  });
}
