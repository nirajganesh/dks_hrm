import 'dart:convert';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Payroll_type/Payroll_type_model.dart';

class Payroll_type_service
{
  static List<Payroll_type_model> payroll_type_list=[];

  static Future<List<Payroll_type_model>> getPayroll_type(BuildContext context,String token) async
  {
    payroll_type_list.clear();
    String url=Api_constants.host+Api_constants.payroll_type_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['payroll_type_data'];
    print(data_json['payroll_type_data']);
    for(var pay_type in data)
    {
      Payroll_type_model payroll_type_model=Payroll_type_model(pay_type['id'],pay_type['salary_type'],pay_type['create_date']);
      print(payroll_type_model);
      payroll_type_list.add(payroll_type_model);
    }
    return payroll_type_list;
  }

  static Future addPayroll_type_list(String salary_type,String create_date,String token) async
  {
    var body={
      'salary_type':salary_type,
      'create_date':create_date,
    };
    String url=Api_constants.host+Api_constants.add_payroll_type;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future deletePayroll_type(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_payroll_type+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updatePayroll_type(String id,String salary_type,String create_date,String token) async
  {
    var body={
      'id':id,
      'salary_type':salary_type,
      'create_date':create_date,
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.update_payroll_type+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }
}