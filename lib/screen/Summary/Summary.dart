import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Summary/Summary_model.dart';
import 'package:dks_hrm/screen/Dashboard/Dashboard.dart';
import 'package:dks_hrm/screen/Summary/Service_summary.dart';
import 'package:dks_hrm/services/Summary_service.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Summary extends StatefulWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {

  final TextEditingController Searchsummarycontroller= TextEditingController();
  static List<Summary_model> summary_list=[];
  static List<Summary_model> container_list=[];
  String token='';
  bool empty_checker=false;
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
          title: Text("Summary",style: TextStyle(color: Colors.white),),
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
                                controller: Searchsummarycontroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search by name..',
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
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchsummarycontroller.text='';
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
                        Text("Visit the summary list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(
                  child:
                  FutureBuilder(
                    future: getSummary(),
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
                            if(summary_list.length!=0)
                            {
                              return ListView.builder(
                                  itemCount:issearching==true ? container_list.length:summary_list.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder:(context,index)
                                  {
                                    Summary_model summary_data=issearching==true?container_list[index]:summary_list[index];
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
                                                        Text(summary_data.name!,style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                                                        SizedBox(height: 5,),
                                                        Text(summary_data.person!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                        SizedBox(height: 5,),
                                                        Text(summary_data.address!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                        SizedBox(height: 5,),
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
                                                            Icon(Icons.phone,color: Colors.grey,),
                                                            SizedBox(width:4),
                                                            Text("+91 ",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                            Text(summary_data.contact_no!,style: TextStyle(color: Colors.black,fontSize: 14),),
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
                                                                    onTap: (){
                                                                     // Delete_dailog(quotation_data.id);
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Service_summary(token:token,client_id:summary_data.id!)),);
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
          appBar: AppBar(
            title: Text("Summary",style: TextStyle(color: Colors.white),),
            backgroundColor: HexColor(Colors_theme.dark_app_color),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color:Colors.white),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                  Dashboard()), (Route<dynamic> route) => false),
            ),
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
                                  controller: Searchsummarycontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.white24,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search by name..',
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
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchsummarycontroller.text='';
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
                          Text("Visit the summary list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  Flexible(
                    child:
                    FutureBuilder(
                      future: getSummary(),
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
                            if(summary_list.length!=0)
                            {
                              return ListView.builder(
                                  itemCount:issearching==true ? container_list.length:summary_list.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder:(context,index)
                                  {
                                    Summary_model summary_data=issearching==true?container_list[index]:summary_list[index];
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
                                                        Text(summary_data.name!,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                                        SizedBox(height: 5,),
                                                        Text(summary_data.person!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                        SizedBox(height: 5,),
                                                        Text(summary_data.address!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                        SizedBox(height: 5,),
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
                                                          children:
                                                          [
                                                            Icon(Icons.phone,color: Colors.grey,),
                                                            SizedBox(width:4),
                                                            Text("+91 ",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                            Text(summary_data.contact_no!,style: TextStyle(color: Colors.white,fontSize: 14),),
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
                                                                    onTap: (){
                                                                      // Delete_dailog(quotation_data.id);
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Service_summary(token:token,client_id:summary_data.id!)),);
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
    });
  }

  LoadTheme() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      theme = (prefs.getBool('theme') ?? false);
    });
  }

  Future getSummary() async
  {
    summary_list=await Summary_service.getSummary(context,token);
  }

  filter_summarylist()
  {
    List<Summary_model> _details=[];
    _details.addAll(summary_list);
    if(Searchsummarycontroller.text.isNotEmpty)
    {
      _details.retainWhere((summary_list){
        String searchterm=Searchsummarycontroller.text.toLowerCase();
        String person=summary_list.name!.toLowerCase();
        return person.contains(searchterm);
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
        _details.addAll(summary_list);
      });
    }
  }






}
