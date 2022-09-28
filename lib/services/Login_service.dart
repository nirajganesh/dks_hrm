import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class Login_service
{
  static Future<Response> login(String username, String password)  async {
    var body = {
      "em_email": username,
      "em_password": password
    };
    String url=Api_constants.host+Api_constants.login;
    print(Api_constants.host + Api_constants.login);
    print(body);
    var res = await http.post(Uri.parse(url),
        body:body);
    print("Login Details" + res.body.toString());
    return res;
  }
}