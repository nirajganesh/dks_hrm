import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Contact/ContactModel.dart';
import 'package:dks_hrm/model/Quotation/Edit_item_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_service_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Quotation/Edit/Quotation_edit_item_modal.dart';
import 'package:dks_hrm/services/Quotation_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Quotation_edit_list extends StatefulWidget {

  Quotation_edit_list({
    Key? key,required this.edit_model,this.index,
    required this.onSubtotal,required this.onEdit,
    required this.theme,
  }) : super(key: key);

  final index;
  Edit_item_model edit_model;
  final Function onSubtotal;
  final Function onEdit;
  final bool theme;

  final state=_Quotation_edit_listState();
  List<String> service_drop_list=[];
  List<ContactModel> contact_list=[];

  @override
  _Quotation_edit_listState createState() => state;

  bool isValidated() => state.validate();
  TextEditingController Qtycontroller = TextEditingController();
  TextEditingController Descriptioncontroller = TextEditingController();
  TextEditingController Pricecontroller = TextEditingController();
  TextEditingController Clientcontroller= TextEditingController();
  final TextEditingController Discountcontroller= TextEditingController();
  final TextEditingController Subtotalcontroller= TextEditingController();
  final TextEditingController Grandtotalcontroller= TextEditingController();
  final TextEditingController Totalcontroller= TextEditingController();
}


class _Quotation_edit_listState extends State<Quotation_edit_list> {

  final formKey = GlobalKey<FormState>();
  List<Service_model> service_list=[];
  String token='';
  List<Quotation_service_model> quotation_service_list=[];
  String? choose_service;
  late String service_id;

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Material(
      child: Padding(
        padding: const EdgeInsets.only(top:7.0),
        child: Form(
          key: formKey,
          child:
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
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
              padding: const EdgeInsets.all(8.0),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.edit_model.service_name,style: TextStyle(color:Colors.black,fontSize: 18),),
                          Text("₹ "+(int.parse(widget.edit_model.price)*int.parse(widget.edit_model.qty)).toString(),style: TextStyle(color:Colors.black,fontSize: 18),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text(widget.edit_model.description,style: TextStyle(color:Colors.black,fontSize: 13),),
                      SizedBox(height: 3,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Price:",style: TextStyle(color:Colors.grey,fontSize: 13),),
                                Text("₹"+widget.edit_model.price,style: TextStyle(color:Colors.black,fontSize: 14),),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Qty:",style: TextStyle(color:Colors.grey,fontSize: 13),),
                                Text(widget.edit_model.qty,style: TextStyle(color:Colors.black,fontSize: 14),),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  flex:4,
                                  child:
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children: [
                                      TouchRippleEffect(
                                        borderRadius: BorderRadius.circular(5),
                                        rippleColor: Colors.white60,
                                        onTap:(){
                                          _displayBottomSheet();
                                        },
                                        child: Container(
                                          width:33,
                                          height:33,
                                          decoration:BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: Color(0xffFFA74D),
                                          ),
                                          child:Icon(Icons.edit,color:Colors.white,size: 20,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                ],
              ),
            ),
          ),
        ),
      ),
    ):
      Padding(
        padding:const EdgeInsets.only(top:7.0),
        child: Container(
          decoration: BoxDecoration(
            color: HexColor(Colors_theme.dark_app_color),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top:1.0),
            child: Form(
              key: formKey,
              child:
              Container(
                decoration: BoxDecoration(
                  color:HexColor(Colors_theme.dark_app_color),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.edit_model.service_name,style: TextStyle(color:Colors.white,fontSize: 18),),
                          Text("₹ "+(int.parse(widget.edit_model.price)*int.parse(widget.edit_model.qty)).toString(),style: TextStyle(color:Colors.white,fontSize: 18),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text(widget.edit_model.description,style: TextStyle(color:Colors.white,fontSize: 13),),
                      SizedBox(height: 3,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Price:",style: TextStyle(color:Colors.white24,fontSize: 13),),
                                Text("₹"+widget.edit_model.price,style: TextStyle(color:Colors.white,fontSize: 14),),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Qty:",style: TextStyle(color:Colors.white24,fontSize: 13),),
                                Text(widget.edit_model.qty,style: TextStyle(color:Colors.white,fontSize: 14),),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  flex:4,
                                  child:
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children: [
                                      TouchRippleEffect(
                                        borderRadius: BorderRadius.circular(5),
                                        rippleColor: Colors.white60,
                                        onTap:(){
                                          _displayBottomSheet();
                                        },
                                        child: Container(
                                          width:33,
                                          height:33,
                                          decoration:BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: Color(0xffFFA74D),
                                          ),
                                          child:Icon(Icons.edit,color:Colors.white,size: 20,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }

  bool validate() {
    //Validate Form Fields by form key
    bool validate = formKey.currentState!.validate();
    if (validate) formKey.currentState!.save();
    return validate;
  }

  void _displayBottomSheet()
  {
    showModalBottomSheet(context: context, enableDrag: true,builder: (BuildContext c){
      return Container(
        child:
        Quotation_edit_item_modal(
          edit_model:widget.edit_model,
          onResult_edit: ()=> onResult_edit(),
          theme:widget.theme,
        ),
      );
    });
  }

  onResult_edit()
  {
    setState(() {
      widget.onEdit();
    });
  }

  Loadtoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
    });
  }

  Future getQuotation_service() async
  {
    service_list=await service.getService(context,token);
    for(var ser in service_list)
    {
      if(choose_service.toString()==ser.name)
      {
        service_id=ser.id!;
      }
    }
    quotation_service_list=await Quotation_service.getQuotation_item_service(context,service_id,token);
  }


  Future getService() async
  {
    service_list=await service.getService(context,token);
    for(var ser in service_list)
    {
      if(choose_service.toString()==ser.name)
      {
        service_id=ser.id!;
        widget.edit_model.item_id=service_id;
      }
    }
  }
}

