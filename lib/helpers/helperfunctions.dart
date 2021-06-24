import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLogInKey = 'ISLOGGEDIN';
  static String sharedPreferenceUidKey = 'UIDKEY';
  static String sharedPreferencePhonenoKey = 'PHONENO';

  static Future<bool> saveUserLoggedInPreferenceKey(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLogInKey, isUserLoggedIn);
  }

  static Future<bool> saveUidPreferenceKey(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUidKey, uid);
  }

  static Future<bool> savePhonenoPreferenceKey(String phoneno) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferencePhonenoKey, phoneno);
  }

  static Future<bool> getUserLoggedInPreferenceKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLogInKey);
  }

  static Future<String> getUidPreferenceKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUidKey);
  }

  static Future<String> getPhonenoPreferenceKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferencePhonenoKey);
  }
}
