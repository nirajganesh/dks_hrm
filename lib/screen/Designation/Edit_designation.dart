import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/screen/Designation/Designation.dart';
import 'package:dks_hrm/services/Designation_service.dart';
import 'package:dks_hrm/widget/App_bar_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Edit_designation extends StatefulWidget {

  String id,dep_name,token;
  bool theme;
  Edit_designation({required this.id,required this.dep_name,required this.token,required this.theme,Key? key}) : super(key: key);

  @override
  _Edit_designationState createState() => _Edit_designationState();
}

class _Edit_designationState extends State<Edit_designation> {

  final TextEditingController Designationnamecontroller= TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Designationnamecontroller.text=widget.dep_name;
  }
 @override
  Widget build(BuildContext context) {
    return widget.theme==true?
      Scaffold(
      appBar: App_bar_widget.App_bar(context,"Edit Department",Colors_theme.light_app_color),
      drawer: Drawer(),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
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
              //     updateDesignation();
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
          _onLoading();
          updateDesignation();
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
      appBar: App_bar_widget.App_bar(context,"Edit Department",Colors_theme.dark_app_color),
      body: Container(
        decoration: BoxDecoration(
          color: HexColor(Colors_theme.dark_background),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
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
          _onLoading();
          updateDesignation();
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

  Future updateDesignation() async
  {
    var response=await Designation_service.updateDesignation(widget.id,Designationnamecontroller.text,widget.token);
    if(response['status']==200)
    {
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
