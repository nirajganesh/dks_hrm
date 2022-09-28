import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Holiday/Holiday_model.dart';
import 'package:dks_hrm/services/Holiday_service.dart';
import 'package:dks_hrm/widget/App_bar_widget.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Holiday extends StatefulWidget {

  const Holiday({Key? key}) : super(key: key);

  @override
  _HolidayState createState() => _HolidayState();
}

class _HolidayState extends State<Holiday> {

  final TextEditingController Searchholidaycontroller= TextEditingController();
  static List<Holiday_model> holiday_list=[];
  static List<Holiday_model> container_list=[];
  String token='';
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
    bool issearching=Searchholidaycontroller.text.isNotEmpty;
    return
      theme==true?
      RefreshIndicator(
        displacement: 250,
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: Scaffold(
          appBar: App_bar_widget.App_bar_holiday(context,"Holiday",token,Colors_theme.light_app_color,theme),
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
                                  controller: Searchholidaycontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search by holiday name..',
                                      hintStyle: TextStyle(
                                          color: Colors.black38
                                      )
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap:(){
                                filter_holidaylist();
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
                      Text("LIST OF HOLIDAY",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchholidaycontroller.text='';
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
                          Text("Visit the holiday list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  Flexible(
                    child:
                    FutureBuilder(
                      future: getHoliday(),
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
                              if(holiday_list.length!=0)
                              {
                                return ListView.builder(
                                    itemCount:issearching==true ? container_list.length:holiday_list.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder:(context,index)
                                    {
                                      Holiday_model holiday_data=issearching==true?container_list[index]:holiday_list[index];
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
                                                      children: [
                                                        Text(holiday_data.holiday_name!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        SizedBox(height: 10,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("From date",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                            Text(holiday_data!.from_date==null?"--":holiday_data.from_date!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Text(holiday_data.year!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        SizedBox(height: 10,),

                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex:2,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(holiday_data.number_of_days!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        SizedBox(height: 10,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("To date",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                            Text(holiday_data!.to_date==null?"--":holiday_data.to_date!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                        GestureDetector(
                                                          onTap: (){
                                                            Delete_dailog(holiday_data.id!);
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
              Searchholidaycontroller.text='';
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
          appBar: App_bar_widget.App_bar_holiday(context,"Holiday",token,Colors_theme.dark_app_color,theme),
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
                                  controller: Searchholidaycontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search by holiday name..',
                                      hintStyle: TextStyle(
                                          color: Colors.white24
                                      )
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap:(){
                                filter_holidaylist();
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
                      Text("LIST OF HOLIDAY",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchholidaycontroller.text='';
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
                          Text("Visit the holiday list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  Flexible(
                    child:
                    FutureBuilder(
                      future: getHoliday(),
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
                            if(holiday_list.length!=0)
                            {
                              return ListView.builder(
                                  itemCount:issearching==true ? container_list.length:holiday_list.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder:(context,index)
                                  {
                                    Holiday_model holiday_data=issearching==true?container_list[index]:holiday_list[index];
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
                                                    children: [
                                                      Text(holiday_data.holiday_name!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      SizedBox(height: 10,),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("From date",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                          Text(holiday_data!.from_date==null?"--":holiday_data.from_date!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Text(holiday_data.year!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                      SizedBox(height: 10,),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex:2,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(holiday_data.number_of_days!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      SizedBox(height: 10,),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text("To date",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                          Text(holiday_data!.to_date==null?"--":holiday_data.to_date!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10,),
                                                      GestureDetector(
                                                        onTap: (){
                                                          Delete_dailog_dark(holiday_data.id!);
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
            Searchholidaycontroller.text='';
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

  Future getHoliday() async
  {
    holiday_list=await Holiday_service.getHoliday(context,token);
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
              "Do yow want to delete the holiday in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteHoliday(ctx,id);
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
              "Do yow want to delete the to do in list?",textAlign: TextAlign.center,style: (TextStyle(color: Colors.white,fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteHoliday(ctx,id);
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




  filter_holidaylist()
  {
    List<Holiday_model> _details=[];
    _details.addAll(holiday_list);
    if(Searchholidaycontroller.text.isNotEmpty)
    {
      _details.retainWhere((payment_list){
        String searchterm=Searchholidaycontroller.text.toLowerCase();
        String holiday_name=payment_list.holiday_name!.toLowerCase();
        return holiday_name.contains(searchterm);
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
        _details.addAll(holiday_list);
      });
    }
  }

  Future deleteHoliday(BuildContext ctx,String id) async
  {
    var response=await Holiday_service.deleteHoliday(id,token);
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
}
