import 'package:dks_hrm/constants/Api_constants.dart';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Settings/Settings_model.dart';
import 'package:dks_hrm/screen/Settings/Edit_settings.dart';
import 'package:dks_hrm/services/Settings_service.dart';
import 'package:dks_hrm/widget/App_bar_widget.dart';
import 'package:dks_hrm/widget/Shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  List<Settings_model> settings_list=[];
  String token='';
  bool theme=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadTheme();
    Loadtoken();
  }

  @override
  Widget build(BuildContext context) {
    return 
      theme==true?
      Scaffold(
      appBar: App_bar_widget.App_bar_view(context, "Settings",Colors_theme.light_app_color),
      body:
      Padding(
        padding: const EdgeInsets.all(10.0),
        child:
        Column(
          children: [
            SizedBox(height: 30,),
            Flexible(
              flex: 1,
              child: FutureBuilder(
                future:getSettings(),
                builder: (context,snapshot)
                {
                  if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 3),
                      child: Shimmer_widget.shimmer_setting(),
                    );
                  }
                  else
                  {
                      if(settings_list.length!=0)
                        {
                          return ListView.builder(
                              itemCount:settings_list.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder:(context,index)
                              {
                                Settings_model setting_data=settings_list[index];
                                return Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Positioned(
                                            child:Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(45),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xffe8e8e8),
                                                    blurRadius: 5.0, // soften the shadow//extend the shadow
                                                    offset: Offset(
                                                        0,5
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                  padding:EdgeInsets.all(0) ,
                                                  child: setting_data.sitelogo!=null?
                                                  CircleAvatar(
                                                      backgroundColor: Colors.transparent,
                                                      child: SizedBox(
                                                          width: 80,
                                                          height: 80,
                                                          child: ClipOval(
                                                            child: Image.network(Api_constants.image_host+setting_data.sitelogo,fit: BoxFit.cover,),
                                                            ),
                                                          )
                                                      ):
                                                  CircleAvatar(
                                                      backgroundColor: Colors.transparent,
                                                      child: SizedBox(
                                                        width: 80,
                                                        height: 80,
                                                        child: ClipOval(
                                                          child:Image.asset("images/placeholder.jpg"),
                                                        ),
                                                      )
                                                  )
                                            )
                                          ),
                                        ),
                                        Positioned(
                                          top: 20,
                                          left: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context).primaryColor,
                                              onPrimary: Colors.white,
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(7.0)),
                                              minimumSize: Size(double.infinity, 45),
                                            ),
                                            onPressed: () {},
                                            child:Icon(Icons.edit),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30,),
                                    Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xffe8e8e8),
                                                blurRadius: 5.0, // soften the shadow//extend the shadow
                                                offset: Offset(
                                                    0,5
                                                ),
                                              ),
                                            ],
                                          ),
                                          child:
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex:3,
                                                    child: Column(
                                                     crossAxisAlignment:CrossAxisAlignment.start,
                                                   children: [
                                                     Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text("Compony Name",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                         Text("Digikraft social",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text("Copyright",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                         Text(setting_data!.copyright==""?"--":setting_data.copyright!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text("System Email",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                         Text(setting_data.system_email==""?"--":setting_data.system_email!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text("Symbol",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                         Text(setting_data.symbol==""?"--":setting_data.symbol!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text("Bank Name",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                         Text(setting_data.bank_name==""?"--":setting_data.bank_name!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text("Account Name",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                         Text(setting_data.account_name==""?"--":setting_data.account_name!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                     Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text("IFSC",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                         Text(setting_data.ifsc==""?"--":setting_data.ifsc!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                       ],
                                                     ),
                                                     SizedBox(height: 10,),
                                                   ],
                                                  )
                                                ),
                                                Expanded(
                                                    flex:3,
                                                    child: Column(
                                                      crossAxisAlignment:CrossAxisAlignment.end,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("Site Title",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                            Text(setting_data.sitetitle==""?"--":setting_data.sitetitle!,style: const TextStyle(color: Colors.black,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("Contact",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                            Text(setting_data.contact==""?"--":setting_data.contact!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("Currency",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                            Text(setting_data.currency==""?"--":setting_data.currency!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("Address",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                            Text(setting_data.address==""?"--":setting_data.address!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("Address",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                            Text("Budhapara, Raipur",style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("Account no",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                            Text(setting_data.account_number==""?"--":setting_data.account_number!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("Upi ID",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                            Text(setting_data.upi_id==""?"--":setting_data.upi_id!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10,),
                                                      ],
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(0xffFFA74D),
                                            onPrimary: Colors.white,
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(7.0)),
                                            minimumSize: Size(60, 40),
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_settings(
                                                id:setting_data.id,compony_name:'Digikraft social',site_logo: setting_data.sitelogo,sitetitle:setting_data.sitetitle!,
                                                copyright:setting_data.copyright!,contact:setting_data.contact!,system_email:setting_data.system_email!,
                                                currency:setting_data.currency!,symbol:setting_data.symbol!,address:setting_data.address!,bank_name:setting_data.bank_name!,
                                                account_no:setting_data.account_number!,account_name:setting_data.account_name!,
                                                ifsc:setting_data.ifsc!,upi_id:setting_data.upi_id!,token:token,image:setting_data.sitelogo,theme:theme
                                            )),);
                                          },
                                          child:Text("Edit Settings",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight:FontWeight.bold),),
                                        ),
                                        SizedBox(width: 3,),
                                      ],
                                    ),
                                  ],
                                );
                              }
                          );
                        }
                      else
                        {
                          return Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 3),
                            child:Shimmer_widget.shimmer_setting(),
                          );
                        }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ):
      Scaffold(
        appBar: App_bar_widget.App_bar_view(context, "Settings",Colors_theme.dark_app_color),
        backgroundColor: HexColor(Colors_theme.dark_background),
        body:
        Padding(
          padding: const EdgeInsets.all(10.0),
          child:
          Column(
            children: [
              SizedBox(height: 30,),
              Flexible(
                flex: 1,
                child: FutureBuilder(
                  future:getSettings(),
                  builder: (context,snapshot)
                  {
                    if(snapshot.connectionState==ConnectionState.waiting)
                    {
                      return Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 3),
                        child: Shimmer_widget.shimmer_setting(),
                      );
                    }
                    else
                    {
                      if(settings_list.length!=0)
                      {
                        return ListView.builder(
                            itemCount:settings_list.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder:(context,index)
                            {
                              Settings_model setting_data=settings_list[index];
                              return Column(
                                children: [
                                  Stack(
                                    children: [
                                      Positioned(
                                        child:Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(45),
                                              color: HexColor(Colors_theme.dark_background),
                                            ),
                                            child: Padding(
                                                padding:EdgeInsets.all(0) ,
                                                child: setting_data.sitelogo!=null?
                                                CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    child: SizedBox(
                                                      width: 80,
                                                      height: 80,
                                                      child: ClipOval(
                                                        child: Image.network(Api_constants.image_host+setting_data.sitelogo,fit: BoxFit.cover,),
                                                      ),
                                                    )
                                                ):
                                                CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    child: SizedBox(
                                                      width: 80,
                                                      height: 80,
                                                      child: ClipOval(
                                                        child:Image.asset("images/placeholder.jpg"),
                                                      ),
                                                    )
                                                )
                                            )
                                        ),
                                      ),
                                      Positioned(
                                        top: 20,
                                        left: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Theme.of(context).primaryColor,
                                            onPrimary: Colors.white,
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(7.0)),
                                            minimumSize: Size(double.infinity, 45),
                                          ),
                                          onPressed: () {},
                                          child:Icon(Icons.edit),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30,),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: HexColor(Colors_theme.dark_app_color),
                                    ),
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex:3,
                                              child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Compony Name",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text("Digikraft social",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Copyright",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data!.copyright==""?"--":setting_data.copyright!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("System Email",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data.system_email==""?"--":setting_data.system_email!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Symbol",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data.symbol==""?"--":setting_data.symbol!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Bank Name",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data.bank_name==""?"--":setting_data.bank_name!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Account Name",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data.account_name==""?"--":setting_data.account_name!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("IFSC",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data.ifsc==""?"--":setting_data.ifsc!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                ],
                                              )
                                          ),
                                          Expanded(
                                              flex:3,
                                              child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("Site Title",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data.sitetitle==""?"--":setting_data.sitetitle!,style: const TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("Contact",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data.contact==""?"--":setting_data.contact!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("Currency",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data.currency==""?"--":setting_data.currency!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("Address",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data.address==""?"--":setting_data.address!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("Address",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text("Budhapara, Raipur",style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children:
                                                    [
                                                      Text("Account no",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data.account_number==""?"--":setting_data.account_number!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("Upi ID",style: TextStyle(color: Colors.white24,fontSize: 12),),
                                                      Text(setting_data.upi_id==""?"--":setting_data.upi_id!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                ],
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xffFFA74D),
                                          onPrimary: Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(7.0)),
                                          minimumSize: Size(60, 40),
                                        ),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_settings(
                                              id:setting_data.id,compony_name:'Digikraft social',site_logo: setting_data.sitelogo,sitetitle:setting_data.sitetitle!,
                                              copyright:setting_data.copyright!,contact:setting_data.contact!,system_email:setting_data.system_email!,
                                              currency:setting_data.currency!,symbol:setting_data.symbol!,address:setting_data.address!,bank_name:setting_data.bank_name!,
                                              account_no:setting_data.account_number!,account_name:setting_data.account_name!,
                                              ifsc:setting_data.ifsc!,upi_id:setting_data.upi_id!,token:token,image:setting_data.sitelogo,theme:theme,
                                          )),);
                                        },
                                        child:Text("Edit Settings",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight:FontWeight.bold),),
                                      ),
                                      SizedBox(width: 3,),
                                    ],
                                  ),
                                ],
                              );
                            }
                        );
                      }
                      else
                      {
                        return Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 3),
                          child:Shimmer_widget.shimmer_setting(),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }

  Loadtoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
    });
  }

  LoadTheme() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      theme = (prefs.getBool('theme') ?? false);
    });
  }

  Future getSettings() async
  {
    settings_list=await Settings_service.getSettings(context,token);
    print(settings_list);
  }




}
