import 'dart:io';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Department/Department_model.dart';
import 'package:dks_hrm/model/Designation/Designation_model.dart';
import 'package:dks_hrm/screen/Employee/Employee.dart';
import 'package:dks_hrm/services/Department_service.dart';
import 'package:dks_hrm/services/Designation_service.dart';
import 'package:dks_hrm/services/Employee_service.dart';
import 'package:dks_hrm/services/Image_pick.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Add_employee extends StatefulWidget {

  String token;
  List<String> department_drop_list=[];
  List<String> designation_drop_list=[];
  bool theme;
  Add_employee({required this.department_drop_list,required this.designation_drop_list,required this.token,required this.theme,Key? key}) : super(key: key);

  @override
  _Add_employeeState createState() => _Add_employeeState();
}

class _Add_employeeState extends State<Add_employee> {

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
  File? file;
  late String choose_department;
  late String dep_id;
  List<Department_model> department_list=[];
  late String choose_designation;
  late String des_id;
  List<Designation_model> designation_list=[];
  List<String> role_list=<String>['EMPLOYEE','ADMIN','SUPERADMIN'];
  late String choose_role;
  DateTime _dateTime=DateTime.now();


  @override
  void initState() {
    super.initState();
    choose_role=role_list.first;
    choose_department=widget.department_drop_list.first;
    choose_designation=widget.designation_drop_list.first;
    Rolecontroller.text=choose_role;
    Joiningdatecontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Add Employee",style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        child: Icon(Icons.email,color: Colors.black38),
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
                                hintText: "Select Department",
                              ),
                            );
                          },
                          onSelected: (value){
                            // Servicecontroller.text=value.toString();
                            choose_department=value.toString();
                            Departmentcontroller.text=choose_department;
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
                            return searchData_designation(textEditingValue.text);
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
                                hintText: "Select Designation",
                              ),
                            );
                          },
                          onSelected: (value){
                            // Servicecontroller.text=value.toString();
                            choose_designation=value.toString();
                            Designationcontroller.text=choose_designation;
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus)
                            {
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
                                Rolecontroller.text=choose_role;
                              });
                            },
                            underline: SizedBox(),
                            dropdownColor: Colors.black,
                            hint:Text(choose_role.toString()+" ",style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
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
                GestureDetector(
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        _dateTime=date!;
                        Joiningdatecontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
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
                  onTap: (){
                    Image_pick.pick().then((value){
                      setState(() {
                        file=value;
                      });
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      border:Border.all(width: 2.0, color:Theme.of(context).primaryColor),
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload,color: Theme.of(context).primaryColor,),
                        SizedBox(width: 5,),
                        Text("Image Uploaded",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                file==null?
                Text('*No Image Selected',style: TextStyle(fontSize: 16,color:Theme.of(context).textSelectionColor),):
                Text(file!.path.split('/').last.toString(),style: TextStyle(fontSize: 16,color:Theme.of(context).textSelectionColor),),
                SizedBox(height: 40,),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
           if(Namecontroller.text.isNotEmpty)
             {
               if(Contactnocontroller.text.isNotEmpty)
                 {
                   if(Emailcontroller.text.isNotEmpty)
                     {
                       if(Employeecodecontroller.text.isNotEmpty)
                         {
                           if(Departmentcontroller.text.isNotEmpty)
                             {
                               if(Designationcontroller.text.isNotEmpty)
                                 {
                                   if(Rolecontroller.text.isNotEmpty)
                                     {
                                       if(Joiningdatecontroller.text.isNotEmpty)
                                         {
                                           _onLoading();
                                           addEmployee();
                                         }
                                       else
                                         {
                                           Notify_widget.notify("Please add the joining date");
                                         }
                                     }
                                   else
                                     {
                                       Notify_widget.notify("Please add the roll of employee");
                                     }
                                 }
                               else
                                 {
                                   Notify_widget.notify("Please add the designation name");
                                 }
                             }
                           else
                             {
                               Notify_widget.notify("Please add the department name");
                             }
                         }
                       else
                         {
                           Notify_widget.notify("Please add the employee code");
                         }
                     }
                   else
                     {
                       Notify_widget.notify("Please add the email id");
                     }
                 }
               else
                 {
                   Notify_widget.notify("Please add the contact number");
                 }
             }
           else
             {
               Notify_widget.notify("Please add the name");
             }

        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Employee",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    ):
      Scaffold(
      appBar: AppBar(
        title: Text("Add Employee",style: TextStyle(color: Colors.white),),
        backgroundColor: HexColor(Colors_theme.dark_app_color),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: HexColor(Colors_theme.dark_background),
      body:Container(
        decoration: BoxDecoration(
          color: HexColor(Colors_theme.dark_background),
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        child: Icon(Icons.email,color: Colors.white24),
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
                        Theme(
                          data: ThemeData(
                              canvasColor: Colors.black
                          ),
                          child: Autocomplete(
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
                                  hintText: "Select Department",
                                  hintStyle: TextStyle(
                                    color: Colors.white24,
                                  )
                                ),
                              );
                            },
                            onSelected: (value){
                              choose_department=value.toString();
                              Departmentcontroller.text=choose_department;
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
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
                            return searchData_designation(textEditingValue.text);
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
                                hintText: "Select Designation",
                                  hintStyle: TextStyle(
                                    color: Colors.white24,
                                  )
                              ),
                            );
                          },
                          onSelected: (value){
                            // Servicecontroller.text=value.toString();
                            choose_designation=value.toString();
                            Designationcontroller.text=choose_designation;
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
                                Rolecontroller.text=choose_role;
                              });
                            },
                            underline: SizedBox(),
                            dropdownColor: Colors.black,
                            hint:Text(choose_role.toString()+" ",style: TextStyle(color:Colors.white24,fontSize: 15),),
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
                GestureDetector(
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        _dateTime=date!;
                        Joiningdatecontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
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
                                Joiningdatecontroller.text,style: (TextStyle(color:Colors.white,fontSize: 14)),
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
                  onTap: (){
                    Image_pick.pick().then((value){
                      setState(() {
                        file=value;
                      });
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor(Colors_theme.dark_app_color),
                      borderRadius: BorderRadius.circular(40),
                      border:Border.all(width: 2.0, color:Theme.of(context).primaryColor),
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload,color: Theme.of(context).primaryColor,),
                        SizedBox(width: 5,),
                        Text("Image Uploaded",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                file==null?
                Text('*No Image Selected',style: TextStyle(fontSize: 16,color:Colors.white24),):
                Text(file!.path.split('/').last.toString(),style: TextStyle(fontSize: 16,color:Theme.of(context).textSelectionColor),),
                SizedBox(height: 40,),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          if(Namecontroller.text.isNotEmpty)
          {
            if(Contactnocontroller.text.isNotEmpty)
            {
              if(Emailcontroller.text.isNotEmpty)
              {
                if(Employeecodecontroller.text.isNotEmpty)
                {
                  if(Departmentcontroller.text.isNotEmpty)
                  {
                    if(Designationcontroller.text.isNotEmpty)
                    {
                      if(Rolecontroller.text.isNotEmpty)
                      {
                        if(Joiningdatecontroller.text.isNotEmpty)
                        {
                          _onLoading();
                          addEmployee();
                        }
                        else
                        {
                          Notify_widget.notify("Please add the joining date");
                        }
                      }
                      else
                      {
                        Notify_widget.notify("Please add the roll of employee");
                      }
                    }
                    else
                    {
                      Notify_widget.notify("Please add the designation name");
                    }
                  }
                  else
                  {
                    Notify_widget.notify("Please add the department name");
                  }
                }
                else
                {
                  Notify_widget.notify("Please add the employee code");
                }
              }
              else
              {
                Notify_widget.notify("Please add the email id");
              }
            }
            else
            {
              Notify_widget.notify("Please add the contact number");
            }
          }
          else
          {
            Notify_widget.notify("Please add the name");
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Employee",style: TextStyle(color: Colors.white,fontSize: 16),)),
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

  Future addEmployee() async
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
    var response=await Employee_service.addEmployee(Namecontroller.text,Contactnocontroller.text
        ,Emailcontroller.text,Employeecodecontroller.text,dep_id,des_id,Rolecontroller.text,Joiningdatecontroller.text,
        file?.path??"",widget.token);
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
