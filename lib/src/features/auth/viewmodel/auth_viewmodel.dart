import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies/src/features/auth/models/app_user.dart';
import 'package:movies/src/features/auth/repository/auth_repository.dart';
import 'package:movies/src/features/auth/repository/firestore_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/src/shared/services/session_service.dart';

final authViewmodelProvider =
    NotifierProvider<AuthViewmodel, AsyncValue<AppUser?>>(
  () => AuthViewmodel(),
);

class AuthViewmodel extends Notifier<AsyncValue<AppUser?>> {
  late AuthRepository _authRepository;
  late FirestoreRepository _firestoreRepository;
  final SessionService _sessionService = SessionService();

  @override
  build() {
    _authRepository = ref.watch(authRepositoryProvider);
    _firestoreRepository = ref.watch(firestoreRepositoryProvider);
    return const AsyncValue.data(null);
  }

 Future<void> restoreSessionIfPossible() async {
  final hasSession = await _sessionService.hasSession();
  print('[restoreSession] Tiene sesión guardada local: $hasSession');

  if (!hasSession) {
    print('[restoreSession] No hay sesión local guardada');
    return;
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  print('[restoreSession] Usuario actual desde FirebaseAuth: $currentUser');

  if (currentUser != null) {
    final appUser = await _firestoreRepository.getUser(currentUser.uid);
    print('[restoreSession] Usuario recuperado desde Firestore: $appUser');

    if (appUser != null) {
      state = AsyncValue.data(appUser);
    } else {
      print('[restoreSession] No se encontró el usuario en Firestore');
      state = const AsyncValue.data(null);
    }
  } else {
    print('[restoreSession] FirebaseAuth no tiene un usuario activo');
    state = const AsyncValue.data(null);
  }
}


  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      print('[login] Iniciando sesión con $email');
      final userCredential =
          await _authRepository.loginWithEmail(email, password);

      final firebaseUser = userCredential?.user;
      if (firebaseUser == null) {
        print('[login] Error: No se pudo obtener credenciales');
        state = AsyncValue.error(
          "Error: No se pudo obtener credenciales del usuario",
          StackTrace.current,
        );
        return;
      }

      AppUser? user = await _firestoreRepository.getUser(firebaseUser.uid);

      user ??= AppUser(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName ?? "Usuario",
        email: firebaseUser.email ?? "Correo no disponible",
        favorites: [],
        watchlist: [],
      );

      await _firestoreRepository.createUser(user);
      await _sessionService.saveSession();
      state = AsyncValue.data(user);
      print('[login] Sesión iniciada correctamente');
    } catch (error) {
      print('[login] Error durante el login: $error');
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> signUpWithEmail(
      String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      print('[signup] Registrando usuario con $email');
      final userCredential =
          await _authRepository.signupWithEmail(name, email, password);

      final firebaseUser = userCredential?.user;
      if (firebaseUser == null) {
        print('[signup] Error: FirebaseUser es null');
        state = AsyncValue.error(
          "Error: No se pudo crear el usuario",
          StackTrace.current,
        );
        return;
      }

      final user = AppUser(
        uid: firebaseUser.uid,
        name: name,
        email: firebaseUser.email ?? email,
        favorites: [],
        watchlist: [],
      );

      await _firestoreRepository.createUser(user);
      await _sessionService.saveSession();
      state = AsyncValue.data(user);
      print('[signup] Usuario registrado exitosamente');
    } catch (error) {
      print('[signup] Error durante el registro: $error');
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> googleLogin() async {
    state = const AsyncValue.loading();
    try {
      print('[googleLogin] Intentando login con Google');
      final userCredential = await _authRepository.googleLogin();
      final firebaseUser = userCredential?.user;

      if (firebaseUser == null) {
        print('[googleLogin] Usuario de Firebase nulo');
        state = const AsyncValue.data(null);
        return;
      }

      AppUser? user = await _firestoreRepository.getUser(firebaseUser.uid);

      user ??= AppUser(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName ?? "Usuario sin nombre",
        email: firebaseUser.email ?? "Correo no disponible",
        favorites: [],
        watchlist: [],
      );

      await _firestoreRepository.createUser(user);
      await _sessionService.saveSession();
      state = AsyncValue.data(user);
      print('[googleLogin] Login con Google exitoso');
    } catch (error) {
      print('[googleLogin] Error en login con Google: $error');
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      print('[logout] Cerrando sesión');
      await _authRepository.logout();
      await _sessionService.clearSession();
      state = const AsyncValue.data(null);
      print('[logout] Sesión cerrada correctamente');
    } catch (error) {
      print('[logout] Error al cerrar sesión: $error');
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}