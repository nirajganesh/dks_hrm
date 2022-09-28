import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/screen/Category/Category.dart';
import 'package:dks_hrm/services/Service_category_service.dart';
import 'package:dks_hrm/widget/App_bar_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Edit_category extends StatefulWidget {

  String id,cname,token;
  bool theme;
  Edit_category({required this.id,required this.cname,required this.token,required this.theme,Key? key}) : super(key: key);

  @override
  _Edit_categoryState createState() => _Edit_categoryState();
}

class _Edit_categoryState extends State<Edit_category> {

  final TextEditingController Categorynamecontroller= TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Categorynamecontroller.text=widget.cname;
  }

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Scaffold(
      appBar:  App_bar_widget.App_bar(context,"Edit Category",Colors_theme.light_app_color),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
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
                        controller: Categorynamecontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Category Name',
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
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          if(Categorynamecontroller.text.isNotEmpty)
          {
            _onLoading();
            updateCategory();
          }
          else
          {
            Notify_widget.notify("Please add the category name");
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Category",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    ):
      Scaffold(
        appBar: App_bar_widget.App_bar(context,"Edit Category",Colors_theme.dark_app_color),
        backgroundColor: HexColor(Colors_theme.dark_background),
        body: Container(
          decoration: BoxDecoration(
            color: HexColor(Colors_theme.dark_background),
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
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
                          controller: Categorynamecontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Category Name',
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
        bottomNavigationBar:
        TouchRippleEffect(
          rippleColor: Colors.white60,
          onTap: (){
            if(Categorynamecontroller.text.isNotEmpty)
            {
              _onLoading();
              updateCategory();
            }
            else
            {
              Notify_widget.notify("Please add the category name");
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(child: Text("Save Category",style: TextStyle(color: Colors.white,fontSize: 16),)),
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
  Future updateCategory() async
  {
    var response=await Service_category_service.updateCategory(widget.id,Categorynamecontroller.text,widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Category()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
    }
  }
}
