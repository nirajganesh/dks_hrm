import 'dart:convert';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Salesreport/Sales_model.dart';

class Sales_report_service
{
  static List<Sales_model> sales_list=[];

  static Future<List<Sales_model>> getSales(BuildContext context,String token) async
  {
    sales_list.clear();
    String url=Api_constants.host+Api_constants.sales_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['sales_data'];
    print(data_json['sales_data']);
    for(var sal in data)
    {
      Sales_model sales_model=Sales_model(sal['inv_no'],sal['name'],sal['inv_date'],sal['total']);
      print(sales_model);
      sales_list.add(sales_model);
    }
    return sales_list;
  }
}