import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Notify_widget
{
  static void notify(var message)
  {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}