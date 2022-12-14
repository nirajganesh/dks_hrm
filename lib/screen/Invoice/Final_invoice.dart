import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Invoice/Invoice_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Dashboard/Dashboard.dart';
import 'package:dks_hrm/screen/Invoice/Final_Edit/Edit_final_invoice.dart';
import 'package:dks_hrm/screen/Invoice/Final_Edit/Final_invoice_edit.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Invoice_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
class Final_invoice extends StatefulWidget {

  const Final_invoice({Key? key}) : super(key: key);

  @override
  _Final_invoiceState createState() => _Final_invoiceState();
}

class _Final_invoiceState extends State<Final_invoice> {

  final TextEditingController Searchinvoicecontroller= TextEditingController();
  String? token;
  List<Invoice_model> invoice_list=[];
  List<Invoice_model> container_list=[];
  List<String> client_drop_list=<String>[];
  List<String> service_drop_list=<String>[];
  List<Client_model> client_list=[];
  List<Service_model> service_list=[];
  bool empty_checker=false;
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
            title: Text("Final Invoice",style: TextStyle(color: Colors.white),),
            backgroundColor: Theme.of(context).primaryColor,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color:Colors.white),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                  Dashboard()), (Route<dynamic> route) => false),
            ),
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
                          color: HexColor("f5f5f5"),
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
                                      hintText: 'Search Invoice..',
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
                    children:
                    [
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
                                                        Text("???"+invoice_data.total!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Paid",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                        Text("???"+invoice_data.total_paid!,style: TextStyle(color: Colors.black,fontSize: 14),),
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
                                                        Text("???"+invoice_data.total_due!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: (){
                                                            getService();
                                                            getClient().then((client_drop_list){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Final_invoice_edit(
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
                                                            width:40,
                                                            height:40,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xffFFA74D),
                                                            ),
                                                            child: Icon(Icons.edit,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        GestureDetector(
                                                          onTap: () async{
                                                            _launchURL(invoice_data.id!,invoice_data.client_id!);
                                                          },
                                                          child: Container(
                                                            width:40,
                                                            height:40,
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
                                                            launch('mailto:nirajganesh234@gmail.com?subject=This is subject');
                                                          },
                                                          child: Container(
                                                            width:40,
                                                            height:40,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xff26DAD2),
                                                            ),
                                                            child: Icon(Icons.email,size: 20,color: Colors.white,),
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
                    ),
                  ),
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
            title: Text("Final Invoice",style: TextStyle(color: Colors.white),),
            backgroundColor: HexColor(Colors_theme.dark_app_color),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color:Colors.white),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                  Dashboard()), (Route<dynamic> route) => false),
            ),
          ),
          backgroundColor:  HexColor(Colors_theme.dark_background),
          body:
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              color:  HexColor(Colors_theme.dark_background),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child:
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color:  HexColor(Colors_theme.dark_app_color),
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
                                      hintText: 'Search Invoice..',
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
                    children:
                    [
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
                                          color:  HexColor(Colors_theme.dark_app_color),
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
                                                        Text("???"+invoice_data.total!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Paid",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                        Text("???"+invoice_data.total_paid!,style: TextStyle(color: Colors.white,fontSize: 14),),
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
                                                        Text("???"+invoice_data.total_due!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: (){
                                                            getService();
                                                            getClient().then((client_drop_list){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Final_invoice_edit(
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
                                                            width:40,
                                                            height:40,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xffFFA74D),
                                                            ),
                                                            child: Icon(Icons.edit,size: 20,color: Colors.white,),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        GestureDetector(
                                                          onTap: () async{
                                                            _launchURL(invoice_data.id!,invoice_data.client_id!);
                                                          },
                                                          child: Container(
                                                            width:40,
                                                            height:40,
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
                                                            launch('mailto:nirajganesh234@gmail.com?subject=This is subject');
                                                          },
                                                          child: Container(
                                                            width:40,
                                                            height:40,
                                                            decoration:BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              color: Color(0xff26DAD2),
                                                            ),
                                                            child: Icon(Icons.email,size: 20,color: Colors.white,),
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
    invoice_list=await Invoice_service.getInvoice_final(token!);
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

  void _launchURL(String inv_id,String client_id) async {
    String url=Api_constants.invoice_view+inv_id+"/"+client_id;
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
