import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/src/features/auth/models/app_user.dart';
import 'firestore_repository_impl.dart';

/// Provider que expone una implementación concreta de la interfaz
final firestoreRepositoryProvider = Provider<FirestoreRepository>(
  (ref) => FirestoreRepositoryImpl(),
);

/// Interfaz abstracta que define el contrato para el repositorio
abstract class FirestoreRepository {
  Future<void> addToFavorites(String userId, int movieId);
  Future<void> removeFromFavorites(String userId, int movieId);
  Future<void> addToWatchlist(String userId, int movieId);
  Future<void> removeFromWatchlist(String userId, int movieId);
  Stream<AppUser?> getUserStream(String uid);
  Future<AppUser?> getUser(String uid);
  Future<void> createUser(AppUser user);

  // 🔥 AGREGADO: permite editar parcialmente campos del perfil (PATCH)
  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates);
}
