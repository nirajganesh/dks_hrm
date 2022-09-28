import 'dart:ffi';

import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Salary_type/Salary_type_model.dart';
import 'package:dks_hrm/screen/Employee/Employee.dart';
import 'package:dks_hrm/services/Employee_service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Salary_info extends StatefulWidget {
  String token;
  List<String> salary_drop_list=[];
  String? em_id;
  bool theme;
  Salary_info({required this.em_id,required this.salary_drop_list,
    required this.token,required this.theme,Key? key}) : super(key: key);

  @override
  _Salary_infoState createState() => _Salary_infoState();
}

class _Salary_infoState extends State<Salary_info> {

  final TextEditingController Salarytypecontroller= TextEditingController();
  final TextEditingController Totalsalarycontroller= TextEditingController();

  final TextEditingController Basiccontroller= TextEditingController();
  final TextEditingController Houserentcontroller= TextEditingController();
  final TextEditingController Medicalcontroller= TextEditingController();
  final TextEditingController Conveyencecontroller= TextEditingController();

  final TextEditingController Taxcontroller= TextEditingController();
  final TextEditingController Providentfundcontroller= TextEditingController();
  final TextEditingController Otherscontroller= TextEditingController();


  late String user_id;
  late String sal_id;
  String token='';
  List<Salary_type_model> salary_list=[];
  late String choose_salary;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadUser();
    choose_salary=widget.salary_drop_list.first;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text("Basic Salary",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
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
                          return searchData_salary(textEditingValue.text);
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
                              hintText: choose_salary,
                            ),
                          );
                        },
                        onSelected: (value){
                          // Servicecontroller.text=value.toString();
                          choose_salary=value.toString();
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
                      child: Icon(Icons.monetization_on,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Totalsalarycontroller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        onChanged: (text){
                          setState(() {
                            Basiccontroller.text=(double.parse(text)/2).toString();
                            Medicalcontroller.text=(double.parse(text)/10).toString();
                            Conveyencecontroller.text=(double.parse(text)/10).toString();
                            Houserentcontroller.text=(double.parse(text)/40).toString();
                          });

                          },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Total Salary',
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
              Text("Addition",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
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
                      child: Icon(Icons.credit_card,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Basiccontroller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Basic',
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
                      child: Icon(Icons.credit_card,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Houserentcontroller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Houser Rent',
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
                      child: Icon(Icons.medical_services,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Medicalcontroller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Medical',
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
                      child: Icon(Icons.confirmation_num,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Conveyencecontroller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Conveyence',
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
              Text("Deduction",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
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
                      child: Icon(Icons.credit_card,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Taxcontroller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Tax',
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
                      child: Icon(Icons.credit_card,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Providentfundcontroller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Provident Fund',
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
                      child: Icon(Icons.credit_card,color: Colors.black38),
                    ),
                    Container(
                      width: 1.0,
                      height: 25.0,
                      color:Color(0xff7B7A7A),
                    ),
                    SizedBox(width:8.0),
                    Flexible(
                      child: TextField(
                        controller: Otherscontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Others',
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
                  if(Salarytypecontroller.text.isNotEmpty)
                    {
                       if(Totalsalarycontroller.text.isNotEmpty)
                         {
                           if(Basiccontroller.text.isNotEmpty)
                             {
                               if(Houserentcontroller.text.isNotEmpty)
                                 {
                                    if(Medicalcontroller.text.isNotEmpty)
                                      {
                                        if(Conveyencecontroller.text.isNotEmpty)
                                          {
                                            _onLoading();
                                            updateSalaryinfo();
                                          }
                                        else
                                          {
                                            Notify_widget.notify("Please add the conveyence");
                                          }
                                      }
                                    else
                                      {
                                        Notify_widget.notify("Please add the medical");
                                      }
                                 }
                               else
                                 {
                                   Notify_widget.notify("Please add the house rent");
                                 }
                             }
                           else
                             {
                               Notify_widget.notify("Please add the basic salary");
                             }
                         }
                       else
                         {
                           Notify_widget.notify("Please add the total salary");
                         }
                    }
                  else
                    {
                      Notify_widget.notify("Please add the salary type");
                    }
                },
                child: Text("Save Salary",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text("Basic Salary",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
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
                            return searchData_salary(textEditingValue.text);
                          },
                          fieldViewBuilder: (context,controller,focusnode,onEditingComplete){
                            return TextField(
                              style: TextStyle(height: 1,color: Colors.white24),
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
                                hintText: choose_salary,
                                hintStyle: TextStyle(
                                  color:Colors.white24,
                                )
                              ),
                            );
                          },
                          onSelected: (value){
                            choose_salary=value.toString();
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
                        child: Icon(Icons.monetization_on,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Totalsalarycontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (text){
                            setState(() {
                              Basiccontroller.text=(double.parse(text)/2).toString();
                              Medicalcontroller.text=(double.parse(text)/10).toString();
                              Conveyencecontroller.text=(double.parse(text)/10).toString();
                              Houserentcontroller.text=(double.parse(text)/40).toString();
                            });

                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Total Salary',
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
                Text("Addition",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
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
                        child: Icon(Icons.credit_card,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Basiccontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Basic',
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
                        child: Icon(Icons.credit_card,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Houserentcontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Houser Rent',
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
                        child: Icon(Icons.medical_services,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Medicalcontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Medical',
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
                        child: Icon(Icons.confirmation_num,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Conveyencecontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Conveyence',
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
                Text("Deduction",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
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
                        child: Icon(Icons.credit_card,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Taxcontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Tax',
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
                        child: Icon(Icons.credit_card,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Providentfundcontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Provident Fund',
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
                        child: Icon(Icons.credit_card,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Otherscontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Others',
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
                    if(Salarytypecontroller.text.isNotEmpty)
                    {
                      if(Totalsalarycontroller.text.isNotEmpty)
                      {
                        if(Basiccontroller.text.isNotEmpty)
                        {
                          if(Houserentcontroller.text.isNotEmpty)
                          {
                            if(Medicalcontroller.text.isNotEmpty)
                            {
                              if(Conveyencecontroller.text.isNotEmpty)
                              {
                                _onLoading();
                                updateSalaryinfo();
                              }
                              else
                              {
                                Notify_widget.notify("Please add the conveyence");
                              }
                            }
                            else
                            {
                              Notify_widget.notify("Please add the medical");
                            }
                          }
                          else
                          {
                            Notify_widget.notify("Please add the house rent");
                          }
                        }
                        else
                        {
                          Notify_widget.notify("Please add the basic salary");
                        }
                      }
                      else
                      {
                        Notify_widget.notify("Please add the total salary");
                      }
                    }
                    else
                    {
                      Notify_widget.notify("Please add the salary type");
                    }
                  },
                  child: Text("Save Salary",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
        ),
      );
  }

  LoadUser() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id= (prefs.getString('user_id') ?? '');
    });
  }
  LoadToken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token= (prefs.getString('token') ?? '');
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
                Text("Loading.."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future updateSalaryinfo() async
  {
    salary_list=await Employee_service.getSalary(widget.token);
    for(var sal in salary_list)
    {
      if(choose_salary.toString()==sal.salary_type.toString())
      {
        sal_id=sal.id;
      }
    }
    print(user_id);
    var response=await Employee_service.updateEmp_salary(widget.em_id!,user_id!,sal_id,Totalsalarycontroller.text,
        Basiccontroller.text, Medicalcontroller.text,Houserentcontroller.text,Conveyencecontroller.text,
        Providentfundcontroller.text,Taxcontroller.text,Otherscontroller.text,widget.token);
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

  List<String> searchData_salary(String param)
  {
    List<String> result=widget.salary_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }

}
