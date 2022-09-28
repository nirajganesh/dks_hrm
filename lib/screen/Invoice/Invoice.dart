import 'dart:io';
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Invoice/Invoice_item_model.dart';
import 'package:dks_hrm/model/Invoice/Invoice_last_model.dart';
import 'package:dks_hrm/model/Invoice/Invoice_model.dart';
import 'package:dks_hrm/model/Payment/Payment_last_modal.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/model/Settings/Settings_model.dart';
import 'package:dks_hrm/screen/Dashboard/Dashboard.dart';
import 'package:dks_hrm/screen/Invoice/Add/Add_invoice.dart';
import 'package:dks_hrm/screen/Invoice/Edit/Edit_invoice.dart';
import 'package:dks_hrm/screen/Invoice/Edit/Invoice_edit.dart';
import 'package:dks_hrm/screen/Payment/Add_payment.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Invoice_service.dart';
import 'package:dks_hrm/services/Payment_service.dart';
import 'package:dks_hrm/services/Settings_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';


class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  final TextEditingController Searchinvoicecontroller= TextEditingController();
  String? token;
  List<Invoice_model> invoice_list=[];
  List<Invoice_item_model> invoice_item_list=[];
  List<Invoice_model> container_list=[];
  List<String> client_drop_list=<String>[];
  List<String> service_drop_list=<String>[];
  List<Client_model> client_list=[];
  List<Service_model> service_list=[];
  bool empty_checker=false;
  List<Invoice_last_model> invoice_list_last=[];
  late String service_name_data;
  List<Settings_model> settings_list=[];
  List<Payment_last_modal> payment_last_list=[];
  bool theme=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadTheme();
    Loadtoken();
  }



  @override
  Widget build(BuildContext context) {
    bool issearching=Searchinvoicecontroller.text.isNotEmpty;
    return
      theme==true?
      RefreshIndicator(
        displacement: 250,
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: Scaffold(
        appBar:
        AppBar(
          title: Text("Invoice",style: TextStyle(color: Colors.white),),
          backgroundColor: Theme.of(context).primaryColor,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                Dashboard()), (Route<dynamic> route) => false),
          ),
          actions:<Widget> [
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: IconButton(
                icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
                onPressed: () {
                  getService();
                  getClient().then((client_drop_list){
                    getInvoice_last().then((value){
                      String inv_last_id=invoice_list_last[0].inv_no;
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_invoice(
                        token:token!,
                        client_drop_list:client_drop_list,
                        service_drop_list:service_drop_list,
                        inv_last_id:inv_last_id,
                        theme:theme,
                         )
                       ),
                      );
                    });
                  });
                },
              ),
            ),
          ],
        ),
        body:
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            color: HexColor("#F9FAFF"),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child:
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: HexColor("#f5f5f5"),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child:
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: TextField(
                                controller: Searchinvoicecontroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search by invoice no..',
                                    hintStyle: TextStyle(
                                        color: Colors.black38
                                    )
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap:(){
                              filter_invoicelist();
                            },
                            child: Container(
                              width:50,
                              height:50,
                              decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Theme.of(context).primaryColor,
                              ),
                              child:Icon(Icons.search,color:Colors.white,size: 20,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("LIST OF INVOICE",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchinvoicecontroller.text='';
                      issearching=false;
                      empty_checker=false;
                    });
                  },
                  child:
                  issearching==true?
                  Padding(
                    padding: const EdgeInsets.only(bottom:8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh,color: Theme.of(context).primaryColor),
                        SizedBox(width: 2,),
                        Text("Visit the invoice list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(child:
                FutureBuilder(
                  future: getInvoice(),
                  builder: (context,snapshot)
                  {
                    if(snapshot.connectionState==ConnectionState.waiting)
                    {
                      return Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 3),
                        child:Shimmer_widget.shimmer(),
                      );
                    }
                    else
                    {
                      if(empty_checker==true)
                      {
                        return Empty_widget.Empty();
                      }
                      else
                        {
                          if(invoice_list.length!=0)
                          {
                            return ListView.builder(
                                itemCount:issearching==true ? container_list.length:invoice_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(context,index)
                                {
                                  Invoice_model invoice_data=issearching==true?container_list[index]:invoice_list[index];
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xffe8e8e8),
                                              blurRadius: 5.0, // soften the shadow//extend the shadow
                                              offset: Offset(
                                                  0,5
                                              ),
                                            ),
                                          ],
                                        ),
                                        child:
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment:MainAxisAlignment.start,
                                                  children: [
                                                    Text(invoice_data.inv_no!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Text(invoice_data.client_name!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Text(invoice_data.remarks!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Total",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                        Text("₹"+invoice_data.total!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Paid",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                        Text("₹"+invoice_data.total_paid!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex:2,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(invoice_data.inv_date!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment:MainAxisAlignment.end,
                                                      children: [
                                                        Text("Due date",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                        Text(invoice_data!.due_date==''?"--":invoice_data.due_date!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment:MainAxisAlignment.end,
                                                      children: [
                                                        Text("Due Amount",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                        Text("₹"+invoice_data.total_due!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: (){
                                                            getClient().then((value){
                                                              getPayment_last().then((value){
                                                                String value_inv_no=payment_last_list[0].receipt_id!;
                                                                int idx = value_inv_no.indexOf("S");
                                                                int increase_value=int.parse(value_inv_no.substring(idx+1).trim())+1;
                                                                String receipt_new_id = "PDS"+increase_value.toString();

                                                                Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_payment(
                                                                  client_drop_list:client_drop_list,
                                                                  token:token!,
                                                                  receipt_id:receipt_new_id,
                                                                  client_name:invoice_data.client_name!,
                                                                  theme:theme,
                                                                )),);
                                                              });
                                                            });
                                                          },
                                                          child: Container(
                                                            width:33,
                                                            height:33,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xff64113f),
                                                            ),
                                                            child: Icon(Icons.monetization_on,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        GestureDetector(
                                                          onTap: (){
                                                            getService();
                                                            getClient().then((client_drop_list){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Invoice_edit(
                                                                id:invoice_data.id!,
                                                                token:token!,
                                                                client_drop_list:client_drop_list,
                                                                service_drop_list:service_drop_list,
                                                                invoice_no:invoice_data.inv_no!,
                                                                invoice_date:invoice_data.inv_date!,
                                                                due_date:invoice_data.due_date!,
                                                                remarks:invoice_data.remarks!,
                                                                total:invoice_data.total!,
                                                                sub_total: invoice_data.sub_total!,
                                                                paid:invoice_data.total_paid!,
                                                                due:invoice_data.total_due!,
                                                                client_name:invoice_data.client_name!,
                                                                client_id: invoice_data.client_id!,
                                                                theme:theme,
                                                                )
                                                               ),
                                                              );
                                                            });

                                                          },
                                                          child: Container(
                                                            width:33,
                                                            height:33,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xffFFA74D),
                                                            ),
                                                            child: Icon(Icons.edit,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        GestureDetector(
                                                          onTap: (){
                                                            // _createPDF(invoice_data.inv_no!);
                                                              getInvoice_item(invoice_data.id!, token!).then((invoice_item_data){
                                                                getSettings().then((setting_list_data){
                                                                  // generateInvoice(invoice_data.inv_no!,
                                                                  //    invoice_data.total!,invoice_data.total_due!,invoice_data.total_paid!,
                                                                  //    invoice_data.client_name!,invoice_data.client_contact!,invoice_data.client_email!,
                                                                  //     invoice_data.due_date!,invoice_data.inv_date!
                                                                  // );
                                                                  _launchURL(invoice_data.id!,invoice_data.client_id!);
                                                               });
                                                             });
                                                          },
                                                          child: Container(
                                                            width:33,
                                                            height:33,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xffE71157),
                                                            ),
                                                            child: Icon(Icons.remove_red_eye,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        GestureDetector(
                                                          onTap: (){
                                                            launch('mailto:'+invoice_data.client_email.toString()+'?subject=This is subject');
                                                          },
                                                          child: Container(
                                                            width:33,
                                                            height:33,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xff26DAD2),
                                                            ),
                                                            child: Icon(Icons.email,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        GestureDetector(
                                                          onTap: (){
                                                            Delete_dailog(invoice_data.id!);
                                                          },
                                                          child: Container(
                                                            width:33,
                                                            height:33,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xffE71157),
                                                            ),
                                                            child: Icon(Icons.delete,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                      ],
                                                    )

                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 8,),
                                            ],
                                          ),
                                        ),

                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  );
                                }
                            );
                          }
                          else
                          {
                            return Empty_widget.Empty();
                          }
                        }
                    }
                  },
                ),),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
    ),
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            Searchinvoicecontroller.text='';
          });
        },
      ):
      RefreshIndicator(
        displacement: 250,
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: Scaffold(
          appBar:
          AppBar(
            title: Text("Invoice",style: TextStyle(color: Colors.white),),
            backgroundColor: HexColor(Colors_theme.dark_app_color),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color:Colors.white),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                  Dashboard()), (Route<dynamic> route) => false),
            ),
            actions:<Widget> [
              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: IconButton(
                  icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
                  onPressed: () {
                    getService();
                    getClient().then((client_drop_list){
                      getInvoice_last().then((value){
                        String inv_last_id=invoice_list_last[0].inv_no;
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_invoice(
                          token:token!,
                          client_drop_list:client_drop_list,
                          service_drop_list:service_drop_list,
                          inv_last_id:inv_last_id,
                          theme:theme,
                        )
                        ),
                        );
                      });
                    });
                  },
                ),
              ),
            ],
          ),
          backgroundColor: HexColor(Colors_theme.dark_background),
          body:
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              color: HexColor(Colors_theme.dark_background),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child:
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: HexColor(Colors_theme.dark_app_color),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child:
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: TextField(
                                  controller: Searchinvoicecontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search by invoice no..',
                                      hintStyle: TextStyle(
                                          color: Colors.white24
                                      )
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap:(){
                                filter_invoicelist();
                              },
                              child: Container(
                                width:50,
                                height:50,
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child:Icon(Icons.search,color:Colors.white,size: 20,),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("LIST OF INVOICE",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchinvoicecontroller.text='';
                        issearching=false;
                        empty_checker=false;
                      });
                    },
                    child:
                    issearching==true?
                    Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh,color: Theme.of(context).primaryColor),
                          SizedBox(width: 2,),
                          Text("Visit the invoice list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  Flexible(child:
                  FutureBuilder(
                    future: getInvoice(),
                    builder: (context,snapshot)
                    {
                      if(snapshot.connectionState==ConnectionState.waiting)
                      {
                        return Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 3),
                          child:Shimmer_widget.shimmer(),
                        );
                      }
                      else
                      {
                        if(empty_checker==true)
                        {
                          return Empty_widget.Empty_dark();
                        }
                        else
                        {
                          if(invoice_list.length!=0)
                          {
                            return ListView.builder(
                                itemCount:issearching==true ? container_list.length:invoice_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(context,index)
                                {
                                  Invoice_model invoice_data=issearching==true?container_list[index]:invoice_list[index];
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: HexColor(Colors_theme.dark_app_color),
                                        ),
                                        child:
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment:MainAxisAlignment.start,
                                                  children: [
                                                    Text(invoice_data.inv_no!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Text(invoice_data.client_name!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Text(invoice_data.remarks!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Total",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                        Text("₹"+invoice_data.total!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Paid",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                        Text("₹"+invoice_data.total_paid!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex:2,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(invoice_data.inv_date!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment:MainAxisAlignment.end,
                                                      children: [
                                                        Text("Due date",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                        Text(invoice_data!.due_date==''?"--":invoice_data.due_date!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment:MainAxisAlignment.end,
                                                      children: [
                                                        Text("Due Amount",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                        Text("₹"+invoice_data.total_due!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: (){
                                                            getClient().then((value){
                                                              getPayment_last().then((value){
                                                                String value_inv_no=payment_last_list[0].receipt_id!;
                                                                int idx = value_inv_no.indexOf("S");
                                                                int increase_value=int.parse(value_inv_no.substring(idx+1).trim())+1;
                                                                String receipt_new_id = "PDS"+increase_value.toString();

                                                                Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_payment(
                                                                  client_drop_list:client_drop_list,
                                                                  token:token!,
                                                                  receipt_id:receipt_new_id,
                                                                  client_name:invoice_data.client_name!,
                                                                  theme:theme,
                                                                )),);
                                                              });
                                                            });
                                                          },
                                                          child: Container(
                                                            width:33,
                                                            height:33,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xff64113f),
                                                            ),
                                                            child: Icon(Icons.monetization_on,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        GestureDetector(
                                                          onTap: (){
                                                            getService();
                                                            getClient().then((client_drop_list){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Invoice_edit(
                                                                id:invoice_data.id!,
                                                                token:token!,
                                                                client_drop_list:client_drop_list,
                                                                service_drop_list:service_drop_list,
                                                                invoice_no:invoice_data.inv_no!,
                                                                invoice_date:invoice_data.inv_date!,
                                                                due_date:invoice_data.due_date!,
                                                                remarks:invoice_data.remarks!,
                                                                total:invoice_data.total!,
                                                                sub_total: invoice_data.sub_total!,
                                                                paid:invoice_data.total_paid!,
                                                                due:invoice_data.total_due!,
                                                                client_name:invoice_data.client_name!,
                                                                client_id: invoice_data.client_id!,
                                                                theme:theme,
                                                              )
                                                              ),
                                                              );
                                                            });

                                                          },
                                                          child: Container(
                                                            width:33,
                                                            height:33,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xffFFA74D),
                                                            ),
                                                            child: Icon(Icons.edit,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        GestureDetector(
                                                          onTap: (){
                                                            getInvoice_item(invoice_data.id!, token!).then((invoice_item_data){
                                                              getSettings().then((setting_list_data){
                                                                _launchURL(invoice_data.id!,invoice_data.client_id!);
                                                              });
                                                            });
                                                          },
                                                          child: Container(
                                                            width:33,
                                                            height:33,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xffE71157),
                                                            ),
                                                            child: Icon(Icons.remove_red_eye,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        GestureDetector(
                                                          onTap: (){
                                                            launch('mailto:'+invoice_data.client_email.toString()+'?subject=This is subject');
                                                          },
                                                          child: Container(
                                                            width:33,
                                                            height:33,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xff26DAD2),
                                                            ),
                                                            child: Icon(Icons.email,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        GestureDetector(
                                                          onTap: (){
                                                            Delete_dailog_dark(invoice_data.id!);
                                                          },
                                                          child: Container(
                                                            width:33,
                                                            height:33,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xffE71157),
                                                            ),
                                                            child: Icon(Icons.delete,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 8,),
                                            ],
                                          ),
                                        ),

                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  );
                                }
                            );
                          }
                          else
                          {
                            return Empty_widget.Empty_dark();
                          }
                        }
                      }
                    },
                  ),),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            Searchinvoicecontroller.text='';
          });
        },
      );
  }

  Future getPayment_last() async
  {
    payment_last_list=await Payment_service.getPayment_last(context,token!);
  }

  Loadtoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
    });
  }

  LoadTheme() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      theme = (prefs.getBool('theme') ?? false);
    });
  }

  Future getInvoice() async
  {
    invoice_list=await Invoice_service.getInvoice(context,token!);
  }

  void Delete_dailog(String id)
  {
    showDialog(
        context: context,
        builder:(ctx)=>AlertDialog(
          title: Center(
            child: Text(
              "Alert for Delete",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(left:12.0,right:12.0),
            child: Text(
              "Do yow want to delete the Invoice in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
            ),
          ),

          actions: <Widget>[
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color:Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Text("Cancel"),
                ),
                SizedBox(width:6),
                FlatButton(
                  onPressed: ()
                  {
                    deleteInvoice(ctx,id);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: HexColor("#F30808"),
                  child: Text("Delete",style:(TextStyle(color: Colors.white)),),
                ),
              ],
            )
          ],
        )
    );
  }

  void Delete_dailog_dark(String id)
  {
    showDialog(
        context: context,
        builder:(ctx)=>AlertDialog(
          backgroundColor: HexColor(Colors_theme.dark_app_color),
          title: Center(
            child: Text(
              "Alert for Delete",style: (TextStyle(color: Colors.white,fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(left:12.0,right:12.0),
            child: Text(
              "Do yow want to delete the invoice in list?",textAlign: TextAlign.center,style: (TextStyle(color: Colors.white,fontSize: 16,fontFamily:'Montserrat_regular')),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color:Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Text("Cancel",style:(TextStyle(color: Colors.white))),
                ),
                SizedBox(width:6),
                FlatButton(
                  onPressed: () {
                    deleteInvoice(ctx,id);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: HexColor("#F30808"),
                  child: Text("Delete",style:(TextStyle(color: Colors.white)),),
                ),
              ],
            )
          ],
        )
    );
  }


  filter_invoicelist()
  {
    List<Invoice_model> _details=[];
    _details.addAll(invoice_list);
    if(Searchinvoicecontroller.text.isNotEmpty)
    {
      _details.retainWhere((quotation_list){
        String searchterm=Searchinvoicecontroller.text.toLowerCase();
        String inv_no=quotation_list.inv_no!.toLowerCase();
        return inv_no.contains(searchterm);
      });
      setState(() {
        container_list.clear();
        container_list=_details;
        if(container_list.length==0)
        {
          empty_checker=true;
        }
      });
    }
    else
    {
      setState(() {
        _details.addAll(invoice_list);
      });
    }
  }

  Future deleteInvoice(BuildContext ctx,String id) async
  {
    var response=await Invoice_service.deleteInvoice(id,token!);
    if(response['status']==200)
    {
      Navigator.of(ctx).pop();
      Notify_widget.notify(response['message']);
      setState(() {});
    }
    else
    {
      Navigator.of(ctx).pop();
      Notify_widget.notify(response['message']);
    }
  }

  Future<List<String>> getClient() async
  {
    client_drop_list.clear();
    client_list=await Client_service.getClient(context,token!);
    for(var data in client_list)
    {
      client_drop_list.add(data.name.toString());
    }
    return client_drop_list;
  }

  Future<List<String>> getService() async
  {
    service_drop_list.clear();
    service_list=await service.getService(context,token!);
    for(var data in service_list)
    {
      service_drop_list.add(data.name.toString());
    }
    return service_drop_list;
  }

  Future getInvoice_last() async
  {
    invoice_list_last=await Invoice_service.getInvoice_last(token!);
  }



  generateInvoice(
      String inv_no,String total,String total_due,String total_paid,
      String client_name,String client_contact,String client_email,
      String due_date,String invoice_date) async
   {
  //  Create a new PDF document.
    final ByteData bytes = await rootBundle.load('images/digikraft.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final pdf = pw.Document();


// Add a new page to the document.
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
             crossAxisAlignment: pw.CrossAxisAlignment.start,
             children: [
               pw.Image(
                   pw.MemoryImage(
                     byteList,
                   ),
                   height: 50),
               pw.SizedBox(height: 5),
               pw.Container(
                 child: pw.Padding(
                   padding: pw.EdgeInsets.all(1.0),
                   child:pw.Row(
                     children: [
                       pw.Expanded(
                         flex:3,
                         child:pw.Column(
                             crossAxisAlignment: pw.CrossAxisAlignment.start,
                             children: [
                               pw.Text("Invoice no.",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 20),),
                               pw.SizedBox(height: 10),
                               pw.Text("#"+inv_no,style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               pw.SizedBox(height: 10),
                               pw.Container(
                                 decoration:pw.BoxDecoration(
                                     border: pw.Border.all(color:PdfColor.fromHex("#006400"),width: 1.0),
                                     borderRadius: pw.BorderRadius.circular(3),
                                 ),
                                 child: pw.Padding(
                                   padding: pw.EdgeInsets.all(4),
                                   child:pw.Text("PAID",style: pw.TextStyle(color:PdfColor.fromHex("#006400"),fontSize: 14),),
                                 ),

                               )
                             ]
                         ),
                       ),
                       pw.SizedBox(width: 10),
                       pw.Expanded(
                         flex:2,
                         child:pw.Column(
                             crossAxisAlignment: pw.CrossAxisAlignment.start,
                             children: [
                               pw.Text("Billed by:",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 18),),
                               pw.SizedBox(height: 5),
                               pw.Text("DIGIKRAFT SOCIAL",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               pw.SizedBox(height: 5),
                               pw.Text("H.O., Shivneri Complex, Beside Lalganga Business",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               pw.SizedBox(height: 5),
                               pw.Text("Park, Dhamtari Rd. Pachpedi Naka Raipur (C.G.)",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               pw.SizedBox(height: 5),
                               pw.Text("+91-9302279701",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               pw.SizedBox(height: 5),
                               pw.Text("digikraftsocial@gmail.com",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),)
                             ]
                         ),
                       ),
                     ],
                   )
                 ),
               ),

               pw.SizedBox(height: 20),
               pw.Container(
                 child: pw.Padding(
                     padding: pw.EdgeInsets.all(1.0),
                     child:pw.Row(
                       children: [
                         pw.Expanded(
                             flex:3,
                             child: pw.Column(
                                 crossAxisAlignment: pw.CrossAxisAlignment.start,
                                 mainAxisAlignment: pw.MainAxisAlignment.start,
                                 children: [
                                   pw.Text("Billed to:",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 20),),
                                   pw.SizedBox(height: 5),
                                   pw.Text(client_name,style:pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                   pw.SizedBox(height: 5),
                                   pw.Row(
                                     children: [
                                       pw.Text("Contact: ",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                       pw.SizedBox(width: 5),
                                       pw.Text(client_contact,style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                     ],
                                   ),
                                   pw.Row(
                                     children: [
                                       pw.Text("E-mail:",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                       pw.SizedBox(width: 5),
                                       pw.Text(client_email,style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                     ],
                                   ),
                                 ]
                             ),
                         ),
                         pw.SizedBox(width: 10),
                         pw.Expanded(
                           flex:2,
                           child: pw.Column(
                               crossAxisAlignment: pw.CrossAxisAlignment.start,
                               children: [
                                 pw.Text("Invoice Details:",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 20),),
                                 pw.SizedBox(height: 5),
                                 pw.Row(
                                   children: [
                                     pw.Text("Invoice date:",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                     pw.SizedBox(width: 5),
                                     pw.Text(invoice_date,style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                   ],
                                 ),

                                 pw.Row(
                                   children: [
                                     pw.Text("Amount Paid:",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                     pw.SizedBox(width: 5),
                                     pw.Text("Rs."+total_paid,style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                   ],
                                 ),

                                 pw.Row(
                                   children: [
                                     pw.Text("Amount Due:",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                     pw.SizedBox(width: 5),
                                     pw.Text("Rs."+total_due,style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                   ],
                                 ),

                                 pw.Row(
                                   children: [
                                     pw.Text("Due date:",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                     pw.SizedBox(width: 5),
                                     pw.Text(due_date,style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                   ],
                                 ),
                               ]
                           ),
                         ),
                       ],
                     )
                 ),
               ),


               pw.SizedBox(height: 25),
               pw.Container(
                 child: pw.Padding(
                     padding: pw.EdgeInsets.all(1.0),
                     child:pw.Column(
                       children: [
                         pw.SizedBox(height: 10),
                         pw.Divider(height: 1,color: PdfColor.fromHex("#696969"),thickness: 1),
                         pw.Row(
                               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                               children: [
                                 pw.Text("S.No.",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                 pw.SizedBox(width: 10),
                                 pw.Text("Service",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                 pw.SizedBox(width: 10),
                                 pw.Text("Price X Qty",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                 pw.SizedBox(width: 10),
                                 pw.Text("Subtotal",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                               ]
                           ),
                         pw.SizedBox(height: 5),
                         pw.Divider(height: 1,color: PdfColor.fromHex("#696969"),thickness: 1),
                         pw.Row(
                             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                             children: [
                               pw.Text("1",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               pw.SizedBox(width: 10),
                               pw.Text("Graphic design",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               pw.SizedBox(width: 10),
                               pw.Text("300 X 2",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                             //  pw.Text(invoice_i[0].price+" X "+invoice_item_list[0].qty,style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               pw.SizedBox(width: 10),
                               pw.Text("Rs. 600",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                            //   pw.Text("Rs."+(int.parse(invoice_item_list[0].price)*int.parse(invoice_item_list[0].qty)).toString(),style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                             ]
                         ),
                         pw.SizedBox(height: 2),
                         pw.Divider(height: 1,color: PdfColor.fromHex("#696969"),thickness: 0.5),
                         pw.Row(
                             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                             children: [
                               pw.Text("2",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               pw.SizedBox(width: 10),
                               pw.Text("Marketing design",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               pw.SizedBox(width: 10),
                               pw.Text("300 X 2",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               pw.SizedBox(width: 10),
                               pw.Text("Rs. 600",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                             ]
                         ),
                         pw.SizedBox(height: 2),
                         pw.Divider(height: 1,color: PdfColor.fromHex("#696969"),thickness: 0.5),
                         pw.SizedBox(height: 10),
                       ],
                     )
                 ),
               ),
               pw.SizedBox(height: 20),
               pw.Container(
                 child: pw.Padding(
                     padding: pw.EdgeInsets.all(1.0),
                     child:pw.Row(
                       children: [
                         pw.Expanded(
                           flex:3,
                           child:
                           pw.Row(
                               mainAxisAlignment: pw.MainAxisAlignment.start,
                               children: [
                                 pw.Column(
                                   crossAxisAlignment: pw.CrossAxisAlignment.start,
                                   children: [
                                     pw.SizedBox(height: 15),
                                     pw.Text("Bank Details:",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 20),),
                                     pw.SizedBox(height: 5),
                                     pw.Row(
                                       children: [
                                         pw.Text("Bank: ",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                         pw.SizedBox(width: 5),
                                         pw.Text(settings_list[0]!.bank_name??"",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                       ],
                                     ),

                                     pw.Row(
                                       children: [
                                         pw.Text("Account Name: ",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                         pw.SizedBox(width: 5),
                                         pw.Text(settings_list[0]!.account_name??"",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                       ],
                                     ),

                                     pw.Row(
                                       children: [
                                         pw.Text("Account no: ",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                         pw.SizedBox(width: 5),
                                         pw.Text(settings_list[0]!.account_number??"",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                       ],
                                     ),

                                     pw.Row(
                                       children: [
                                         pw.Text("IFSC: ",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                         pw.SizedBox(width: 5),
                                         pw.Text(settings_list[0]!.ifsc??"",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                       ],
                                     ),

                                     pw.Row(
                                       children: [
                                         pw.Text("UPI ID: ",style: pw.TextStyle(color:PdfColor.fromHex("#696969"),fontSize: 14),),
                                         pw.SizedBox(width: 5),
                                         pw.Text(settings_list[0]!.upi_id??"",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                       ],
                                     ),
                                     pw.SizedBox(height: 20),
                                     pw.Text("Thank you for your business",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                   ],
                                 ),
                               ]
                           ),
                         ),
                         pw.Expanded(
                           flex:2,
                           child: pw.Column(
                               crossAxisAlignment: pw.CrossAxisAlignment.start,
                               children: [
                                 pw.Text("T&C-",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                 pw.SizedBox(height: 5),
                                 pw.Text("- Please pay within 10 days upon receipt of the invoice.",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                 pw.SizedBox(width: 5),
                                 pw.Text("Additional Notes",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                                 pw.SizedBox(width: 5),
                                 pw.Text("- Please quote invoice no. when remitting funds.",style: pw.TextStyle(color:PdfColor.fromHex("#000"),fontSize: 14),),
                               ]
                           ),
                         ),
                       ],
                     )
                 ),
               ),
             ],
          ); // Center
        })); // Page

    Directory directory = (await getApplicationDocumentsDirectory());
    String path = directory.path;
    File file = File('$path/$inv_no.pdf');
    file.writeAsBytes(List.from(await pdf.save()));
    OpenFile.open('$path/$inv_no.pdf');
  }

  Future getSettings() async
  {
    settings_list=await Settings_service.getSettings(context,token!);
  }

  Future getInvoice_item(String inv_id,String token) async
  {
    invoice_item_list=await Invoice_service.getInvoice_item(context,inv_id,token);
  }

  void _launchURL(String inv_id,String client_id) async {
    String url=Api_constants.invoice_view+inv_id+"/"+client_id;
    if (!await launch(url)) throw 'Could not launch $url';
  }
}



