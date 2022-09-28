import 'package:dks_hrm/screen/Category/Add_category.dart';
import 'package:dks_hrm/screen/Client/Add_client.dart';
import 'package:dks_hrm/screen/Dashboard/Dashboard.dart';
import 'package:dks_hrm/screen/Department/Add_department.dart';
import 'package:dks_hrm/screen/Designation/Add_designation.dart';
import 'package:dks_hrm/screen/Expenses/Add_expenses.dart';
import 'package:dks_hrm/screen/Holiday/Add_holiday.dart';
import 'package:dks_hrm/screen/Payrolltype/Add_payrolltype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class App_bar_widget
{
  static PreferredSizeWidget App_bar(BuildContext context,String app_name,String color)
  {
    return AppBar(
        title: Text(app_name,style: TextStyle(color: Colors.white),),
        backgroundColor: HexColor(color),
         leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color:Colors.white),
         onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  static PreferredSizeWidget App_bar_view(BuildContext context,String app_name,String color)
  {
    return AppBar(
      title: Text(app_name,style: TextStyle(color: Colors.white),),
      backgroundColor: HexColor(color),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color:Colors.white),
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
            Dashboard()), (Route<dynamic> route) => false),
      ),
    );
  }

  static PreferredSizeWidget App_bar_department(BuildContext context,String app_name,String token,String color)
  {
    return AppBar(
      title: Text(app_name,style: TextStyle(color: Colors.white),),
      backgroundColor: HexColor(color),
      // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color:Colors.white),
        onPressed: (){

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
              Dashboard()), (Route<dynamic> route) => false);
        },
      ),
      actions:<Widget> [
        Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: IconButton(
            icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_department(token:token)),);
            },
          ),
        ),
      ],
    );
  }

  static PreferredSizeWidget App_bar_designation(BuildContext context,String app_name,String token,String color,bool theme)
  {
    return AppBar(
      title: Text(app_name,style: TextStyle(color: Colors.white),),
      backgroundColor: HexColor(color),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color:Colors.white),
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
            Dashboard()), (Route<dynamic> route) => false),
      ),
      actions:<Widget> [
        Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: IconButton(
            icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_designation(token:token,theme:theme)),);
            },
          ),
        ),
      ],
    );
  }

  static PreferredSizeWidget App_bar_client(BuildContext context,String app_name,String token,String color,bool theme)
  {
    return AppBar(
      title: Text(app_name,style: TextStyle(color: Colors.white),),
      backgroundColor: HexColor(color),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color:Colors.white),
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
            Dashboard()), (Route<dynamic> route) => false),
      ),
      actions:<Widget> [
        Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: IconButton(
            icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_client(token:token,theme:theme)),);
            },
          ),
        ),
      ],
    );
  }

  static PreferredSizeWidget App_bar_category(BuildContext context,String app_name,String token,String color,bool theme)
  {
    return AppBar(
      title: Text(app_name,style: TextStyle(color: Colors.white),),
      backgroundColor: HexColor(color),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color:Colors.white),
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
            Dashboard()), (Route<dynamic> route) => false),
      ),
      actions:<Widget> [
        Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: IconButton(
            icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_category(token:token,theme:theme)),);
            },
          ),
        ),
      ],
    );
  }

  static PreferredSizeWidget App_bar_expenses(BuildContext context,String app_name,String token,String color,bool theme)
  {
    return AppBar(
      title: Text(app_name,style: TextStyle(color: Colors.white),),
      backgroundColor: HexColor(color),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color:Colors.white),
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
            Dashboard()), (Route<dynamic> route) => false),
      ),
      actions:<Widget> [
        Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: IconButton(
            icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_expenses(
                token:token,
                theme:theme,
              )),);
            },
          ),
        ),
      ],
    );
  }

  static PreferredSizeWidget App_bar_payrolltype(BuildContext context,String app_name,String token,String color,bool theme)
  {
    return AppBar(
      title: Text(app_name,style: TextStyle(color: Colors.white),),
      backgroundColor: HexColor(color),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color:Colors.white),
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
            Dashboard()), (Route<dynamic> route) => false),
      ),
      actions:<Widget> [
        Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: IconButton(
            icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_payrolltype(
                token:token,
                theme:theme,
              )),);
            },
          ),
        ),
      ],
    );
  }

  static PreferredSizeWidget App_bar_holiday(BuildContext context,String app_name,String token,String color,theme)
  {
    return AppBar(
      title: Text(app_name,style: TextStyle(color: Colors.white),),
      backgroundColor: HexColor(color),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color:Colors.white),
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
            Dashboard()), (Route<dynamic> route) => false),
      ),
      actions:<Widget> [
        Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: IconButton(
            icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_holiday(
                theme:theme,
                token:token,
              )),);
            },
          ),
        ),
      ],
    );
  }
}