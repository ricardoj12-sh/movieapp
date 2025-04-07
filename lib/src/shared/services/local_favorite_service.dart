import 'package:shared_preferences/shared_preferences.dart';

class LocalFavoriteService {
  static const _key = 'local_favorite_ids';

  Future<List<int>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    return ids.map(int.parse).toList();
  }

  Future<void> addFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    if (!ids.contains(movieId.toString())) {
      ids.add(movieId.toString());
      await prefs.setStringList(_key, ids);
    }
  }

  Future<void> removeFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    ids.remove(movieId.toString());
    await prefs.setStringList(_key, ids);
  }

  Future<bool> isFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    return ids.contains(movieId.toString());
  }
}