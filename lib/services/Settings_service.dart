import 'dart:convert';

import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Settings/Settings_model.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Settings_service
{

  static List<Settings_model> setting_list=[];
  static Future<List<Settings_model>> getSettings(BuildContext context,String token) async
  {
    setting_list.clear();
    String url=Api_constants.host+Api_constants.settings_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['settings_data'];
    print(data_json['settings_data']);
    for(var exp in data)
    {
      Settings_model setting_model=Settings_model(exp['id'],exp['sitelogo'],exp['sitetitle'],
          exp['description'],exp['copyright'],exp['contact'],exp['currency'],exp['symbol'],exp['system_email'],
          exp['address'],exp['bank_name'],exp['account_name'],exp['account_number'],exp['ifsc'],exp['upi_id']);
      print(setting_model);
      setting_list.add(setting_model);
    }
    return setting_list;
  }

  static Future updateSettings(String id,String site_logo,String sitetitle,
      String copyright,String contact,String currency,String symbol,String system_email,String address,
      String bank_name,String account_name,String account_number,String ifsc,String upi_id,String token) async
  {

    var headers = {
      "Authorization": token,
      "Content-type":"multipart/form-data"
    };

    String url=Api_constants.host+Api_constants.update_settings+"/"+id;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      'sitetitle':sitetitle,
      'copyright':copyright,
      'contact':contact,
      'currency':currency,
      'symbol':symbol,
      'system_email':system_email,
      'address':address,
      'bank_name':bank_name,
      'account_name':account_name,
      'account_number':account_number,
      'ifsc':ifsc,
      'upi_id':upi_id,
      '_method':'PUT',
    });

    if(site_logo!='')
      {
        request.files.add(await http.MultipartFile.fromPath('sitelogo',site_logo));
      }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    var json_response=jsonDecode(res.body);
    return json_response;
  }
}