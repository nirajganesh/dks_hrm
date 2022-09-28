import 'dart:convert';
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Client_service
{
  static List<Client_model> client_list=[];

  static Future<List<Client_model>> getClient(BuildContext context,String token) async
  {
    client_list.clear();
    String url=Api_constants.host+Api_constants.client_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['Client_data'];
    print(data_json['Client_data']);
    for(var client in data)
    {
      Client_model designation_model=Client_model(client['id'],client['name'],client['person'],client['address'],client['contact_no'],client['email'],client['gst_no'],client['remarks'],client['balance']);
      print(designation_model);
      client_list.add(designation_model);
    }
    return client_list;
  }

  static Future addClient(String name,String person,String address,String contact_no,String email,String balance,String gst_no,String remarks,String token) async
  {
    var body={
      'name':name,
      'person':person,
      'address':address,
      'contact_no':contact_no,
      'email':email,
      'balance':balance,
      'remarks':remarks,
      'gst_no':gst_no,
    };
    String url=Api_constants.host+Api_constants.add_client;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future deleteClient(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_client+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateClient(String id,String name,String person,String address,String contact_no,String email,String balance,String gst_no,String remarks,String token) async
  {
    var body={
      'id':id,
      'name':name,
      'person':person,
      'address':address,
      'contact_no':contact_no,
      'email':email,
      'balance':balance,
      'remarks':remarks,
      'gst_no':gst_no,
      '_method':'PUT',
    };
    print(body);
    String url=Api_constants.host+Api_constants.update_client+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

}