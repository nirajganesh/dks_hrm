import 'dart:convert';
import 'package:dks_hrm/model/Payroll_list/Generate_payslip_model.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Payroll_list/Payroll_list_model.dart';

class Payroll_list_service
{
  static List<Payroll_list_model> payroll_list=[];
  static List<Generate_payslip_model> generate_pay_list=[];

  static Future<List<Payroll_list_model>> getPayroll_list(BuildContext context,String token) async
  {
    payroll_list.clear();
    String url=Api_constants.host+Api_constants.payroll_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['payroll_list_data'];
    print(data_json['payroll_list_data']);
    for(var pay in data)
    {
      Payroll_list_model payroll_model=Payroll_list_model(pay['pay_id'],pay['emp_id'],pay['type_id'],pay['month'],pay['year']
      ,pay['paid_date'],pay['total_days'],pay['basic'],pay['medical'],pay['house_rent'],pay['bima'],pay['tax'],pay['provident_fund'],
          pay['em_code'],pay['total_pay'],pay['bonus'],pay['dep_id'],pay['first_name']);
      print(payroll_model);
      payroll_list.add(payroll_model);
    }
    return payroll_list;
  }


  static Future<List<Generate_payslip_model>> getGenerate_Payroll_list(String dep_id,String token) async
  {
    generate_pay_list.clear();
    var body={
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.generate_payslip+"/"+dep_id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    var data_json=json_response['data'];
    List data=data_json['payslip data'];
    print(data_json['payslip data']);
    for(var pay in data)
    {
      Generate_payslip_model payroll_model=Generate_payslip_model(pay['pay_id'],pay['emp_id'],pay['total_id'],pay['bonus'],pay['first_name']);
      print(payroll_model);
      generate_pay_list.add(payroll_model);
    }
    return generate_pay_list;
  }



  static Future addPayroll_list(String dep_name,String token) async
  {
    var body={
      'dep_name':dep_name,
    };
    String url=Api_constants.host+Api_constants.add_payroll;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }


  static Future deletePayroll_list(String id,String token) async
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

  static Future updatePayroll_list(String id,String dep_name,String token) async
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