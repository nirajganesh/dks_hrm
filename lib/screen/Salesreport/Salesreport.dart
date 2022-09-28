import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Salesreport/Sales_model.dart';
import 'package:dks_hrm/services/Sales_report_service.dart';
import 'package:dks_hrm/widget/App_bar_widget.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Salesreport extends StatefulWidget {

  const Salesreport({Key? key}) : super(key: key);

  @override
  _SalesreportState createState() => _SalesreportState();
}

class _SalesreportState extends State<Salesreport> {

  final TextEditingController Searchcategorycontroller= TextEditingController();
  String token='';
  List<Sales_model> sales_list=[];
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
    return 
    theme==true?
    RefreshIndicator(
      displacement: 250,
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Scaffold(
        appBar:App_bar_widget.App_bar(context,"Salesreport",Colors_theme.light_app_color),
        body:
        Container(
            color: HexColor("#F9FAFF"),
            child: Column(
              children: [
                Flexible(
                  child:
                  FutureBuilder(
                    future: getSales(),
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
                        if(sales_list.length!=0)
                        {
                          return ListView.builder(
                              itemCount:sales_list.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder:(context,index)
                              {
                                Sales_model sal_data=sales_list[index];
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
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
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex:1,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    children: [
                                                      Text(sal_data.inv_no,style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                                                      SizedBox(height: 10,),
                                                      Text(sal_data.client_name,style: TextStyle(color: Colors.grey,fontSize: 14),),
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
                                                          Text(sal_data.inv_date,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Text("₹"+sal_data.amount,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      SizedBox(height: 10,),
                                                    ],
                                                  )
                                              ),
                                            ],
                                          ),
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
                    },
                  ),
                ),

                SizedBox(height: 10,),
              ],
            ),
          ),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          Searchcategorycontroller.text='';
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
        appBar:App_bar_widget.App_bar(context,"Salesreport",Colors_theme.dark_app_color),
        backgroundColor: HexColor(Colors_theme.dark_background),
        body:
        Container(
          color: HexColor(Colors_theme.dark_background),
          child: Column(
            children: [
              Flexible(
                child:
                FutureBuilder(
                  future: getSales(),
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
                      if(sales_list.length!=0)
                      {
                        return ListView.builder(
                            itemCount:sales_list.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder:(context,index)
                            {
                              Sales_model sal_data=sales_list[index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: HexColor(Colors_theme.dark_app_color),
                                      ),
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                flex:1,
                                                child: Column(
                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                  children: [
                                                    Text(sal_data.inv_no,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                                    SizedBox(height: 10,),
                                                    Text(sal_data.client_name,style: TextStyle(color: Colors.white24,fontSize: 14),),
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
                                                        Text(sal_data.inv_date,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Text("₹"+sal_data.amount,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    SizedBox(height: 10,),
                                                  ],
                                                )
                                            ),
                                          ],
                                        ),
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
                  },
                ),
              ),

              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          Searchcategorycontroller.text='';
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

  Future getSales() async
  {
    sales_list=await Sales_report_service.getSales(context,token);
  }

}
