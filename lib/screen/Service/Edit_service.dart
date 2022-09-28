import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Category/Category_model.dart';
import 'package:dks_hrm/screen/Service/Service.dart';
import 'package:dks_hrm/services/Service_category_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class Edit_service extends StatefulWidget {

  String id,name,short_descr,long_descr,price,token,status,cname;
  List<String> cat_drop_list=[];
  bool theme;

  Edit_service({required this.id,required this.name,required this.price,required this.short_descr,
    required this.long_descr,required this.status,required this.cat_drop_list,required this.cname,
    required this.token,required this.theme,Key? key}) : super(key: key);

  @override
  _Edit_serviceState createState() => _Edit_serviceState();
}

class _Edit_serviceState extends State<Edit_service> {

  final TextEditingController Servicenamecontroller= TextEditingController();
  final TextEditingController Categorynamecontroller= TextEditingController();
  final TextEditingController Pricecontroller= TextEditingController();
  final TextEditingController Statuscontroller= TextEditingController();
  final TextEditingController ShortDescriptioncontroller= TextEditingController();
  final TextEditingController LongDescriptioncontroller= TextEditingController();

  List<String> status_list=<String>['Active','InActive'];
  late String choose_status;
  late String choose_category;
  late String category_id;
  List<Category_model> category_list=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.status=="1")
    {
      choose_status="Active";
    }
    else
      {
        choose_status="InActive";
      }
    choose_category=widget.cname;
    Categorynamecontroller.text=choose_category;
    Servicenamecontroller.text=widget.name;
    Pricecontroller.text=widget.price;
    ShortDescriptioncontroller.text=widget.short_descr;
    LongDescriptioncontroller.text=widget.long_descr;
  }


  @override
  Widget build(BuildContext context)
  {
    return
      widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Edit Service",style: TextStyle(color: Colors.white),),
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
                        child: Icon(Icons.supervised_user_circle_rounded,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Servicenamecontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Service Name',
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
                          controller: Pricecontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Price',
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
                        child:
                        Autocomplete(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            return searchData_category(textEditingValue.text);
                          },
                          fieldViewBuilder: (context,controller,focusnode,onEditingComplete){
                            return TextField(
                              style: TextStyle(height: 1),
                              controller: controller,
                              focusNode: focusnode,
                              onEditingComplete: onEditingComplete,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff00ffffff)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff00ffffff)),
                                ),
                                hintText: choose_category,
                              ),
                            );
                          },
                          onSelected: (value)
                          {
                            choose_category=value.toString();
                            Categorynamecontroller.text=choose_category;
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus)
                            {
                              currentFocus.unfocus();
                            }
                          },
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
                 child: Row(
                    children: [
                       Padding(
                         padding: const EdgeInsets.only(left:8.0,right:8.0),
                         child: Icon(Icons.repeat,color: Colors.black38),
                   ),
                   Container(
                     width: 1.0,
                     height: 25.0,
                     color:Color(0xff7B7A7A),
                   ),
                   SizedBox(width:8.0),
                   Flexible(
                     child:
                     Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: DropdownButton(
                        isExpanded: true,
                        value: choose_status,
                        onChanged: (newvalue){
                          setState(() {
                            choose_status=newvalue as String;
                            if(choose_status=='Active')
                            {
                              Statuscontroller.text="1";
                              choose_status=status_list.first;
                            }
                            else
                            {
                              Statuscontroller.text="0";
                              choose_status=status_list.last;
                            }
                          });
                        },
                        underline: SizedBox(),
                        dropdownColor: Colors.white,
                        hint:Text(choose_status.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
                        items:status_list.map((valueitem) {
                          return DropdownMenuItem(
                              value: valueitem,
                              child:Text(valueitem.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),)
                          );
                        }).toList(),
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
                          controller: ShortDescriptioncontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Short Description',
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
                          controller:LongDescriptioncontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Long Description',
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
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          if(Servicenamecontroller.text.isNotEmpty)
          {
            if(Pricecontroller.text.isNotEmpty)
            {
              if(Categorynamecontroller.text.isNotEmpty)
              {
                if(ShortDescriptioncontroller.text.isNotEmpty)
                {
                  if(LongDescriptioncontroller.text.isNotEmpty)
                  {
                    _onLoading();
                    updateService();
                  }
                  else
                  {
                    Notify_widget.notify("Please add the long description");
                  }
                }
                else
                {
                  Notify_widget.notify("Please add the short description");
                }
              }
              else
              {
                Notify_widget.notify("Please add the category");
              }
            }
            else
            {
              Notify_widget.notify("Please add the price");
            }
          }
          else
          {
            Notify_widget.notify("Please add the service name");
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(child: Text("Save Service",style: TextStyle(color: Colors.white,fontSize: 16),)),
        ),
      ),
    ):
      Scaffold(
        appBar: AppBar(
          title: Text("Edit Service",style: TextStyle(color: Colors.white),),
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
                          child: Icon(Icons.supervised_user_circle_rounded,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child: TextField(
                            controller: Servicenamecontroller,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Service Name',
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
                            controller: Pricecontroller,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Price',
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
                          child: Icon(Icons.person,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child:
                          Autocomplete(
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              return searchData_category(textEditingValue.text);
                            },
                            fieldViewBuilder: (context,controller,focusnode,onEditingComplete){
                              return TextField(
                                style: TextStyle(height: 1,color: Colors.white),
                                controller: controller,
                                focusNode: focusnode,
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff00ffffff)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff00ffffff)),
                                  ),
                                  hintText: choose_category,
                                  hintStyle: TextStyle(
                                       color:Colors.white24,
                                  )
                                ),
                              );
                            },
                            onSelected: (value){
                              choose_category=value.toString();
                              Categorynamecontroller.text=choose_category;
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
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
                          child: Icon(Icons.repeat,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Flexible(
                          child:
                          Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: DropdownButton(
                              isExpanded: true,
                              value: choose_status,
                              onChanged: (newvalue){
                                setState(()
                                {
                                  choose_status=newvalue as String;
                                  if(choose_status=='Active')
                                  {
                                    Statuscontroller.text="1";
                                    choose_status=status_list.first;
                                  }
                                  else
                                  {
                                    Statuscontroller.text="0";
                                    choose_status=status_list.last;
                                  }
                                });
                              },
                              underline: SizedBox(),
                              dropdownColor: Colors.black,
                              hint:Text(choose_status.toString(),style: TextStyle(color:Colors.white24,fontSize: 15),),
                              items:status_list.map((valueitem) {
                                return DropdownMenuItem(
                                    value: valueitem,
                                    child:Text(valueitem.toString(),style: TextStyle(color:Colors.white,fontSize: 15),)
                                );
                              }).toList(),
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
                            controller: ShortDescriptioncontroller,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Short Description',
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
                            controller:LongDescriptioncontroller,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Long Description',
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
        TouchRippleEffect(
          rippleColor: Colors.white60,
          onTap: (){
            if(Servicenamecontroller.text.isNotEmpty)
            {
              if(Pricecontroller.text.isNotEmpty)
              {
                if(Categorynamecontroller.text.isNotEmpty)
                {
                  if(ShortDescriptioncontroller.text.isNotEmpty)
                  {
                    if(LongDescriptioncontroller.text.isNotEmpty)
                    {
                      _onLoading();
                      updateService();
                    }
                    else
                    {
                      Notify_widget.notify("Please add the long description");
                    }
                  }
                  else
                  {
                    Notify_widget.notify("Please add the short description");
                  }
                }
                else
                {
                  Notify_widget.notify("Please add the category");
                }
              }
              else
              {
                Notify_widget.notify("Please add the price");
              }
            }
            else
            {
              Notify_widget.notify("Please add the service name");
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(child: Text("Save Service",style: TextStyle(color: Colors.white,fontSize: 16),)),
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

  Future updateService() async
  {
    category_list=await Service_category_service.getCategory(context,widget.token);
    for(var cat in category_list)
    {
      if(choose_category.toString()==cat.cname)
      {
        category_id=cat.id;
      }
    }
    if(choose_status=='Active')
    {
      Statuscontroller.text="1";
    }
    else
    {
      Statuscontroller.text="0";
    }
    var response=await service.updateService(widget.id,category_id,Servicenamecontroller.text,
        ShortDescriptioncontroller.text,LongDescriptioncontroller.text,Pricecontroller.text,Statuscontroller.text,
        widget.token);
    if(response['status']==200)
    {
      Navigator.of(context).pop();
      Notify_widget.notify(response['message']);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Service()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.of(context).pop();
      Notify_widget.notify(response['message']);
    }
  }

  List<String> searchData_category(String param)
  {
    List<String> result=widget.cat_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }
}
