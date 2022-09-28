import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:dks_hrm/auth/Login_screen.dart';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/preferences/Theme_preferences.dart';
import 'package:dks_hrm/screen/Category/Category.dart';
import 'package:dks_hrm/screen/Client/Clients.dart';
import 'package:dks_hrm/screen/Department/Department.dart';
import 'package:dks_hrm/screen/Designation/Designation.dart';
import 'package:dks_hrm/screen/Employee/Employee.dart';
import 'package:dks_hrm/screen/Expenses/Expenses.dart';
import 'package:dks_hrm/screen/Holiday/Holiday.dart';
import 'package:dks_hrm/screen/Invoice/Final_invoice.dart';
import 'package:dks_hrm/screen/Invoice/Invoice.dart';
import 'package:dks_hrm/screen/Payment/Payment.dart';
import 'package:dks_hrm/screen/Payrolltype/Payrolltype.dart';
import 'package:dks_hrm/screen/Payslips/Payslips.dart';
import 'package:dks_hrm/screen/Proposal/Proposal.dart';
import 'package:dks_hrm/screen/Quotation/Quotation.dart';
import 'package:dks_hrm/screen/Salesreport/Salesreport.dart';
import 'package:dks_hrm/screen/Service/Service.dart';
import 'package:dks_hrm/screen/Settings/Settings.dart';
import 'package:dks_hrm/screen/Summary/Summary.dart';
import 'package:dks_hrm/screen/Todo/Todo.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final TextEditingController addtaskcontroller=TextEditingController();
  late SharedPreferences prefs;
  final ScrollController scrollController=ScrollController();
  bool isSwitched=true;
  bool isDarkModeEnabled=false;

  @override
  void initState() {
    super.initState();
    Load_Preferences();
  }

  @override
  Widget build(BuildContext context) {
    Theme_preferences.get_theme().then((value){
        isSwitched=value!;
        if(isSwitched==true)
        isDarkModeEnabled=false;
        else
          isDarkModeEnabled=true;
    });
    return isSwitched==true?
      Scaffold(
        appBar: AppBar(
         title: Text("Dashboard",style: TextStyle(color: Colors.white),),
         backgroundColor: Theme.of(context).primaryColor,
         elevation: 0,
         actions: [
           IconButton(
             icon: const Icon(Icons.logout,color: Colors.white,),
             onPressed: () {
               prefs.remove('token');
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                   Login_screen()), (Route<dynamic> route) => false);
               },
             ),
           ],
       ),
        drawer: Drawer(
        backgroundColor: Colors.white,
        child:
        Container(
            child:SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50,),
                  Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(55),
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
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.asset("images/digikraft.png",),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text("Admin",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 45,
                                width: 75,
                                child:DayNightSwitcher(
                                  isDarkModeEnabled: isDarkModeEnabled,
                                  onStateChanged: (isDarkModeEnabled) {
                                    setState(()
                                    {
                                      this.isDarkModeEnabled = isDarkModeEnabled;
                                      toggleSwitch(isDarkModeEnabled);
                                    });
                                  },
                                ),
                              ),

                              // Switch(
                              //   onChanged: toggleSwitch,
                              //   value: isSwitched,
                              //   activeColor: Colors.blue,
                              //   activeTrackColor: Colors.blue,
                              //   inactiveThumbColor: Colors.grey,
                              //   inactiveTrackColor: Colors.grey,
                              // )
                            ],
                          ),
                  Column(
                      children: [
                        Scrollbar(
                          isAlwaysShown: true,
                          controller: scrollController,
                          scrollbarOrientation: ScrollbarOrientation.bottom,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            controller: scrollController,
                            children:<Widget> [
                              ListTile(
                                  title: Text(
                                    'Dashboard',
                                    style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.7)),
                                  ),
                                  leading: Icon(
                                    Icons.dashboard,
                                    size: 20.0,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                  onTap: () {
                                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => home()),);
                                  },
                                ),
                              ExpansionTile(
                                  title: Text(
                                    'Organization',
                                    style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.7)),
                                  ),
                                  leading: Icon(
                                    Icons.supervised_user_circle,
                                    size: 20.0,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                children:[
                                  Divider(height: 1,color: Colors.grey,thickness: 0.5,),
                                  SizedBox(height: 7,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Department()),);
                                      },
                                      child: Text('Department', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Designation()),);
                                      },
                                      child: Text('Designation', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Clients()),);
                                      },
                                      child: Text('Client', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Employee()),);
                                      },
                                      child: Text('Employee', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  'Services',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.7)),
                                ),
                                leading: Icon(
                                  Icons.list_alt_sharp,
                                  size: 20.0,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                children:[
                                  Divider(height: 1,color: Colors.grey,thickness: 0.5,),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Category()),);
                                    },
                                      child: Text('Category', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Service()),);
                                    },
                                      child: Text('Service', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  'Sales',
                                  style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.7)),
                                ),
                                leading: Icon(
                                  Icons.monetization_on,
                                  size: 20.0,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                children:[
                                  Divider(height: 1,color: Colors.grey,thickness: 0.5,),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Proposal()),);
                                    },
                                      child: Text('Proposal', style: TextStyle(fontSize: 16.0, color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Quotation()),);
                                    },
                                      child: Text('Quotation', style: TextStyle(fontSize: 16.0, color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Summary()),);
                                      },
                                      child: Text('Summary', style: TextStyle(fontSize: 16.0, color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Payment()),);
                                      },
                                      child: Text('Payment', style: TextStyle(fontSize: 16.0,color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Salesreport()),);
                                      },
                                      child: Text('Sales Report', style: TextStyle(fontSize: 16.0,color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  'Invoice',
                                  style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.7)),
                                ),
                                leading: Icon(
                                  Icons.print,
                                  size: 20.0,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                children: [
                                  Divider(height: 1,color: Colors.grey,thickness: 0.5,),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Invoice()),);
                                      },
                                      child: Text('Proforma Invoice', style: TextStyle(fontSize: 16.0,color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Final_invoice()),);
                                      },
                                      child: Text('Final Invoice', style: TextStyle(fontSize: 16.0,color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  'Payroll',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.7)),
                                ),
                                leading: Icon(
                                  Icons.credit_card,
                                  size: 20.0,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                children:[
                                  Divider(height: 1,color: Colors.grey,thickness: 0.5,),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Payslips()),);
                                    },
                                      child: Text('Payslips list', style: TextStyle(fontSize: 16.0,color: Colors.black.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Payrolltype()),);
                                    },
                                    child:Text('Payroll type', style: TextStyle(fontSize: 16.0,color: Colors.black.withOpacity(0.7)),),
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              ),
                              ListTile(
                                title: Text(
                                  'Expenses',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.7)),
                                ),
                                leading: Icon(
                                  Icons.arrow_circle_up,
                                  size: 20.0,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Expenses()),);
                                },
                              ),
                              ListTile(
                                title: Text(
                                  'Settings',
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0, color: Colors.black.withOpacity(0.7)),
                                ),
                                leading: Icon(
                                  Icons.settings,
                                  size: 20.0,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Settings()),);
                                },
                              ),
                              ListTile(
                                title: Text(
                                  'Log out',
                                  style: TextStyle(fontFamily:'Titilliumweb',fontSize: 18.0, color: Colors.red),
                                ),
                                leading: Icon(
                                  Icons.logout,
                                  size: 20.0,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                   prefs.remove('token');
                                   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                                       Login_screen()), (Route<dynamic> route) => false);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            )
        ),
      ),
        body: Container(
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hi Admin",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight:FontWeight.bold),),
                        SizedBox(height: 4,),
                        Text("HAVE A NICE DAY",style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: 14,fontWeight:FontWeight.bold),),
                        SizedBox(height: 4,),
                        Text("Sunday, 24 Feb",style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: 14),),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Settings()),);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("images/digikraft.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  color: HexColor("F9FAFF"),
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child:
                        Column(
                          children: [
                            Row(
                                children:[
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Quotation()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:Colors.white,
                                          borderRadius:BorderRadius.circular(10),
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
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),

                                              ),

                                              child: Icon(Icons.list_alt_sharp,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Quotation",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.bold),),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Payment()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:Colors.white,
                                          borderRadius:BorderRadius.circular(10),
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
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),

                                              ),

                                              child: Icon(Icons.credit_card,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                   Text("Payment",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.bold),),

                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child:
                        Column(
                          children: [
                            Row(
                                children:[
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Final_invoice()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:Colors.white,
                                          borderRadius:BorderRadius.circular(10),
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
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),

                                              ),
                                              child:
                                              Icon(Icons.print,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Invoice(Paid)",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.bold),),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Invoice()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:Colors.white,
                                          borderRadius:BorderRadius.circular(10),
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
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),
                                              ),

                                              child: Icon(Icons.print,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Invoice(Unpaid)",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.bold),),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child:
                        Column(
                          children: [
                            Row(
                                children:[
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Todo()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:Colors.white,
                                          borderRadius:BorderRadius.circular(10),
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
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),

                                              ),

                                              child: Icon(Icons.list_alt_sharp,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Todo",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.bold),),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Holiday()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:Colors.white,
                                          borderRadius:BorderRadius.circular(10),
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
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),

                                              ),

                                              child: Icon(Icons.note,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Holiday",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.bold),),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ):
      Scaffold(
      appBar: AppBar(
        title: Text("Dashboard",style: TextStyle(color: Colors.white),),
        backgroundColor: HexColor(Colors_theme.dark_app_color),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,color: Colors.white,),
            onPressed: () {
              prefs.remove('token');
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                  Login_screen()), (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      backgroundColor: HexColor(Colors_theme.dark_background),
      drawer: Drawer(
        backgroundColor: HexColor(Colors_theme.dark_background),
        child:
        Container(
            child:SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: HexColor(Colors_theme.dark_app_color),
                          borderRadius: BorderRadius.circular(55),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset("images/digikraft.png",),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Admin",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 45,
                        width: 75,
                        child: DayNightSwitcher(
                          isDarkModeEnabled: isDarkModeEnabled,
                          onStateChanged: (isDarkModeEnabled) {
                            setState(() {
                              this.isDarkModeEnabled = isDarkModeEnabled;
                              toggleSwitch(isDarkModeEnabled);
                            });
                          },
                        ),
                      ),
                      // Switch(
                      //   onChanged: toggleSwitch,
                      //   value: isSwitched,
                      //   activeColor: Colors.blue,
                      //   activeTrackColor: Colors.blue,
                      //   inactiveThumbColor: Colors.grey,
                      //   inactiveTrackColor: Colors.grey,
                      // )
                    ],
                  ),
                  Column(
                    children: [
                      Scrollbar(
                        isAlwaysShown: true,
                        controller: scrollController,
                        scrollbarOrientation: ScrollbarOrientation.bottom,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          controller: scrollController,
                          children:<Widget> [
                            ListTile(
                              title: Text(
                                'Dashboard',
                                style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.7)),
                              ),
                              leading: Icon(
                                Icons.dashboard,
                                size: 20.0,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              onTap: () {
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => home()),);
                              },
                            ),
                            Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  'Organization',
                                  style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.7)),
                                ),
                                iconColor: Colors.white,
                                leading: Icon(
                                  Icons.supervised_user_circle,
                                  size: 20.0,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                collapsedIconColor: Colors.white,
                                children:[
                                  Divider(height: 1,color: Colors.grey,thickness: 0.5,),
                                  SizedBox(height: 7,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Department()),);
                                      },
                                      child: Text('Department', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Designation()),);
                                      },
                                      child: Text('Designation', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Clients()),);
                                      },
                                      child: Text('Client', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Employee()),);
                                      },
                                      child: Text('Employee', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  'Services',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.white.withOpacity(0.7)),
                                ),
                                iconColor: Colors.white,
                                leading: Icon(
                                  Icons.list_alt_sharp,
                                  size: 20.0,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                collapsedIconColor: Colors.white,
                                children:[
                                  Divider(height: 1,color: Colors.grey,thickness: 0.5,),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Category()),);
                                      },
                                      child: Text('Category', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Service()),);
                                      },
                                      child: Text('Service', style: TextStyle(fontFamily:'Titilliumweb',fontSize: 16.0, color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  'Sales',
                                  style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.7)),
                                ),
                                leading: Icon(
                                  Icons.monetization_on,
                                  size: 20.0,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                children:[
                                  Divider(height: 1,color: Colors.grey,thickness: 0.5,),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Proposal()),);
                                      },
                                      child: Text('Proposal', style: TextStyle(fontSize: 16.0, color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Quotation()),);
                                      },
                                      child: Text('Quotation', style: TextStyle(fontSize: 16.0, color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Summary()),);
                                      },
                                      child: Text('Summary', style: TextStyle(fontSize: 16.0, color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Payment()),);
                                      },
                                      child: Text('Payment', style: TextStyle(fontSize: 16.0,color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Salesreport()),);
                                      },
                                      child: Text('Sales Report', style: TextStyle(fontSize: 16.0,color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  'Invoice',
                                  style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.7)),
                                ),
                                leading: Icon(
                                  Icons.print,
                                  size: 20.0,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                children: [
                                  Divider(height: 1,color: Colors.grey,thickness: 0.5,),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Invoice()),);
                                      },
                                      child: Text('Proforma Invoice', style: TextStyle(fontSize: 16.0,color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Final_invoice()),);
                                      },
                                      child: Text('Final Invoice', style: TextStyle(fontSize: 16.0,color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  'Payroll',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.white.withOpacity(0.7)),
                                ),
                                leading: Icon(
                                  Icons.credit_card,
                                  size: 20.0,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                children:[
                                  Divider(height: 1,color: Colors.grey,thickness: 0.5,),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Payslips()),);
                                      },
                                      child: Text('Payslips list', style: TextStyle(fontSize: 16.0,color: Colors.white.withOpacity(0.7)),)),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>Payrolltype()),);
                                    },
                                    child:Text('Payroll type', style: TextStyle(fontSize: 16.0,color: Colors.white.withOpacity(0.7)),),
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Expenses',
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.white.withOpacity(0.7)),
                              ),
                              leading: Icon(
                                Icons.arrow_circle_up,
                                size: 20.0,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>Expenses()),);
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Settings',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0, color: Colors.white.withOpacity(0.7)),
                              ),
                              leading: Icon(
                                Icons.settings,
                                size: 20.0,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>Settings()),);
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Log out',
                                style: TextStyle(fontFamily:'Titilliumweb',fontSize: 18.0, color: Colors.red),
                              ),
                              leading: Icon(
                                Icons.logout,
                                size: 20.0,
                                color: Colors.red,
                              ),
                              onTap: () {
                                prefs.remove('token');
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                                    Login_screen()), (Route<dynamic> route) => false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        ),
      ),
      body: Container(
        color: HexColor(Colors_theme.dark_background),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hi Admin",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight:FontWeight.bold),),
                        SizedBox(height: 4,),
                        Text("HAVE A NICE DAY",style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: 14,fontWeight:FontWeight.bold),),
                        SizedBox(height: 4,),
                        Text("Sunday, 24 Feb",style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: 14),),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Settings()),);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: HexColor(Colors_theme.dark_app_color),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("images/digikraft.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  color: HexColor("#060910"),
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child:
                        Column(
                          children: [
                            Row(
                                children:[
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Quotation()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:HexColor(Colors_theme.dark_app_color),
                                          borderRadius:BorderRadius.circular(10),
                                        ),
                                        child:
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),
                                              ),
                                              child: Icon(Icons.list_alt_sharp,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Quotation",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight:FontWeight.bold),),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Payment()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:HexColor(Colors_theme.dark_app_color),
                                          borderRadius:BorderRadius.circular(10),
                                        ),
                                        child:
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),
                                              ),
                                              child: Icon(Icons.credit_card,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Payment",style: TextStyle(color:Colors.white,fontSize: 16,fontWeight:FontWeight.bold),),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child:
                        Column(
                          children: [
                            Row(
                                children:[
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Final_invoice()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:HexColor(Colors_theme.dark_app_color),
                                          borderRadius:BorderRadius.circular(10),
                                        ),
                                        child:
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),

                                              ),
                                              child:
                                              Icon(Icons.print,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Invoice(Paid)",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight:FontWeight.bold),),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Invoice()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:HexColor(Colors_theme.dark_app_color),
                                          borderRadius:BorderRadius.circular(10),
                                        ),
                                        child:
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),
                                              ),

                                              child: Icon(Icons.print,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Invoice(Unpaid)",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight:FontWeight.bold),),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child:
                        Column(
                          children: [
                            Row(
                                children:[
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Todo()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:HexColor(Colors_theme.dark_app_color),
                                          borderRadius:BorderRadius.circular(10),
                                        ),
                                        child:
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),
                                              ),

                                              child: Icon(Icons.list_alt_sharp,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Todo",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight:FontWeight.bold),),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    flex:1,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Holiday()),);
                                      },
                                      child: Container(
                                        decoration:
                                        BoxDecoration(
                                          color:HexColor(Colors_theme.dark_app_color),
                                          borderRadius:BorderRadius.circular(10),
                                        ),
                                        child:
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.circular(45),

                                              ),
                                              child: Icon(Icons.note,size: 20,color: Colors.white,),
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Holiday",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight:FontWeight.bold),),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("View Details",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:4.0),
                                                  child: Icon(Icons.arrow_forward_outlined,size: 16,color: Theme.of(context).primaryColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSwitch()
  {
    return Switch(
      onChanged: toggleSwitch,
      value: true,
      activeColor: Colors.blue,
      activeTrackColor: Colors.blue,
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey,
    );
  }

  void toggleSwitch(bool value)
  {
    if(value == false)
    {
      setState(() {
        Theme_preferences.set_theme(true);
        isSwitched = true;
      });
    }
    else
    {
      setState(() {
        isSwitched = false;
        Theme_preferences.set_theme(false);
      });
    }
  }


  Future Load_Preferences() async
  {
     prefs=await SharedPreferences.getInstance();
     Theme_preferences.get_theme().then((value){
       setState(() {
         isSwitched=value!;
         if(isSwitched==true)
           isDarkModeEnabled=false;
         else
           isDarkModeEnabled=true;
       });
     });
  }
}

class Entry
{
  final String title;
  final List<Entry> children;
  Entry(this.title,[this.children=const <Entry>[]]);
}

final List<Entry> data=<Entry>[
  Entry(
    'Dashboard',
  ),
  Entry(
      'Organization',
      <Entry>[
        Entry('Department'),
        Entry('Designation'),
        Entry('Client'),
        Entry('Employee'),
      ]),
  Entry(
      'Services',
      <Entry>[
        Entry('Category'),
        Entry('Service'),
      ]),
  Entry(
      'Sales',
      <Entry>[
        Entry('Proposal'),
        Entry('Quotation'),
        Entry('Summary'),
        Entry('Payment'),
        Entry('Sales Report'),
      ]),
  Entry(
      'Invoice',
      <Entry>[
        Entry('Proforma Invoice'),
        Entry('Final Invoice'),
      ]),
    Entry(
      'Expenses',
    ),
    Entry(
      'Settings',
    ),
];

class EntryItem extends StatelessWidget{
  const EntryItem(this.entry);
  final Entry entry;

  Widget _buildTiles(Entry root)
  {
    if(root.children.isEmpty)
    {
      return ListTile(title:Text(root.title,style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold
      ),));
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return _buildTiles(entry);
  }


}
