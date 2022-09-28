import 'dart:convert';
import 'package:dks_hrm/auth/Login_screen.dart';
import 'package:dks_hrm/model/Quotation/Quotation_item_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_last_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_service_model.dart';
import 'package:dks_hrm/screen/Payment/Payment.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Quotation/Quotation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quotation_service
{
  static List<Quotation_model> quotation_list=[];
  static List<Quotation_last_model> quotation_last_list=[];
  static List<Quotation_item_model> quotation_item_list=[];
  static List<Quotation_service_model> quotation_service_list=[];


  static Future<List<Quotation_model>> getQuotation(BuildContext context,String token,) async
  {
    quotation_list.clear();
    String url=Api_constants.host+Api_constants.quatation_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['quotation_data'];
    print(data_json['quotation_data']);
    for(var quotation in data)
    {
      Quotation_model quotation_model=Quotation_model(quotation['id'],quotation['quote_no'],quotation['client_id'],
          quotation['name'],quotation['email'],quotation['quote_date'],quotation['valid_till'],quotation['sub_total'],quotation['gst'],quotation['discount'],
       quotation['total'],quotation['status'],quotation['remarks'],quotation['is_deleted'],quotation['ref_invoice_id']);
      print(quotation_model);
      quotation_list.add(quotation_model);
    }
    return quotation_list;
  }

  static Future<List<Quotation_item_model>> getQuotation_item(BuildContext context,String quo_id,String token) async
  {
    var body={
      '_method':'PUT',
    };
    quotation_item_list.clear();
    String url=Api_constants.host+Api_constants.quotation_item_list+"/"+quo_id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token,"Accept": "application/json"},body: body);
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['quotation_item'];
    print(data_json['quotation_item']);
    for(var item in data)
    {
      Quotation_item_model quotation_item_model=Quotation_item_model(item['id'],item['quotation_id'],item['item_id'],item['descr'],item['price'],item['qty']);
      print(quotation_item_model);
      quotation_item_list.add(quotation_item_model);
    }
    return quotation_item_list;
  }

  static Future<List<Quotation_service_model>> getQuotation_item_service(BuildContext context,String item_id,String token) async
  {
    var body={
      '_method':'PUT',
    };
    quotation_service_list.clear();
    String url=Api_constants.host+Api_constants.listQuotation_item_service+"/"+item_id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token,"Accept": "application/json"},body: body);
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['service_item'];
    print(data_json['service_item']);
    for(var item in data)
    {
      Quotation_service_model quotation_service_model=Quotation_service_model(item['id'],item['short_descr'],item['price']);
      print(quotation_service_model);
      quotation_service_list.add(quotation_service_model);
    }
    return quotation_service_list;
  }




  static Future<List<Quotation_last_model>> getQuotation_last(String token) async
  {
    quotation_last_list.clear();
    String url=Api_constants.host+Api_constants.listQuatation_last;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    var data_json=json_response['data'];
    List data=data_json['quotation_data'];
    print(data_json['quotation_data']);
    for(var quotation in data)
    {
      Quotation_last_model quotation_model=Quotation_last_model(quotation['quote_no']);
      print(quotation_model);
      quotation_last_list.add(quotation_model);
    }
    return quotation_last_list;
  }


  static Future addQuotation(String quote_no,String client_id,String quote_date,String valid_till
      ,String sub_total,String gst,String discount,String total,String status,
      String remarks,String is_deleted,String ref_invoice_id,var array,String token) async
  {
    var body={
      'quote_no':quote_no,
      'client_id':client_id,
      'quote_date':quote_date,
      'valid_till':valid_till,
      'sub_total':sub_total,
      'gst':gst,
      'discount':discount,
      'total':total,
      'status':status,
      'remarks':remarks,
      'is_deleted':is_deleted,
      'ref_invoice_id':ref_invoice_id,
      'array':jsonEncode(array),
    };
    print(body);
    String url=Api_constants.host+Api_constants.add_quatation;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token,"Accept": "application/json"},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future deleteQuotation(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_quatation+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateQuotation(String id,String quote_no,String client_id,String quote_date,String valid_till
      ,String sub_total,String gst,String discount,String total,String status,
      String remarks,String is_deleted,String ref_invoice_id,var array,String token) async
  {
    var body={
      'id':id,
      'quote_no':quote_no,
      'client_id':client_id,
      'quote_date':quote_date,
      'valid_till':valid_till,
      'sub_total':sub_total,
      'gst':gst,
      'discount':discount,
      'total':total,
      'status':status,
      'remarks':remarks,
      'is_deleted':is_deleted,
      'ref_invoice_id':ref_invoice_id,
      'array':jsonEncode(array),
      '_method':'PUT',
    };
    print(body);
    String url=Api_constants.host+Api_constants.update_quatation+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }
}