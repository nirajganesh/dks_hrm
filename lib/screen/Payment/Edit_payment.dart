import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Payment_service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import 'Payment.dart';
class Edit_payment extends StatefulWidget {

  String token;
  List<String> client_drop_list=[];
  String? receipt_no;
  String? payment_date;
  String? payment_amount;
  String? remarks;
  String? invoice_id;
  String? id;
  String client_name;
  bool theme;

  Edit_payment({required this.client_drop_list,required this.token,required this.receipt_no,
    required this.payment_date,required this.payment_amount,required this.remarks,required this.invoice_id,
    required this.id,required this.client_name,required this.theme,Key? key}) : super(key: key);

  @override
  _Edit_paymentState createState() => _Edit_paymentState();
}

class _Edit_paymentState extends State<Edit_payment> {

  final TextEditingController Receiptnocontroller= TextEditingController();
  final TextEditingController Paymentdatecontroller= TextEditingController();
  final TextEditingController Clientcontroller= TextEditingController();
  final TextEditingController Paymentamountcontroller= TextEditingController();
  final TextEditingController Remarkcontroller= TextEditingController();
  final TextEditingController Invoicecontroller= TextEditingController();

  int? _value=1;
  late String choose_client;
  List<Client_model> client_list=[];
  late String client_id;
  DateTime _dateTime=DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Receiptnocontroller.text=widget.receipt_no!;
    Paymentdatecontroller.text=widget.payment_date!;
    Paymentamountcontroller.text=widget.payment_amount!;
    Remarkcontroller.text=widget.remarks!;
    Invoicecontroller.text=widget.invoice_id!;
  //  choose_client=widget.client_drop_list.first;
    choose_client=widget.client_name;
  }
  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Edit Payment",style: TextStyle(color: Colors.white),),
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
                        child: Icon(Icons.supervised_user_circle_rounded,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Receiptnocontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Receipt no.',
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
                        _dateTime=date!;
                        Paymentdatecontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
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
                              Paymentdatecontroller.text,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
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
                                hintText: choose_client,
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
                        child: Icon(Icons.email,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Paymentamountcontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Payment Amount',
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: <Widget>[
                        Radio(
                            value: 1,
                            groupValue: _value,
                            onChanged: (Value){
                              setState(() {
                                _value= Value as int?;
                              });
                            }
                        ),
                        Text("Add Payment to Invoice",style: TextStyle(fontSize: 14),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                            value: 2,
                            groupValue: _value,
                            onChanged: (Value){
                              setState(() {
                                _value= Value as int?;
                                Invoicecontroller.text='';
                              });
                            }
                        ),
                        Text("Advance Payment"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                _value==1?
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
                        child: Icon(Icons.location_on,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Invoicecontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Select Invoice',
                              hintStyle: TextStyle(
                                  color: Colors.black38
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ):SizedBox(),
                SizedBox(height: 20,),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     primary: Theme.of(context).primaryColor,
                //     onPrimary: Colors.white,
                //     elevation: 3,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(40.0)),
                //     minimumSize: Size(double.infinity, 45),
                //   ),
                //   onPressed: () {
                //     _onLoading();
                //     updatePayment();
                //   },
                //   child: Text("Save Payment",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          _onLoading();
          updatePayment();
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Payment",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    ):
      Scaffold(
        appBar: AppBar(
          title: Text("Edit Payment",style: TextStyle(color: Colors.white),),
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
                          child: Icon(Icons.supervised_user_circle_rounded,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child: TextField(
                            controller: Receiptnocontroller,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Receipt no.',
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
                          _dateTime=date!;
                          Paymentdatecontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
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
                                Paymentdatecontroller.text,style: (TextStyle(color: Colors.white,fontSize: 14)),
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
                                  hintText: choose_client,
                                  hintStyle: TextStyle(
                                    color: Colors.white24,
                                  )
                                ),
                              );
                            },
                            onSelected: (value){
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
                          child: Icon(Icons.email,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child: TextField(
                            controller: Paymentamountcontroller,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Payment Amount',
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
                  SizedBox(height: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor: Colors.white
                            ),
                            child: Radio(
                                value: 1,
                                groupValue: _value,
                                onChanged: (Value){
                                  setState(() {
                                    _value= Value as int?;
                                  });
                                }
                            ),
                          ),
                          Text("Add Payment to Invoice",style: TextStyle(fontSize: 14,color: Colors.white),),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor: Colors.white
                            ),
                            child: Radio(
                                value: 2,
                                groupValue: _value,
                                onChanged: (Value){
                                  setState(() {
                                    _value= Value as int?;
                                    Invoicecontroller.text='';
                                  });
                                }
                            ),
                          ),
                          Text("Advance Payment",style: TextStyle(fontSize: 14,color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  _value==1?
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
                          child: Icon(Icons.location_on,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child: TextField(
                            controller: Invoicecontroller,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Select Invoice',
                                hintStyle: TextStyle(
                                    color: Colors.white24
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ):SizedBox(),
                  SizedBox(height: 20,),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Theme.of(context).primaryColor,
                  //     onPrimary: Colors.white,
                  //     elevation: 3,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(40.0)),
                  //     minimumSize: Size(double.infinity, 45),
                  //   ),
                  //   onPressed: () {
                  //     _onLoading();
                  //     updatePayment();
                  //   },
                  //   child: Text("Save Payment",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                  // ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:
        TouchRippleEffect(
          rippleColor: Colors.white60,
          onTap: (){
            _onLoading();
            updatePayment();
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(child: Text("Save Payment",style: TextStyle(color: Colors.white,fontSize: 16),)),
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

  Future updatePayment() async
  {
    client_list=await Client_service.getClient(context,widget.token);
    for(var cat in client_list)
    {
      if(choose_client.toString()==cat.name)
      {
        client_id=cat.id;
      }
    }

    var response=await Payment_service.updatePayment(widget.id!,Receiptnocontroller.text,client_id,Paymentamountcontroller.text,
        Invoicecontroller.text,Paymentdatecontroller.text,Remarkcontroller.text,widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Payment()), (Route<dynamic> route) => false);
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
