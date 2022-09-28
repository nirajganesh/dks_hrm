// ignore: file_names
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Department/Department_model.dart';
import 'package:dks_hrm/model/Payroll_list/Payroll_list_model.dart';
import 'package:dks_hrm/screen/Dashboard/Dashboard.dart';
import 'package:dks_hrm/screen/Payslips/Add_payslips.dart';
import 'package:dks_hrm/services/Department_service.dart';
import 'package:dks_hrm/services/Payroll_list_service.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:url_launcher/url_launcher.dart';

class Payslips extends StatefulWidget {
  const Payslips({Key? key}) : super(key: key);

  @override
  _PayslipsState createState() => _PayslipsState();
}

class _PayslipsState extends State<Payslips> {

  final TextEditingController Searchpayslipscontroller= TextEditingController();
  static List<Payroll_list_model> payroll_list=[];
  static List<Payroll_list_model> container_list=[];
  String token='';
  bool empty_checker=false;
  List<String> department_drop_list=[];
  List<Department_model> department_list=[];
  List<String> department_id_list=[];
  final Map<String, dynamic> map_data = new Map<String, dynamic>();
  List<Map<String, dynamic>> department_data = [];
  bool theme=false;


  @override
  void initState() {
    super.initState();
    LoadTheme();
    Loadtoken();
  }

  @override
  Widget build(BuildContext context) {
    bool issearching=Searchpayslipscontroller.text.isNotEmpty;
    return
      theme==true?
      RefreshIndicator(
      displacement: 250,
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Scaffold(
        appBar:AppBar(
          title: Text("Payslips",style: TextStyle(color: Colors.white),),
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
                  getDepartment().then((department_drop_list){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_payslips(
                        department_drop_list:department_drop_list,
                        department_data:department_data,
                        department_list:department_list,
                        token:token,
                        theme:theme
                    )),);
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
                                controller: Searchpayslipscontroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search by employee id..',
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
                              filter_paysliplist();
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
                    Text("LIST OF PAYSLIPS",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchpayslipscontroller.text='';
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
                        Text("Visit the payslip list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                SizedBox(height: 10,),
                Flexible(
                  child:
                  FutureBuilder(
                    future: getPayslips(),
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
                            if(payroll_list.length!=0)
                            {
                              return ListView.builder(
                                  itemCount:issearching==true ? container_list.length:payroll_list.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder:(context,index)
                                  {
                                    Payroll_list_model payroll_data=issearching==true?container_list[index]:payroll_list[index];
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
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        flex:3,
                                                        child: Column(
                                                          crossAxisAlignment:CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text(payroll_data!.em_code==''?"---":payroll_data.em_code!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                            SizedBox(height: 5,),
                                                            Text(payroll_data!.month==null?"---":payroll_data.month!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                            SizedBox(height: 5,),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("Salary",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                                Row(
                                                                  children: [
                                                                    Text("₹",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                                    SizedBox(width: 3,),
                                                                    Text(payroll_data!.total_pay==''?"---":payroll_data.total_pay!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 8,),
                                                          ],
                                                        )
                                                    ),
                                                    Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          crossAxisAlignment:CrossAxisAlignment.end,
                                                          mainAxisAlignment:MainAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:MainAxisAlignment.end,
                                                              crossAxisAlignment:CrossAxisAlignment.center,
                                                              children: [
                                                                Text(payroll_data!.paid_date==null?"---":payroll_data.paid_date!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                              ],
                                                            ),
                                                            SizedBox(height: 5,),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Text("Total Paid",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Text("₹",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                    Text(payroll_data!.total_pay==''?"---":payroll_data.total_pay!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(height: 10,),
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
                                                                          _launchURL(payroll_data.emp_id!,payroll_data.pay_id!);
                                                                        },
                                                                        child: Container(
                                                                          width:35,
                                                                          height:35,
                                                                          decoration:BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(25),
                                                                            color: Color(0xffFFA74D),
                                                                          ),
                                                                          child:Icon(Icons.print,color:Colors.white,size: 20,),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 5,),
                                                                      TouchRippleEffect(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        rippleColor: Colors.white60,
                                                                        onTap: (){
                                                                          Delete_dailog(payroll_data.pay_id!);
                                                                        },
                                                                        child: Container(
                                                                          width:35,
                                                                          height:35,
                                                                          decoration:BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(25),
                                                                            color: Color(0xffE71157),
                                                                          ),
                                                                          child: Icon(Icons.delete,size: 20,color: Colors.white,),
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
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
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
          Searchpayslipscontroller.text='';
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
          appBar:AppBar(
            title: Text("Payslips",style: TextStyle(color: Colors.white),),
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
                    getDepartment().then((department_drop_list){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_payslips(
                          department_drop_list:department_drop_list,
                          department_data:department_data,
                          department_list:department_list,
                          token:token,
                          theme:theme,
                      )),);
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
                                  controller: Searchpayslipscontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search by employee id..',
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
                                filter_paysliplist();
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
                      Text("LIST OF PAYSLIPS",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchpayslipscontroller.text='';
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
                          Text("Visit the payslip list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  SizedBox(height: 10,),
                  Flexible(
                    child:
                    FutureBuilder(
                      future: getPayslips(),
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
                            if(payroll_list.length!=0)
                            {
                              return ListView.builder(
                                  itemCount:issearching==true ? container_list.length:payroll_list.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder:(context,index)
                                  {
                                    Payroll_list_model payroll_data=issearching==true?container_list[index]:payroll_list[index];
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
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        flex:3,
                                                        child: Column(
                                                          crossAxisAlignment:CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text(payroll_data!.em_code==''?"---":payroll_data.em_code!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                            SizedBox(height: 5,),
                                                            Text(payroll_data!.month==null?"---":payroll_data.month!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                            SizedBox(height: 5,),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("Salary",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                                Row(
                                                                  children: [
                                                                    Text("₹",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                                    SizedBox(width: 3,),
                                                                    Text(payroll_data!.total_pay==''?"---":payroll_data.total_pay!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 8,),
                                                          ],
                                                        )
                                                    ),
                                                    Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          crossAxisAlignment:CrossAxisAlignment.end,
                                                          mainAxisAlignment:MainAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:MainAxisAlignment.end,
                                                              crossAxisAlignment:CrossAxisAlignment.center,
                                                              children: [
                                                                Text(payroll_data!.paid_date==null?"---":payroll_data.paid_date!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                              ],
                                                            ),
                                                            SizedBox(height: 5,),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Text("Total Paid",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Text("₹",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                                    Text(payroll_data!.total_pay==''?"---":payroll_data.total_pay!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(height: 10,),
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
                                                                          _launchURL(payroll_data.emp_id!,payroll_data.pay_id!);
                                                                        },
                                                                        child: Container(
                                                                          width:35,
                                                                          height:35,
                                                                          decoration:BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(25),
                                                                            color: Color(0xffFFA74D),
                                                                          ),
                                                                          child:Icon(Icons.print,color:Colors.white,size: 20,),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 5,),
                                                                      TouchRippleEffect(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        rippleColor: Colors.white60,
                                                                        onTap: (){
                                                                          Delete_dailog_dark(payroll_data.pay_id!);
                                                                        },
                                                                        child: Container(
                                                                          width:35,
                                                                          height:35,
                                                                          decoration:BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(25),
                                                                            color: Color(0xffE71157),
                                                                          ),
                                                                          child: Icon(Icons.delete,size: 20,color: Colors.white,),
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
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
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
            Searchpayslipscontroller.text='';
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

  Future getPayslips() async
  {
    payroll_list=await Payroll_list_service.getPayroll_list(context,token);
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
              "Do yow want to delete the payroll in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deletePayroll(ctx,id);
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
              "Do yow want to delete the payslips in list?",textAlign: TextAlign.center,style: (TextStyle(color: Colors.white,fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deletePayroll(ctx,id);
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

  filter_paysliplist()
  {
    List<Payroll_list_model> _details=[];
    _details.addAll(payroll_list);
    if(Searchpayslipscontroller.text.isNotEmpty)
    {
      _details.retainWhere((payment_list){
        String searchterm=Searchpayslipscontroller.text.toLowerCase();
        String invoice_id=payment_list.emp_id!.toLowerCase();
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
        _details.addAll(payroll_list);
      });
    }
  }

  Future deletePayroll(BuildContext ctx,String id) async
  {
    var response=await Payroll_list_service.deletePayroll_list(id,token);
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

  Future<List<String>> getDepartment() async
  {
    department_drop_list.clear();
    department_list=await Department_service.getDepartment(context,token!);
    for(var data in department_list)
    {
      department_drop_list.add(data.dep_name.toString());
      department_data.add(map_data);
    }
    return department_drop_list;
  }

  void _launchURL(String emp_id,String  pay_id) async {
    String url=Api_constants.payslip_invoice+"/"+emp_id+"/"+pay_id;
    if (!await launch(url)) throw 'Could not launch $url';
  }


}
