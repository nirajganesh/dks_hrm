import 'package:dks_hrm/auth/Login_screen.dart';
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/screen/Holiday/Holiday.dart';
import 'package:dks_hrm/services/Holiday_service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Add_holiday extends StatefulWidget {

  bool theme;
  String token;

  Add_holiday({
    required this.theme,
    required this.token,
    Key? key}) : super(key: key);

  @override
  _Add_holidayState createState() => _Add_holidayState();
}

class _Add_holidayState extends State<Add_holiday> {
  final TextEditingController Searchholidaycontroller= TextEditingController();
  final TextEditingController Holidaynamecontroller= TextEditingController();
  final TextEditingController Fromdatecontroller= TextEditingController();
  final TextEditingController Todatecontroller= TextEditingController();
  final TextEditingController Numberofdaycontroller= TextEditingController();
  final TextEditingController Yearcontroller= TextEditingController();
  DateTime dateTime_from=DateTime.now();
  DateTime dateTime_to=DateTime.now();
  String from_Date='(from_date)';
  String to_Date='(to_date)';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fromdatecontroller.text=dateTime_from.day.toString()+"-"+dateTime_from.month.toString()+"-"+dateTime_from.year.toString();
    Todatecontroller.text=dateTime_to.day.toString()+"-"+dateTime_to.month.toString()+"-"+dateTime_to.year.toString();
  }
  @override
  Widget build(BuildContext context) {

    return
      widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Add Holiday",style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor:Colors.white,
      body:
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor("#F9FAFF"),
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
                          controller:Holidaynamecontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Holiday Name',
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
                GestureDetector(
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        dateTime_from=date!;
                        Fromdatecontroller.text=dateTime_from.day.toString()+"-"+dateTime_from.month.toString()+"-"+dateTime_from.year.toString();
                      });
                    });
                  },
                  child:
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor("#F9FAFF"),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width:10.0),
                        Flexible(
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
                                Fromdatecontroller.text+from_Date,style: (TextStyle(color: Colors.black87,fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        dateTime_to=date!;
                        Todatecontroller.text=dateTime_from.day.toString()+"-"+dateTime_from.month.toString()+"-"+dateTime_from.year.toString();
                      });
                    });
                  },
                  child:
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor("#F9FAFF"),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width:10.0),
                        Flexible(
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
                                Todatecontroller.text+to_Date,style: (TextStyle(color: Colors.black87,fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: HexColor("#F9FAFF"),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.note,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller:Numberofdaycontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Number of days',
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
                    color: HexColor("#F9FAFF"),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.date_range,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller:Yearcontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Year',
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
      GestureDetector(
        onTap: (){
          if(Holidaynamecontroller.text.isNotEmpty)
            {
              if(Numberofdaycontroller.text.isNotEmpty)
                {
                  if(Yearcontroller.text.isNotEmpty)
                    {
                      _onLoading();
                      addHoliday();
                    }
                  else
                    {
                      Notify_widget.notify("Please add the year");
                    }
                }
              else
                {
                  Notify_widget.notify("Please add the total number of days");
                }
            }
          else
            {
              Notify_widget.notify("Please add the holiday name");
            }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Holiday",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    ):
      Scaffold(
        appBar: AppBar(
          title: Text("Add Holiday",style: TextStyle(color: Colors.white),),
          backgroundColor: HexColor(Colors_theme.dark_app_color),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor:HexColor(Colors_theme.dark_background),
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
                            controller:Holidaynamecontroller,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Holiday Name',
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
                  GestureDetector(
                    onTap: (){
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                        setState(() {
                          dateTime_from=date!;
                          Fromdatecontroller.text=dateTime_from.day.toString()+"-"+dateTime_from.month.toString()+"-"+dateTime_from.year.toString();
                        });
                      });
                    },
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
                          SizedBox(width:10.0),
                          Flexible(
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
                                  Fromdatecontroller.text+from_Date,style: (TextStyle(color: Colors.white,fontSize: 14)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                        setState(() {
                          dateTime_to=date!;
                          Todatecontroller.text=dateTime_from.day.toString()+"-"+dateTime_from.month.toString()+"-"+dateTime_from.year.toString();
                        });
                      });
                    },
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
                          SizedBox(width:10.0),
                          Flexible(
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
                                  Todatecontroller.text+to_Date,style: (TextStyle(color: Colors.white,fontSize: 14)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right:8.0),
                          child: Icon(Icons.note,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child: TextField(
                            controller:Numberofdaycontroller,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Number of days',
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
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right:8.0),
                          child: Icon(Icons.date_range,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child: TextField(
                            controller:Yearcontroller,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Year',
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
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:
        GestureDetector(
          onTap: (){
            if(Holidaynamecontroller.text.isNotEmpty)
            {
              if(Numberofdaycontroller.text.isNotEmpty)
              {
                if(Yearcontroller.text.isNotEmpty)
                {
                  _onLoading();
                  addHoliday();
                }
                else
                {
                  Notify_widget.notify("Please add the year");
                }
              }
              else
              {
                Notify_widget.notify("Please add the total number of days");
              }
            }
            else
            {
              Notify_widget.notify("Please add the holiday name");
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(child: Text("Save Holiday",style: TextStyle(color: Colors.white,fontSize: 16),)),
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

  Future addHoliday() async
  {
    var response=await Holiday_service.addHoliday(Holidaynamecontroller.text,Fromdatecontroller.text,Todatecontroller.text,
        Numberofdaycontroller.text,Yearcontroller.text,widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Holiday()), (Route<dynamic> route) => false);
    }
    else if(response['message']=="Expired token")
    {
      Removetoken();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Login_screen()), (Route<dynamic> route) => false);
    }
    else
      {
        Navigator.pop(context);
        Notify_widget.notify(response['message']);
      }
  }

  Removetoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

}
