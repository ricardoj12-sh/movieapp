import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SessionService {
  static const String _sessionKey = 'is_logged_in';

  Future<void> saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setBool(_sessionKey, true);
    debugPrint('[SessionService] Guardado is_logged_in = true → $result');

    final check = prefs.getBool(_sessionKey);
    debugPrint('[SessionService] Confirmación inmediata: is_logged_in = $check');
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.remove(_sessionKey);
    debugPrint('[SessionService] Eliminado is_logged_in → $result');
  }

  Future<bool> hasSession() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_sessionKey) ?? false;
    debugPrint('[SessionService] Lectura is_logged_in = $value');
    return value;
  }
}
