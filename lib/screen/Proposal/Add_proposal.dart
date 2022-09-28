import 'dart:convert';
import 'dart:io';

import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/screen/Proposal/Proposal.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Image_pick.dart';
import 'package:dks_hrm/services/Proposal_service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Add_proposal extends StatefulWidget {

  String token;
  List<String> client_drop_list=[];
  bool theme;
  Add_proposal({required this.client_drop_list,
    required this.token,required this.theme,
    Key? key}) : super(key: key);

  @override
  _Add_proposalState createState() => _Add_proposalState();

}

class _Add_proposalState extends State<Add_proposal> {

  final TextEditingController Clientnamecontroller= TextEditingController();
  final TextEditingController Followupcontroller= TextEditingController();
  final TextEditingController Statuscontroller= TextEditingController();
  final TextEditingController ShortDescriptioncontroller= TextEditingController();
  final TextEditingController LongDescriptioncontroller= TextEditingController();
  List<String> status_list=<String>['Send','Approved','Rejected','Revised&Send'];
  late String choose_status;
  late String choose_client;
  late String client_id;
  List<Client_model> client_list=[];
  File? file;
  String? permission_status;
  DateTime _dateTime=DateTime.now();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    choose_status=status_list.first;
    choose_client=widget.client_drop_list.first;
    Followupcontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
  }


  @override
  Widget build(BuildContext context) {
    return widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Add Proposal",style: TextStyle(color: Colors.white),),
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
                        child: Icon(Icons.person,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child:
                        Autocomplete(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            return searchData_client(textEditingValue.text);
                          },
                          fieldViewBuilder: (context,controller,focusnode,onEditingComplete){
                            return TextField(
                              style: TextStyle(height: 1),
                              controller: controller,
                              focusNode: focusnode,
                              onEditingComplete: onEditingComplete,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff00ffffff)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff00ffffff)),
                                ),
                                hintText: "Select Client",
                              ),
                            );
                          },
                          onSelected: (value){
                            // Servicecontroller.text=value.toString();
                            choose_client=value.toString();
                            Clientnamecontroller.text=choose_client;
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
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
                        _dateTime=date!;
                        Followupcontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
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
                              Followupcontroller.text,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                        child: Icon(Icons.repeat,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: DropdownButton(
                            isExpanded: true,
                            value: choose_status,
                            onChanged: (newvalue){
                              setState(() {
                                  choose_status=newvalue as String;
                              });
                            },
                            underline: SizedBox(),
                            dropdownColor: Colors.white,
                            hint:Text(choose_status.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
                            items:status_list.map((valueitem) {
                              return DropdownMenuItem(
                                  value: valueitem,
                                  child:Text(valueitem.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),)
                              );
                            }).toList(),
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
                          controller: ShortDescriptioncontroller,
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
                          controller: LongDescriptioncontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Long Description',
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
                      border: Border.all(color:Theme.of(context).primaryColor,width: 2),
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

          if(Clientnamecontroller.text.isNotEmpty)
            {
              if(ShortDescriptioncontroller.text.isNotEmpty)
                {
                  if(LongDescriptioncontroller.text.isNotEmpty)
                    {
                      _onLoading();
                      addProposal();
                    }
                  else
                    {
                      Notify_widget.notify("Please add the longdescription");
                    }
                }
              else
                {
                  Notify_widget.notify("Please add the shortdescription");
                }
            }
          else
            {
              Notify_widget.notify("Please add the clientname");
            }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Proposal",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    ):
      Scaffold(
      appBar: AppBar(
        title: Text("Add Proposal",style: TextStyle(color: Colors.white),),
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
                        child: Icon(Icons.person,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child:
                        Autocomplete(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            return searchData_client(textEditingValue.text);
                          },
                          fieldViewBuilder: (context,controller,focusnode,onEditingComplete){
                            return TextField(
                              style: TextStyle(height: 1,color: Colors.white),
                              controller: controller,
                              focusNode: focusnode,
                              onEditingComplete: onEditingComplete,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff00ffffff)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff00ffffff)),
                                ),
                                hintText: "Select Client",
                                hintStyle: TextStyle(
                                 color: Colors.white24,
                                )
                              ),
                            );
                          },
                          onSelected: (value){
                            choose_client=value.toString();
                            Clientnamecontroller.text=choose_client;
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
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
                        _dateTime=date!;
                        Followupcontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
                      });
                    });
                  },
                  child:
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor(Colors_theme.dark_app_color),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width:10.0),
                        Row(
                          children: [
                            Icon(Icons.date_range,color: Colors.white24,),
                            SizedBox(width:5),
                            Container(
                              width: 1.0,
                              height: 25.0,
                              color:Color(0xff7B7A7A),
                            ),
                            SizedBox(width:8.0),
                            Text(
                              Followupcontroller.text,style: (TextStyle(color: Colors.white,fontSize: 14)),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                        child: Icon(Icons.repeat,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: DropdownButton(
                            isExpanded: true,
                            value: choose_status,
                            onChanged: (newvalue){
                              setState(()
                              {
                                choose_status=newvalue as String;
                              });
                            },
                            underline: SizedBox(),
                            dropdownColor: Colors.black,
                            hint:Text(choose_status.toString(),style: TextStyle(color:Colors.white24,fontSize: 15),),
                            items:status_list.map((valueitem)
                             {
                               return DropdownMenuItem(
                                   value: valueitem,
                                   child:Text(valueitem.toString(),style: TextStyle(color:Colors.white,fontSize: 15),)
                               );
                             }).toList(),
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
                          controller: ShortDescriptioncontroller,
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
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children:
                    [
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
                          controller: LongDescriptioncontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Long Description',
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
                      border: Border.all(color:Theme.of(context).primaryColor,width: 2),
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                      [
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
                Text(file!.path.split('/').last.toString(),style: TextStyle(fontSize: 16,color:Colors.white24),),
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

          if(Clientnamecontroller.text.isNotEmpty)
          {
            if(ShortDescriptioncontroller.text.isNotEmpty)
            {
              if(LongDescriptioncontroller.text.isNotEmpty)
              {
                _onLoading();
                addProposal();
              }
              else
              {
                Notify_widget.notify("Please add the longdescription");
              }
            }
            else
            {
              Notify_widget.notify("Please add the shortdescription");
            }
          }
          else
          {
            Notify_widget.notify("Please add the clientname");
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Proposal",style: TextStyle(color: Colors.white,fontSize: 16),)),
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

  Future addProposal() async
  {
    client_list=await Client_service.getClient(context,widget.token);
    for(var cat in client_list)
    {
      if(choose_client.toString()==cat.name)
      {
        client_id=cat.id;
      }
    }
    var response=await Proposal_service.addProposal_Multipart(client_id,file?.path??"",ShortDescriptioncontroller.text,
        LongDescriptioncontroller.text,choose_status,Followupcontroller.text,widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Proposal()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
    }
  }

  List<String> searchData_client(String param)
  {
    List<String> result=widget.client_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }
}
