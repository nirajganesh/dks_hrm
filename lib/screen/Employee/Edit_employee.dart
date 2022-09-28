import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Department/Department_model.dart';
import 'package:dks_hrm/model/Designation/Designation_model.dart';
import 'package:dks_hrm/model/Employee/Employee_model.dart';
import 'package:dks_hrm/model/Salary_type/Salary_type_model.dart';
import 'package:dks_hrm/screen/Employee/Address.dart';
import 'package:dks_hrm/screen/Employee/Bank_info.dart';
import 'package:dks_hrm/screen/Employee/Change_password.dart';
import 'package:dks_hrm/screen/Employee/Document.dart';
import 'package:dks_hrm/screen/Employee/Person_info.dart';
import 'package:dks_hrm/screen/Employee/Salary_info.dart';
import 'package:dks_hrm/screen/Employee/Social_media.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Edit_employee extends StatefulWidget {
  String? id;
  String? em_id;
  Employee_model employee_model;
  String token;
  List<String> department_drop_list=<String>[];
  List<String> designation_drop_list=<String>[];
  List<String> salary_drop_list=<String>[];
  String gender_name;
  String status_name;
  String role_name;
  String dep_id;
  String des_id;
  bool theme;

  Edit_employee({required this.id,required this.em_id,required this.employee_model,required this.department_drop_list,required this.designation_drop_list,
    required this.salary_drop_list,required this.token,required this.gender_name,
    required this.status_name,required this.role_name,required this.dep_id,
    required this.des_id,required this.theme,Key? key}) : super(key: key);

  @override
  _Edit_employeeState createState() => _Edit_employeeState();
}

class _Edit_employeeState extends State<Edit_employee> {

  List<Department_model> department_list=[];
  List<Designation_model> designation_list=[];
  List<Salary_type_model> salary_type_list=[];

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Scaffold(
      body: DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Edit Employee",style: TextStyle(color: Colors.white),),
            backgroundColor: Theme.of(context).primaryColor,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color:Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.person,color: Colors.white,)),
                Tab(icon: Icon(Icons.location_on,color: Colors.white,)),
                Tab(icon: Icon(Icons.credit_card,color: Colors.white,)),
                Tab(icon: Icon(Icons.file_copy,color: Colors.white,)),
                Tab(icon: Icon(Icons.monetization_on,color: Colors.white,)),
                Tab(icon: Icon(Icons.supervised_user_circle_rounded,color: Colors.white,)),
                Tab(icon: Icon(Icons.lock,color: Colors.white,)),
              ],
            ),
          ),
          body:TabBarView(
            children: [
              Personal_info(
                  id:widget.id!,
                  employee_model:widget.employee_model,
                  department_drop_list:widget.department_drop_list,
                  designation_drop_list:widget.designation_drop_list,
                  gender_name:widget.gender_name,
                  status_name:widget.status_name,
                  role_name:widget.role_name,
                  dep_id:widget.dep_id,
                  des_id:widget.des_id,
                  token:widget.token,
                  theme:widget.theme,
              ),
              Address(
                id:widget.id,
                theme:widget.theme,
              ),
              Bank_info(
                theme:widget.theme,
              ),
              Document(
                theme:widget.theme,
              ),
              Salary_info(em_id:widget.em_id,salary_drop_list:widget.salary_drop_list,
                  token:widget.token,theme:widget.theme),
              Social_media(
                  theme:widget.theme
              ),
              Change_password(id:widget.id!,theme:widget.theme),
            ],
          ),
        ),
      ),
    ):
      Scaffold(
        body: DefaultTabController(
          length: 7,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Edit Employee",style: TextStyle(color: Colors.white),),
              backgroundColor: HexColor(Colors_theme.dark_app_color),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color:Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              bottom: const TabBar(
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(icon: Icon(Icons.person,color: Colors.white,)),
                  Tab(icon: Icon(Icons.location_on,color: Colors.white,)),
                  Tab(icon: Icon(Icons.credit_card,color: Colors.white,)),
                  Tab(icon: Icon(Icons.file_copy,color: Colors.white,)),
                  Tab(icon: Icon(Icons.monetization_on,color: Colors.white,)),
                  Tab(icon: Icon(Icons.supervised_user_circle_rounded,color: Colors.white,)),
                  Tab(icon: Icon(Icons.lock,color: Colors.white,)),
                ],
              ),
            ),
            body:TabBarView(
              children: [
                Personal_info(
                    id:widget.id!,
                    employee_model:widget.employee_model,
                    department_drop_list:widget.department_drop_list,
                    designation_drop_list:widget.designation_drop_list,
                    gender_name:widget.gender_name,
                    status_name:widget.status_name,
                    role_name:widget.role_name,
                    dep_id:widget.dep_id,
                    des_id:widget.des_id,
                    token:widget.token,
                    theme:widget.theme,
                ),
                Address(
                  id:widget.id,
                  theme:widget.theme,
                ),
                Bank_info(
                  theme:widget.theme,
                ),
                Document(
                  theme:widget.theme,
                ),
                Salary_info(em_id:widget.em_id,salary_drop_list:widget.salary_drop_list,
                    token:widget.token,theme:widget.theme),
                Social_media(
                    theme:widget.theme
                ),
                Change_password(id:widget.id!,theme:widget.theme),
              ],
            ),
          ),
        ),
      );
  }




}
