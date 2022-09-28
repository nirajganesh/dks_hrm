import 'package:shared_preferences/shared_preferences.dart';

class Login_preferences
{
   static Future<void> set_token(String token) async {
     SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     await sharedPreferences.setString('token', token);
   }

   static Future<String?> get_token() async
   {
     final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     final String? token = sharedPreferences.getString('token');
     return token;
   }

   static Future<void> set_user(String user_id) async {
     SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     await sharedPreferences.setString('user_id', user_id);
   }

   static Future<String?> get_user() async
   {
     final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     final String? user_id = sharedPreferences.getString('user_id');
     return user_id;
   }



}