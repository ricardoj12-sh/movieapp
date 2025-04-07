import 'package:shared_preferences/shared_preferences.dart';

class LocalHistoryService {
  static const _key = 'viewed_history';

  Future<List<int>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key);
    return ids?.map(int.parse).toList() ?? [];
  }

  Future<void> addToHistory(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    if (!ids.contains(movieId.toString())) {
      ids.add(movieId.toString());
      await prefs.setStringList(_key, ids);
    }
  }
} 

final localHistoryService = LocalHistoryService();