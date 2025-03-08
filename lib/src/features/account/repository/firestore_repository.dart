import 'package:movies/src/features/auth/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreRepositoryProvider = Provider(
  (ref) => FirestoreRepository(),
);

class FirestoreRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addToFavorites(String userId, int movieId) async {
    if (userId.isEmpty) return; // 🔹 Evita errores si userId está vacío
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return;

    List<int> favorites = List<int>.from(userDoc.data()?['favorites'] ?? []);
    if (!favorites.contains(movieId)) {
      favorites.add(movieId);
      await _firestore.collection('users').doc(userId).update({'favorites': favorites});
    }
  }

  Future<void> removeFromFavorites(String userId, int movieId) async {
    if (userId.isEmpty) return;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return;

    List<int> favorites = List<int>.from(userDoc.data()?['favorites'] ?? []);
    favorites.remove(movieId);
    await _firestore.collection('users').doc(userId).update({'favorites': favorites});
  }

  Future<void> addToWatchlist(String userId, int movieId) async {
    if (userId.isEmpty) return;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return;

    List<int> watchlist = List<int>.from(userDoc.data()?['watchlist'] ?? []);
    if (!watchlist.contains(movieId)) {
      watchlist.add(movieId);
      await _firestore.collection('users').doc(userId).update({'watchlist': watchlist});
    }
  }

  Future<void> removeFromWatchlist(String userId, int movieId) async {
    if (userId.isEmpty) return;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return;

    List<int> watchlist = List<int>.from(userDoc.data()?['watchlist'] ?? []);
    watchlist.remove(movieId);
    await _firestore.collection('users').doc(userId).update({'watchlist': watchlist});
  }

  Stream<AppUser?> getUserStream(String uid) {
    if (uid.isEmpty) return Stream.value(null); // 🔹 Evita fallos si uid está vacío

    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return null; // 🔹 Si no hay datos, retorna null
      return AppUser.fromJson(data);
    });
  }
}
