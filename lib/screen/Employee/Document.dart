import 'dart:io';

import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/services/Employee_service.dart';
import 'package:dks_hrm/services/Image_pick.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Employee.dart';
class Document extends StatefulWidget {

  bool theme;
  Document({required this.theme,Key? key}) : super(key: key);

  @override
  _DocumentState createState() => _DocumentState();
}

class _DocumentState extends State<Document> {

  final TextEditingController Filenamecontroller= TextEditingController();
  late String user_id;
  String token='';
  File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadUser();
    LoadToken();
  }

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      child: Icon(Icons.file_copy,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Filenamecontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'File Name',
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
                  Image_pick.pick().then((value){
                    setState(() {
                      file=value;
                    });
                  });
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    border:Border.all(width: 2.0, color:Theme.of(context).primaryColor),
                  ),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload,color: Theme.of(context).primaryColor,),
                      SizedBox(width: 5,),
                      Text("Image Uploaded",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              file==null?
              Text('*No Image Selected',style: TextStyle(fontSize: 16,color:Theme.of(context).textSelectionColor),):
              Text(file!.path.split('/').last.toString(),style: TextStyle(fontSize: 16,color:Theme.of(context).textSelectionColor),),
              SizedBox(height: 20,),
              SizedBox(height: 60,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  minimumSize: Size(double.infinity, 45),
                ),
                onPressed: () {
                  if(Filenamecontroller.text.isNotEmpty)
                    {
                      _onLoading();
                      updateDocument();
                    }
                  else
                    {
                      Notify_widget.notify("Please add the file name");
                    }
                },
                child: Text("Save Document",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      ),
    ):
      Container(
        decoration: BoxDecoration(
          color: HexColor(Colors_theme.dark_background),
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                        child: Icon(Icons.file_copy,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Filenamecontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'File Name',
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
                    Image_pick.pick().then((value){
                      setState(() {
                        file=value;
                      });
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor(Colors_theme.dark_app_color),
                      borderRadius: BorderRadius.circular(40),
                      border:Border.all(width: 2.0, color:Theme.of(context).primaryColor),
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload,color: Theme.of(context).primaryColor,),
                        SizedBox(width: 5,),
                        Text("Image Uploaded",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                file==null?
                Text('*No Image Selected',style: TextStyle(fontSize: 16,color:Colors.white24),):
                Text(file!.path.split('/').last.toString(),style: TextStyle(fontSize: 16,color:Theme.of(context).textSelectionColor),),
                SizedBox(height: 20,),
                SizedBox(height: 60,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  onPressed: () {
                    if(Filenamecontroller.text.isNotEmpty)
                    {
                      _onLoading();
                      updateDocument();
                    }
                    else
                    {
                      Notify_widget.notify("Please add the file name");
                    }
                  },
                  child: Text("Save Document",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                ),
              ],
            ),
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
  LoadToken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token= (prefs.getString('token') ?? '');
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

  Future updateDocument() async
  {
    var response=await Employee_service.updateEmp_document(user_id!,Filenamecontroller.text,file?.path??"",token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Employee()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
    }
  }
}
