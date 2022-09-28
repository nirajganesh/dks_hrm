import 'package:dks_hrm/preferences/Login_preferences.dart';
import 'package:flutter/cupertino.dart';

class Login_provider with ChangeNotifier
{
  String? token;
  String? get_token()
  {
    Login_preferences.get_token().then((value){
      token=value;
    });
    return token;
  }

}