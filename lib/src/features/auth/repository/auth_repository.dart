import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(),
);

abstract class AuthRepository {
  Future<UserCredential?> loginWithEmail(String email, String password);
  Future<UserCredential?> signupWithEmail(String name, String email, String password);
  Future<UserCredential?> googleLogin();
  Future<void> logout();
}
