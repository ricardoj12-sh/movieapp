import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:movies/src/features/account/viewmodel/account_viewmodel.dart';
import 'package:movies/src/features/account/repository/firestore_repository.dart';
import 'account_viewmodel_test.mocks.dart';

/// 🔧 Genera mocks para FirestoreRepository
@GenerateMocks([FirestoreRepository])
void main() {
  group('AccountViewModel', () {
    test('updateProfile llama a updateUserProfile con datos válidos', () async {
      final mockRepo = MockFirestoreRepository();

      // 🔹 Capturar un Ref real desde un Provider
      late Ref ref;
      final testRefProvider = Provider<void>((r) {
        ref = r;
      });

      final container = ProviderContainer(
        overrides: [
          firestoreRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );

      container.read(testRefProvider); // capturar Ref

      final viewModel = AccountViewModel(ref);

      // 🔹 Simular la respuesta del repositorio
      when(mockRepo.updateUserProfile(any, any)).thenAnswer((_) async => {});

      // ✅ Llamar al método con uidOverride (evita FirebaseAuth)
      await viewModel.updateProfile(
        {'name': 'Nuevo nombre'},
        uidOverride: 'test_uid',
      );

      // ✅ Verificar que se llamó correctamente con ese UID
      verify(mockRepo.updateUserProfile('test_uid', {'name': 'Nuevo nombre'})).called(1);
    });
  });
}
