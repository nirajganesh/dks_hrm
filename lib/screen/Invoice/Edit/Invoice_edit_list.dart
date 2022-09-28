import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Contact/ContactModel.dart';
import 'package:dks_hrm/model/Quotation/Edit_item_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_service_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Invoice/Edit/Invoice_edit_item_modal.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Invoice_edit_list extends StatefulWidget {

  Invoice_edit_list({
    required this.edit_model,this.index,
    required this.onSubtotal,required this.onEdit,
    required this.theme,
    Key? key}) : super(key: key);
  final index;
  Edit_item_model edit_model;
  final Function onSubtotal;
  final Function onEdit;
  final bool theme;

  final state=_Invoice_edit_listState();
  List<String> service_drop_list=[];
  List<ContactModel> contact_list=[];

  @override
  _Invoice_edit_listState createState() => state;

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

class _Invoice_edit_listState extends State<Invoice_edit_list> {

  final formKey = GlobalKey<FormState>();
  List<Service_model> service_list=[];
  String token='';
  List<Quotation_service_model> invoice_service_list=[];
  String? choose_service;
  late String service_id;

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Material(
      child: Padding(
        padding: const EdgeInsets.only(top:10.0),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child:
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
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
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            color: HexColor(Colors_theme.dark_app_color),
          ),
          child:
              Padding(
                  padding: const EdgeInsets.only(top:4.0),
                  child: Form(
                    key: formKey,
                    child:
                    Container(
                      decoration: BoxDecoration(
                        color: HexColor(Colors_theme.dark_app_color),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.edit_model.service_name,style: TextStyle(color:Colors.white24,fontSize: 18),),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child:
                                        Row(
                                          mainAxisAlignment:MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
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
    bool validate = formKey.currentState!.validate();
    if (validate) formKey.currentState!.save();
    return validate;
  }

  void _displayBottomSheet()
  {
    showModalBottomSheet(context: context, enableDrag: true,builder: (BuildContext c){
      return Container(
        child:
        Invoice_edit_item_modal(
          edit_model:widget.edit_model,
          onResult_edit: ()=> onResult_edit(),
          theme:widget.theme,
         ),
       );
      }
    );
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
