
import 'dart:convert';
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:http/http.dart' as http;


class Dashboard_service
{
   static Future getDashboard() async
   {
     String url=Api_constants.host+Api_constants.dashboard;
     var response=await http.get(Uri.parse(url));
     var json_response=jsonDecode(response.body);
     return json_response;
   }
}