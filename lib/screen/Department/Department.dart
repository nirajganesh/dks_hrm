import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Department/Department_model.dart';
import 'package:dks_hrm/screen/Department/Edit_department.dart';
import 'package:dks_hrm/services/Department_service.dart';
import 'package:dks_hrm/widget/App_bar_widget.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class Department extends StatefulWidget {
  const Department({Key? key}) : super(key: key);

  @override
  _DepartmentState createState() => _DepartmentState();

}

class _DepartmentState extends State<Department> {

  final TextEditingController Searchdepartmentcontroller= TextEditingController();
  static List<Department_model> department_list=[];
  static List<Department_model> container_list=[];

  String token='';
  bool theme=false;
  bool empty_checker=false;


  @override
  void initState() {
    super.initState();
    LoadTheme();
    Loadtoken();
  }

  @override
  Widget build(BuildContext context) {
    bool issearching=Searchdepartmentcontroller.text.isNotEmpty;
    return theme==true?
      RefreshIndicator(
        displacement: 250,
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: Scaffold(
          appBar:App_bar_widget.App_bar_department(context,"Department",token,Colors_theme.light_app_color),
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
                                      controller: Searchdepartmentcontroller,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Search Department..',
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
                                    filter_departmentlist();
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
                      Text("LIST OF DEPARTMENT",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Searchdepartmentcontroller.text='';
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
                          Text("Visit the department list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ):SizedBox(),
                  ),
                  Flexible(
                    child:
                    FutureBuilder(
                      future: getDepartment(),
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
                              if(department_list.length!=0)
                              {
                                return ListView.builder(
                                    itemCount:issearching==true ? container_list.length:department_list.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder:(context,index)
                                    {
                                      Department_model dep_data=issearching==true?container_list[index]:department_list[index];
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
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex:3,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(dep_data.dep_name.toString(),maxLines: 2,overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        ],
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex:2,
                                                      child: Row(
                                                        mainAxisAlignment:MainAxisAlignment.end,
                                                        children: [
                                                          TouchRippleEffect(
                                                            borderRadius: BorderRadius.circular(5),
                                                            rippleColor: Colors.white60,
                                                            onTap:(){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_department(id:dep_data.id,dep_name:dep_data.dep_name,token: token,theme:theme)),);
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
                                                              Delete_dailog(dep_data.id);
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
                                                    )
                                                  ],
                                                ),
                                              )
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
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
        onRefresh: () async {
           await Future.delayed(Duration(milliseconds: 500));
           setState(() {
             Searchdepartmentcontroller.text='';
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
        appBar:App_bar_widget.App_bar_department(context,"Department",token,Colors_theme.dark_app_color),
        backgroundColor: HexColor(Colors_theme.dark_background) ,
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
                                controller: Searchdepartmentcontroller,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search Department..',
                                    hintStyle: TextStyle(
                                        color: Colors.white30
                                    )
                                ),
                              ),
                            ),
                          ),
                          TouchRippleEffect(
                            borderRadius: BorderRadius.circular(5),
                            rippleColor: Colors.white60,
                            onTap:(){
                              filter_departmentlist();
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
                    Text("LIST OF DEPARTMENT",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchdepartmentcontroller.text='';
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
                        Text("Visit the department list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(
                  child:
                  FutureBuilder(
                    future: getDepartment(),
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
                          if(department_list.length!=0)
                          {
                            return ListView.builder(
                                itemCount:issearching==true ? container_list.length:department_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(context,index)
                                {
                                  Department_model dep_data=issearching==true?container_list[index]:department_list[index];
                                  return Column(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: HexColor(Colors_theme.dark_app_color),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  flex:3,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(dep_data.dep_name.toString(),maxLines: 2,overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  flex:2,
                                                  child: Row(
                                                    mainAxisAlignment:MainAxisAlignment.end,
                                                    children: [
                                                      TouchRippleEffect(
                                                        borderRadius: BorderRadius.circular(5),
                                                        rippleColor: Colors.white60,
                                                        onTap:(){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_department(id:dep_data.id,dep_name:dep_data.dep_name,token: token,theme: theme,)),);
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
                                                          Delete_dailog_dark(dep_data.id);
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
                                                )
                                              ],
                                            ),
                                          )
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
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          Searchdepartmentcontroller.text='';
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

  Future getDepartment() async
  {
    department_list=await Department_service.getDepartment(context,token);
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
              "Do yow want to delete the department in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteDepartment(ctx,id);
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
              "Do yow want to delete the department in list?",textAlign: TextAlign.center,style: (TextStyle(color: Colors.white,fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteDepartment(ctx,id);
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

  filter_departmentlist()
  {
    List<Department_model> _details=[];
    _details.addAll(department_list);
    if(Searchdepartmentcontroller.text.isNotEmpty)
    {
        _details.retainWhere((department_list){
        String searchterm=Searchdepartmentcontroller.text.toLowerCase();
        String dep_name=department_list.dep_name.toLowerCase();
        return dep_name.contains(searchterm);
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
          _details.addAll(department_list);
        });
    }
  }

  Future deleteDepartment(BuildContext ctx,String id) async
  {
    var response=await Department_service.deleteDepartment(id,token);
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
