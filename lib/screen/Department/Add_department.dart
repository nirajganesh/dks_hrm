import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/constants/ThemeClass.dart';
import 'package:dks_hrm/screen/Department/Department.dart';
import 'package:dks_hrm/services/Department_service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Add_department extends StatefulWidget {

  String token;
  Add_department({required this.token,Key? key}) : super(key: key);
  

  @override
  _Add_departmentState createState() => _Add_departmentState();
}



class _Add_departmentState extends State<Add_department> {

  final TextEditingController Departmentnamecontroller= TextEditingController();
  bool theme=false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadTheme();
  }
  @override
  Widget build(BuildContext context) {
    return theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Add Department",style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            children: [
              Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color:HexColor("#f5f5f5"),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right:8.0),
                          child: Icon(Icons.person,color: Colors.black38),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Colors.black38,
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child: TextField(
                            controller: Departmentnamecontroller,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Department Name',
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
            ],
          ),
        ),
      ),
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          if(Departmentnamecontroller.text.isNotEmpty)
            {
              _onLoading();
              addDepartment();
            }
          else
            {
              Notify_widget.notify("Please add the deparment name");
            }
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Department",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    ):
      Scaffold(
      appBar: AppBar(
        title: Text("Add Department",style: TextStyle(color: Colors.white),),
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
        child: Padding(
          padding: EdgeInsets.all(14),
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
                      child: Icon(Icons.person,color: Colors.white24),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color: Colors.white24,
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Departmentnamecontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Department Name',
                            hintStyle: TextStyle(
                                color: Colors.white24,
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     primary: Theme.of(context).primaryColor,
              //     onPrimary: Colors.white,
              //     elevation: 3,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(7.0)),
              //       minimumSize: Size(double.infinity, 45),
              //   ),
              //   onPressed: () {
              //     _onLoading();
              //     addDepartment();
              //   },
              //   child: Text("Save Department",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          if(Departmentnamecontroller.text.isNotEmpty)
          {
            _onLoading();
            addDepartment();
          }
          else
          {
            Notify_widget.notify("Please add the deparment name");
          }
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Department",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    )
    ;
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

  LoadTheme() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      theme = (prefs.getBool('theme') ?? false);
    });
  }

  Future addDepartment() async
  {
    var response=await Department_service.addDepartment(Departmentnamecontroller.text,widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Department()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
    }
  }
}
