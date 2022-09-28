
import 'dart:io';

import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Expenses/Expenses_model.dart';
import 'package:dks_hrm/screen/Expenses/Expenses.dart';
import 'package:dks_hrm/services/Expenses_service.dart';
import 'package:dks_hrm/services/Image_pick.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class Add_expenses extends StatefulWidget {
  String token;
  bool theme;
  Add_expenses({required this.token,required this.theme,Key? key}) : super(key: key);

  @override
  _Add_expensesState createState() => _Add_expensesState();
}

class _Add_expensesState extends State<Add_expenses> {

  final TextEditingController Amountcontroller= TextEditingController();
  final TextEditingController Datecontroller= TextEditingController();
  final TextEditingController Shortdescriptioncontroller= TextEditingController();
  File? file;
  List<Expenses_model> expenses_list=[];
  String? user_id;
  DateTime dateTime_from=DateTime.now();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadUser();
    Datecontroller.text=dateTime_from.day.toString()+"-"+dateTime_from.month.toString()+"-"+dateTime_from.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Add Expenses",style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor("#f5f5f5"),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.monetization_on,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Amountcontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Amount',
                              hintStyle: TextStyle(
                                  color: Colors.black38
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor("#f5f5f5"),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.note,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Shortdescriptioncontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Short Description',
                              hintStyle: TextStyle(
                                  color: Colors.black38
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        dateTime_from=date!;
                        Datecontroller.text=dateTime_from.day.toString()+"-"+dateTime_from.month.toString()+"-"+dateTime_from.year.toString();
                      });
                    });
                  },
                  child:
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor("#f5f5f5"),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width:10.0),
                        Flexible(
                          child:
                          Row(
                            children: [
                              Icon(Icons.date_range,color: Colors.black38,),
                              SizedBox(width:5),
                              Container(
                                width: 1.0,
                                height: 25.0,
                                color:Color(0xff7B7A7A),
                              ),
                              SizedBox(width:8.0),
                              Text(
                                Datecontroller.text,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    Image_pick.pick().then((value){
                      setState(() {
                        file=value;
                      });
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Theme.of(context).primaryColor,width: 2),
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload,color: Theme.of(context).primaryColor,),
                        SizedBox(width: 5,),
                        Text("File Uploaded",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                file==null?
                Text('*No Image Selected',style: TextStyle(fontSize: 16,color:Theme.of(context).textSelectionColor),):
                Text(file!.path.split('/').last.toString(),style: TextStyle(fontSize: 16,color:Theme.of(context).textSelectionColor),),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          if(Amountcontroller.text.isNotEmpty)
          {
            if(Shortdescriptioncontroller.text.isNotEmpty)
            {
              _onLoading();
              addExpenses();
            }
            else
            {
              Notify_widget.notify("Please add the description");
            }
          }
          else
          {
            Notify_widget.notify("Please add the amount");
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Expenses",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    ):
      Scaffold(
        appBar: AppBar(
          title: Text("Add Expenses",style: TextStyle(color: Colors.white),),
          backgroundColor: HexColor(Colors_theme.dark_app_color),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: HexColor(Colors_theme.dark_background),
        body: Container(
          decoration: BoxDecoration(
            color: HexColor(Colors_theme.dark_background),
          ),
          child:
          Padding(
            padding: EdgeInsets.all(14),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor(Colors_theme.dark_app_color),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right:8.0),
                          child: Icon(Icons.monetization_on,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child: TextField(
                            controller: Amountcontroller,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Amount',
                                hintStyle: TextStyle(
                                    color: Colors.white24
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor(Colors_theme.dark_app_color),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right:8.0),
                          child: Icon(Icons.note,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child: TextField(
                            controller: Shortdescriptioncontroller,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Short Description',
                                hintStyle: TextStyle(
                                    color: Colors.white24
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                        setState(() {
                          dateTime_from=date!;
                          Datecontroller.text=dateTime_from.day.toString()+"-"+dateTime_from.month.toString()+"-"+dateTime_from.year.toString();
                        });
                      });
                    },
                    child:
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color:HexColor(Colors_theme.dark_app_color),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(width:10.0),
                          Flexible(
                            child:
                            Row(
                              children: [
                                Icon(Icons.date_range,color: Colors.black38,),
                                SizedBox(width:5),
                                Container(
                                  width: 1.0,
                                  height: 25.0,
                                  color:Color(0xff7B7A7A),
                                ),
                                SizedBox(width:8.0),
                                Text(
                                  Datecontroller.text,style: (TextStyle(color: Colors.white,fontSize: 14)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Image_pick.pick().then((value){
                        setState(() {
                          file=value;
                        });
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Theme.of(context).primaryColor,width: 2),
                      ),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload,color: Theme.of(context).primaryColor,),
                          SizedBox(width: 5,),
                          Text("File Uploaded",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  file==null?
                  Text('*No Image Selected',style: TextStyle(fontSize: 16,color:Colors.white24),):
                  Text(file!.path.split('/').last.toString(),style: TextStyle(fontSize: 16,color:Theme.of(context).textSelectionColor),),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:
        TouchRippleEffect(
          rippleColor: Colors.white60,
          onTap: (){
            if(Amountcontroller.text.isNotEmpty)
              {
                if(Shortdescriptioncontroller.text.isNotEmpty)
                  {
                    _onLoading();
                    addExpenses();
                  }
                else
                  {
                    Notify_widget.notify("Please add the description");
                  }
              }
            else
              {
                Notify_widget.notify("Please add the amount");
              }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(child: Text("Save Expenses",style: TextStyle(color: Colors.white,fontSize: 16),)),
          ),
        ),
      );
  }

  LoadUser() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
       user_id= (prefs.getString('user_id') ?? '');
    });
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 10,),
                Text("Loading.."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future addExpenses() async
  {
    file?.length ?? '';
    var response=await Expenses_service.addExpenses(user_id!,Shortdescriptioncontroller.text,Datecontroller.text,
          Amountcontroller.text,file?.path??"",widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Expenses()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
    }
  }
}
