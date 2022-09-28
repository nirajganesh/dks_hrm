import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Summary/Service_summary.dart';
import 'package:dks_hrm/services/Summary_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class Edit_service_summary extends StatefulWidget {

  List<String> service_drop_list=[];
  String token;
  String client_id;
  String id;
  String qty;
  String date;
  String billed;
  String description;
  String service_name;
  bool theme;

  Edit_service_summary({required this.id,required this.service_drop_list,required this.token,
  required this.client_id,required this.qty,required this.date,required this.billed,required this.description,
    required this.service_name,required this.theme,Key? key}) : super(key: key);

  @override
  _Edit_service_summaryState createState() => _Edit_service_summaryState();
}

class _Edit_service_summaryState extends State<Edit_service_summary> {

  final TextEditingController Servicecontroller= TextEditingController();
  final TextEditingController Qtycontroller= TextEditingController();
  final TextEditingController Datecontroller= TextEditingController();
  final TextEditingController Billedcontroller= TextEditingController();
  final TextEditingController Descriptioncontroller= TextEditingController();

  late String choose_service;
  List<Service_model> service_list=[];
  late String service_id;
  DateTime _dateTime=DateTime.now();
  List<String> bill_list=<String>['BILL','NOT BILL'];
  late String choose_bill;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    choose_service=widget.service_name;
    Qtycontroller.text=widget.qty;
    Datecontroller.text=widget.date;
    Billedcontroller.text=widget.billed;
    if(widget.billed=="1")
      {
        choose_bill="BILL";
      }
    else
      {
        choose_bill="NOT BILL";
      }
    Descriptioncontroller.text=widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Edit Summary",style: TextStyle(color: Colors.white),),
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
                            return searchData_service(textEditingValue.text);
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
                                hintText: choose_service,
                              ),
                            );
                          },
                          onSelected: (value){
                            choose_service=value.toString();
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
                        Datecontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
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
                              Datecontroller.text,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
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
                          controller: Qtycontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Qty',
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
                        Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: DropdownButton(
                            isExpanded: true,
                            value: choose_bill,
                            onChanged: (newvalue){
                              setState(() {
                                choose_bill=newvalue as String;
                                Billedcontroller.text=choose_bill;
                              });
                            },
                            underline: SizedBox(),
                            dropdownColor: Colors.white,
                            hint:Text(choose_bill.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
                            items:bill_list.map((valueitem) {
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
                          controller: Descriptioncontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Description',
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
                    _onLoading();
                    updateService_summary();
                  },
                  child: Text("Save Summary",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          if(choose_service.isNotEmpty)
          {
            if(Qtycontroller.text.isNotEmpty)
            {
              if(Descriptioncontroller.text.isNotEmpty)
              {
                _onLoading();
                updateService_summary();
              }
              else
              {
                Notify_widget.notify("Please add the description");
              }
            }
            else
            {
              Notify_widget.notify("Please add the qty");
            }
          }
          else
          {
            Notify_widget.notify("Please add the service name");
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Summary",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    ):
      Scaffold(
        appBar: AppBar(
          title: Text("Edit Summary",style: TextStyle(color: Colors.white),),
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
                      color:HexColor(Colors_theme.dark_app_color),
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
                              return searchData_service(textEditingValue.text);
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
                                  hintText: choose_service,
                                  hintStyle: TextStyle(
                                    color: Colors.white24,
                                  )
                                ),
                              );
                            },
                            onSelected: (value){
                              choose_service=value.toString();
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
                          Datecontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
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
                                Datecontroller.text,style: (TextStyle(color: Colors.white,fontSize: 14)),
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
                            controller: Qtycontroller,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Qty',
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
                          Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: DropdownButton(
                              isExpanded: true,
                              value: choose_bill,
                              onChanged: (newvalue){
                                setState(() {
                                  choose_bill=newvalue as String;
                                  Billedcontroller.text=choose_bill;
                                });
                              },
                              underline: SizedBox(),
                              dropdownColor: Colors.black,
                              hint:Text(choose_bill.toString(),style: TextStyle(color:Colors.white24,fontSize: 15),),
                              items:bill_list.map((valueitem) {
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
                            controller: Descriptioncontroller,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Description',
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
        ),
        bottomNavigationBar:
        TouchRippleEffect(
          rippleColor: Colors.white60,
          onTap: (){
            if(choose_service.isNotEmpty)
            {
              if(Qtycontroller.text.isNotEmpty)
              {
                if(Descriptioncontroller.text.isNotEmpty)
                {
                  _onLoading();
                  updateService_summary();
                }
                else
                {
                  Notify_widget.notify("Please add the description");
                }
              }
              else
              {
                Notify_widget.notify("Please add the qty");
              }
            }
            else
            {
              Notify_widget.notify("Please add the service name");
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(child: Text("Save Summary",style: TextStyle(color: Colors.white,fontSize: 16),)),
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

  Future updateService_summary() async
  {
    service_list=await service.getService(context,widget.token);
    for(var ser in service_list)
    {
      if(choose_service.toString()==ser.name)
      {
        service_id=ser.id!;
      }
    }

    var response=await Summary_service.updateService_summary(widget.id,widget.client_id,service_id,Descriptioncontroller.text,
        Qtycontroller.text,Billedcontroller.text,Datecontroller.text,widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Service_summary(token: widget.token, client_id: widget.client_id)), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
    }
  }

  List<String> searchData_service(String param)
  {
    List<String> result=widget.service_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }

}
