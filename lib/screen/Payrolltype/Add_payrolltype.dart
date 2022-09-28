import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/screen/Payrolltype/Payrolltype.dart';
import 'package:dks_hrm/services/Payroll_type_service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Add_payrolltype extends StatefulWidget {

  String token;
  bool theme;
  Add_payrolltype({required this.token,required this.theme,Key? key}) : super(key: key);

  @override
  _Add_payrolltypeState createState() => _Add_payrolltypeState();
}

class _Add_payrolltypeState extends State<Add_payrolltype> {

  final TextEditingController Salarytypecontroller= TextEditingController();
  final TextEditingController Createdatecontroller= TextEditingController();
  DateTime _dateTime=DateTime.now();

  @override
  void initState() {
    super.initState();
    Createdatecontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Add PayslipsType",style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        child: Icon(Icons.monetization_on,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Salarytypecontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'SalaryType(Monthly,Hourly)',
                              hintStyle: TextStyle(
                                  color: Colors.black38
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor("#f5f5f5"),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child:Padding(
                    padding: const EdgeInsets.only(left:8,right:8),
                    child:
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                            setState(() {
                              _dateTime=date!;
                              Createdatecontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
                            });
                          });
                          //_toDate(context);
                        },
                        child:
                        Row(
                          children: [
                            Icon(Icons.date_range,color: Colors.black38,),
                            SizedBox(width:5),
                            Container(
                              width: 1.0,
                              height: 25.0,
                              color:Color(0xff7B7A7A),
                            ),
                            SizedBox(width:8.0),
                            Text(
                              Createdatecontroller.text,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ),
                SizedBox(height: 20,),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     primary: Theme.of(context).primaryColor,
                //     onPrimary: Colors.white,
                //     elevation: 3,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(40.0)),
                //     minimumSize: Size(double.infinity, 45),
                //   ),
                //   onPressed: () {
                //     _onLoading();
                //     addPayrolltype();
                //   },
                //   child: Text("Save Payrolltype",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          _onLoading();
          addPayrolltype();
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Payrolltype",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    ):
      Scaffold(
        appBar: AppBar(
          title: Text("Add PayslipsType",style: TextStyle(color: Colors.white),),
          backgroundColor: HexColor(Colors_theme.dark_app_color),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: HexColor(Colors_theme.dark_background),
        body: Container(
          decoration: BoxDecoration(
            color: HexColor(Colors_theme.dark_background),
          ),
          child: Padding(
            padding: EdgeInsets.all(14),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                          child: Icon(Icons.monetization_on,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child: TextField(
                            controller: Salarytypecontroller,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'SalaryType(Monthly,Hourly)',
                                hintStyle: TextStyle(
                                    color: Colors.white24
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor(Colors_theme.dark_app_color),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 50,
                    child:Padding(
                      padding: const EdgeInsets.only(left:8,right:8),
                      child:
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                              setState(() {
                                _dateTime=date!;
                                Createdatecontroller.text=_dateTime.day.toString()+"-"+_dateTime.month.toString()+"-"+_dateTime.year.toString();
                              });
                            });
                            //_toDate(context);
                          },
                          child:
                          Row(
                            children: [
                              Icon(Icons.date_range,color: Colors.white24,),
                              SizedBox(width:5),
                              Container(
                                width: 1.0,
                                height: 25.0,
                                color:Color(0xff7B7A7A),
                              ),
                              SizedBox(width:8.0),
                              Text(
                                Createdatecontroller.text,style: (TextStyle(color: Colors.white,fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:
        TouchRippleEffect(
          rippleColor: Colors.white60,
          onTap: (){
            _onLoading();
            addPayrolltype();
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(child: Text("Save Payrolltype",style: TextStyle(color: Colors.white,fontSize: 16),)),
          ),
        ),
      );
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

  Future addPayrolltype() async
  {
    var response=await Payroll_type_service.addPayroll_type_list(Salarytypecontroller.text,Createdatecontroller.text,widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
         Payrolltype()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
    }
  }
}
