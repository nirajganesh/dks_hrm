import 'dart:convert';
import 'package:dks_hrm/model/Invoice/Invoice_item_model.dart';
import 'package:dks_hrm/model/Invoice/Invoice_last_model.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Invoice/Invoice_model.dart';

class Invoice_service
{

  static List<Invoice_model> invoice_list=[];
  static List<Invoice_item_model> invoice_item_list=[];
  static List<Invoice_last_model> invoice_last_list=[];

  static Future<List<Invoice_model>> getInvoice(BuildContext context,String token) async
  {
    invoice_list.clear();
    String url=Api_constants.host+Api_constants.invoice_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['Invoice_data'];
    print(data_json['Invoice_data']);
    for(var inv in data)
    {
      Invoice_model invoice_model=Invoice_model(inv['id'],inv['inv_no'],inv['client_id'],inv['name'],
          inv['contact_no'],inv['email'],inv['inv_date'],inv['sub_total'],inv['gst'],inv['total'],
          inv['total_paid'],inv['total_due'],inv['due_date'],inv['remarks'],inv['is_deleted'],
          inv['ref_quotation_id']);
      print(invoice_model);
      invoice_list.add(invoice_model);
    }
    return invoice_list;
  }

  static Future<List<Invoice_model>> getInvoice_final(String token) async
  {
    invoice_list.clear();
    String url=Api_constants.host+Api_constants.listfinal_Invoice;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    var data_json=json_response['data'];
    List data=data_json['Invoice_data'];
    print(data_json['Invoice_data']);
    for(var inv in data)
    {
      Invoice_model invoice_model=Invoice_model(inv['id'],inv['inv_no'],inv['client_id'],inv['name'],
          inv['contact_no'],inv['email'],inv['inv_date'],inv['sub_total'],inv['gst'],inv['total'],
          inv['total_paid'],inv['total_due'],inv['due_date'],inv['remarks'],inv['is_deleted'],
          inv['ref_quotation_id']);
      invoice_list.add(invoice_model);
    }
    return invoice_list;
  }

  static Future addInvoice(String inv_no,String client_id,String inv_date,
      String gst,String total,String sub_total,String total_paid,String total_due,
      String due_date,String remarks,String is_deleted,String ref_quotation_id,
      var array,String token) async
  {
    var body={
      'inv_no':inv_no,
      'client_id':client_id,
      'inv_date':inv_date,
      'total_paid':total_paid,
      'total_due':total_due,
      'due_date':due_date,
      'gst':gst,
      'sub_total':sub_total,
      'total':total,
      'remarks':remarks,
      'is_deleted':is_deleted,
      'ref_invoice_id':ref_quotation_id,
      'array':jsonEncode(array),
    };
    print(body);
    String url=Api_constants.host+Api_constants.add_invoice;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token,"Accept": "application/json"},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }


  static Future<List<Invoice_last_model>> getInvoice_last(String token) async
  {
    invoice_last_list.clear();
    String url=Api_constants.host+Api_constants.listInvoice_last;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    var data_json=json_response['data'];
    List data=data_json['invoice_data'];
    print(data_json['invoice_data']);
    for(var quotation in data)
    {
      Invoice_last_model invoice_model=Invoice_last_model(quotation['inv_no']);
      print(invoice_model);
      invoice_last_list.add(invoice_model);
    }
    return invoice_last_list;
  }


  static Future deleteInvoice(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_invoice+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateInvoice(String id,
      String inv_no,
      String client_id,
      String inv_date,
      String due_date,
      String sub_total,
      String gst,
      String total,
      String total_paid,
      String total_due,
      String remarks,
      String is_deleted,
      String ref_quotation_id,
      var array,
      String token) async
    {
    var body={
      'id':id,
      'inv_no':inv_no,
      'client_id':client_id,
      'inv_date':inv_date,
      'due_date':due_date,
      'sub_total':sub_total,
      'total_paid':total_paid,
      'total_due':total_due,
      'gst':gst,
      'total':total,
      'remarks':remarks,
      'is_deleted':is_deleted,
      'ref_invoice_id':ref_quotation_id,
      'array':jsonEncode(array),
      '_method':'PUT',
    };
    print(body);
    String url=Api_constants.host+Api_constants.update_invoice+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }


  static Future<List<Invoice_item_model>> getInvoice_item(BuildContext context,String inv_id,String token) async
  {
    var body={
      '_method':'PUT',
    };
    invoice_item_list.clear();
    String url=Api_constants.host+Api_constants.invoice_item_list+"/"+inv_id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token,"Accept": "application/json"},body: body);
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['invoice_item'];
    print(data_json['invoice_item']);
    for(var item in data)
    {
      Invoice_item_model invoice_item_model=Invoice_item_model(item['id'],item['invoice_id'],item['item_id'],item['descr'],item['price'],item['qty']);
      print(invoice_item_model);
      invoice_item_list.add(invoice_item_model);
    }
    return invoice_item_list;
  }
}