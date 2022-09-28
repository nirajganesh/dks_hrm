import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_service_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Invoice/Add/Invoice_list.dart';
import 'package:dks_hrm/screen/Invoice/Add_%20multiForm_invoice.dart';
import 'package:dks_hrm/services/Quotation_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Add_invoice extends StatefulWidget {

  String token;
  List<String> client_drop_list=[];
  List<String> service_drop_list=[];
  String inv_last_id;
  bool theme;

  Add_invoice({
    required this.client_drop_list,
    required this.service_drop_list,
    required this.token,
    required this.inv_last_id,
    required this.theme,
    Key? key}) : super(key: key);


  @override
  _Add_invoiceState createState() => _Add_invoiceState();
}

class _Add_invoiceState extends State<Add_invoice> {

  final TextEditingController Duedatecontroller= TextEditingController();
  final TextEditingController Invoicedatecontroller= TextEditingController();
  final TextEditingController Clientcontroller= TextEditingController();
  final TextEditingController Remarkcontroller= TextEditingController();
  final TextEditingController Invoicenocontroller= TextEditingController();
  final TextEditingController Descriptioncontroller= TextEditingController();
  final TextEditingController Pricecontroller= TextEditingController();
  final TextEditingController Qtycontroller= TextEditingController();
  List<Quotation_service_model> quotation_service_list=[];
  final TextEditingController Grandtotalcontroller= TextEditingController();
  final TextEditingController Duetotalcontroller= TextEditingController();
  final TextEditingController Paidtotalcontroller= TextEditingController();

  String? choose_client;
  late String client_id;
  List<Client_model> client_list=[];
  late String choose_service;
  late String service_id;
  List<Service_model> service_list=[];
  DateTime dateTime_inv=DateTime.now();
  DateTime dateTime_due=DateTime.now();
  String invoice_Date='(Invoice date)';
  String due_Date='(Due date)';
  late String inv_last_id;
  late String value_inv_no;
  bool valuefirst = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    choose_service=widget.service_drop_list.first;

    value_inv_no=widget.inv_last_id;
    int idx = value_inv_no.indexOf("S");
    int increase_value=int.parse(value_inv_no.substring(idx+1).trim())+1;
    inv_last_id = "DS"+increase_value.toString();

    Invoicedatecontroller.text=dateTime_inv.day.toString()+"-"+dateTime_inv.month.toString()+"-"+dateTime_inv.year.toString();
    Duedatecontroller.text=dateTime_due.day.toString()+"-"+dateTime_due.month.toString()+"-"+dateTime_due.year.toString();

    getInvoice_service().then((value){
      Descriptioncontroller.text=quotation_service_list[0].short_descr;
      Pricecontroller.text=quotation_service_list[0].price;
      Qtycontroller.text="1";
      setState(() {
        Duetotalcontroller.text= Pricecontroller.text;
        Grandtotalcontroller.text=Pricecontroller.text;
        Paidtotalcontroller.text="0";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Add Invoice",style: TextStyle(color: Colors.white),),
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
                          child:Text(inv_last_id,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                        setState(() {
                          dateTime_inv=date!;
                          Invoicedatecontroller.text=dateTime_inv.day.toString()+"-"+dateTime_inv.month.toString()+"-"+dateTime_inv.year.toString();
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
                                  Invoicedatecontroller.text+invoice_Date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
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
                    onTap: ()
                    {
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                        setState(() {
                          dateTime_due=date!;
                          Duedatecontroller.text=dateTime_due.day.toString()+"-"+dateTime_due.month.toString()+"-"+dateTime_due.year.toString();
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
                                  Duedatecontroller.text+due_Date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
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
                  SizedBox(height: 60,),
                  GestureDetector(
                    onTap: (){
                      if(choose_client==null)
                      {
                        Notify_widget.notify("Please select the client");
                      }
                      else
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Invoice_list(
                          client_drop_list: widget.client_drop_list,
                          service_drop_list: widget.service_drop_list,
                          inv_date: Invoicedatecontroller.text,
                          invoice_no: inv_last_id,
                          due_date: Duedatecontroller.text,
                          choose_client:choose_client!,
                          remarks:Remarkcontroller.text,
                          theme:widget.theme,
                        )),);
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
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
                   SizedBox(height: 20,),
                ],
              ),
          ),
        ),
      ),
    ):
      Scaffold(
        appBar: AppBar(
          title: Text("Add Invoice",style: TextStyle(color: Colors.white),),
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
                                    color:Colors.white24,
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
                          child: Icon(Icons.inventory,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Container(
                          child:Text(inv_last_id,style: (TextStyle(color: Colors.white,fontSize: 14)),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                        setState(() {
                          dateTime_inv=date!;
                          Invoicedatecontroller.text=dateTime_inv.day.toString()+"-"+dateTime_inv.month.toString()+"-"+dateTime_inv.year.toString();
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
                                  Invoicedatecontroller.text+invoice_Date,style: (TextStyle(color: Colors.white,fontSize: 14)),
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
                    onTap: ()
                    {
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                        setState(() {
                          dateTime_due=date!;
                          Duedatecontroller.text=dateTime_due.day.toString()+"-"+dateTime_due.month.toString()+"-"+dateTime_due.year.toString();
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
                                  Duedatecontroller.text+due_Date,style: (TextStyle(color: Colors.white,fontSize: 14)),
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
                  SizedBox(height: 60,),
                  GestureDetector(
                    onTap: (){
                      if(choose_client==null)
                      {
                        Notify_widget.notify("Please select the client");
                      }
                      else
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Invoice_list(
                          client_drop_list: widget.client_drop_list,
                          service_drop_list: widget.service_drop_list,
                          inv_date: Invoicedatecontroller.text,
                          invoice_no: inv_last_id,
                          due_date: Duedatecontroller.text,
                          choose_client:choose_client!,
                          remarks:Remarkcontroller.text,
                          theme:widget.theme,
                        )),);
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
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
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      );
  }

  List<String> searchData(String param)
  {
    List<String> result=widget.client_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }

  Future getInvoice_service() async
  {
    service_list=await service.getService(context,widget.token);
    for(var ser in service_list)
    {
      if(choose_service.toString()==ser.name)
      {
        service_id=ser.id!;
      }
    }
    quotation_service_list=await Quotation_service.getQuotation_item_service(context,service_id,widget.token);
  }


}
