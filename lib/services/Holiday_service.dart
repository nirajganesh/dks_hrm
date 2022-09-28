import 'dart:convert';
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Holiday/Holiday_model.dart';
import 'package:dks_hrm/screen/Holiday/Holiday.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Holiday_service
{
  static List<Holiday_model> holiday_list=[];
  static Future getHoliday(BuildContext context,String token) async
  {
    holiday_list.clear();
    String url=Api_constants.host+Api_constants.holiday_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['Holiday_data'];
    print(data_json['Holiday_data']);
    for(var holiday in data)
    {
      Holiday_model holiday_model=Holiday_model(holiday['id'],holiday['holiday_name'],
          holiday['from_date'],holiday['to_date'],holiday['number_of_days'],holiday['year']);
      print(holiday_model);
      holiday_list.add(holiday_model);
    }
    return holiday_list;
  }

  static Future addHoliday(String holiday_name,String from_date,String to_date,String number_of_days,String year,String token) async
  {
    var body={
      'holiday_name':holiday_name,
      'from_date':from_date,
      'to_date':to_date,
      'number_of_days':number_of_days,
      'year':year,
    };
    String url=Api_constants.host+Api_constants.add_holiday;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future deleteHoliday(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_holiday+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }




}