import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies/src/features/auth/models/app_user.dart';
import 'firestore_repository.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addToFavorites(String userId, int movieId) async {
    if (userId.isEmpty) return;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return;

    List<int> favorites = List<int>.from(userDoc.data()?['favorites'] ?? []);
    if (!favorites.contains(movieId)) {
      favorites.add(movieId);
      await _firestore.collection('users').doc(userId).update({'favorites': favorites});
    }
  }

  @override
  Future<void> removeFromFavorites(String userId, int movieId) async {
    if (userId.isEmpty) return;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return;

    List<int> favorites = List<int>.from(userDoc.data()?['favorites'] ?? []);
    favorites.remove(movieId);
    await _firestore.collection('users').doc(userId).update({'favorites': favorites});
  }

  @override
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

  @override
  Future<void> removeFromWatchlist(String userId, int movieId) async {
    if (userId.isEmpty) return;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return;

    List<int> watchlist = List<int>.from(userDoc.data()?['watchlist'] ?? []);
    watchlist.remove(movieId);
    await _firestore.collection('users').doc(userId).update({'watchlist': watchlist});
  }

  @override
  Stream<AppUser?> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return AppUser.fromJson(snapshot.data()!);
    });
  }

  @override
  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromJson(doc.data()!);
  }

  @override
  Future<void> createUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  // 🔥 AGREGADO: editar parcialmente campos del perfil (PATCH)
  @override
  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    await _firestore.collection('users').doc(uid).update(updates);
  }
}
