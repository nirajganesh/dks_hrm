import 'dart:convert';
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Summary/Service_summary_model.dart';
import 'package:dks_hrm/model/Summary/Summary_model.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Summary_service
{
  static List<Summary_model> summary_list=[];
  static List<Service_summary_model> service_summary_list=[];
  static Future<List<Service_summary_model>> getService_Summary(BuildContext context,String client_id,String is_billed,String token) async
  {
    var body={
      'is_billed':is_billed,
      '_method':"PUT",
    };
    service_summary_list.clear();
    String url=Api_constants.host+Api_constants.service_summary_list+"/"+client_id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['Service summary_data'];
    print(data_json['Service summary_data']);
    for(var summary in data)
    {
      Service_summary_model service_summary_model=Service_summary_model(id:summary['id'],client_id:summary['client_id'], item_id:summary['item_id'],
          descr:summary['descr'],qty:summary['qty'],price:summary['price'],is_billed:summary['is_billed'],date:summary['date'],item_name:summary['name'],isSelected: false);
      print(service_summary_model);
      service_summary_list.add(service_summary_model);
    }
    return service_summary_list;
  }

  static Future<List<Summary_model>> getSummary(BuildContext context,String token) async
  {
    summary_list.clear();
    String url=Api_constants.host+Api_constants.summary_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['summary_data'];
    print(data_json['summary_data']);
    for(var summary in data)
    {
      Summary_model summary_model=Summary_model(summary['id'], summary['name'], summary['person'],
          summary['address'],summary['contact_no'],summary['email'],summary['gst_no'],summary['remarks']
         ,summary['balance']);
      print(summary_model);
      summary_list.add(summary_model);
    }
    return summary_list;
  }


  static Future addService_summary(String client_id,String item_id,String descr
      ,String qty,String is_billed,String date,String token) async
  {
    var body={
      'client_id':client_id,
      'item_id':item_id,
      'descr':descr,
      'qty':qty,
      'is_billed':is_billed,
      'date':date,
    };
    print(body);
    String url=Api_constants.host+Api_constants.add_service_summary;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token,"Accept": "application/json"},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateService_summary(String id,String client_id,String item_id,String descr
      ,String qty,String is_billed,String date,String token) async
  {
    var body={
      'client_id':client_id,
      'item_id':item_id,
      'descr':descr,
      'qty':qty,
      'is_billed':is_billed,
      'date':date,
      '_method':'PUT'
    };
    print(body);
    String url=Api_constants.host+Api_constants.update_service_summary+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }


  static Future deleteService_summary(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_summary+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

}