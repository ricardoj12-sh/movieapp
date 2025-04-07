import 'package:movies/src/features/account/repository/firestore_repository.dart';
import 'package:movies/src/features/auth/models/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// 🔹 Nuevo provider que expone el usuario actual (para facilitar testing y desacoplar Firebase)
final currentUserProvider = Provider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});

/// 🔹 Stream del usuario de Firestore si está autenticado y el uid coincide
final userStreamProvider = StreamProvider.family<AppUser?, String>((ref, uid) {
  final user = ref.watch(currentUserProvider); // ✅ usamos el nuevo provider
  if (uid.isEmpty || user == null || uid != user.uid) {
    return Stream.value(null); // 🔐 Protege contra accesos sin sesión válida
  }
  return ref.watch(firestoreRepositoryProvider).getUserStream(uid);
});

/// 🔹 ViewModel para acciones relacionadas al perfil del usuario
final accountViewModelProvider = Provider<AccountViewModel>((ref) {
  return AccountViewModel(ref);
});

class AccountViewModel {
  final Ref ref;

  AccountViewModel(this.ref);

  /// 🔥 Método para actualizar parcialmente el perfil del usuario (PATCH)
Future<void> updateProfile(Map<String, dynamic> updates, {String? uidOverride}) async {
  final uid = uidOverride ?? FirebaseAuth.instance.currentUser?.uid;
  if (uid != null && updates.isNotEmpty) {
    await ref.read(firestoreRepositoryProvider).updateUserProfile(uid, updates);
  }
}


  /// 🔐 Método para cambiar la contraseña del usuario autenticado
  Future<void> updatePassword(String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && newPassword.isNotEmpty) {
      await user.updatePassword(newPassword);
    }
  }
}
