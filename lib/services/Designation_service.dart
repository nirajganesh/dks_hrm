import 'dart:convert';
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Designation/Designation_model.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Designation_service
{
  static List<Designation_model> designation_list=[];

  static Future<List<Designation_model>> getDesignation(BuildContext context,String token) async
  {
    designation_list.clear();
    String url=Api_constants.host+Api_constants.designation_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['designation_data'];
    print(data_json['designation_data']);
    for(var dep in data)
    {
      Designation_model designation_model=Designation_model(dep['id'],dep['des_name']);
      print(designation_model);
      designation_list.add(designation_model);
    }
    return designation_list;
  }

  static Future addDesignation(String des_name,String token) async
  {
    var body={
      'des_name':des_name,
    };
    String url=Api_constants.host+Api_constants.add_designation;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future deleteDesignation(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_designation+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateDesignation(String id,String des_name,String token) async
  {
    var body={
      'id':id,
      'des_name':des_name,
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.update_designation+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }
}