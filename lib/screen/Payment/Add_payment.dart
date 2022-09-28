import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Invoice/Invoice_model.dart';
import 'package:dks_hrm/screen/Payment/Payment.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Payment_service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Add_payment extends StatefulWidget {

  String token;
  List<String> client_drop_list=[];
  String receipt_id;
  String client_name;
  bool theme;


  Add_payment({
    required this.client_drop_list,
    required this.token,
    required this.receipt_id,
    required this.client_name,
    required this.theme,
    Key? key}) : super(key: key);


  @override
  _Add_paymentState createState() => _Add_paymentState();

}

class _Add_paymentState extends State<Add_payment> {

  final TextEditingController Receiptnocontroller= TextEditingController();
  final TextEditingController Paymentdatecontroller= TextEditingController();
  final TextEditingController Clientcontroller= TextEditingController();
  final TextEditingController Paymentamountcontroller= TextEditingController();
  final TextEditingController Remarkcontroller= TextEditingController();
  final TextEditingController Invoicecontroller= TextEditingController();
  int? _value=1;
  late String choose_client;
  String choose_invoice='';
  late String client_id;
  List<Client_model> client_list=[];
  DateTime _dateTime=DateTime.now();
  List<Invoice_model> invoice_client_list=[];
  List<String> invoice_client_drop_list=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     Receiptnocontroller.text=widget.receipt_id;
     choose_client=widget.client_drop_list.first;
     Paymentdatecontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
  }


  @override
  Widget build(BuildContext context) {
    return 
      widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Add Payment",style: TextStyle(color: Colors.white),),
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
                      Text(Receiptnocontroller.text,style: TextStyle(fontSize: 14,color: Colors.black),),
                      SizedBox(width:8.0),
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
                                hintText: "Select Client",
                              ),
                            );
                          },
                          onSelected: (value){
                            // Servicecontroller.text=value.toString();
                            setState(() {
                              invoice_client_drop_list.clear();
                              choose_client=value.toString();
                              getClient_id(choose_client).then((value){
                                getInvoice_client(client_id).then((value){
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                });
                              });
                            });
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
                            return searchData_invoice(textEditingValue.text);
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
                                hintText: "Select Invoice",
                              ),
                            );
                          },
                          onSelected: (value){
                            // Servicecontroller.text=value.toString();
                            choose_invoice=value.toString();
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ):
                SizedBox(),
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
                //     addPayment();
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
          addPayment();
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
          title: Text("Add Payment",style: TextStyle(color: Colors.white),),
          backgroundColor: HexColor(Colors_theme.dark_app_color),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor:HexColor(Colors_theme.dark_background),
        body: Container(
          decoration: BoxDecoration(
            color:HexColor(Colors_theme.dark_background),
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
                        Text(Receiptnocontroller.text,style: TextStyle(fontSize: 14,color: Colors.white),),
                        SizedBox(width:8.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                        setState(()
                        {
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
                              Text
                                (
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
                            optionsBuilder: (TextEditingValue textEditingValue)
                            {
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
                                  hintStyle:
                                  TextStyle(
                                    color: Colors.white24,
                                  )
                                ),
                              );
                            },
                            onSelected: (value){
                              setState(()
                              {
                                choose_client=value.toString();
                                invoice_client_drop_list.clear();
                                getClient_id(choose_client).then((value){
                                  getInvoice_client(client_id).then((value1)
                                  {
                                    invoice_client_drop_list.add(value1);
                                    searchData_invoice("");
                                    FocusScopeNode currentFocus = FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus)
                                    {
                                      currentFocus.unfocus();
                                    }
                                  });
                                });
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container
                    (
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
                          child:
                          TextField(
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
                                onChanged: (Value)
                                {
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
                                onChanged: (Value)
                                {
                                  setState(()
                                  {
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
                            optionsBuilder: (TextEditingValue textEditingValue)
                            {
                              setState(()
                              {

                              });
                              return searchData_invoice(textEditingValue.text);
                            },
                            fieldViewBuilder: (context,controller,focusnode,onEditingComplete)
                            {
                                setState(()
                                {

                                });
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
                                      hintText: "Select Invoice",
                                      hintStyle:
                                      TextStyle(
                                          color: Colors.white24
                                      )
                                  ),
                                );
                            },
                            onSelected: (value)
                            {
                              // Servicecontroller.text=value.toString();
                              choose_invoice=value.toString();
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus)
                              {
                                currentFocus.unfocus();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ): SizedBox(),
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
            _onLoading();
            addPayment();
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

  void _onLoading()
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)
      {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children:
              [
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

  Future getClient_id(String client_name) async
  {
    client_list=await Client_service.getClient(context,widget.token);
    for(var cat in client_list)
    {
      if(choose_client.toString()==cat.name)
      {
        client_id=cat.id;
      }
    }
  }

  Future addPayment() async
  {
    client_list=await Client_service.getClient(context,widget.token);
    for(var cat in client_list)
    {
      if(choose_client.toString()==cat.name)
      {
        client_id=cat.id;
      }
    }

    var response=await Payment_service.addPayment(Receiptnocontroller.text,client_id,Paymentamountcontroller.text,
        Paymentdatecontroller.text,Remarkcontroller.text,choose_invoice,widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.pop(context);
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

  Future getInvoice_client(String client_id) async
  {
    invoice_client_list=await Payment_service.getInvoice_client(context,widget.token,client_id);
    for(var client in invoice_client_list)
    {
      invoice_client_drop_list.add(client.inv_no.toString()+"(due Amount: ₹"+client.total_due.toString()+")");
    }
    return invoice_client_drop_list;
  }

  List<String> searchData_invoice(String param)
  {
      List<String> result=invoice_client_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
      return result;
  }

}
