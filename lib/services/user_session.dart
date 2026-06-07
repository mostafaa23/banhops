import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const _keyUsername = 'username';
  static const _keyFirstName = 'firstName';

  // حفظ بعد Login
  static Future<void> save({
    required String username,
    required String firstName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyFirstName, firstName);
  }

  // جيب الـ username
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? 'guest';
  }

  // جيب الـ firstName
  static Future<String> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFirstName) ?? 'User';
  }

  // مسح عند Logout
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}