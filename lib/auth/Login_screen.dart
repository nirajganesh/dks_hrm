import 'dart:convert';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/preferences/Login_preferences.dart';
import 'package:dks_hrm/screen/Dashboard/Dashboard.dart';
import 'package:dks_hrm/services/Login_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_screen extends StatefulWidget {
  const Login_screen({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login_screen> {

  final TextEditingController usernameController=TextEditingController();
  final TextEditingController passwordEditingcontroller= TextEditingController();
  bool hiddenpassword=true;
  bool theme=false;

  @override
  void initState()
  {
    super.initState();
    LoadTheme();
    Login_preferences.get_token().then((token_value)
    {
      if(token_value != null)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>Dashboard()),);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      theme==true?
      Scaffold(
        backgroundColor: Colors.white,
        body:SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:70),
              Image.asset('images/digikraft.png',height: 100,),
              SizedBox(height:30),
              Text('LOGIN HRM',textAlign: TextAlign.center,style: TextStyle(fontSize: 20,height: 1,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(top:16.0,left:20,right:20),
                child:
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor("#f5f5f5"),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.person,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          onTap: (){

                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter username',
                              hintStyle: TextStyle(
                                  color: Colors.black38
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(top:16.0,left:20,right:20),
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor("#f5f5f5"),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.lock,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: passwordEditingcontroller,
                          obscureText: hiddenpassword,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon:Icon(hiddenpassword ?Icons.visibility_off :Icons.visibility),
                                onPressed: (){
                                  setState(() {
                                    hiddenpassword=!hiddenpassword;
                                  });
                                },
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  color: Colors.black38
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
        bottomNavigationBar:
        GestureDetector(
        onTap: (){
          _onLoading();
          getLogin();
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text('LOGIN HRM',style: TextStyle(fontSize: 16,color: Colors.white),)),
        ),
      ),
    ):
      Scaffold(
        backgroundColor: HexColor(Colors_theme.dark_background),
        body:SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:70),
              Image.asset('images/digikraft.png',height: 100,),
              SizedBox(height:30),
              Text('LOGIN HRM',textAlign: TextAlign.center,style: TextStyle(fontSize: 20,height: 1,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(top:16.0,left:20,right:20),
                child:
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.person,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onTap: (){

                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter username',
                              hintStyle: TextStyle(
                                  color: Colors.white24
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(top:16.0,left:20,right:20),
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor(Colors_theme.dark_app_color),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.lock,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: passwordEditingcontroller,
                          obscureText: hiddenpassword,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon:Icon(hiddenpassword ?Icons.visibility_off :Icons.visibility,color: Colors.white,),
                                onPressed: (){
                                  setState(() {
                                    hiddenpassword=!hiddenpassword;
                                  });
                                },
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  color: Colors.white24
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
        bottomNavigationBar:
        GestureDetector(
          onTap: (){
            _onLoading();
            getLogin();
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(child: Text('LOGIN HRM',style: TextStyle(fontSize: 16,color: Colors.white),)),
          ),
        ),
      );
  }

  LoadTheme() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      theme = (prefs.getBool('theme') ?? false);
    });
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 10,),
                Text("Loading.."),
              ],
            ),
          ),
        );
      },
    );
  }
  void getLogin()
  {
    Login_service.login(usernameController.text.toString(), passwordEditingcontroller.text.toString()).then((res){
      var json=jsonDecode(res.body);
      if(json['status']==200)
      {
        Navigator.pop(context);
        var json_data=json['data'];
        String token=json_data['token'].toString();
        var user_data=json_data['user_data'];
        String user_id=user_data['id'].toString();
        Login_preferences.set_user(user_id);
        Login_preferences.set_token(token).then((value){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>Dashboard()),);
        });
      }
      else
      {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Incorrect Username and Password",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

}
