import 'package:shared_preferences/shared_preferences.dart';

class AuthManager{
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

   Future<void> setAuthToken(String token)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }
}