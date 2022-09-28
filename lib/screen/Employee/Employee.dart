import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Department/Department_model.dart';
import 'package:dks_hrm/model/Designation/Designation_model.dart';
import 'package:dks_hrm/model/Employee/Employee_model.dart';
import 'package:dks_hrm/model/Salary_type/Salary_type_model.dart';
import 'package:dks_hrm/screen/Dashboard/Dashboard.dart';
import 'package:dks_hrm/screen/Employee/Add_employee.dart';
import 'package:dks_hrm/screen/Employee/Edit_employee.dart';
import 'package:dks_hrm/services/Department_service.dart';
import 'package:dks_hrm/services/Designation_service.dart';
import 'package:dks_hrm/services/Employee_service.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  _EmployeeState createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {

  final TextEditingController Searchemployeecontroller= TextEditingController();
  List<Employee_model> employee_list=[];
  List<Employee_model> container_list=[];
  String token='';
  static List<String> department_drop_list=<String>[];
  List<Department_model> department_list=[];
  static List<String> designation_drop_list=<String>[];
  List<Designation_model> designation_list=[];
  static List<String> salary_drop_list=<String>[];
  List<Salary_type_model> salary_list=[];
  bool empty_checker=false;
  bool theme=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Loadtoken();
    LoadTheme();
  }

  @override
  Widget build(BuildContext context) {
    bool issearching=Searchemployeecontroller.text.isNotEmpty;
    return theme==true?
      RefreshIndicator(
      displacement: 250,
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Scaffold(
        appBar:AppBar(
          title: Text("Employee",style: TextStyle(color: Colors.white),),
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
                  getSalary();
                  getDepartment().then((value){
                    getDesignation().then((designation_list){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_employee(
                        token:token,
                        department_drop_list:department_drop_list,
                        designation_drop_list:designation_drop_list,
                        theme:theme,
                      )),);
                    });
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
                                controller: Searchemployeecontroller,
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
                              filter_employeelist();
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
                    Text("LIST OF EMPLOYEE",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchemployeecontroller.text='';
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
                        Text("Visit the employee list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(child:
                FutureBuilder(
                  future: getEmployee(),
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
                          if(employee_list.length!=0)
                          {
                            return ListView.builder(
                                itemCount:issearching==true ? container_list.length:employee_list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder:(context,index)
                                {
                                  Employee_model emp_data=issearching==true?container_list[index]:employee_list[index];
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
                                                flex:4,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    children: [
                                                      Text(emp_data!.em_code??'--',style: TextStyle(color: Colors.black,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(emp_data!.first_name??'--',style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),
                                                      Text(emp_data!.em_email??'--',style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                      SizedBox(height: 5,),

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
                                                          Icon(Icons.phone,color: Colors.grey,),
                                                          Text("+91 ",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          Text(emp_data!.em_phone?? "--",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Text(emp_data!.em_role??'--',style: TextStyle(color: Colors.blue,fontSize: 14),),
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
                                                                    getDesignation().then((designation_list){
                                                                      getSalary().then((salary_drop_list){
                                                                        getDepartment().then((department_drop_list){
                                                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_employee(
                                                                            id:emp_data!.id,
                                                                            em_id:emp_data!.em_code,
                                                                            employee_model:emp_data,
                                                                            department_drop_list:department_drop_list,
                                                                            designation_drop_list:designation_drop_list,
                                                                            salary_drop_list:salary_drop_list,
                                                                            token:token,
                                                                            gender_name:emp_data.em_gender!,
                                                                            status_name:emp_data.status!,
                                                                            role_name:emp_data.em_role!,
                                                                            dep_id:emp_data.dep_id!,
                                                                            des_id:emp_data.des_id!,
                                                                            theme:theme,
                                                                          )),);
                                                                        });
                                                                      });
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
                                                                    Delete_dailog(emp_data!.id??'');
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
                 ),
                ),
              ],
            ),
          ),
        ),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          Searchemployeecontroller.text='';
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
          title: Text("Employee",style: TextStyle(color: Colors.white),),
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
                  getSalary().then((value){
                    getDepartment().then((value){
                      getDesignation().then((designation_list){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_employee(
                          token:token,
                          department_drop_list:department_drop_list,
                          designation_drop_list:designation_drop_list,
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
                                controller: Searchemployeecontroller,
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
                              filter_employeelist();
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
                    Text("LIST OF EMPLOYEE",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Searchemployeecontroller.text='';
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
                        Text("Visit the employee list",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ):SizedBox(),
                ),
                Flexible(child:
                FutureBuilder(
                  future: getEmployee(),
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
                        if(employee_list.length!=0)
                        {
                          return ListView.builder(
                              itemCount:issearching==true ? container_list.length:employee_list.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder:(context,index)
                              {
                                Employee_model emp_data=issearching==true?container_list[index]:employee_list[index];
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
                                                flex:4,
                                                child: Column(
                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                  children: [
                                                    Text(emp_data!.em_code??'--',style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Text(emp_data!.first_name??'--',style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                    SizedBox(height: 5,),
                                                    Text(emp_data!.em_email??'--',style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                    SizedBox(height: 5,),

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
                                                        Icon(Icons.phone,color: Colors.white,),
                                                        Text("+91 ",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                        Text(emp_data!.em_phone?? "--",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Text(emp_data!.em_role??'--',style: TextStyle(color: Colors.blue,fontSize: 14),),
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
                                                                  getDesignation().then((designation_list){
                                                                    getSalary().then((salary_drop_list){
                                                                      getDepartment().then((department_drop_list){
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_employee(
                                                                          id:emp_data!.id,
                                                                          em_id:emp_data!.em_code,
                                                                          employee_model:emp_data,
                                                                          department_drop_list:department_drop_list,
                                                                          designation_drop_list:designation_drop_list,
                                                                          salary_drop_list:salary_drop_list,
                                                                          token:token,
                                                                          gender_name:emp_data.em_gender!,
                                                                          status_name:emp_data.status!,
                                                                          role_name:emp_data.em_role!,
                                                                          dep_id:emp_data.dep_id!,
                                                                          des_id:emp_data.des_id!,
                                                                          theme:theme,
                                                                        )),);
                                                                      });
                                                                    });
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
                                                                  Delete_dailog_dark(emp_data!.id??'');
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
                ),
                ),
              ],
            ),
          ),
        ),
      ),
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          Searchemployeecontroller.text='';
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

  Future getEmployee() async
  {
    employee_list=await Employee_service.getEmployee(context,token);
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
              "Do yow want to delete the Employee in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteEmployee(ctx,id);
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
              "Do yow want to delete the employee in list?",textAlign: TextAlign.center,style: (TextStyle(color: Colors.white,fontSize: 16,fontFamily:'Montserrat_regular')),
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
                    deleteEmployee(ctx,id);
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

  filter_employeelist()
  {
    List<Employee_model> _details=[];
    _details.addAll(employee_list);
    if(Searchemployeecontroller.text.isNotEmpty)
    {
      _details.retainWhere((employee_list){
        String searchterm=Searchemployeecontroller.text.toLowerCase();
        String first_name=employee_list!.first_name==null?"".toLowerCase():employee_list.first_name!.toLowerCase();
        return first_name.contains(searchterm);
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
        _details.addAll(employee_list);
      });
    }
  }


  Future deleteEmployee(BuildContext ctx,String id) async
  {
    var response=await Employee_service.deleteEmployee(id,token);
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
    department_list=await Department_service.getDepartment(context,token);
    for(var data in department_list)
    {
      department_drop_list.add(data.dep_name.toString());
    }
    return department_drop_list;
  }

  Future<List<String>> getDesignation() async
  {
    designation_drop_list.clear();
    designation_list=await Designation_service.getDesignation(context,token);
    for(var data in designation_list)
    {
      designation_drop_list.add(data.des_name.toString());
    }
    return designation_drop_list;
  }

  Future<List<String>> getSalary() async
  {
    salary_drop_list.clear();
    salary_list=await Employee_service.getSalary(token);
    for(var data in salary_list)
    {
      salary_drop_list.add(data.salary_type.toString());
    }
    return salary_drop_list;
  }

}
