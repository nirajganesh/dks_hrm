import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Category/Category_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Dashboard/Dashboard.dart';
import 'package:dks_hrm/screen/Service/Add_service.dart';
import 'package:dks_hrm/screen/Service/Edit_service.dart';
import 'package:dks_hrm/services/Service_category_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class Service extends StatefulWidget {
  const Service({Key? key}) : super(key: key);

  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {

  final TextEditingController Searchservicecontroller= TextEditingController();
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

  static List<Service_model> service_list=[];
  static List<Service_model> container_list=[];
  String token='';
  static List<String> cat_drop_list=<String>[];
  List<Category_model> category_list=[];
  bool empty_checker=false;
  bool theme=false;

  @override
  void initState() {
    super.initState();
    Loadtoken();
    LoadTheme();
  }

  @override
  Widget build(BuildContext context) {
    bool issearching=Searchservicecontroller.text.isNotEmpty;
    return 
      theme==true?
      RefreshIndicator(
      displacement: 250,
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Services",style: TextStyle(color: Colors.white),),
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
                  getCategory().then((cat_list){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_service(cat_drop_list:cat_list,token:token,theme:theme)),);
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
                                controller: Searchservicecontroller,
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
                              filter_Servicelist();
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
                    Text("LIST OF SERVICE",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchservicecontroller.text='';
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
                        Text("Visit the service list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(child:
                FutureBuilder(
                  future: getService(),
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
                          if(service_list.length!=0)
                          {
                            return ListView.builder(
                                itemCount:issearching==true ? container_list.length:service_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(context,index)
                                {
                                  Service_model service_data=issearching==true?container_list[index]:service_list[index];
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
                                            children: [
                                              Expanded(
                                                  flex:3,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    children: [
                                                      Text(service_data!.name==''?"--":service_data.name!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(service_data!.cname==''?"--":service_data.cname!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(service_data!.short_descr==''?"--":service_data.short_descr!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(service_data!.long_descr==''?"--":service_data.long_descr!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                    ],
                                                  )
                                              ),
                                              Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.end,
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 3,),
                                                      Row(
                                                        mainAxisAlignment:MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.center,
                                                        children: [
                                                          Text("₹",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          Text(service_data.price==''?"--":service_data.price!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      service_data.isactive=='1'?
                                                      Text('Active',style: TextStyle(color: Colors.black,fontSize: 14),):
                                                      Text('InActive',style: TextStyle(color: Colors.black,fontSize: 14),),
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
                                                                    getCategory().then((cat_list){
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_service(id:service_data.id!,
                                                                          name:service_data.name!,price:service_data.price!,short_descr:service_data.short_descr!,
                                                                          long_descr:service_data.long_descr!,status:service_data.isactive!,cat_drop_list:cat_list,
                                                                          cname:service_data.cname!,token:token,theme:theme)),);
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
                                                                    Delete_dailog(service_data.id!);
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
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          Searchservicecontroller.text='';
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
            title: Text("Services",style: TextStyle(color: Colors.white),),
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
                    getCategory().then((cat_list){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_service(cat_drop_list:cat_list,token:token,theme:theme)),);
                    });
                  },
                ),
              ),
            ],
          ),
          backgroundColor:HexColor(Colors_theme.dark_background),
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
                                  controller: Searchservicecontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.white,
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
                                filter_Servicelist();
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
                      Text("LIST OF SERVICE",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchservicecontroller.text='';
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
                          Text("Visit the service list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  Flexible(child:
                  FutureBuilder(
                    future: getService(),
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
                          if(service_list.length!=0)
                          {
                            return ListView.builder(
                                itemCount:issearching==true ? container_list.length:service_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(context,index)
                                {
                                  Service_model service_data=issearching==true?container_list[index]:service_list[index];
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
                                            children: [
                                              Expanded(
                                                  flex:3,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    children: [
                                                      Text(service_data!.name==''?"--":service_data.name!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(service_data!.cname==''?"--":service_data.cname!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(service_data!.short_descr==''?"--":service_data.short_descr!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(service_data!.long_descr==''?"--":service_data.long_descr!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                    ],
                                                  )
                                              ),
                                              Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.end,
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 3,),
                                                      Row(
                                                        mainAxisAlignment:MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.center,
                                                        children: [
                                                          Text("₹",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                          Text(service_data.price==''?"--":service_data.price!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      service_data.isactive=='1'?
                                                      Text('Active',style: TextStyle(color: Colors.white,fontSize: 14),):
                                                      Text('InActive',style: TextStyle(color: Colors.white,fontSize: 14),),
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
                                                                    getCategory().then((cat_list){
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_service(id:service_data.id!,
                                                                          name:service_data.name!,price:service_data.price!,short_descr:service_data.short_descr!,
                                                                          long_descr:service_data.long_descr!,status:service_data.isactive!,cat_drop_list:cat_list,
                                                                          cname:service_data.cname!,token:token,theme:theme)),);
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
                                                                    Delete_dailog_dark(service_data.id!);
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
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            Searchservicecontroller.text='';
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

  Future getService() async
  {
    service_list=await service.getService(context,token);
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
              "Do yow want to delete the service in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteService(ctx,id);
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
              "Do yow want to delete the service in list?",textAlign: TextAlign.center,style: (TextStyle(color: Colors.white,fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteService(ctx,id);
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

  filter_Servicelist()
  {
    List<Service_model> _details=[];
    _details.addAll(service_list);
    if(Searchservicecontroller.text.isNotEmpty)
    {
      _details.retainWhere((service_list){
        String searchterm=Searchservicecontroller.text.toLowerCase();
        String name=service_list.name!.toLowerCase();
        return name.contains(searchterm);
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
        _details.addAll(service_list);
      });
    }
  }

  Future deleteService(BuildContext ctx,String id) async
  {
    var response=await service.deleteService(id,token);
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

  Future<List<String>> getCategory() async
  {
    cat_drop_list.clear();
    category_list=await Service_category_service.getCategory(context,token);
    for(var data in category_list)
    {
      cat_drop_list.add(data.cname.toString());
    }
    return cat_drop_list;
  }
}
