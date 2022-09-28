import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Empty_widget
{
    static Widget Empty()
    {
      return Padding(
        padding: const EdgeInsets.only(top:30.0),
        child: Container(
            color: Color(0xffF9FAFF),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:<Widget>
              [
                 Text('No data found',style: TextStyle(color: Colors.black,fontSize: 16),),
              ],
            ),
          ),
      );
    }

    static Widget Empty_dark()
    {
      return Padding(
        padding: const EdgeInsets.only(top:30.0),
        child: Container(
          color: HexColor(Colors_theme.dark_background),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>
            [
              Text('No data found',style: TextStyle(color: Colors.white,fontSize: 16),),
            ],
          ),
        ),
      );
    }
}