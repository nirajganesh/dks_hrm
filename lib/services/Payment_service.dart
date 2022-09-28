import 'dart:convert';
import 'package:dks_hrm/model/Invoice/Invoice_model.dart';
import 'package:dks_hrm/model/Payment/Payment_last_modal.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Payment/Payment_model.dart';

class Payment_service
{
  static List<Payment_model> payment_list=[];
  static List<Payment_last_modal> payment_last_list=[];
  static List<Invoice_model> invoice_client_list=[];

  static Future<List<Payment_model>> getPayment(BuildContext context,String token) async
  {
    payment_list.clear();
    String url=Api_constants.host+Api_constants.payment_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['payment_data'];
    print(data_json['payment_data']);
    for(var pay in data)
    {
      Payment_model payment_model=Payment_model(pay['id'], pay['receipt_no'], pay['client_id'],
          pay['name'],pay['amount'], pay['invoice_id'], pay['payment_date'], pay['remarks'],
          pay['is_deleted'], pay['name'], pay['person'], pay['address'],
          pay['contact_no'], pay['email'], pay['gst_no'], pay['balance']);
      print(payment_model);
      payment_list.add(payment_model);
    }
    return payment_list;
  }


  static Future<List<Payment_last_modal>> getPayment_last(BuildContext context,String token) async
  {
    payment_last_list.clear();
    String url=Api_constants.host+Api_constants.listpayment_last;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['payment_data'];
    for(var pay in data)
    {
      Payment_last_modal payment_last_modal=Payment_last_modal(pay['receipt_no']);
      payment_last_list.add(payment_last_modal);
    }
    return payment_last_list;
  }

  static Future<List<Invoice_model>> getInvoice_client(BuildContext context,String token,String client_id) async
  {
    invoice_client_list.clear();
    var body={
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.invoice_client+"/"+client_id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['Invoice_data'];
    for(var inv in data)
    {
      Invoice_model invoice_model=Invoice_model(inv['id'],inv['inv_no'],inv['client_id'],inv['name'],
          inv['contact_no'],inv['email'],inv['inv_date'],inv['sub_total'],inv['gst'],inv['total'],
          inv['total_paid'],inv['total_due'],inv['due_date'],inv['remarks'],inv['is_deleted'],
          inv['ref_quotation_id']);
      invoice_client_list.add(invoice_model);
    }
    return invoice_client_list;
  }


  static Future addPayment(String receipt_no,String client_id,String amount,
      String payment_date,String remarks,String choose_invoice,String token) async
  {
    var body={
      'receipt_no':receipt_no,
      'client_id':client_id,
      'amount':amount,
      'payment_date':payment_date,
      'remarks':remarks,
      'invoice_id':choose_invoice,
    };
    print(body);
    String url=Api_constants.host+Api_constants.add_payment;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future deletePayment(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_payment+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updatePayment(String? id,String receipt_no,String client_id,String amount,String invoice_id,
      String payment_date,String remarks,String token) async
  {
    var body={
       'id':id,
      'receipt_no':receipt_no,
      'client_id':client_id,
      'amount':amount,
      'invoice_id':invoice_id,
      'payment_date':payment_date,
      'remarks':remarks,
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.update_payment+"/"+id!;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }
}