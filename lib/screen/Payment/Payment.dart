import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Invoice/Invoice_model.dart';
import 'package:dks_hrm/model/Payment/Payment_last_modal.dart';
import 'package:dks_hrm/model/Payment/Payment_model.dart';
import 'package:dks_hrm/screen/Dashboard/Dashboard.dart';
import 'package:dks_hrm/screen/Payment/Add_payment.dart';
import 'package:dks_hrm/screen/Payment/Edit_payment.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Payment_service.dart';
import 'package:dks_hrm/widget/App_bar_widget.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:url_launcher/url_launcher.dart';
class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  final TextEditingController Searchpaymentcontroller= TextEditingController();
  static List<Payment_model> payment_list=[];
  static List<Payment_model> container_list=[];
  String token='';
  List<String> client_drop_list=[];
  List<Client_model> client_list=[];
  bool empty_checker=false;
  List<Payment_last_modal> payment_last_list=[];
  List<Invoice_model> invoice_client_list=[];
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
    bool issearching=Searchpaymentcontroller.text.isNotEmpty;
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
          title: Text("Payment",style: TextStyle(color: Colors.white),),
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
                  getClient().then((value){
                    getPayment_last().then((value){

                        String value_inv_no=payment_last_list[0].receipt_id!;
                        int idx = value_inv_no.indexOf("S");
                        int increase_value=int.parse(value_inv_no.substring(idx+1).trim())+1;
                        String receipt_new_id = "PDS"+increase_value.toString();

                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_payment(
                           client_drop_list:client_drop_list,
                           token:token,
                           receipt_id:receipt_new_id,
                           client_name:"Aviral",
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
        ) ,
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
                                controller: Searchpaymentcontroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search by client name..',
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
                              filter_paymentlist();
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
                    Text("LIST OF PAYMENT",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchpaymentcontroller.text='';
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
                        Text("Visit the payment list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(
                  child:
                  FutureBuilder(
                    future: getPayment(),
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
                        else {
                          if (payment_list.length != 0) {
                            return ListView.builder(
                                itemCount: issearching == true ? container_list
                                    .length : payment_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  Payment_model pay_data = issearching == true
                                      ? container_list[index]
                                      : payment_list[index];
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xffe8e8e8),
                                              blurRadius: 5.0,
                                              // soften the shadow//extend the shadow
                                              offset: Offset(
                                                  0, 5
                                              ),
                                            ),
                                          ],
                                        ),
                                        child:
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex:1,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    children: [
                                                      Text(pay_data.receipt_no!,style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                                                      SizedBox(height: 5,),
                                                      Text(pay_data.client_name!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(pay_data.remarks!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                    ],
                                                  )
                                              ),
                                              Expanded(
                                                  flex:1,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.end,
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.center,
                                                        children: [
                                                          Text( pay_data.payment_date!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Text( "₹" + pay_data.amount!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.end,
                                                        children: [
                                                          Flexible(
                                                            flex:4,
                                                            child: Row(
                                                              mainAxisAlignment:MainAxisAlignment.end,
                                                              children: [
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap:(){
                                                                    getClient().then((
                                                                        value) {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (
                                                                                context) =>
                                                                                Edit_payment(
                                                                                  client_drop_list: client_drop_list,
                                                                                  token: token,
                                                                                  receipt_no: pay_data
                                                                                      .receipt_no!,
                                                                                  payment_date: pay_data
                                                                                      .payment_date!,
                                                                                  payment_amount: pay_data
                                                                                      .amount!,
                                                                                  remarks: pay_data
                                                                                      .remarks!,
                                                                                  invoice_id: pay_data
                                                                                      .invoice_id!,
                                                                                  id: pay_data
                                                                                      .pay_id!,
                                                                                  client_name:pay_data.client_name!,
                                                                                  theme:theme,
                                                                                )),);
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    width:35,
                                                                    height:35,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xffFFA74D),
                                                                    ),
                                                                    child:Icon(Icons.edit,color:Colors.white,size: 20,),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 5,),
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap: (){
                                                                    _launchURL(pay_data.pay_id!);
                                                                  },
                                                                  child: Container(
                                                                    width:35,
                                                                    height:35,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xffE71157),
                                                                    ),
                                                                    child: Icon(Icons.remove_red_eye,size: 20,color: Colors.white,),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                              ),
                                              SizedBox(height: 8,),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  );
                                }
                            );
                          }
                          else {
                            return Empty_widget.Empty();
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
          Searchpaymentcontroller.text='';
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
            title: Text("Payment",style: TextStyle(color: Colors.white),),
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
                    getClient().then((value){
                      getPayment_last().then((value){
                        String value_inv_no=payment_last_list[0].receipt_id!;
                        int idx = value_inv_no.indexOf("S");
                        int increase_value=int.parse(value_inv_no.substring(idx+1).trim())+1;
                        String receipt_new_id = "PDS"+increase_value.toString();

                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_payment(
                          client_drop_list:client_drop_list,
                          token:token,
                          receipt_id:receipt_new_id,
                          client_name:"Aviral",
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
          ) ,
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
                                  controller: Searchpaymentcontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search by client name..',
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
                                filter_paymentlist();
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
                      Text("LIST OF PAYMENT",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchpaymentcontroller.text='';
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
                          Text("Visit the payment list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  Flexible(
                    child:
                    FutureBuilder(
                      future: getPayment(),
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
                          else {
                            if (payment_list.length != 0) {
                              return ListView.builder(
                                  itemCount: issearching == true ? container_list
                                      .length : payment_list.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Payment_model pay_data = issearching == true
                                        ? container_list[index]
                                        : payment_list[index];
                                    return Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                10),
                                            color: HexColor(Colors_theme.dark_app_color),
                                          ),
                                          child:
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    flex:1,
                                                    child: Column(
                                                      crossAxisAlignment:CrossAxisAlignment.start,
                                                      children: [
                                                        Text(pay_data.receipt_no!,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                                        SizedBox(height: 5,),
                                                        Text(pay_data.client_name!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                        SizedBox(height: 5,),
                                                        Text(pay_data.remarks!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                      ],
                                                    )
                                                ),
                                                Expanded(
                                                    flex:1,
                                                    child: Column(
                                                      crossAxisAlignment:CrossAxisAlignment.end,
                                                      mainAxisAlignment:MainAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:MainAxisAlignment.end,
                                                          crossAxisAlignment:CrossAxisAlignment.center,
                                                          children: [
                                                            Text( pay_data.payment_date!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Text( "₹" + pay_data.amount!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                        SizedBox(height: 5,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          crossAxisAlignment:CrossAxisAlignment.end,
                                                          children: [
                                                            Flexible(
                                                              flex:4,
                                                              child: Row(
                                                                mainAxisAlignment:MainAxisAlignment.end,
                                                                children: [
                                                                  TouchRippleEffect(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    rippleColor: Colors.white60,
                                                                    onTap:(){
                                                                      getClient().then((
                                                                          value) {
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (
                                                                                  context) =>
                                                                                  Edit_payment(
                                                                                    client_drop_list: client_drop_list,
                                                                                    token: token,
                                                                                    receipt_no: pay_data.receipt_no!,
                                                                                    payment_date: pay_data.payment_date!,
                                                                                    payment_amount: pay_data.amount!,
                                                                                    remarks: pay_data.remarks!,
                                                                                    invoice_id: pay_data.invoice_id!,
                                                                                    id: pay_data.pay_id!,
                                                                                    client_name:pay_data.client_name!,
                                                                                    theme:theme,
                                                                                  )),);
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      width:35,
                                                                      height:35,
                                                                      decoration:BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(25),
                                                                        color: Color(0xffFFA74D),
                                                                      ),
                                                                      child:Icon(Icons.edit,color:Colors.white,size: 20,),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 5,),
                                                                  TouchRippleEffect(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    rippleColor: Colors.white60,
                                                                    onTap: (){
                                                                      _launchURL(pay_data.pay_id!);
                                                                    },
                                                                    child: Container(
                                                                      width:35,
                                                                      height:35,
                                                                      decoration:BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(25),
                                                                        color: Color(0xffE71157),
                                                                      ),
                                                                      child: Icon(Icons.remove_red_eye,size: 20,color: Colors.white,),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                ),
                                                SizedBox(height: 8,),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                      ],
                                    );
                                  }
                              );
                            }
                            else {
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
            Searchpaymentcontroller.text='';
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

  Future getPayment() async
  {
    payment_list=await Payment_service.getPayment(context,token);
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
              "Do yow want to delete the payment in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deletePayment(ctx,id);
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

  filter_paymentlist()
  {
    List<Payment_model> _details=[];
    _details.addAll(payment_list);
    if(Searchpaymentcontroller.text.isNotEmpty)
    {
      _details.retainWhere((payment_list){
        String searchterm=Searchpaymentcontroller.text.toLowerCase();
        String invoice_id=payment_list.client_name!.toLowerCase();
        return invoice_id.contains(searchterm);
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
        _details.addAll(payment_list);
      });
    }
  }

  Future deletePayment(BuildContext ctx,String id) async
  {
    var response=await Payment_service.deletePayment(id,token);
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

  Future getPayment_last() async
  {
    payment_last_list=await Payment_service.getPayment_last(context,token);
  }

  Future getInvoice_client(String client_id) async
  {
    invoice_client_list=await Payment_service.getInvoice_client(context,token,client_id);
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

  void _launchURL(String id) async {
    String url=Api_constants.invoice_payment+id;
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
