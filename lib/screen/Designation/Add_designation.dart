import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/screen/Designation/Designation.dart';
import 'package:dks_hrm/services/Designation_service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Add_designation extends StatefulWidget {

  String token;
  bool theme;
  Add_designation({required this.token,required this.theme,Key? key}) : super(key: key);

  @override
  _Add_designationState createState() => _Add_designationState();
}

class _Add_designationState extends State<Add_designation> {

  final TextEditingController Designationnamecontroller= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return widget.theme==true?
    Scaffold(
      appBar: AppBar(
        title: Text("Add Designation",style: TextStyle(color: Colors.white),),
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
                      child: Icon(Icons.person,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Designationnamecontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Designation Name',
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
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     primary: Theme.of(context).primaryColor,
              //     onPrimary: Colors.white,
              //     elevation: 3,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(7.0)),
              //     minimumSize: Size(double.infinity, 45),
              //   ),
              //   onPressed: () {
              //     _onLoading();
              //     addDesignation();
              //   },
              //   child: Text("Save Designation",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          if(Designationnamecontroller.text.isNotEmpty)
          {
            _onLoading();
            addDesignation();
          }
          else
          {
            Notify_widget.notify("Please add the designation name");
          }

        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Designation",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    ):
    Scaffold(
      appBar: AppBar(
        title: Text("Add Designation",style: TextStyle(color: Colors.white),),
        backgroundColor: HexColor(Colors_theme.dark_app_color),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor:HexColor(Colors_theme.dark_background),
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
                decoration:BoxDecoration(
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
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Designationnamecontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Designation Name',
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
            ],
          ),
        ),
      ),
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          if(Designationnamecontroller.text.isNotEmpty)
          {
            _onLoading();
            addDesignation();
          }
          else
          {
            Notify_widget.notify("Please add the designation name");
          }

        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Designation",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    );
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

  Future addDesignation() async
  {
    var response=await Designation_service.addDesignation(Designationnamecontroller.text,widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Designation()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
    }
  }
}
