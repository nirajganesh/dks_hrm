import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Department/Department_model.dart';
import 'package:dks_hrm/model/Payroll_list/Generate_payslip_model.dart';
import 'package:dks_hrm/model/Payroll_list/Payroll_list_model.dart';
import 'package:dks_hrm/services/Department_service.dart';
import 'package:dks_hrm/services/Payroll_list_service.dart';
import 'package:dks_hrm/widget/Empty_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:url_launcher/url_launcher.dart';
class Add_payslips extends StatefulWidget {

  List<String> department_drop_list=[];
  String token;
  var department_data;
  List<Department_model> department_list=[];
  bool theme;
  Add_payslips({required this.department_drop_list,required this.department_data,
    required this.department_list,required this.token,required this.theme,Key? key}) : super(key: key);

  @override
  _Add_payslipsState createState() => _Add_payslipsState();
}

class _Add_payslipsState extends State<Add_payslips> {
  final TextEditingController Departmentcontroller= TextEditingController();
  final TextEditingController Datecontroller= TextEditingController();
  late String choose_payslip;
  bool checker=false;
  List<Generate_payslip_model> generate_payslip_list=[];
  List<Payroll_list_model> container_list=[];
  List<Department_model> department_list=[];
  late String dep_id;
  List<Generate_payslip_model> generate_pay_list=[];

  @override
  void initState() {
    super.initState();
    choose_payslip=widget.department_drop_list.first;
    print(widget.department_data);
  }

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Generate Payslips",style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                    children: [
                       Flexible(
                           flex: 3,
                           child:
                           Container(
                             alignment: Alignment.centerLeft,
                             decoration: BoxDecoration(
                               color: HexColor("#f5f5f5"),
                               borderRadius: BorderRadius.circular(40),
                             ),
                             height: 50,
                             child: Padding(
                               padding: const EdgeInsets.only(left:8.0),
                               child: Row(
                                 children: [
                                   Flexible(
                                     child:
                                     Autocomplete(
                                       optionsBuilder: (TextEditingValue textEditingValue) {
                                         return searchData(textEditingValue.text);
                                       },
                                       fieldViewBuilder: (context,controller,focusnode,onEditingComplete){
                                         return TextField(
                                           style: TextStyle(height: 1),
                                           controller: controller,
                                           focusNode: focusnode,
                                           onEditingComplete: onEditingComplete,
                                           decoration: InputDecoration(
                                             enabledBorder: UnderlineInputBorder(
                                               borderSide: BorderSide(color: Color(0xff00ffffff)),
                                             ),
                                             focusedBorder: UnderlineInputBorder(
                                               borderSide: BorderSide(color: Color(0xff00ffffff)),
                                             ),
                                             hintText: "Select Department",
                                           ),
                                         );
                                       },
                                       onSelected: (value){
                                         // Servicecontroller.text=value.toString();
                                         choose_payslip=value.toString();
                                         FocusScopeNode currentFocus = FocusScope.of(context);
                                         if (!currentFocus.hasPrimaryFocus) {
                                           currentFocus.unfocus();
                                         }
                                       },
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                       ),
                      SizedBox(width: 7,),
                      Flexible(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: HexColor("#f5f5f5"),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          height: 50,
                          child: Row(
                            children: [
                              SizedBox(width:8.0),
                              Flexible(
                                child: TextField(
                                  controller: Datecontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Month',
                                      hintStyle: TextStyle(
                                          color: Colors.black38
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 7,),
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
                Flexible(
                  child: FutureBuilder(
                        future: generatePayslips(),
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
                              if(generate_payslip_list.length!=0)
                              {
                                return ListView.builder(
                                      itemCount:generate_payslip_list.length,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder:(context,index)
                                      {
                                        Generate_payslip_model generate_data=generate_payslip_list[index];
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
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                              flex:3,
                                                              child:Column(
                                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(generate_data.emp_id.toString(),style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                  SizedBox(height: 5,),
                                                                  Text(generate_data.first_name.toString(),style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                                  SizedBox(height: 5,),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex:3,
                                                              child:Column(
                                                                crossAxisAlignment:CrossAxisAlignment.end,
                                                                children: [
                                                                  generate_data!.total_pay==null?
                                                                  Row(
                                                                    mainAxisAlignment:MainAxisAlignment.end,
                                                                    children: [
                                                                      Text("---",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                    //  Text("(Total pay)",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                    ],
                                                                  ):
                                                                  Row(
                                                                    mainAxisAlignment:MainAxisAlignment.end,
                                                                    children: [
                                                                      Text("₹ ",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                      Text(generate_data!.total_pay==null?"--":generate_data.total_pay!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                      Text("(Total pay)",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  Row(
                                                                    mainAxisAlignment:MainAxisAlignment.end,
                                                                    children: [
                                                                      Text("₹ ",style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                                      Text(generate_data.bonus.toString(),style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                                      Text("(Bonus)",style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  TouchRippleEffect(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    rippleColor: Colors.white60,
                                                                          onTap:(){
                                                                            _launchURL(generate_data.emp_id!,generate_data.pay_id!);
                                                                          },
                                                                          child: Container(
                                                                            width:40,
                                                                            height:40,
                                                                            decoration:BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(25),
                                                                              color: Color(0xffFFA74D),
                                                                            ),
                                                                            child:Icon(Icons.print,color:Colors.white,size: 20,),
                                                                          ),
                                                                        ),
                                                                  SizedBox(width: 5,),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    ):
      Scaffold(
        appBar: AppBar(
          title: Text("Generate Payslips",style: TextStyle(color: Colors.white),),
          backgroundColor: HexColor(Colors_theme.dark_app_color),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: HexColor(Colors_theme.dark_background),
        body: Container(
          decoration: BoxDecoration(
            color: HexColor(Colors_theme.dark_background),
          ),
          child: Padding(
            padding: EdgeInsets.all(14),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child:
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: HexColor(Colors_theme.dark_app_color),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Row(
                              children: [
                                Flexible(
                                  child:
                                  Autocomplete(
                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                      return searchData(textEditingValue.text);
                                    },
                                    fieldViewBuilder: (context,controller,focusnode,onEditingComplete){
                                      return TextField(
                                        style: TextStyle(height: 1,color: Colors.white),
                                        controller: controller,
                                        focusNode: focusnode,
                                        onEditingComplete: onEditingComplete,
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xff00ffffff)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xff00ffffff)),
                                          ),
                                          hintText: "Select Department",
                                          hintStyle: TextStyle(
                                            color: Colors.white24
                                          )
                                        ),
                                      );
                                    },
                                    onSelected: (value){
                                      choose_payslip=value.toString();
                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 7,),
                      Flexible(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: HexColor(Colors_theme.dark_app_color),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          height: 50,
                          child: Row(
                            children: [
                              SizedBox(width:8.0),
                              Flexible(
                                child: TextField(
                                  controller: Datecontroller,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Month',
                                      hintStyle: TextStyle(
                                          color: Colors.white24
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 7,),
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
                  Flexible(
                    child: FutureBuilder(
                        future: generatePayslips(),
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
                            if(generate_payslip_list.length!=0)
                            {
                              return ListView.builder(
                                  itemCount:generate_payslip_list.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder:(context,index)
                                  {
                                    Generate_payslip_model generate_data=generate_payslip_list[index];
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
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          flex:3,
                                                          child:Column(
                                                            crossAxisAlignment:CrossAxisAlignment.start,
                                                            children: [
                                                              Text(generate_data.emp_id.toString(),style: TextStyle(color: Colors.white,fontSize: 14),),
                                                              SizedBox(height: 5,),
                                                              Text(generate_data.first_name.toString(),style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                              SizedBox(height: 5,),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex:3,
                                                          child:Column(
                                                            crossAxisAlignment:CrossAxisAlignment.end,
                                                            children: [
                                                              generate_data!.total_pay==null?
                                                              Row(
                                                                mainAxisAlignment:MainAxisAlignment.end,
                                                                children: [
                                                                  Text("---",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                                  //  Text("(Total pay)",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                ],
                                                              ):
                                                              Row(
                                                                mainAxisAlignment:MainAxisAlignment.end,
                                                                children: [
                                                                  Text("₹ ",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                                  Text(generate_data!.total_pay==null?"--":generate_data.total_pay!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                  Text("(Total pay)",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Row(
                                                                mainAxisAlignment:MainAxisAlignment.end,
                                                                children: [
                                                                  Text("₹ ",style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                                  Text(generate_data.bonus.toString(),style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                                  Text("(Bonus)",style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              TouchRippleEffect(
                                                                borderRadius: BorderRadius.circular(5),
                                                                rippleColor: Colors.white60,
                                                                onTap:(){
                                                                  _launchURL(generate_data.emp_id!,generate_data.pay_id!);
                                                                },
                                                                child: Container(
                                                                  width:40,
                                                                  height:40,
                                                                  decoration:BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(25),
                                                                    color: Color(0xffFFA74D),
                                                                  ),
                                                                  child:Icon(Icons.print,color:Colors.white,size: 20,),
                                                                ),
                                                              ),
                                                              SizedBox(width: 5,),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Future<String> getDepartment(String choose_pay) async {
    department_list=await Department_service.getDepartment(context,widget.token);
    for(var dep in department_list)
    {
      if(choose_pay.toString()==dep.dep_name)
      {
        dep_id=dep.id;
      }
    }
    return dep_id;
  }

  Future generatePayslips() async
  {
      for(var dep in widget.department_list)
      {
        if(choose_payslip.toString()==dep.dep_name)
        {
          dep_id=dep.id;
        }
      }
    generate_payslip_list=await Payroll_list_service.getGenerate_Payroll_list(dep_id,widget.token);
  }

  void _launchURL(String emp_id,String pay_id) async {
    String url=Api_constants.payslip_invoice+"/"+emp_id+"/"+pay_id;
    if (!await launch(url)) throw 'Could not launch $url';
  }

  List<String> searchData(String param)
  {
    List<String> result=widget.department_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }

}
