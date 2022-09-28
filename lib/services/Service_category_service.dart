
import 'dart:convert';
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Category/Category_model.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Service_category_service
{
  static List<Category_model> category_list=[];

  static Future<List<Category_model>> getCategory(BuildContext context,String token) async
  {
    category_list.clear();
    String url=Api_constants.host+Api_constants.service_category_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['Services_category_data'];
    print(data_json['Services_category_data']);
    for(var category in data)
    {
      Category_model designation_model=Category_model(category['id'],category['cname']);
      print(designation_model);
      category_list.add(designation_model);
    }
    return category_list;
  }

  static Future addCategory(String name,String token) async
  {
    var body={
      'cname':name,
    };
    String url=Api_constants.host+Api_constants.add_service_category;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future deleteCategory(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_service_category+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateCategory(String id,String cname,String token) async
  {
    var body={
      'id':id,
      'cname':cname,
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.update_service_category+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }
}