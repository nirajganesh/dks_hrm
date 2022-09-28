import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Employee/Employee_model.dart';
import 'package:dks_hrm/model/Todo/Todo_model.dart';
import 'package:dks_hrm/screen/Dashboard/Dashboard.dart';
import 'package:dks_hrm/screen/Todo/Add_todo.dart';
import 'package:dks_hrm/services/Employee_service.dart';
import 'package:dks_hrm/services/Todo_service.dart';
import 'package:dks_hrm/widget/App_bar_widget.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {

  final TextEditingController Searchtodocontroller= TextEditingController();
  static List<Todo_model> todo_list=[];
  static List<Todo_model> container_list=[];
  String token='';
  static List<Employee_model> employee_list=[];
  static List<String> employee_drop_list=[];
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
    bool issearching=Searchtodocontroller.text.isNotEmpty;
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
          title: Text("Todo",style: TextStyle(color: Colors.white),),
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
                  getEmployee().then((employee_drop_list){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_todo(
                      token:token,
                      employee_drop_list:employee_drop_list,
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
                                controller: Searchtodocontroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search by todo date..',
                                    hintStyle: TextStyle(
                                        color: Colors.black38
                                    )
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap:(){
                              filter_todolist();
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
                    Text("LIST OF TODO",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchtodocontroller.text='';
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
                        Text("Visit the todo list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(
                  child:
                  FutureBuilder(
                    future: getTodo(),
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
                            if(todo_list.length!=0)
                            {
                              return ListView.builder(
                                  itemCount:issearching==true ? container_list.length:todo_list.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder:(context,index)
                                  {
                                    Todo_model todo_data=issearching==true?container_list[index]:todo_list[index];
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
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex:1,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 10,),
                                                          Text(todo_data.to_dodata!,
                                                            style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex:2,
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(todo_data.date!,overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          SizedBox(width: 15,),
                                                          GestureDetector(
                                                            onTap: (){
                                                              Delete_dailog(todo_data.id!);
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
          Searchtodocontroller.text='';
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
            title: Text("Todo",style: TextStyle(color: Colors.white),),
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
                    getEmployee().then((employee_drop_list){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_todo(
                        token:token,
                        employee_drop_list:employee_drop_list,
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
                                  controller: Searchtodocontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search by todo date..',
                                      hintStyle: TextStyle(
                                          color: Colors.white24
                                      )
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap:(){
                                filter_todolist();
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
                      Text("LIST OF TODO",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchtodocontroller.text='';
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
                          Text("Visit the to do list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  Flexible(
                    child:
                    FutureBuilder(
                      future: getTodo(),
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
                            if(todo_list.length!=0)
                            {
                              return ListView.builder(
                                  itemCount:issearching==true ? container_list.length:todo_list.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder:(context,index)
                                  {
                                    Todo_model todo_data=issearching==true?container_list[index]:todo_list[index];
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
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex:1,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 10,),
                                                          Text(todo_data.to_dodata!,
                                                            style: TextStyle(color: Colors.white,fontSize: 14),),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex:2,
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(todo_data.date!,overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            style: TextStyle(color: Colors.white,fontSize: 14),),
                                                          SizedBox(width: 15,),
                                                          GestureDetector(
                                                            onTap: (){
                                                              Delete_dailog_dark(todo_data.id!);
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
            Searchtodocontroller.text='';
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

  Future getTodo() async
  {
    todo_list=await Todo_service.getTodo(context,token);
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
              "Do yow want to delete the todo in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteTodo(ctx,id);
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
                    deleteTodo(ctx,id);
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

  filter_todolist()
  {
    List<Todo_model> _details=[];
    _details.addAll(todo_list);
    if(Searchtodocontroller.text.isNotEmpty)
    {
      _details.retainWhere((todo_list){
        String searchterm=Searchtodocontroller.text.toLowerCase();
        String value=todo_list.date!.toLowerCase();
        return value.contains(searchterm);
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
        _details.addAll(todo_list);
      });
    }
  }

  Future deleteTodo(BuildContext ctx,String id) async
  {
    var response=await Todo_service.deleteTodo(id,token);
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

  Future<List<String>> getEmployee() async
  {
    employee_drop_list.clear();
    employee_list=await Employee_service.getEmployee(context,token);
    for(var data in employee_list)
    {
      employee_drop_list.add(data.em_id.toString());
    }
    return employee_drop_list;
  }
}
