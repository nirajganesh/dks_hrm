import 'dart:convert';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Todo/Todo_model.dart';

class Todo_service
{
  static List<Todo_model> todo_list=[];
  static Future getTodo(BuildContext context,String token) async
  {
    todo_list.clear();
    String url=Api_constants.host+Api_constants.todo_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['todo_data'];
    print(data_json['todo_data']);
    for(var todo in data)
    {
      Todo_model todo_model=Todo_model(todo['id'],todo['user_id'],
          todo['to_dodata'],todo['date'],todo['value']);
      print(todo_model);
      todo_list.add(todo_model);
    }
    return todo_list;
  }

  static Future addTodo(String user_id,String to_dodata,String date,String token) async
  {
    var body={
      'user_id':user_id,
      'date':date,
      'to_dodata':to_dodata,
      'date':date,
    };
    String url=Api_constants.host+Api_constants.add_todo;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future deleteTodo(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_todo+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }
}