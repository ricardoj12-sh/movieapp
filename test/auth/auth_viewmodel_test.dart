import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Para mockear preferencias

import 'package:movies/src/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:movies/src/features/auth/repository/auth_repository.dart';
import 'package:movies/src/features/auth/repository/firestore_repository.dart';

import '../mocks/mocks_test.mocks.dart'; // ✅ Mocks generados

// ✅ Fakes personalizados para evitar problemas de mock con getters
class FakeUser extends Fake implements User {
  @override
  String get uid => 'abc123';

  @override
  String? get email => 'test@example.com';

  @override
  String? get displayName => 'Test User';

  @override
  String? get photoURL => null;
}

class FakeUserCredential extends Fake implements UserCredential {
  final User _user;

  FakeUserCredential(this._user);

  @override
  User? get user => _user;
}

void main() {
  // ✅ Evita error de bindings no inicializados
  TestWidgetsFlutterBinding.ensureInitialized();

  // ✅ Evita MissingPluginException de shared_preferences
  SharedPreferences.setMockInitialValues({});

  test('loginWithEmail crea un nuevo AppUser si no existe en Firestore', () async {
    // Arrange
    final mockAuthRepo = MockAuthRepository();
    final mockFirestoreRepo = MockFirestoreRepositoryAuth();

    final fakeUser = FakeUser();
    final fakeCredential = FakeUserCredential(fakeUser);

    // Simula login y que el usuario no existe aún
    when(mockAuthRepo.loginWithEmail('test@example.com', '123456'))
        .thenAnswer((_) async => fakeCredential);

    when(mockFirestoreRepo.getUser('abc123')).thenAnswer((_) async => null);
    when(mockFirestoreRepo.createUser(any)).thenAnswer((_) async => {});

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        firestoreRepositoryProvider.overrideWithValue(mockFirestoreRepo),
      ],
    );

    final viewModel = container.read(authViewmodelProvider.notifier);

    // Act
    await viewModel.loginWithEmail('test@example.com', '123456');

    // Assert
    final result = container.read(authViewmodelProvider);

    expect(result.value, isNotNull);
    expect(result.value?.uid, equals('abc123'));
    expect(result.value?.email, equals('test@example.com'));
    expect(result.value?.name, equals('Test User'));

    // Verifica que las funciones clave se llamaron
    verify(mockAuthRepo.loginWithEmail('test@example.com', '123456')).called(1);
    verify(mockFirestoreRepo.getUser('abc123')).called(1);
    verify(mockFirestoreRepo.createUser(any)).called(1);
  });
}
