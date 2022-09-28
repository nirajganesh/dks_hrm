import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Contact/ContactModel.dart';
import 'package:dks_hrm/model/Quotation/Quotation_service_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Invoice/Add/Invoice_edit_modal.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Invoice_list_add extends StatefulWidget {

  Invoice_list_add({
    Key? key,required this.contactModel, required this.onRemove, this.index,
    required this.service_drop_list,required this.onSubtotal,
    required this.onEdit,required this.theme}) : super(key: key);

  final index;
  ContactModel contactModel;
  final Function onRemove;
  final Function onEdit;
  final Function onSubtotal;
  List<String> service_drop_list=[];
  List<ContactModel> contact_list=[];
  final bool theme;
  final state = _Invoice_list_addState();


  @override
  State<StatefulWidget> createState() {
    return state;
  }

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


class _Invoice_list_addState extends State<Invoice_list_add> {
  final formKey = GlobalKey<FormState>();
  List<Service_model> service_list=[];
  List<String> service_drop=[];
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
        padding: const EdgeInsets.only(top:4.0,bottom:12.0),
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
                  SingleChildScrollView(
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.contactModel.item_name,style: TextStyle(color:Colors.black,fontSize: 18),),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("₹ "+(int.parse(widget.contactModel.price)*int.parse(widget.contactModel.qty)).toString(),style: TextStyle(color:Colors.black,fontSize: 18),),
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Text(widget.contactModel.description,style: TextStyle(color:Colors.black,fontSize: 13),),
                        SizedBox(height: 3,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Price:",style: TextStyle(color:Colors.grey,fontSize: 13),),
                                  Text("₹"+widget.contactModel.price,style: TextStyle(color:Colors.black,fontSize: 14),),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Qty:",style: TextStyle(color:Colors.grey,fontSize: 13),),
                                  Text(widget.contactModel.qty,style: TextStyle(color:Colors.black,fontSize: 14),),
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
                                        GestureDetector(
                                          onTap:()
                                          {
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
                                        SizedBox(width: 5,),
                                        GestureDetector(
                                          onTap:()
                                          {
                                            widget.onRemove();
                                          },
                                          child: Container(
                                            width:33,
                                            height:33,
                                            decoration:BoxDecoration(
                                              borderRadius: BorderRadius.circular(25),
                                              color: Color(0xffE71157),
                                            ),
                                            child:Icon(Icons.delete,color:Colors.white,size: 20,),
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
                      ],
                    ),
                  ),
            ),
          ),
        ),
      ),
    ):
      Padding(
        padding: const EdgeInsets.only(top:4.0,bottom:12.0),
        child: Container(
          decoration: BoxDecoration(
            color: HexColor(Colors_theme.dark_app_color),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top:4.0,bottom:12.0),
            child: Form(
              key: formKey,
              child:
              Container(
                decoration: BoxDecoration(
                  color: HexColor(Colors_theme.dark_app_color),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  SingleChildScrollView(
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.contactModel.item_name,style: TextStyle(color:Colors.white,fontSize: 18),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("₹ "+(int.parse(widget.contactModel.price)*int.parse(widget.contactModel.qty)).toString(),style: TextStyle(color:Colors.white,fontSize: 18),),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Text(widget.contactModel.description,style: TextStyle(color:Colors.white,fontSize: 13),),
                        SizedBox(height: 3,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Price:",style: TextStyle(color:Colors.white24,fontSize: 13),),
                                  Text("₹"+widget.contactModel.price,style: TextStyle(color:Colors.white,fontSize: 14),),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Qty:",style: TextStyle(color:Colors.white24,fontSize: 13),),
                                  Text(widget.contactModel.qty,style: TextStyle(color:Colors.white,fontSize: 14),),
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
                                        GestureDetector(
                                          onTap:()
                                          {
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
                                        SizedBox(width: 5,),
                                        GestureDetector(
                                          onTap:()
                                          {
                                            widget.onRemove();
                                          },
                                          child: Container(
                                            width:33,
                                            height:33,
                                            decoration:BoxDecoration(
                                              borderRadius: BorderRadius.circular(25),
                                              color: Color(0xffE71157),
                                            ),
                                            child:Icon(Icons.delete,color:Colors.white,size: 20,),
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
                      ],
                    ),
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
        Invoice_edit_modal(
          contactModel:widget.contactModel,
          onResult_edit: ()=> onResult_edit(),
          service_drop_list:service_drop,
          theme:widget.theme,
        ),
      );
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
      service_drop.add(ser.name.toString());
    }
  }

  onResult_edit()
  {
    setState(() {
      widget.onEdit();
    });
  }
}
