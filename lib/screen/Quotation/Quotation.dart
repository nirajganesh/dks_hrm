import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Invoice/Invoice_last_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_last_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Dashboard/Dashboard.dart';
import 'package:dks_hrm/screen/Quotation/Add/Add_quotation.dart';
import 'package:dks_hrm/screen/Quotation/Convert_invoice.dart';
import 'package:dks_hrm/screen/Quotation/Edit/Quotation_edit.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Invoice_service.dart';
import 'package:dks_hrm/services/Quotation_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:url_launcher/url_launcher.dart';


class Quotation extends StatefulWidget {
  const Quotation({Key? key}) : super(key: key);

  @override
  _QuotationState createState() => _QuotationState();
}

class _QuotationState extends State<Quotation> {

  final TextEditingController Searchquotationcontroller= TextEditingController();
  bool isSwitched = false;

  void toggleSwitch(bool value) {
    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
      });
    }
    else
    {
      setState(() {
        isSwitched = false;
      });
    }
  }


  List<Quotation_model> quotation_list=[];
  List<Quotation_last_model> quotation_list_last=[];
  List<Quotation_model> container_list=[];
  String token='';
  static List<String> client_drop_list=<String>[];
  List<Client_model> client_list=[];
  static List<String> service_drop_list=<String>[];
  List<Service_model> service_list=[];
  bool empty_checker=false;
  late String quo_last_id;
  List<Invoice_last_model> invoice_list_last=[];
  bool theme=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadTheme();
    Loadtoken();
    Searchquotationcontroller.addListener(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    bool issearching=Searchquotationcontroller.text.isNotEmpty;
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
          title: Text("Quotation",style: TextStyle(color: Colors.white),),
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
                  getClient().then((client_list){
                    getService().then((service_list){
                      getQuotation_last().then((quotation_list_las){
                        if(quotation_list_last.length==0)
                          {
                            quo_last_id="QDS10001";
                          }
                        else
                          {
                            quo_last_id=quotation_list_last[0].quo_no;
                          }
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_quotation(
                          client_drop_list:client_list,
                          service_drop_list:service_list,
                          token: token,
                          quo_last_id:quo_last_id,
                          theme:theme,
                        )),);
                      });
                    });
                  });
                },
              ),
            ),
          ],
        ),
        body: Padding(
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
                                controller: Searchquotationcontroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search by quotation no..',
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
                              filter_quotationlist();
                            },
                            child: 
                            Container(
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
                    Text("LIST OF QUOTATION",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchquotationcontroller.text='';
                      issearching=false;
                      empty_checker=false;
                    });
                  },
                  child:
                  Searchquotationcontroller.text.isNotEmpty==true?
                  Padding(
                    padding: const EdgeInsets.only(bottom:8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh,color: Theme.of(context).primaryColor),
                        SizedBox(width: 2,),
                        Text("Visit the quotation list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(child:
                FutureBuilder(
                  future: getQuotation(context),
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
                          if(quotation_list.length!=0)
                          {
                            return ListView.builder(
                                itemCount:issearching==true ? container_list.length:quotation_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(context,index)
                                {
                                  Quotation_model quotation_data=issearching==true?container_list[index]:quotation_list[index];
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
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex:1,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    children: [
                                                      Text(quotation_data.quote_no,style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                                                      SizedBox(height: 5,),
                                                      Text(quotation_data.client_name,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(quotation_data!.remarks==""?"--":quotation_data.remarks!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(quotation_data.status,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                    ],
                                                  )
                                              ),
                                              Expanded(
                                                  flex:2,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.end,
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.center,
                                                        children: [
                                                          Text(quotation_data.quote_date,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Text("₹"+quotation_data.total,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.end,
                                                        children: [
                                                          Flexible(
                                                            flex:7,
                                                            child: Row(
                                                              mainAxisAlignment:MainAxisAlignment.end,
                                                              children: [
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap:(){
                                                                    getClient().then((client_list){
                                                                      getService().then((service_list){
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Quotation_edit(
                                                                          quotation_no:quotation_data.quote_no,quotation_date:quotation_data.quote_date,
                                                                          valid_till:quotation_data.valid_till,remarks:quotation_data.remarks!,id:quotation_data.id,
                                                                          client_drop_list:client_list,service_drop_list:service_list,token: token,
                                                                          sub_total:quotation_data.sub_total,total:quotation_data.total,discount:quotation_data.discount,
                                                                           status:quotation_data.status,client_name:quotation_data.client_name,
                                                                          client_id:quotation_data.client_id,theme: theme,
                                                                        )),);
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    width:33,
                                                                    height:33,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xffFFA74D),
                                                                    ),
                                                                    child:Icon(Icons.edit,color:Colors.white,size: 18,),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 3,),
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap: () async{
                                                                    _launchURL(quotation_data.id!,quotation_data.client_id!);
                                                                  },
                                                                  child: Container(
                                                                    width:33,
                                                                    height:33,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xffE71157),
                                                                    ),
                                                                    child: Icon(Icons.remove_red_eye,size: 18,color: Colors.white,),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 3,),
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap: () async{
                                                                    launch('mailto:'+quotation_data.client_email+'?subject=This is subject');
                                                                  },
                                                                  child: Container(
                                                                    width:33,
                                                                    height:33,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xff26DAD2),
                                                                    ),
                                                                    child: Icon(Icons.mail,size: 18,color: Colors.white,),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 3,),
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap: () async{
                                                                    getClient().then((value){
                                                                      getService().then((value){
                                                                        getInvoice_last().then((value){
                                                                          String inv_last_id=invoice_list_last[0].inv_no;
                                                                          String value_inv_no=inv_last_id;
                                                                          int idx = value_inv_no.indexOf("S");
                                                                          int increase_value=int.parse(value_inv_no.substring(idx+1).trim())+1;
                                                                          inv_last_id = "DS"+increase_value.toString();

                                                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>Convert_invoice(
                                                                            client_name:quotation_data.client_name,
                                                                            token:token,
                                                                            client_drop_list:client_drop_list,
                                                                            service_drop_list:service_drop_list,
                                                                            due_date:quotation_data.valid_till,
                                                                            invoice_date:quotation_data.quote_date,
                                                                            remarks:quotation_data.remarks!,
                                                                            invoice_no:inv_last_id,
                                                                            quote_id:quotation_data.id,
                                                                            sub_total: quotation_data.sub_total,
                                                                            total: quotation_data.total,
                                                                            client_id: quotation_data.client_id,
                                                                            id: quotation_data.id,
                                                                            paid: '',
                                                                            due: quotation_data.total,
                                                                            theme:theme,
                                                                             )
                                                                            ),
                                                                          );
                                                                        });
                                                                      });
                                                                    });

                                                                  },
                                                                  child: Container(
                                                                    width:33,
                                                                    height:33,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xff3D3B8E),
                                                                    ),
                                                                    child: Icon(Icons.add_link,size: 18,color: Colors.white,),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 3,),
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap: (){
                                                                    Delete_dailog(quotation_data.id);
                                                                  },
                                                                  child: Container(
                                                                    width:33,
                                                                    height:33,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xffE71157),
                                                                    ),
                                                                    child: Icon(Icons.delete,size: 18,color: Colors.white,),
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
                          else
                          {
                            return Empty_widget.Empty();
                          }
                        }
                    }
                  },
                ),),
              ],
            ),
          ),
        ),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          Searchquotationcontroller.text='';
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
            title: Text("Quotation",style: TextStyle(color: Colors.white),),
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
                    getClient().then((client_list){
                      getService().then((service_list){
                        getQuotation_last().then((quotation_list_las){
                          if(quotation_list_last.length==0)
                          {
                            quo_last_id="QDS10001";
                          }
                          else
                          {
                            quo_last_id=quotation_list_last[0].quo_no;
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_quotation(
                            client_drop_list:client_list,
                            service_drop_list:service_list,
                            token: token,
                            quo_last_id:quo_last_id,
                            theme:theme,
                          )),);
                        });
                      });
                    });
                  },
                ),
              ),
            ],
          ),
          backgroundColor: HexColor(Colors_theme.dark_background),
          body: Padding(
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
                                  controller: Searchquotationcontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search by quotation no..',
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
                                filter_quotationlist();
                              },
                              child:
                              Container(
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
                      Text("LIST OF QUOTATION",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchquotationcontroller.text='';
                        issearching=false;
                        empty_checker=false;
                      });
                    },
                    child:
                    Searchquotationcontroller.text.isNotEmpty==true?
                    Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh,color: Theme.of(context).primaryColor),
                          SizedBox(width: 2,),
                          Text("Visit the quotation list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  Flexible(child:
                  FutureBuilder(
                    future: getQuotation(context),
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
                          if(quotation_list.length!=0)
                          {
                            return ListView.builder(
                                itemCount:issearching==true ? container_list.length:quotation_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(context,index)
                                {
                                  Quotation_model quotation_data=issearching==true?container_list[index]:quotation_list[index];
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
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex:1,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    children: [
                                                      Text(quotation_data.quote_no,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                                      SizedBox(height: 5,),
                                                      Text(quotation_data.client_name,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(quotation_data!.remarks==""?"--":quotation_data.remarks!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(quotation_data.status,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                    ],
                                                  )
                                              ),
                                              Expanded(
                                                  flex:2,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.end,
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.center,
                                                        children: [
                                                          Text(quotation_data.quote_date,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Text("₹"+quotation_data.total,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.end,
                                                        children: [
                                                          Flexible(
                                                            flex:7,
                                                            child: Row(
                                                              mainAxisAlignment:MainAxisAlignment.end,
                                                              children: [
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap:(){
                                                                    getClient().then((client_list){
                                                                      getService().then((service_list){
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Quotation_edit(
                                                                          quotation_no:quotation_data.quote_no,quotation_date:quotation_data.quote_date,
                                                                          valid_till:quotation_data.valid_till,remarks:quotation_data.remarks!,id:quotation_data.id,
                                                                          client_drop_list:client_list,service_drop_list:service_list,token: token,
                                                                          sub_total:quotation_data.sub_total,total:quotation_data.total,discount:quotation_data.discount,
                                                                          status:quotation_data.status,client_name:quotation_data.client_name,
                                                                          client_id:quotation_data.client_id,theme: theme,
                                                                        )),);
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    width:33,
                                                                    height:33,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xffFFA74D),
                                                                    ),
                                                                    child:Icon(Icons.edit,color:Colors.white,size: 18,),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 3,),
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap: () async{
                                                                    _launchURL(quotation_data.id!,quotation_data.client_id!);
                                                                  },
                                                                  child: Container(
                                                                    width:33,
                                                                    height:33,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xffE71157),
                                                                    ),
                                                                    child: Icon(Icons.remove_red_eye,size: 18,color: Colors.white,),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 3,),
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap: () async{
                                                                    launch('mailto:'+quotation_data.client_email+'?subject=This is subject');
                                                                  },
                                                                  child: Container(
                                                                    width:33,
                                                                    height:33,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xff26DAD2),
                                                                    ),
                                                                    child: Icon(Icons.mail,size: 18,color: Colors.white,),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 3,),
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap: () async{
                                                                    getClient().then((value){
                                                                      getService().then((value){
                                                                        getInvoice_last().then((value){
                                                                          String inv_last_id=invoice_list_last[0].inv_no;
                                                                          String value_inv_no=inv_last_id;
                                                                          int idx = value_inv_no.indexOf("S");
                                                                          int increase_value=int.parse(value_inv_no.substring(idx+1).trim())+1;
                                                                          inv_last_id = "DS"+increase_value.toString();

                                                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>Convert_invoice(
                                                                            client_name:quotation_data.client_name,
                                                                            token:token,
                                                                            client_drop_list:client_drop_list,
                                                                            service_drop_list:service_drop_list,
                                                                            due_date:quotation_data.valid_till,
                                                                            invoice_date:quotation_data.quote_date,
                                                                            remarks:quotation_data.remarks!,
                                                                            invoice_no:inv_last_id,
                                                                            quote_id:quotation_data.id,
                                                                            sub_total: quotation_data.sub_total,
                                                                            total: quotation_data.total,
                                                                            client_id: quotation_data.client_id,
                                                                            id: quotation_data.id,
                                                                            paid: '',
                                                                            due: quotation_data.total,
                                                                            theme:theme,
                                                                            )
                                                                           ),
                                                                          );
                                                                        });
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    width:33,
                                                                    height:33,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xff3D3B8E),
                                                                    ),
                                                                    child: Icon(Icons.add_link,size: 18,color: Colors.white,),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 3,),
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap: (){
                                                                    Delete_dailog_dark(quotation_data.id);
                                                                  },
                                                                  child: Container(
                                                                    width:33,
                                                                    height:33,
                                                                    decoration:BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(25),
                                                                      color: Color(0xffE71157),
                                                                    ),
                                                                    child: Icon(Icons.delete,size: 18,color: Colors.white,),
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
                          else
                          {
                            return Empty_widget.Empty_dark();
                          }
                        }
                      }
                    },
                  ),),
                ],
              ),
            ),
          ),
        ),
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            Searchquotationcontroller.text='';
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

  Future getQuotation(BuildContext context) async
  {
    quotation_list=await Quotation_service.getQuotation(context,token);
  }

  Future getQuotation_last() async
  {
    quotation_list_last=await Quotation_service.getQuotation_last(token);
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
              "Do yow want to delete the quotation in list?",textAlign: TextAlign.center,style: (TextStyle(color: Colors.white,fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteQuotation(ctx,id);
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

  void Delete_dailog(String id)
  {
    showDialog(
        context: context,
        builder:(ctx)=>AlertDialog(
          title: Center(
            child:
            Text(
              "Alert for Delete",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(left:12.0,right:12.0),
            child: Text(
              "Do yow want to delete the Quotation in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteQuotation(ctx,id);
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

  filter_quotationlist()
  {
    List<Quotation_model> _details=[];
    _details.addAll(quotation_list);
    if(Searchquotationcontroller.text.isNotEmpty)
    {
      _details.retainWhere((quotation_list){
        String searchterm=Searchquotationcontroller.text.toLowerCase();
        String description=quotation_list.quote_no.toLowerCase();
        return description.contains(searchterm);
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
        _details.addAll(quotation_list);
      });
    }
  }

  Future deleteQuotation(BuildContext ctx,String id) async
  {
    var response=await Quotation_service.deleteQuotation(id,token);
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
    client_list=await Client_service.getClient(context,token);
    for(var data in client_list)
    {
      client_drop_list.add(data.name.toString());
    }
    return client_drop_list;
  }

  Future<List<String>> getService() async
  {
    service_drop_list.clear();
    service_list=await service.getService(context,token);
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

  void _launchURL(String quo_id,String client_id) async {
    String url=Api_constants.quotation_invoice+quo_id+"/"+client_id;
    if (!await launch(url)) throw 'Could not launch $url';
  }

}
