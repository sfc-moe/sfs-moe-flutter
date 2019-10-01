import 'package:shared_preferences/shared_preferences.dart';

class SfsCredential {
  SfsCredential({this.username, this.password});
  String username;
  String password;
}

class SfsAuth {
  static Future<SfsCredential> get profile async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (username == null || password == null) { return null; }

    return new SfsCredential(username: username, password: password);
  }

  static updateProfile(SfsCredential credential) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', credential.username);
    await prefs.setString('password', credential.password);
  }

  static removeProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
  }

  static setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String> get token async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
