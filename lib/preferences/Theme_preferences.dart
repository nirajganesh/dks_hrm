import 'package:shared_preferences/shared_preferences.dart';

class Theme_preferences
{
  static Future<void> set_theme(bool theme) async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    await sharedPreferences.setBool('theme', theme);
  }

  static Future<bool?> get_theme() async
  {
    final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    final bool? token = sharedPreferences.getBool('theme');
    return token;
  }

}