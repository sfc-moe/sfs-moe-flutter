import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static Future<bool> get darkMode async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkMode') ?? false;
  }

  static setDarkMode(bool darkMode) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('darkMode', darkMode);
  }
}
