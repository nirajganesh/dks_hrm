import 'package:dks_hrm/auth/Login_screen.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expire_token
{
   static Future<void> expire(BuildContext context,String message) async {
     if(message=="Expired token")
     {
       SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
       sharedPreferences.remove('token');
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
           Login_screen()), (Route<dynamic> route) => false);
       Notify_widget.notify("Login session out ! Please login again");
     }
     return;
   }
}