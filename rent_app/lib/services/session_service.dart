import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _loggedInKey = 'isLoggedIn';
  static const String _roleKey = 'role';
  static const String _nameKey = 'name';

  // Save login session
  static Future<void> saveSession({
    required String role,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_roleKey, role);
    await prefs.setString(_nameKey, name);
  }

  // Check whether user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  // Get saved role
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // Get saved name
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_loggedInKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_nameKey);
  }
}