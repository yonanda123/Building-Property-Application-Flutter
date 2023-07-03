import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static final SharedPrefHelper instance = SharedPrefHelper._();
  static SharedPreferences? _preferences;

  SharedPrefHelper._();

  Future<SharedPreferences> get preferences async {
    if (_preferences != null) return _preferences!;

    _preferences = await SharedPreferences.getInstance();
    return _preferences!;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await preferences;
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<String?> getLoggedInUser() async {
    final prefs = await preferences;
    return prefs.getString('loggedInUser');
  }

  Future<void> setLoggedInUser(String username) async {
    final prefs = await preferences;
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('loggedInUser', username);
  }

  Future<void> clearLoggedInUser() async {
    final prefs = await preferences;
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('loggedInUser');
  }
}
