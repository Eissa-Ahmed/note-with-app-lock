import 'package:shared_preferences/shared_preferences.dart';

class CachHelper {
  static late SharedPreferences sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.get("myDate") == null) {
      await saveLocalData("myDate", DateTime.now().toString());
    }
  }

  static Future<bool> saveLocalData(String key, dynamic value) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else {
      return await sharedPreferences.setBool(key, value);
    }
  }
}
