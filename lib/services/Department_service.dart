import 'dart:convert';
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Department/Department_model.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Department_service
{
  static List<Department_model> department_list=[];

  static Future<List<Department_model>> getDepartment(BuildContext context,String token) async
  {
    department_list.clear();
    String url=Api_constants.host+Api_constants.department_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['department_data'];
    print(data_json['department_data']);
    for(var dep in data)
      {
         Department_model department_model=Department_model(dep['id'],dep['dep_name']);
         print(department_model);
         department_list.add(department_model);
      }
    return department_list;
  }

  static Future addDepartment(String dep_name,String token) async
  {
    var body={
      'dep_name':dep_name,
    };
    String url=Api_constants.host+Api_constants.add_department;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future deleteDepartment(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_department+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateDepartment(String id,String dep_name,String token) async
  {
    var body={
      'id':id,
      'dep_name':dep_name,
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.update_department+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

}