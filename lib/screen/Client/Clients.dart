
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/screen/Client/Edit_client.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/widget/App_bar_widget.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Clients extends StatefulWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  _ClientState createState() => _ClientState();
}

class _ClientState extends State<Clients> {

  final TextEditingController Searchclientcontroller= TextEditingController();
  static List<Client_model> client_list=[];
  static List<Client_model> container_list=[];
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
    bool issearching=Searchclientcontroller.text.isNotEmpty;
    return theme==true?
      RefreshIndicator(
      displacement: 250,
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Scaffold(
        appBar: App_bar_widget.App_bar_client(context,"Client",token,Colors_theme.light_app_color,theme),
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
                                controller: Searchclientcontroller,
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
                              filter_clientlist();
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
                    Text("LIST OF CLIENT",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchclientcontroller.text='';
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
                        Text("Visit the client list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(child:
                FutureBuilder(
                  future: getClient(),
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
                          if(client_list.length!=0)
                          {
                            return ListView.builder(
                                itemCount:issearching==true ? container_list.length:client_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(context,index)
                                {
                                  Client_model client_data=issearching==true?container_list[index]:client_list[index];
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
                                          padding: const EdgeInsets.all(6.0),
                                          child:
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex:1,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    children: [
                                                      Text(client_data!.name==''?"--":client_data.name!,style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                                                      SizedBox(height: 5,),
                                                      Text(client_data!.person==''?"--":client_data.person!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(client_data!.email==''?"--":client_data.email!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(client_data!.address==''?"--":client_data.address!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(client_data!.gst_no==''?'--':client_data.gst_no!,style: TextStyle(color: Colors.grey,fontSize: 14),),
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
                                                          Text("+91 ",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          Text(client_data!.contact_no==''?"--":client_data.contact_no!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Row(
                                                        mainAxisAlignment:MainAxisAlignment.end,
                                                        children: [
                                                          Text("₹",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          Text(client_data.balance==''?"--":client_data.balance!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Text(client_data!.remarks==''?'--':client_data.remarks!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.end,
                                                        children: [
                                                          Flexible(
                                                            flex:4,
                                                            child: Row(
                                                              mainAxisAlignment:MainAxisAlignment.end,
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap:(){
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_client(
                                                                        id:client_data.id,name:client_data.name!,person:client_data.person!,contact_no:client_data.contact_no!,email:client_data.email!,
                                                                        gst_no:client_data.gst_no!,address:client_data.address!,remarks:client_data.remarks!,balance:client_data.balance!,token:token,theme:theme
                                                                    )),);
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
                                                                    Delete_dailog(client_data.id);
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
                                              Divider(height: 2,color: Colors.grey,thickness: 1,),
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
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          Searchclientcontroller.text='';
        });
      },
    ):
      RefreshIndicator(
      displacement: 250,
      backgroundColor: HexColor(Colors_theme.dark_background),
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Scaffold(
        appBar: App_bar_widget.App_bar_client(context,"Client",token,Colors_theme.dark_app_color,theme),
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
                                controller: Searchclientcontroller,
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
                              filter_clientlist();
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
                    Text("LIST OF CLIENT",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchclientcontroller.text='';
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
                        Text("Visit the client list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(child:
                FutureBuilder(
                  future: getClient(),
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
                        if(client_list.length!=0)
                        {
                          return ListView.builder(
                              itemCount:issearching==true ? container_list.length:client_list.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder:(context,index)
                              {
                                Client_model client_data=issearching==true?container_list[index]:client_list[index];
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: HexColor(Colors_theme.dark_app_color),
                                      ),
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child:
                                        Row(
                                          children: [
                                            Expanded(
                                                flex:1,
                                                child: Column(
                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                  children: [
                                                    Text(client_data!.name==''?"--":client_data.name!,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                                    SizedBox(height: 5,),
                                                    Text(client_data!.person==''?"--":client_data.person!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Text(client_data!.email==''?"--":client_data.email!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Text(client_data!.address==''?"--":client_data.address!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Text(client_data!.gst_no==''?'--':client_data.gst_no!,style: TextStyle(color: Colors.white24,fontSize: 14),),
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
                                                        Icon(Icons.phone,color: Colors.white,),
                                                        Text("+91 ",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                        Text(client_data!.contact_no==''?"--":client_data.contact_no!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment:MainAxisAlignment.end,
                                                      children: [
                                                        Text("₹",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                        Text(client_data.balance==''?"--":client_data.balance!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Text(client_data!.remarks==''?'--':client_data.remarks!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment:CrossAxisAlignment.end,
                                                      children: [
                                                        Flexible(
                                                          flex:4,
                                                          child: Row(
                                                            mainAxisAlignment:MainAxisAlignment.end,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              TouchRippleEffect(
                                                                borderRadius: BorderRadius.circular(5),
                                                                rippleColor: Colors.white60,
                                                                onTap:(){
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_client(
                                                                      id:client_data.id,name:client_data.name!,person:client_data.person!,contact_no:client_data.contact_no!,email:client_data.email!,
                                                                      gst_no:client_data.gst_no!,address:client_data.address!,remarks:client_data.remarks!,balance:client_data.balance!,token:token,theme:theme
                                                                  )),);
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
                                                                  Delete_dailog_dark(client_data.id);
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
                                            Divider(height: 2,color: Colors.grey,thickness: 1,),
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
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          Searchclientcontroller.text='';
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

  Future getClient() async
  {
    client_list=await Client_service.getClient(context,token);
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
              "Do yow want to delete the Client in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteClient(ctx,id);
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
              "Do yow want to delete the client in list?",textAlign: TextAlign.center,style: (TextStyle(color: Colors.white,fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteClient(ctx,id);
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

  filter_clientlist()
  {
    List<Client_model> _details=[];
    _details.addAll(client_list);
    if(Searchclientcontroller.text.isNotEmpty)
    {
      _details.retainWhere((client_list){
        String searchterm=Searchclientcontroller.text.toLowerCase();
        String name=client_list.name!.toLowerCase();
        String person=client_list.person!.toLowerCase();
        return name.contains(searchterm) || person.contains(searchterm) ;
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
        _details.addAll(client_list);
      });
    }
  }

  Future deleteClient(BuildContext ctx,String id) async
  {
    var response=await Client_service.deleteClient(id,token);
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
