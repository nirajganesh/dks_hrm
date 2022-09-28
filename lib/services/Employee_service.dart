import 'dart:convert';
import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/model/Employee/Employee_model.dart';
import 'package:dks_hrm/model/Salary_type/Salary_type_model.dart';
import 'package:dks_hrm/widget/Expire_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Employee_service
{
  static List<Employee_model> employee_list=[];
  static List<Salary_type_model> salary_list=[];

  static Future<List<Employee_model>> getEmployee(BuildContext context,String token) async
  {
    employee_list.clear();
    String url=Api_constants.host+Api_constants.employee_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    Expire_token.expire(context, json_response['message']);
    var data_json=json_response['data'];
    List data=data_json['employee_data'];
    print(data_json['employee_data']);
    for(var emp in data)
    {
      Employee_model employee_model=Employee_model(emp['id'],emp['em_id'],emp['em_code'],emp['des_id'],
          emp['dep_id'],emp['first_name'],emp['last_name'],emp['em_email'],emp['em_role'],emp['em_address'],
        emp['status'],emp['em_gender'],emp['em_phone'],emp['em_birthday'],emp['em_blood_group'],
        emp['em_joining_date'],emp['em_contact_end'],emp['em_image'],
      );
      print(employee_model);
      employee_list.add(employee_model);
    }
    return employee_list;
  }

  static Future<List<Salary_type_model>> getSalary(String token) async
  {
    salary_list.clear();
    String url=Api_constants.host+Api_constants.salary_type_list;
    var response=await http.get(Uri.parse(url),headers:{'Authorization':token});
    var json_response=jsonDecode(response.body);
    var data_json=json_response['data'];
    List data=data_json['Sal_type_data'];
    print(data_json['Sal_type_data']);
    for(var sal in data)
    {
      Salary_type_model salary_type_model=Salary_type_model(sal['id'],sal['salary_type'],sal['create_date']);
      print(salary_type_model);
      salary_list.add(salary_type_model);
    }
    return salary_list;
  }


  static Future addEmployee(String first_name,String contact,String email,String emp_code,String dep_id,
      String des_id,String em_role,String joining_of_date,String file_src, String token) async
  {
    var headers = {
      "Authorization": token,
      "Content-type":"multipart/form-data"
    };

    String url=Api_constants.host+Api_constants.add_employee;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      'first_name':first_name,
      'em_phone':contact,
      'em_email':email,
      'em_id':emp_code,
      'em_code':emp_code,
      'dep_id':dep_id,
      'des_id':des_id,
      'em_role':em_role,
      'em_joining_date':joining_of_date,
    });
    if(file_src!='')
    {
      request.files.add(await http.MultipartFile.fromPath('em_image',file_src));
    }
    else
      {
        request.files.add(await http.MultipartFile.fromPath('em_image',''));
      }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    var json_response=jsonDecode(res.body);
    return json_response;
  }

  static Future deleteEmployee(String id,String token) async
  {
    var body={
      'id':id,
      '_method':'DELETE',
    };
    String url=Api_constants.host+Api_constants.delete_employee+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateEmp_address(String id,String address,String city,String country,String token) async
  {
    var body={
      'emp_id':id,
      'address':address,
      'city':city,
      'country':country,
      '_method':'PUT',
    };
    print(body);
    print(token);
    String url=Api_constants.host+Api_constants.edit_address+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateEmp_personalinfo(String id,String emp_Code,String first_name,String last_name,
      String blood_group,String gender,String em_role,String status,String date_of_birth,String contact,
      String email,String dep_id,String des_id,String joining_of_date,String date_of_leaving,
      String file_src, String token) async
  {
    var headers = {
      "Authorization": token,
      "Content-type":"multipart/form-data"
    };

    String url=Api_constants.host+Api_constants.edit_personalinfo+"/"+id;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      'em_code':emp_Code,
      'des_id':dep_id,
      'dep_id':des_id,
      'first_name':first_name,
      'last_name':last_name,
      'em_email':email,
      'em_role':em_role,
      'status':status,
      'em_gender':gender,
      'em_phone':contact,
      'em_birthday':date_of_birth,
      'em_blood_group':blood_group,
      'em_joining_date':joining_of_date,
      'em_contact_end':date_of_leaving,
      '_method':'PUT',
    });

    if(file_src!='')
      {
        request.files.add(await http.MultipartFile.fromPath('em_image',file_src));
      }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    var json_response=jsonDecode(res.body);
    return json_response;
  }


  static Future updateEmp_bankinfo(String id,String bank_name,String account_name,String ifsc,String branch_name,
      String account_no,String token) async
  {
    var body={
      'emp_id':id,
      'holder_name':account_name,
      'bank_name':bank_name,
      'branch_name':branch_name,
      'account_number':account_no,
      'ifsc':ifsc,
      '_method':'PUT',
    };
    print(body);
    // String url=Api_constants.host+Api_constants.edit_bankinfo+"/"+id;
    // var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    // var json_response=jsonDecode(response.body);
    // return json_response;
  }

  static Future updateEmp_password(String id,String current_password,String change_password,String token) async
  {
    var body={
      'emp_id':id,
      'em_password':current_password,
      'change_password':change_password,
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.edit_password+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateEmp_salary(String em_id,String id,String type_id,
      String total,String basic,String medical,String house_rent,
      String conveyance,String provident_fund,String tax,String other,String token) async
  {
    var body={
      'emp_id':em_id,
      'type_id':type_id,
      'total_pay':total,
      'basic':basic,
      'medical':medical,
      'house_rent':house_rent,
      'conveyance':conveyance,
      'provident_fund':provident_fund,
      'tax':tax,
      'other':other,
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.edit_salary+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }

  static Future updateEmp_document(String id,String file_title,String file_url,String token) async
  {
    var headers = {
      "Authorization": token,
      "Content-type":"multipart/form-data"
    };

    String url=Api_constants.host+Api_constants.edit_document+"/"+id;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      'emp_id':id,
      'file_title':file_title,
      '_method':'PUT',
    });

    if(file_url!='')
      {
        request.files.add(await http.MultipartFile.fromPath('file_url',file_url));
      }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var res = await http.Response.fromStream(response);
    var json_response=jsonDecode(res.body);
    return json_response;
  }

  static Future updateEmp_social(String id,String facebook,String linkedin,String instagram,String skype_id,String token) async
  {
    var body={
      'emp_id':id,
      'facebook':facebook,
      'linkedin':linkedin,
      'instagram':instagram,
      'skype_id':skype_id,
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.edit_socialmedia+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }


  static Future updateEmployee(String id,String des_name,String token) async
  {
    var body={
      'id':id,
      'des_name':des_name,
      '_method':'PUT',
    };
    String url=Api_constants.host+Api_constants.update_designation+"/"+id;
    var response=await http.post(Uri.parse(url),headers:{'Authorization':token},body: body);
    var json_response=jsonDecode(response.body);
    return json_response;
  }
}