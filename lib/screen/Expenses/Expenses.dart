
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Expenses/Expenses_model.dart';
import 'package:dks_hrm/screen/Expenses/Edit_expenses.dart';
import 'package:dks_hrm/services/Expenses_service.dart';
import 'package:dks_hrm/widget/App_bar_widget.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  final TextEditingController Searchexpensescontroller= TextEditingController();
  List<Expenses_model> expenses_list=[];
  List<Expenses_model> container_list=[];
  String token='';
  bool empty_checker=false;
  var dio = Dio();
  bool downloading = true;
  String downloadingStr = "No data";
  String savePath = "";
  int progress=0;
  ReceivePort _port=ReceivePort();
  bool theme=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadTheme();
    Loadtoken();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      progress = data[2];

      if(status==DownloadTaskStatus.complete)
        {
          Navigator.pop(context);
          Notify_widget.notify("Download Completed");
        }
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }


  @override
  Widget build(BuildContext context) {
    bool issearching=Searchexpensescontroller.text.isNotEmpty;
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
         App_bar_widget.App_bar_expenses(context,"Expenses",token,Colors_theme.light_app_color,theme),
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
                                controller: Searchexpensescontroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search by description..',
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
                              filter_expenseslist();
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
                    Text("LIST OF EXPENSES",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchexpensescontroller.text='';
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
                        Text("Visit the expenses list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(child:
                FutureBuilder(
                  future: getExpenses(),
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
                          if(expenses_list.length!=0)
                          {
                            return ListView.builder(
                                itemCount:issearching==true ? container_list.length:expenses_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(context,index)
                                {
                                  Expenses_model exp_data=issearching==true?container_list[index]:expenses_list[index];
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
                                                    children: [
                                                      Text(exp_data!.descr==''?"--":exp_data.descr!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(exp_data!.date==''?"--":exp_data.date!,style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      GestureDetector(
                                                         onTap:()
                                                          {
                                                            String? url_file=exp_data.file_src ??"";
                                                            String image_url=Api_constants.image_host;
                                                            _onLoading();
                                                            downloadFile(image_url+url_file,exp_data!.file_src??"");
                                                          },
                                                          child: Text(exp_data!.file_src==null?"--":exp_data.file_src!,style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 14),)),
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
                                                          Text("₹"),
                                                          Text(exp_data!.amount==''?"--":exp_data.amount!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.end,
                                                        children: [
                                                          Flexible(
                                                            flex:4,
                                                            child:
                                                            Row(
                                                              mainAxisAlignment:MainAxisAlignment.end,
                                                              children: [
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap:(){
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_expenses(id:exp_data.id!,
                                                                        amount:exp_data.amount!,description:exp_data.descr!,date:exp_data.date!,token:token,theme:theme
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
                                                                    Delete_dailog(exp_data.id!);
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
              ],
            ),
          ),
        ),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          Searchexpensescontroller.text='';
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
          App_bar_widget.App_bar_expenses(context,"Expenses",token,Colors_theme.dark_app_color,theme),
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
                                  controller: Searchexpensescontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search by description..',
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
                                filter_expenseslist();
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
                      Text("LIST OF EXPENSES",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchexpensescontroller.text='';
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
                          Text("Visit the expenses list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  Flexible(child:
                  FutureBuilder(
                    future: getExpenses(),
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
                          if(expenses_list.length!=0)
                          {
                            return ListView.builder(
                                itemCount:issearching==true ? container_list.length:expenses_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(context,index)
                                {
                                  Expenses_model exp_data=issearching==true?container_list[index]:expenses_list[index];
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
                                                    children: [
                                                      Text(exp_data!.descr==''?"--":exp_data.descr!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(exp_data!.date==''?"--":exp_data.date!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      GestureDetector(
                                                          onTap:()
                                                          {
                                                            String? url_file=exp_data.file_src ??"";
                                                            String image_url=Api_constants.image_host;
                                                            _onLoading();
                                                            downloadFile(image_url+url_file,exp_data!.file_src??"");
                                                          },
                                                          child: Text(exp_data!.file_src==null?"--":exp_data.file_src!,style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 14),)),
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
                                                          Text("₹",style: TextStyle(color: Colors.white),),
                                                          Text(exp_data!.amount==''?"--":exp_data.amount!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment:CrossAxisAlignment.end,
                                                        children: [
                                                          Flexible(
                                                            flex:4,
                                                            child:
                                                            Row(
                                                              mainAxisAlignment:MainAxisAlignment.end,
                                                              children: [
                                                                TouchRippleEffect(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  rippleColor: Colors.white60,
                                                                  onTap:(){
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_expenses(id:exp_data.id!,
                                                                        amount:exp_data.amount!,description:exp_data.descr!,date:exp_data.date!,token:token,theme:theme
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
                                                                    Delete_dailog_dark(exp_data.id!);
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
                ],
              ),
            ),
          ),
        ),
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            Searchexpensescontroller.text='';
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



  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 10,),
                Text("Downloading file..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getExpenses() async
  {
    expenses_list=await Expenses_service.getExpenses(context,token);
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
              "Do yow want to delete the expenses in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteExpenses(ctx,id);
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
              "Do yow want to delete the expenses in list?",textAlign: TextAlign.center,style: (TextStyle(color: Colors.white,fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteExpenses(ctx,id);
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

  filter_expenseslist()
  {
    List<Expenses_model> _details=[];
    _details.addAll(expenses_list);
    if(Searchexpensescontroller.text.isNotEmpty)
    {
      _details.retainWhere((proposal_list){
        String searchterm=Searchexpensescontroller.text.toLowerCase();
        String description=proposal_list.descr!.toLowerCase();
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
        _details.addAll(expenses_list);
      });
    }
  }


  Future deleteExpenses(BuildContext ctx,String id) async
  {
    var response=await Expenses_service.deleteExpense(id,token);
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

  void downloadFile(String url,String file_name) async
  {
    final status=await Permission.storage.request();
    if(status.isGranted)
      {
        final baseStorage=await getExternalStorageDirectory();
        final taskId = await FlutterDownloader.enqueue(
          url: url,
          savedDir: baseStorage!.path,
          showNotification: true, // show download progress in status bar (for Android)
          openFileFromNotification: true, // click on notification to open downloaded file (for Android)
        );
      }
    else
      {
         print('No permission');
      }
  }

}
