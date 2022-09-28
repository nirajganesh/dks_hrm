import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Invoice/Invoice_last_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/model/Service_checker.dart';
import 'package:dks_hrm/model/Summary/Service_summary_model.dart';
import 'package:dks_hrm/screen/Summary/Add_summary.dart';
import 'package:dks_hrm/screen/Summary/Checker/Service_add_invoice.dart';
import 'package:dks_hrm/screen/Summary/Checker/Service_summary_list.dart';
import 'package:dks_hrm/screen/Summary/Summary.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Invoice_service.dart';
import 'package:dks_hrm/services/Summary_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';


class Service_summary extends StatefulWidget {
  String token;
  String client_id;
  Service_summary({required this.token,required this.client_id,Key? key}) : super(key: key);

  @override
  _Service_summaryState createState() => _Service_summaryState();
}

class _Service_summaryState extends State<Service_summary> {

  final TextEditingController Searchsummarycontroller= TextEditingController();
  List<Service_summary_model> service_summary_list=[];
  List<Service_summary_model> container_list=[];
  String token='';
  bool empty_checker=false;
  List<String> service_drop_list=[];
  List<Service_model> service_list=[];
  bool bill_service=false;
  List<String> client_drop_list=<String>[];
  List<Invoice_last_model> invoice_list_last=[];
  List<Client_model> client_list=[];
  late String service_name;
  late bool value=false;
  List<Service_checker> service_id_checker=[];
  String data_check="false";
  final List summary_list=[];
  List<Service_summary_list> contactForms = List.empty(growable: true);
  final ScrollController scrollController=ScrollController();
  bool checker_select=false;
  bool theme=false;


  @override
  void initState() {
    super.initState();
    LoadTheme();
    Loadtoken();
  }

  @override
  Widget build(BuildContext context) {
    bool issearching=Searchsummarycontroller.text.isNotEmpty;
    return 
      theme==true?
      RefreshIndicator(
      displacement: 250,
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Scaffold(
        appBar:  AppBar(
          title: Text("Service Summary",style: TextStyle(color: Colors.white),),
          backgroundColor: Theme.of(context).primaryColor,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () =>  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                Summary()), (Route<dynamic> route) => false),
          ),
          actions:<Widget> [
            bill_service==false?
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child: IconButton(
                icon: const Icon(Icons.print,color: Colors.white,size: 26,),
                onPressed: () {
                  checker_select=false;
                  List array_list=[];
                  for (int i = 0; i < contactForms.length; i++) {
                    Service_summary_list item = contactForms[i];
                    if(item.service_summary_model.isSelected==true)
                      {
                        checker_select=true;
                        var map = Map();
                        map['item_id']=item.service_summary_model.item_id!;
                        map['descr']=item.service_summary_model.descr!;
                        map['price']=item.service_summary_model.price!;
                        map['qty']=item.service_summary_model.qty;
                        array_list.add(map);
                      }
                  }
                  if(checker_select==true)
                    {
                      getService_data();
                      getClient().then((client_drop_list){
                        getInvoice_last().then((value){
                          String inv_last_id=invoice_list_last[0].inv_no;
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>Service_add_invoice(
                            token:token!,
                            client_drop_list:client_drop_list,
                            service_drop_list:service_drop_list,
                            inv_last_id:inv_last_id,
                            list_data:array_list,
                            )
                           ),
                          );
                        });
                      });
                    }
                  else
                    {
                      Notify_widget.notify("Please select at least one service");
                    }
                },
              ),
            ):SizedBox(),
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: IconButton(
                icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
                onPressed: () {
                  getService("1").then((service_drop_list){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_summary(
                      service_drop_list:service_drop_list,
                      token:token,
                      client_id:widget.client_id,
                      theme:theme,
                      )
                     ),
                    );
                   }
                  );
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
                        color: HexColor("f5f5f5"),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child:
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child:
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: TextField(
                                controller: Searchsummarycontroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search by service name..',
                                    hintStyle: TextStyle(
                                        color: Colors.black38
                                    )
                                ),
                              ),
                            ),
                          ),
                          TouchRippleEffect(
                            borderRadius: BorderRadius.circular(5),
                            rippleColor: Colors.white60,
                            onTap:(){
                              filter_summarylist();
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
                    Text("LIST OF SUMMARY",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                    bill_service==false?
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          bill_service=true;
                          contactForms.clear();
                          getService_Summary().then((value){
                            for(var data in service_summary_list)
                            {
                              onAddform(data.id!, data.client_id!, data.item_id!, data.descr!,data.qty!,data.price!,data.is_billed!,data.date!,data.item_name!,data.isSelected!);
                            }
                          });
                        });
                      },
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color:Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Text("SEE BILLED SERVICE",style: TextStyle(color: Colors.green,fontSize: 12,fontWeight: FontWeight.bold),),
                            ],
                          )
                    ):
                    GestureDetector(
                        onTap: (){
                          setState(() {
                            bill_service=false;
                            contactForms.clear();
                            getService_Summary().then((value){
                              for(var data in service_summary_list)
                              {
                                onAddform(data.id!, data.client_id!, data.item_id!, data.descr!,data.qty!,data.price!,data.is_billed!,data.date!,data.item_name!,data.isSelected!);
                              }
                            });
                          });

                        },
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color:Color(0xffFFA74D),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text("SEE UNBILLED SERVICE",style: TextStyle(color: Color(0xffFFA74D),fontSize: 12,fontWeight: FontWeight.bold),),
                          ],
                        )
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchsummarycontroller.text='';
                      issearching=false;
                      empty_checker=false;

                      contactForms.clear;
                      getService_Summary().then((value){
                        for(var data in service_summary_list)
                        {
                          onAddform(data.id!, data.client_id!, data.item_id!, data.descr!,data.qty!,data.price!,data.is_billed!,data.date!,data.item_name!,data.isSelected!);
                        }
                      });
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
                        Text("Visit the service-summary list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(
                  child:
                  Scrollbar(
                    isAlwaysShown: true,
                    controller: scrollController,
                    scrollbarOrientation: ScrollbarOrientation.bottom,
                    child:
                    contactForms.length==0?
                        issearching==false?
                        SizedBox():Empty_widget.Empty():
                        dynamiclist(),
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          Searchsummarycontroller.text='';
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
          appBar:  AppBar(
            title: Text("Service Summary",style: TextStyle(color: Colors.white),),
            backgroundColor: HexColor(Colors_theme.dark_app_color),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color:Colors.white),
              onPressed: () =>  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                  Summary()), (Route<dynamic> route) => false),
            ),
            actions:<Widget> [
              bill_service==false?
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: IconButton(
                  icon: const Icon(Icons.print,color: Colors.white,size: 26,),
                  onPressed: () {
                    checker_select=false;
                    List array_list=[];
                    for (int i = 0; i < contactForms.length; i++) {
                      Service_summary_list item = contactForms[i];
                      if(item.service_summary_model.isSelected==true)
                      {
                        checker_select=true;
                        var map = Map();
                        map['item_id']=item.service_summary_model.item_id!;
                        map['descr']=item.service_summary_model.descr!;
                        map['price']=item.service_summary_model.price!;
                        map['qty']=item.service_summary_model.qty;
                        array_list.add(map);
                      }
                    }
                    if(checker_select==true)
                    {
                      getService_data();
                      getClient().then((client_drop_list){
                        getInvoice_last().then((value){
                          String inv_last_id=invoice_list_last[0].inv_no;
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>Service_add_invoice(
                            token:token!,
                            client_drop_list:client_drop_list,
                            service_drop_list:service_drop_list,
                            inv_last_id:inv_last_id,
                            list_data:array_list,
                          )
                          ),
                          );
                        });
                      });
                    }
                    else
                    {
                      Notify_widget.notify("Please select at least one service");
                    }
                  },
                ),
              ):SizedBox(),
              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: IconButton(
                  icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
                  onPressed: () {
                    getService("1").then((service_drop_list)
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_summary(
                        service_drop_list:service_drop_list,
                        token:token,
                        client_id:widget.client_id,
                        theme:theme,
                         )
                        ),
                      );
                    }
                    );
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
                    children:
                    [
                      Flexible(child:
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: HexColor(Colors_theme.dark_app_color),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child:
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child:
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: TextField(
                                  controller: Searchsummarycontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search by service name..',
                                      hintStyle: TextStyle(
                                          color: Colors.white24
                                      )
                                  ),
                                ),
                              ),
                            ),
                            TouchRippleEffect(
                              borderRadius: BorderRadius.circular(5),
                              rippleColor: Colors.white60,
                              onTap:(){
                                filter_summarylist();
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
                      Text("LIST OF SUMMARY",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                      bill_service==false?
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              bill_service=true;
                              contactForms.clear();
                              getService_Summary().then((value){
                                for(var data in service_summary_list)
                                {
                                  onAddform(data.id!, data.client_id!, data.item_id!, data.descr!,data.qty!,data.price!,data.is_billed!,data.date!,data.item_name!,data.isSelected!);
                                }
                              });
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color:Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Text("SEE BILLED SERVICE",style: TextStyle(color: Colors.green,fontSize: 12,fontWeight: FontWeight.bold),),
                            ],
                          )
                      ):
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              bill_service=false;
                              contactForms.clear();
                              getService_Summary().then((value){
                                for(var data in service_summary_list)
                                {
                                  onAddform(data.id!, data.client_id!, data.item_id!, data.descr!,data.qty!,data.price!,data.is_billed!,data.date!,data.item_name!,data.isSelected!);
                                }
                              });
                            });

                          },
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color:Color(0xffFFA74D),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Text("SEE UNBILLED SERVICE",style: TextStyle(color: Color(0xffFFA74D),fontSize: 12,fontWeight: FontWeight.bold),),
                            ],
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchsummarycontroller.text='';
                        issearching=false;
                        empty_checker=false;

                        contactForms.clear;
                        getService_Summary().then((value){
                          for(var data in service_summary_list)
                          {
                            onAddform(data.id!, data.client_id!, data.item_id!, data.descr!,data.qty!,data.price!,data.is_billed!,data.date!,data.item_name!,data.isSelected!);
                          }
                        });
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
                          Text("Visit the service-summary list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  Flexible(
                    child:
                    Scrollbar(
                      isAlwaysShown: true,
                      controller: scrollController,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      child:
                      contactForms.length==0?
                      issearching==false?
                      SizedBox():Empty_widget.Empty():
                      dynamiclist(),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            Searchsummarycontroller.text='';
          });
        },
      );
  }

  Loadtoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
      getService_Summary().then((value){
         for(var data in service_summary_list)
           {
             onAddform(data.id!, data.client_id!, data.item_id!, data.descr!,data.qty!,data.price!,data.is_billed!,data.date!,data.item_name!,data.isSelected!);
           }
      });
    });
  }


  Future getService_Summary() async
  {
    String value_bill;
    if(bill_service==true)
      {
        value_bill="1";
      }
    else
      {
        value_bill="0";
      }
    service_summary_list=await Summary_service.getService_Summary(context,widget.client_id,value_bill,token);
  }

  filter_summarylist()
  {
    List<Service_summary_model> _details=[];
    _details.addAll(service_summary_list);
    if(Searchsummarycontroller.text.isNotEmpty)
    {
        _details.retainWhere((summary_list){
        String searchterm=Searchsummarycontroller.text.toLowerCase();
        String inv_no=summary_list.item_name!.toLowerCase();
        return inv_no.contains(searchterm);
      });
      setState(() {
        contactForms.clear();
        if(_details.length==0)
        {
          empty_checker=true;
        }
        else
          {
             for(var data in _details)
               {
                 onAddform(data.id!, data.client_id!, data.item_id!, data.descr!,data.qty!,data.price!,data.is_billed!,data.date!,data.item_name!,data.isSelected!);
               }
          }
      });
    }
    else
    {
      setState(() {
        _details.addAll(service_summary_list);
      });
    }
  }

  Future<List<String>> getService(String item_id) async
  {
    service_drop_list.clear();
    service_list=await service.getService(context,token);
    for(var data in service_list)
    {
      if(item_id==data.id.toString())
        {
          service_name=data.name.toString();
        }
      service_drop_list.add(data.name.toString());
    }
    return service_drop_list;
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
              "Do yow want to delete the service_summary in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteService_summary(ctx,id);
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
              "Do yow want to delete the service summary in list?",textAlign: TextAlign.center,style: (TextStyle(color: Colors.white,fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteService_summary(ctx,id);
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
  
  Widget dynamiclist()
  {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: contactForms.length,
        controller: scrollController,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, index)
        {
          return contactForms[index];
        });
  }
  
  Future deleteService_summary(BuildContext ctx,String id) async
  {
    var response=await Summary_service.deleteService_summary(id,token);
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
  
  Future getInvoice_last() async
  {
    invoice_list_last=await Invoice_service.getInvoice_last(token!);
  }

  onAddform(String id_data,String client_id,String item_id,String descr,String qty,String price,String is_billed,String date,String item_name,bool isSelected)
  {
      setState(()
      {
        Service_summary_model _serviceModel=Service_summary_model(id:id_data, client_id:client_id,item_id:item_id,descr:descr, qty:qty,price:price,is_billed:is_billed, date:date, item_name:item_name, isSelected:isSelected);
        contactForms.add(Service_summary_list(
            index:contactForms.length,
            service_summary_model: _serviceModel,
            onResult:()=> onResult(),
            theme:theme,
          ),
         );
       }
       );
   }

  onResult()
  {
    setState(() {

    });
  }

  Future<List<String>> getService_data() async
  {
    service_drop_list.clear();
    service_list=await service.getService(context,token!);
    for(var data in service_list)
    {
      service_drop_list.add(data.name.toString());
    }
    return service_drop_list;
  }

  LoadTheme() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      theme = (prefs.getBool('theme') ?? false);
    });
  }
  
}
