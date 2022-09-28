import 'package:dks_hrm/model/Contact/ContactModel.dart';
import 'package:dks_hrm/model/Quotation/Quotation_service_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/provider/Login_provider/Item_provider.dart';
import 'package:dks_hrm/services/Quotation_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactFormItemWidget extends StatefulWidget {
  ContactFormItemWidget(
      {Key? key, required this.contactModel, required this.onRemove, this.index,
        required this.service_drop_list,required this.onSubtotal}) : super(key: key);

  final index;
  ContactModel contactModel;
  final Function onRemove;
  final Function onSubtotal;
  final state = _ContactFormItemWidgetState();
  List<String> service_drop_list=[];
  List<ContactModel> contact_list=[];

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

class _ContactFormItemWidgetState extends State<ContactFormItemWidget> {
  final formKey = GlobalKey<FormState>();
  List<Service_model> service_list=[];
  String token='';
  List<Quotation_service_model> quotation_service_list=[];
  String? choose_service;
  late String service_id;
  Item_provider item_provider=Item_provider();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.Clientcontroller.text=widget.contactModel.client_name;
    // widget.Descriptioncontroller.text=widget.contactModel.description;
    // widget.Pricecontroller.text=widget.contactModel.price;
    // widget.Qtycontroller.text=widget.contactModel.qty;
    Loadtoken();
  //  choose_service=widget.service_drop_list.first;
    item_provider =Provider.of<Item_provider>(context,listen: false);
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(4),
              child:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                     //  "Contact - ${widget.index}",
                        "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.orange),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  //Clear All forms Data
                                  // widget.contactModel.qty = "";
                                  // widget.contactModel.description = "";
                                  // widget.contactModel.price = "";
                                  // widget.contactModel.client_name = "";
                                  // widget.Qtycontroller.clear();
                                  // widget.Descriptioncontroller.clear();
                                  // widget.Pricecontroller.clear();
                                  // widget.Clientcontroller.clear();
                                });
                              },
                              child: Text(
                                "",
                                style: TextStyle(color: Colors.blue),
                              )
                          ),
                          TextButton(
                              onPressed: () => widget.onRemove(),
                              child:
                              Row(
                                mainAxisAlignment:MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.clear,color: Colors.redAccent,),
                                  // Text(
                                  //   "Delete",
                                  //   style: TextStyle(color: Colors.redAccent),
                                  // ),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),

                  TextField(
                    enableInteractiveSelection: true,
                    readOnly: true,
                    controller: widget.Descriptioncontroller,
                    onChanged: (value) => widget.contactModel.description = value,
                  //  onSaved: (value) => widget.contactModel.description = value!,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Enter description",
                      labelText: "Description",
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border:Border.all(width: 2.0, color: const Color(0xff7B7A7A)),
                    ),
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
                        DropdownButton(
                          value: choose_service,
                          onChanged: (newvalue){
                            setState(() {
                              choose_service=newvalue as String;
                              widget.contactModel.item_id = newvalue;
                              getService().then((v){
                                getQuotation_service().then((value){
                                  widget.Descriptioncontroller.text=quotation_service_list[0].short_descr;
                                  widget.Pricecontroller.text=quotation_service_list[0].price;
                                  widget.Qtycontroller.text="1";
                                  widget.contactModel.price=widget.Pricecontroller.text;
                                  widget.contactModel.description=widget.Descriptioncontroller.text;
                                  widget.Totalcontroller.text=(int.parse(quotation_service_list[0].price)*int.parse(widget.Qtycontroller.text)).toString();
                                  widget.contactModel.subtotal=widget.Totalcontroller.text;
                                  widget.onSubtotal();
                                  widget.Grandtotalcontroller.text=quotation_service_list[0].price;
                                  widget.Discountcontroller.text='';
                                });
                              });
                            });
                          },
                          underline: SizedBox(),
                          dropdownColor: Colors.white,
                          hint:Text("Select service",style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
                          items:widget.service_drop_list.map((valueitem) {
                            return DropdownMenuItem(
                                value: valueitem,
                                child:Text(valueitem.toString(),style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),)
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    enableInteractiveSelection: true,
                    readOnly: true,
                    controller: widget.Pricecontroller,
                    onChanged: (value) => widget.contactModel.price = value,
                    onSaved: (value) => widget.contactModel.price = value!,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Enter Price",
                      labelText: "Price",
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: widget.Qtycontroller,
                    onChanged: (value)
                    {
                      widget.Totalcontroller.text=(int.parse(widget.Pricecontroller.text)*int.parse(widget.Qtycontroller.text)).toString();
                      widget.contactModel.subtotal=widget.Totalcontroller.text;
                      widget.onSubtotal();
                      widget.contactModel.qty = value;
                    },
                    onSaved: (value) => widget.contactModel.qty = value!,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Enter Quantity",
                      labelText: "Quantity",
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: widget.Totalcontroller,
                    // initialValue: widget.contactModel.name,
                    keyboardType: TextInputType.number,
                    enableInteractiveSelection: true,
                    readOnly: true,
                    onChanged: (value) => widget.contactModel.subtotal = value,
                    onSaved: (value) => widget.contactModel.subtotal = value!,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Subtotal",
                      labelText: "Total",
                    ),
                  ),
                ],
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
        widget.contactModel.item_id=service_id;
      }
    }
  }

}