import 'dart:core';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/screen/Quotation/Add/Quotation_list.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/widget/ContactFormItemWidget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';


class Add_quotation extends StatefulWidget {

  List<String> client_drop_list=[];
  List<String> service_drop_list=[];
  String token;
  String quo_last_id;
  bool theme;
  Add_quotation({required this.client_drop_list,
    required this.service_drop_list,
    required this.token,
    required this.quo_last_id,
    required this.theme,
    Key? key}) : super(key: key);

  @override
  _Add_quotationState createState() => _Add_quotationState();
}

class _Add_quotationState extends State<Add_quotation> {

  final TextEditingController Quotationdatecontroller= TextEditingController();
  final TextEditingController Clientcontroller= TextEditingController();
  final TextEditingController Remarkcontroller= TextEditingController();
  final TextEditingController Validtillcontroller= TextEditingController();
  final TextEditingController Subtotalcontroller= TextEditingController();
  final TextEditingController Grandtotalcontroller= TextEditingController();
  final TextEditingController Totalcontroller= TextEditingController();

  List<String> status_list=<String>['Send','Approved','Rejected','Revised&Send'];
  late String choose_status;
  String? choose_client;
  late String client_id;
  late String choose_service;
  late String service_id;
  DateTime dateTime_que=DateTime.now();
  DateTime dateTime_valid=DateTime.now();
  String quotation_Date='(Quotation date)';
  String valid_Date='(Validation date)';
  late String quote_no;
  late String value_que_no;
  List<ContactFormItemWidget> contactForms = List.empty(growable: true);
  final formKey = GlobalKey<FormState>();
  List<Client_model> client_list=[];


  @override
  void initState()
  {
    super.initState();
    choose_status=status_list.first;
    choose_service=widget.service_drop_list.first;
    Quotationdatecontroller.text=dateTime_que.day.toString()+"-"+dateTime_que.month.toString()+"-"+dateTime_que.year.toString();
    Validtillcontroller.text=dateTime_valid.day.toString()+"-"+dateTime_valid.month.toString()+"-"+dateTime_valid.year.toString();

    value_que_no=widget.quo_last_id;
    int idx = value_que_no.indexOf("S");
    int increase_value=int.parse(value_que_no.substring(idx+1).trim())+1;
    quote_no = "QDS"+increase_value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Add Quotation",style: TextStyle(color: Colors.white),),
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
          child:  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
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
                            return searchData(textEditingValue.text);
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
                        child: Icon(Icons.inventory,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Container(
                        child:Text(quote_no,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        dateTime_que=date!;
                        Quotationdatecontroller.text=dateTime_que.day.toString()+"-"+dateTime_que.month.toString()+"-"+dateTime_que.year.toString();
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
                                Quotationdatecontroller.text+quotation_Date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
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
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        dateTime_valid=date!;
                        Validtillcontroller.text=dateTime_valid.day.toString()+"-"+dateTime_valid.month.toString()+"-"+dateTime_valid.year.toString();
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
                                Validtillcontroller.text+valid_Date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
                              ),
                            ],
                          ),
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
                          controller: Remarkcontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Remarks',
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TouchRippleEffect(
                      borderRadius: BorderRadius.circular(5),
                      rippleColor: Colors.white60,
                      onTap: (){
                        if(choose_client==null)
                          {
                            Notify_widget.notify("Please select the client");
                          }
                        else
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>Quotation_list(
                              service_drop_list:widget.service_drop_list,
                              choose_client:choose_client??"",
                              quote_no:quote_no,
                              valid_date:Validtillcontroller.text,
                              quo_date:Quotationdatecontroller.text,
                              remarks:Remarkcontroller.text,
                              client_drop_list:widget.client_drop_list,
                              theme:widget.theme,
                              )
                             ),
                            );
                          }
                      },
                      child:
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: HexColor("#D5EFFC"),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Icon(Icons.add_circle_outline,color: Theme.of(context).primaryColor,),
                             Text("Add More Items",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ):
      Scaffold(
        appBar: AppBar(
          title: Text("Add Quotation",style: TextStyle(color: Colors.white),),
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
            child:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
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
                              return searchData(textEditingValue.text);
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
                              // Servicecontroller.text=value.toString();
                              choose_client=value.toString();
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
                          child: Icon(Icons.inventory,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Container(
                          child:Text(quote_no,style: (TextStyle(color: Colors.white,fontSize: 14)),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                        setState(() {
                          dateTime_que=date!;
                          Quotationdatecontroller.text=dateTime_que.day.toString()+"-"+dateTime_que.month.toString()+"-"+dateTime_que.year.toString();
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
                          Flexible(
                            child:
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
                                  Quotationdatecontroller.text+quotation_Date,style: (TextStyle(color: Colors.white,fontSize: 14)),
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
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                        setState(() {
                          dateTime_valid=date!;
                          Validtillcontroller.text=dateTime_valid.day.toString()+"-"+dateTime_valid.month.toString()+"-"+dateTime_valid.year.toString();
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
                          Flexible(
                            child:
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
                                  Validtillcontroller.text+valid_Date,style: (TextStyle(color: Colors.white,fontSize: 14)),
                                ),
                              ],
                            ),
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
                            controller: Remarkcontroller,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Remarks',
                                hintStyle: TextStyle(
                                    color: Colors.white24
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 80,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TouchRippleEffect(
                        borderRadius: BorderRadius.circular(5),
                        rippleColor: Colors.white60,
                        onTap: (){
                          if(choose_client==null)
                          {
                            Notify_widget.notify("Please select the client");
                          }
                          else
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>Quotation_list(
                              service_drop_list:widget.service_drop_list,
                              choose_client:choose_client??"",
                              quote_no:quote_no,
                              valid_date:Validtillcontroller.text,
                              quo_date:Quotationdatecontroller.text,
                              remarks:Remarkcontroller.text,
                              client_drop_list:widget.client_drop_list,
                              theme:widget.theme,
                            )),);
                          }
                        },
                        child:
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: HexColor(Colors_theme.light_app_color).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                            [
                              Icon(Icons.add_circle_outline,color: Colors.white,),
                              Text("Add More Items",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Future getClient() async
  {
    client_list=await Client_service.getClient(context,widget.token);
  }

  List<String> searchData(String param)
  {
    List<String> result=widget.client_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }

}
