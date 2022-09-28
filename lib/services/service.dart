import 'dart:convert';

import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class service
{
  static List<Service_model> service_list=[];

  static Future<List<Service_model>> getService(BuildContext context,String token) async
  {
    service_list.clear();
    String url=Api_constants.host+Api_constants.services_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['service_data'];
    print(data_json['service_data']);
    for(var service in data)
    {
      Service_model service_model=Service_model(service['id'],service['cname'],service['category_id'],
          service['name'],service['short_descr'],service['long_descr'],service['price'],service['isactive']);
      print(service_model);
      service_list.add(service_model);
    }
    return service_list;
  }

  static Future addService(String category_id,String name,String short_descr,String long_descr,String price,String isactive,String token) async
  {
    var body={
      'category_id':category_id,
      'name':name,
      'short_descr':short_descr,
      'long_descr':long_descr,
      'price':price,
      'isactive':isactive,
    };
    String url=Api_constants.host+Api_constants.add_services;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future deleteService(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_services+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateService(String id,String category_id,String name,String short_descr,String long_descr,String price,String isactive,String token) async
  {
    var body={
      'id':id,
      'category_id':category_id,
      'name':name,
      'short_descr':short_descr,
      'long_descr':long_descr,
      'price':price,
      'isactive':isactive,
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.update_services+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

}