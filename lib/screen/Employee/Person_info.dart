import 'dart:io';

import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Department/Department_model.dart';
import 'package:dks_hrm/model/Designation/Designation_model.dart';
import 'package:dks_hrm/model/Employee/Employee_model.dart';
import 'package:dks_hrm/screen/Employee/Employee.dart';
import 'package:dks_hrm/services/Department_service.dart';
import 'package:dks_hrm/services/Designation_service.dart';
import 'package:dks_hrm/services/Employee_service.dart';
import 'package:dks_hrm/services/Image_pick.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
class Personal_info extends StatefulWidget {

  String id;
  Employee_model employee_model;
  String token;
  List<String> department_drop_list=[];
  List<String> designation_drop_list=[];
  String gender_name;
  String status_name;
  String role_name;
  String dep_id;
  String des_id;
  bool theme;
  Personal_info({required this.id,required this.employee_model,required this.department_drop_list,
    required this.designation_drop_list,required this.token,required this.gender_name,
    required this.status_name,required this.role_name,required this.dep_id,
    required this.des_id,required this.theme,Key? key}) : super(key: key);

  @override
  _Personal_infoState createState() => _Personal_infoState();
}

class _Personal_infoState extends State<Personal_info> {

  final TextEditingController Namecontroller= TextEditingController();
  final TextEditingController Lastnamecontroller= TextEditingController();
  final TextEditingController Gendercontroller= TextEditingController();
  final TextEditingController Bloodgroupcontroller= TextEditingController();
  final TextEditingController Contactnocontroller= TextEditingController();
  final TextEditingController Emailcontroller= TextEditingController();
  final TextEditingController Dateofbirthcontroller= TextEditingController();

  final TextEditingController Employeecodecontroller= TextEditingController();
  final TextEditingController Departmentcontroller= TextEditingController();
  final TextEditingController Designationcontroller= TextEditingController();
  final TextEditingController Rolecontroller= TextEditingController();
  final TextEditingController Joiningdatecontroller= TextEditingController();
  final TextEditingController Dateofleavingcontroller= TextEditingController();
  final TextEditingController Salarycontroller= TextEditingController();
  final TextEditingController Usertypecontroller= TextEditingController();
  final TextEditingController Statusecontroller= TextEditingController();
  File? file;
  late String choose_department;
  late String dep_id;
  late String choose_designation;
  late String des_id;
  List<String> role_list=<String>['EMPLOYEE','ADMIN','SUPERADMIN'];
  late String choose_role;
  List<String> status_list=<String>['ACTIVE','INACTIVE'];
  late String choose_status;
  List<Designation_model> designation_list=[];
  List<Department_model> department_list=[];
  List<String> gender_list=<String>['Male','Female'];
  late String choose_gender;
  DateTime _dateTime_birth=DateTime.now();
  DateTime _dateTime_join=DateTime.now();
  DateTime _dateTime_leave=DateTime.now();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Namecontroller.text=widget.employee_model!.first_name??"";
    Contactnocontroller.text=widget.employee_model!.em_phone??"";
    Emailcontroller.text=widget.employee_model!.em_email??"";
    Employeecodecontroller.text=widget.employee_model!.em_code??"";
    Departmentcontroller.text=widget.employee_model!.dep_id??"";
    Designationcontroller.text=widget.employee_model!.des_id??"";
    Rolecontroller.text=widget.employee_model!.em_role??"";
    Joiningdatecontroller.text=widget.employee_model!.em_joining_date?? "";

    choose_role=widget.role_name;
    choose_gender=widget.gender_name;
    choose_department=widget.department_drop_list.first;
    choose_designation=widget.designation_drop_list.first;
    choose_status=widget.status_name;

    Dateofbirthcontroller.text=_dateTime_birth.day.toString()+"-"+_dateTime_birth.month.toString()+"-"+_dateTime_birth.year.toString();
    Dateofleavingcontroller.text='Date of leaving';
  }

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55),
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
                          padding:EdgeInsets.all(0) ,
                          child:  file!=null?
                          CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: SizedBox(
                                width: 90,
                                height: 90,
                                child: ClipOval(
                                  child: Image.file(file!,fit: BoxFit.cover,),
                                ),
                              )
                          ):
                          CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: SizedBox(
                                width: 90,
                                height: 90,
                                child: ClipOval(
                                  child:
                                  Image.asset("images/placeholder.jpg"),
                                ),
                              )
                          ),
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:71.0,top: 6),
                      child:
                      GestureDetector(
                        onTap: (){
                          Image_pick.pick().then((value){
                            setState(() {
                              file=value;
                            });
                          });
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.orange,
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
                          child: Icon(Icons.edit,color: Colors.white,size: 18.0),
                        ),
                      ),
                    )
                  ]
              ),
              SizedBox(height: 40,),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: HexColor("#f5f5f5"),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: Icon(Icons.supervised_user_circle_rounded,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Employeecodecontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Employee code',
                            hintStyle: TextStyle(
                                color: Colors.black38
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: HexColor("#f5f5f5"),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: Icon(Icons.person,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Namecontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter the first name',
                            hintStyle: TextStyle(
                                color: Colors.black38
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: HexColor("#f5f5f5"),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: Icon(Icons.person,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Lastnamecontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter the last name',
                            hintStyle: TextStyle(
                                color: Colors.black38
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: HexColor("#f5f5f5"),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: Icon(Icons.person,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Bloodgroupcontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Blood Group',
                            hintStyle: TextStyle(
                                color: Colors.black38
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: HexColor("#f5f5f5"),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: Icon(Icons.repeat,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: DropdownButton(
                        isExpanded: true,
                        value: choose_gender,
                        onChanged: (newvalue){
                          setState(() {
                            choose_gender=newvalue as String;
                          });
                        },
                        underline: SizedBox(),
                        dropdownColor: Colors.white,
                        hint:Text(choose_gender.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
                        items:gender_list.map((valueitem) {
                          return DropdownMenuItem(
                              value: valueitem,
                              child:Text(valueitem.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),)
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: HexColor("#f5f5f5"),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: Icon(Icons.repeat,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: DropdownButton(
                          isExpanded: true,
                          value: choose_role,
                          onChanged: (newvalue){
                            setState(() {
                              choose_role=newvalue as String;
                            });
                          },
                          underline: SizedBox(),
                          dropdownColor: Colors.white,
                          hint:Text(choose_role.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
                          items:role_list.map((valueitem) {
                            return DropdownMenuItem(
                                value: valueitem,
                                child:Text(valueitem.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),)
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: HexColor("#f5f5f5"),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: Icon(Icons.repeat,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: DropdownButton(
                          isExpanded: true,
                          value: choose_status,
                          onChanged: (newvalue){
                            setState(() {
                              choose_status=newvalue as String;
                            });
                          },
                          underline: SizedBox(),
                          dropdownColor: Colors.white,
                          hint:Text(choose_status.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
                          items:status_list.map((valueitem) {
                            return DropdownMenuItem(
                                value: valueitem,
                                child:Text(valueitem.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),)
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                    setState(() {
                      _dateTime_birth=date!;
                      Dateofbirthcontroller.text=_dateTime_birth.day.toString()+"-"+_dateTime_birth.month.toString()+"-"+_dateTime_birth.year.toString();
                    });
                  });
                },
                child:
                GestureDetector(
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        _dateTime_birth=date!;
                        Dateofbirthcontroller.text=_dateTime_birth.day.toString()+"-"+_dateTime_birth.month.toString()+"-"+_dateTime_birth.year.toString();
                      });
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor("#f5f5f5"),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width:10.0),
                        Flexible(
                          child:
                          Row(
                            children: [
                              Icon(Icons.date_range,color: Colors.black38,),
                              SizedBox(width:5),
                              Container(
                                width: 1.0,
                                height: 25.0,
                                color:Color(0xff7B7A7A),
                              ),
                              SizedBox(width:8.0),
                              Text(
                                Dateofbirthcontroller.text,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: HexColor("#f5f5f5"),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: Icon(Icons.phone,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Contactnocontroller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Contact no',
                            hintStyle: TextStyle(
                                color: Colors.black38
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: HexColor("#f5f5f5"),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: Icon(Icons.person,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child:
                      Autocomplete(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return searchData_department(textEditingValue.text);
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
                              hintText: choose_department,
                            ),
                          );
                        },
                        onSelected: (value){
                          // Servicecontroller.text=value.toString();
                          choose_department=value.toString();
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
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: HexColor("#f5f5f5"),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: Icon(Icons.person,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child:
                      Autocomplete(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return searchData_department(textEditingValue.text);
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
                              hintText: choose_designation,
                            ),
                          );
                        },
                        onSelected: (value){
                          // Servicecontroller.text=value.toString();
                          choose_designation=value.toString();
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
              SizedBox(height: 20,),
              GestureDetector(
                onTap:(){
                  showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                    setState(() {
                      _dateTime_join=date!;
                      Joiningdatecontroller.text=_dateTime_leave.day.toString()+"-"+_dateTime_leave.month.toString()+"-"+_dateTime_leave.year.toString();
                    });
                  });
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor("#f5f5f5"),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width:10.0),
                      Flexible(
                        child:
                        Row(
                          children: [
                            Icon(Icons.date_range,color: Colors.black38,),
                            SizedBox(width:5),
                            Container(
                              width: 1.0,
                              height: 25.0,
                              color:Color(0xff7B7A7A),
                            ),
                            SizedBox(width:8.0),
                            Text(
                              Joiningdatecontroller.text,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap:(){
                  showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                    setState(() {
                      _dateTime_leave=date!;
                      Dateofleavingcontroller.text=_dateTime_leave.day.toString()+"-"+_dateTime_leave.month.toString()+"-"+_dateTime_leave.year.toString();
                    });
                  });
                },
                child:
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor("#f5f5f5"),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width:10.0),
                      Flexible(
                        child:
                        Row(
                          children: [
                            Icon(Icons.date_range,color: Colors.black38,),
                            SizedBox(width:5),
                            Container(
                              width: 1.0,
                              height: 25.0,
                              color:Color(0xff7B7A7A),
                            ),
                            SizedBox(width:8.0),
                            Text(
                              Dateofleavingcontroller.text,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: HexColor("#f5f5f5"),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: Icon(Icons.person,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Emailcontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                color: Colors.black38
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  minimumSize: Size(double.infinity, 45),
                ),
                onPressed: () {
                   _onLoading();
                   updatePersonalinfo();
                },
                child: Text("Save Personal Info",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      ),
    ):
      Container(
        decoration: BoxDecoration(
          color: HexColor(Colors_theme.dark_background),
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(55),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding:EdgeInsets.all(0) ,
                          child:  file!=null?
                          CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: SizedBox(
                                width: 90,
                                height: 90,
                                child: ClipOval(
                                  child: Image.file(file!,fit: BoxFit.cover,),
                                ),
                              )
                          ):
                          CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: SizedBox(
                                width: 90,
                                height: 90,
                                child: ClipOval(
                                  child:
                                  Image.asset("images/placeholder.jpg"),
                                ),
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:71.0,top: 6),
                        child:
                        GestureDetector(
                          onTap: (){
                            Image_pick.pick().then((value){
                              setState(() {
                                file=value;
                              });
                            });
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Colors.orange,
                            ),
                            child: Icon(Icons.edit,color: Colors.white,size: 18.0),
                          ),
                        ),
                      )
                    ]
                ),
                SizedBox(height: 40,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.supervised_user_circle_rounded,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Employeecodecontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Employee code',
                              hintStyle: TextStyle(
                                  color: Colors.white24
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color:  HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.person,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Namecontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter the first name',
                              hintStyle: TextStyle(
                                  color: Colors.white24
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.person,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Lastnamecontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter the last name',
                              hintStyle: TextStyle(
                                  color: Colors.white24
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color:  HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.person,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Bloodgroupcontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Blood Group',
                              hintStyle: TextStyle(
                                  color: Colors.white24
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color:  HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.repeat,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: DropdownButton(
                          isExpanded: true,
                          value: choose_gender,
                          onChanged: (newvalue){
                            setState(() {
                              choose_gender=newvalue as String;
                            });
                          },
                          underline: SizedBox(),
                          dropdownColor: Colors.black,
                          hint:Text(choose_gender.toString(),style: TextStyle(color:Colors.white,fontSize: 15),),
                          items:gender_list.map((valueitem) {
                            return DropdownMenuItem(
                                value: valueitem,
                                child:Text(valueitem.toString(),style: TextStyle(color:Colors.white,fontSize: 15),)
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.repeat,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: DropdownButton(
                            isExpanded: true,
                            value: choose_role,
                            onChanged: (newvalue){
                              setState(() {
                                choose_role=newvalue as String;
                              });
                            },
                            underline: SizedBox(),
                            dropdownColor: Colors.black,
                            hint:Text(choose_role.toString(),style: TextStyle(color:Colors.white,fontSize: 15),),
                            items:role_list.map((valueitem) {
                              return DropdownMenuItem(
                                  value: valueitem,
                                  child:Text(valueitem.toString(),style: TextStyle(color:Colors.white,fontSize: 15),)
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color:  HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.repeat,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: DropdownButton(
                            isExpanded: true,
                            value: choose_status,
                            onChanged: (newvalue){
                              setState(()
                              {
                                choose_status=newvalue as String;
                              });
                            },
                            underline: SizedBox(),
                            dropdownColor: Colors.black,
                            hint:Text(choose_status.toString(),style: TextStyle(color:Colors.white24,fontSize: 15),),
                            items:status_list.map((valueitem) {
                              return DropdownMenuItem(
                                  value: valueitem,
                                  child:Text(valueitem.toString(),style: TextStyle(color:Colors.white,fontSize: 15),)
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        _dateTime_birth=date!;
                        Dateofbirthcontroller.text=_dateTime_birth.day.toString()+"-"+_dateTime_birth.month.toString()+"-"+_dateTime_birth.year.toString();
                      });
                    });
                  },
                  child:
                  GestureDetector(
                    onTap: (){
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                        setState(() {
                          _dateTime_birth=date!;
                          Dateofbirthcontroller.text=_dateTime_birth.day.toString()+"-"+_dateTime_birth.month.toString()+"-"+_dateTime_birth.year.toString();
                        });
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color:  HexColor(Colors_theme.dark_app_color),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(width:10.0),
                          Flexible(
                            child:
                            Row(
                              children: [
                                Icon(Icons.date_range,color: Colors.white24,),
                                SizedBox(width:5),
                                Container(
                                  width: 1.0,
                                  height: 25.0,
                                  color:Color(0xff7B7A7A),
                                ),
                                SizedBox(width:8.0),
                                Text(
                                  Dateofbirthcontroller.text,style: (TextStyle(color: Colors.white,fontSize: 14)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color:  HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.phone,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Contactnocontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Contact no',
                              hintStyle: TextStyle(
                                  color: Colors.white24
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.person,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child:
                        Autocomplete(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            return searchData_department(textEditingValue.text);
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
                                hintText: choose_department,
                                hintStyle: TextStyle(
                                  color: Colors.white24
                                )
                              ),
                            );
                          },
                          onSelected: (value){
                            choose_department=value.toString();
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
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.person,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child:
                        Autocomplete(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            return searchData_department(textEditingValue.text);
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
                                hintText: choose_designation,
                                hintStyle: TextStyle(
                                     color:Colors.white24,
                                )
                              ),
                            );
                          },
                          onSelected: (value){
                            choose_designation=value.toString();
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
                SizedBox(height: 20,),
                GestureDetector(
                  onTap:(){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        _dateTime_join=date!;
                        Joiningdatecontroller.text=_dateTime_leave.day.toString()+"-"+_dateTime_leave.month.toString()+"-"+_dateTime_leave.year.toString();
                      });
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor(Colors_theme.dark_app_color),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width:10.0),
                        Flexible(
                          child:
                          Row(
                            children: [
                              Icon(Icons.date_range,color: Colors.white24,),
                              SizedBox(width:5),
                              Container(
                                width: 1.0,
                                height: 25.0,
                                color:Color(0xff7B7A7A),
                              ),
                              SizedBox(width:8.0),
                              Text(
                                Joiningdatecontroller.text,style: (TextStyle(color: Colors.white,fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap:(){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        _dateTime_leave=date!;
                        Dateofleavingcontroller.text=_dateTime_leave.day.toString()+"-"+_dateTime_leave.month.toString()+"-"+_dateTime_leave.year.toString();
                      });
                    });
                  },
                  child:
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor(Colors_theme.dark_app_color),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width:10.0),
                        Flexible(
                          child:
                          Row(
                            children: [
                              Icon(Icons.date_range,color: Colors.white24,),
                              SizedBox(width:5),
                              Container(
                                width: 1.0,
                                height: 25.0,
                                color:Color(0xff7B7A7A),
                              ),
                              SizedBox(width:8.0),
                              Text(
                                Dateofleavingcontroller.text,style: (TextStyle(color: Colors.white,fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color:  HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.person,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Emailcontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  color: Colors.white24
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  onPressed: () {
                    _onLoading();
                    updatePersonalinfo();
                  },
                  child: Text("Save Personal Info",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
        ),
      );
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
                Text("Loading.."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future updatePersonalinfo() async
  {
    department_list=await Department_service.getDepartment(context,widget.token);
    for(var dep in department_list)
    {
      if(choose_department.toString()==dep.dep_name)
      {
        dep_id=dep.id;
      }
    }
    designation_list=await Designation_service.getDesignation(context,widget.token);
    for(var des in designation_list)
    {
      if(choose_designation.toString()==des.des_name)
      {
        des_id=des.id;
      }
    }
    var response=await Employee_service.updateEmp_personalinfo(widget.id,Employeecodecontroller.text,
        Namecontroller.text, Lastnamecontroller.text,Bloodgroupcontroller.text,choose_gender,
        Rolecontroller.text,choose_status,Dateofbirthcontroller.text,Contactnocontroller.text,Emailcontroller.text,dep_id,
        des_id,Joiningdatecontroller.text,Dateofleavingcontroller.text,file?.path??"",widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Employee()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
    }
  }

  List<String> searchData_department(String param)
  {
    List<String> result=widget.department_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }

  List<String> searchData_designation(String param)
  {
    List<String> result=widget.designation_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }



}


