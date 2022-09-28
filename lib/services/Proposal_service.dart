import 'dart:convert';
import 'dart:io';
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Proposal/Proposal_model.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Proposal_service
{
  static List<Proposal_model> proposal_list=[];

  static Future<List<Proposal_model>> getProposal(BuildContext context,String token) async
  {
    proposal_list.clear();
    String url=Api_constants.host+Api_constants.proposals_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['proposals_data'];
    print(data_json['proposals_data']);
    for(var proposal in data)
    {
      Proposal_model proposal_model=Proposal_model(proposal['id'],proposal['name'],proposal['client_id'], proposal['file_src'], proposal['short_descr'], proposal['descr'],proposal['status'],proposal['follow_up_date']);
      print(proposal_model);
      proposal_list.add(proposal_model);
    }
    return proposal_list;
  }

  static Future addProposal(String client_id,String file_src,String short_descr,String descr,String status,String follow_up_date,String token) async
  {
    var body={
      'client_id':client_id,
       'file_src':file_src,
      'short_descr':short_descr,
      'descr':descr,
      'status':status,
      'follow_up_date':follow_up_date,
    };
    String url=Api_constants.host+Api_constants.add_proposals;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future addProposal_Multipart (String client_id,String file_src,String short_descr,String descr,String status,String follow_up_date,String token) async {
    var headers = {
      "Authorization": token,
      "Content-type":"multipart/form-data"
    };

    String url=Api_constants.host+Api_constants.add_proposals;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      'client_id':client_id,
      'short_descr':short_descr,
      'descr':descr,
      'status':status,
      'follow_up_date':follow_up_date,
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

  static Future deleteProposal(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_proposals+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateProposal(String id,String client_id,String file_src,String short_descr,String descr,String status,String follow_up_date,String token) async
  {
    var body={
      'id':id,
      'client_id':client_id,
      'file_src':file_src,
      'short_descr':short_descr,
      'descr':descr,
      'status':status,
      'follow_up_date':follow_up_date,
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.update_proposals+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateProposal_Multipart (String id,String client_id,String file_src,String short_descr,String descr,String status,String follow_up_date,String token) async {
    var headers = {
      "Authorization": token,
      "Content-type":"multipart/form-data"
    };

    String url=Api_constants.host+Api_constants.update_proposals+"/"+id;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      'id':id,
      'client_id':client_id,
      'short_descr':short_descr,
      'descr':descr,
      'status':status,
      'follow_up_date':follow_up_date,
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