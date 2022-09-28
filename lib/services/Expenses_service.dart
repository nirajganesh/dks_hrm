import 'dart:convert';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Expenses/Expenses_model.dart';

class Expenses_service
{
  static List<Expenses_model> expenses_list=[];

  static Future<List<Expenses_model>> getExpenses(BuildContext context,String token) async
  {
    expenses_list.clear();
    String url=Api_constants.host+Api_constants.expenses_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['expenses_data'];
    print(data_json['expenses_data']);
    for(var exp in data)
    {
      Expenses_model expenses_model=Expenses_model(exp['id'],exp['user_id'],exp['first_name'],exp['descr'],exp['amount'],exp['file_src'],exp['date']);
      print(expenses_model);
      expenses_list.add(expenses_model);
    }
    return expenses_list;
  }

  static Future addExpenses(String user_id,String descr,String date,String amount,String file_src,String token) async
  {
    var headers = {
      "Authorization": token,
      "Content-type":"multipart/form-data"
    };

    String url=Api_constants.host+Api_constants.add_expenses;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      'user_id':user_id,
      'descr':descr,
      'amount':amount,
      'date':date,
    });
    if(file_src!='')
      {
        request.files.add(await http.MultipartFile.fromPath('file_src',file_src));
      }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    var json_response=jsonDecode(res.body);
    return json_response;
  }

  static Future deleteExpense(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_expenses+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateExpenses(String id,String user_id,String descr,String amount,String date,String file_src,String token) async
  {
    var headers = {
      "Authorization": token,
      "Content-type":"multipart/form-data"
    };

    String url=Api_constants.host+Api_constants.update_expenses+"/"+id;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      'user_id':user_id,
      'descr':descr,
      'amount':amount,
      'date':date,
      '_method':'PUT',
    });
    if(file_src!='')
      {
        request.files.add(await http.MultipartFile.fromPath('file_src',file_src));
      }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    var json_response=jsonDecode(res.body);
    return json_response;
  }
}