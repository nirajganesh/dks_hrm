import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Invoice/Invoice_item_model.dart';
import 'package:dks_hrm/model/Quotation/Edit_item_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Invoice/Add/Invoice_add_modal.dart';
import 'package:dks_hrm/screen/Invoice/Add/Invoice_list_add.dart';
import 'package:dks_hrm/screen/Invoice/Edit/Invoice_detail_edit_modal.dart';
import 'package:dks_hrm/screen/Invoice/Edit/Invoice_edit_list.dart';
import 'package:dks_hrm/screen/Invoice/Invoice.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Invoice_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/App_bar_widget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Service_Invoice_edit extends StatefulWidget {

  List<String> client_drop_list=[];
  List<String> service_drop_list=[];
  String inv_date;
  String invoice_no;
  String due_date;
  String choose_client;
  String remarks;
  List list_data=[];

  Service_Invoice_edit({
    required this.client_drop_list,
    required this.service_drop_list,
    required this.inv_date,
    required this.invoice_no,
    required this.due_date,
    required this.choose_client,
    required this.remarks,
    required this.list_data,
    Key? key}) : super(key: key);

  @override
  _Service_Invoice_editState createState() => _Service_Invoice_editState();


}

class _Service_Invoice_editState extends State<Service_Invoice_edit> {

  late String token="";
  List<Invoice_list_add> contactForms = List.empty(growable: true);
  List<Invoice_edit_list> editForms = List.empty(growable: true);
  final ScrollController scrollController=ScrollController();
  bool checker=false;
  final TextEditingController SubtotalController=TextEditingController();
  final TextEditingController GrandtotalController=TextEditingController();
  final TextEditingController PaidtotalController=TextEditingController();
  final TextEditingController DuetotalController=TextEditingController();


  List<Service_model> service_list=[];
  List<Client_model> client_list=[];
  late String service_name;
  List<Invoice_item_model> invoice_item_list=[];
  final TextEditingController StatusController=TextEditingController();
  final TextEditingController RemarkController=TextEditingController();
  bool valuefirst=false;
  late String client_id;
  bool theme=false;


  @override
  void initState() {
    super.initState();
    LoadTheme();
    Loadtoken();
  }

  @override
  Widget build(BuildContext context) {
    return
      theme==true?
      Scaffold(
      appBar: App_bar_widget.App_bar(context,"Edit Invoice List",Colors_theme.light_app_color),
      body:
      Container(
        color: HexColor("#F9FAFF"),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Text("Invoice Details",style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
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
                            children: [
                                  Opacity(
                                    opacity:0.4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("#"+widget.invoice_no,style: TextStyle(color:Colors.black,fontSize: 16),),
                                        Text(widget.inv_date,style: TextStyle(color:Colors.black,fontSize: 16),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.choose_client,style: TextStyle(color:Colors.black,fontSize: 14),),
                                        Text(widget.due_date,style: TextStyle(color:Colors.black,fontSize: 14),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Opacity(
                                        opacity:0.4,
                                        child:
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Remark:",style: TextStyle(color:Colors.grey,fontSize: 13),),
                                              Text(RemarkController.text,style: TextStyle(color:Colors.black,fontSize: 14),),
                                            ],
                                          ),
                                      ),
                                      Expanded(
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
                                                      _displayBottomSheet_details();
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
                      SizedBox(height: 20,),
                      Text("Invoice Item List",style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
                      editdynamiclist(),
                      SizedBox(height: 10,),
                      dynamiclist(),
                      SizedBox(height: 20,),
                      TouchRippleEffect(
                        borderRadius: BorderRadius.circular(5),
                        rippleColor: Colors.white60,
                        onTap:() {
                          _displayBottomSheet();
                        },
                        child:
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: HexColor("#D5EFFC"),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline,color: Theme.of(context).primaryColor,),
                              Text("Add More Items",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Summary",style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Paid In Advance',style: TextStyle(fontSize: 17.0), ),
                              Checkbox(
                                value: this.valuefirst,
                                onChanged: (bool? value) {
                                  setState(() {
                                    this.valuefirst = value!;
                                    if(this.valuefirst==true)
                                    {
                                      PaidtotalController.text=DuetotalController.text;
                                      DuetotalController.text='0';
                                    }
                                    else
                                    {
                                      DuetotalController.text=PaidtotalController.text;
                                      PaidtotalController.text='0';
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
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
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Amount Paid:",style: TextStyle(color:Colors.grey,fontSize: 14),),
                                            SizedBox(height: 2,),
                                            Text("Amount Due:",style: TextStyle(color:Colors.grey,fontSize: 14),),
                                            SizedBox(height: 2,),
                                            Text("Grand Total:",style: TextStyle(color:Colors.grey,fontSize: 14),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("₹ "+PaidtotalController.text,style: TextStyle(color:Colors.black,fontSize: 16),),
                                            SizedBox(height: 2,),
                                            Text("₹"+DuetotalController.text,style: TextStyle(color:Colors.black,fontSize: 16),),
                                            SizedBox(height: 2,),
                                            Text("₹"+GrandtotalController.text,style: TextStyle(color:Colors.black,fontSize: 16),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar:
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          _onLoading();
          updateInvoice();
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child:
          Padding(
            padding: const EdgeInsets.only(left:8.0,right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: ₹"+GrandtotalController.text,style: TextStyle(color: Colors.white,fontSize: 16),),
                Row(
                  children: [
                    Text("Save Invoice ",style: TextStyle(color: Colors.white,fontSize: 16),),
                    Icon(Icons.arrow_forward_rounded,color: Colors.white,size: 14,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ):
      Scaffold(
        appBar: App_bar_widget.App_bar(context,"Edit Invoice List",Colors_theme.dark_app_color),
        backgroundColor: HexColor(Colors_theme.dark_background),
        body:
        Container(
          color: HexColor(Colors_theme.dark_app_color),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Text("Invoice Details",style: TextStyle(color:Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
                      Container(
                        decoration: BoxDecoration(
                          color: HexColor(Colors_theme.dark_app_color),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          Column(
                            children: [
                              Opacity(
                                opacity:0.4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("#"+widget.invoice_no,style: TextStyle(color:Colors.white,fontSize: 16),),
                                    Text(widget.inv_date,style: TextStyle(color:Colors.white,fontSize: 16),),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                              Opacity(
                                opacity: 0.4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.choose_client,style: TextStyle(color:Colors.white,fontSize: 14),),
                                    Text(widget.due_date,style: TextStyle(color:Colors.white,fontSize: 14),),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Opacity(
                                    opacity:0.4,
                                    child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Remark:",style: TextStyle(color:Colors.white24,fontSize: 13),),
                                        Text(RemarkController.text,style: TextStyle(color:Colors.white,fontSize: 14),),
                                      ],
                                    ),
                                  ),
                                  Expanded(
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
                                                  _displayBottomSheet_details();
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
                      SizedBox(height: 20,),
                      Text("Invoice Item List",style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
                      editdynamiclist(),
                      SizedBox(height: 10,),
                      dynamiclist(),
                      SizedBox(height: 20,),
                      TouchRippleEffect(
                        borderRadius: BorderRadius.circular(5),
                        rippleColor: Colors.white60,
                        onTap:() {
                          _displayBottomSheet();
                        },
                        child:
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: HexColor("#D5EFFC"),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline,color: Theme.of(context).primaryColor,),
                              Text("Add More Items",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Summary",style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Paid In Advance',style: TextStyle(fontSize: 17.0), ),
                              Checkbox(
                                value: this.valuefirst,
                                onChanged: (bool? value) {
                                  setState(() {
                                    this.valuefirst = value!;
                                    if(this.valuefirst==true)
                                    {
                                      PaidtotalController.text=DuetotalController.text;
                                      DuetotalController.text='0';
                                    }
                                    else
                                    {
                                      DuetotalController.text=PaidtotalController.text;
                                      PaidtotalController.text='0';
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
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
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Amount Paid:",style: TextStyle(color:Colors.grey,fontSize: 14),),
                                            SizedBox(height: 2,),
                                            Text("Amount Due:",style: TextStyle(color:Colors.grey,fontSize: 14),),
                                            SizedBox(height: 2,),
                                            Text("Grand Total:",style: TextStyle(color:Colors.grey,fontSize: 14),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("₹ "+PaidtotalController.text,style: TextStyle(color:Colors.black,fontSize: 16),),
                                            SizedBox(height: 2,),
                                            Text("₹"+DuetotalController.text,style: TextStyle(color:Colors.black,fontSize: 16),),
                                            SizedBox(height: 2,),
                                            Text("₹"+GrandtotalController.text,style: TextStyle(color:Colors.black,fontSize: 16),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar:
        TouchRippleEffect(
          rippleColor: Colors.white60,
          onTap: (){
            _onLoading();
            updateInvoice();
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child:
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total: ₹"+GrandtotalController.text,style: TextStyle(color: Colors.white,fontSize: 16),),
                  Row(
                    children: [
                      Text("Save Invoice ",style: TextStyle(color: Colors.white,fontSize: 16),),
                      Icon(Icons.arrow_forward_rounded,color: Colors.white,size: 14,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Loadtoken() async
  {
    int total_count=0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
        for(var data in widget.list_data)
        {
          total_count=total_count+int.parse(data['price'])*int.parse(data['qty']);
          onAddEditform(data['item_id'],data['price'],data['descr'],data['qty']);
          GrandtotalController.text=total_count.toString();
          DuetotalController.text=GrandtotalController.text;
          PaidtotalController.text="0";
          valuefirst=false;
        }
    });
  }

  Future getInvoice_item(String inv_id,String token) async
  {
    invoice_item_list=await Invoice_service.getInvoice_item(context,inv_id,token);
  }

  Widget dynamiclist()
  {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: contactForms.length,
        controller: scrollController,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, index) {
          return contactForms[index];
        });
  }

  onAddEditform(String item_id,String price,String descr,String qty)
  {
    getService(item_id).then((value){
      setState(() {
        String subtotal_value=(int.parse(price)*int.parse(qty)).toString();
        Edit_item_model _editModel=Edit_item_model(id: editForms.length, description:descr, qty: qty, item_id: item_id, price: price, subtotal: subtotal_value,service_name: service_name, quo_item_id:"1");
        editForms.add(Invoice_edit_list(
          index: editForms.length,
          edit_model: _editModel,
          onSubtotal:()=>onSubtotal,
          onEdit:()=>onSubtotal(),
          theme:theme,
        ),
        );
      });
    });
  }

  Widget editdynamiclist()
  {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: editForms.length,
        controller: scrollController,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, index) {
          return editForms[index];
        });
  }

  void _displayBottomSheet()
  {
    showModalBottomSheet(context: context, enableDrag: true,builder: (BuildContext c){
      return Container(
        child:
        Invoice_add_modal(
          contactForms:contactForms,
          service_drop_list: widget.service_drop_list,
          onResult: ()=> onResult(contactForms),
          theme:theme,
        ),
      );
    });
  }

  void _displayBottomSheet_details()
  {
    showModalBottomSheet(context: context,builder: (BuildContext c){
      return Container(
        height: MediaQuery.of(context).copyWith().size.height * 0.75,
        child: Invoice_detail_edit_modal(
          inv_id:widget.invoice_no,
          inv_date:widget.inv_date,
          due_date:widget.due_date,
          client_name:widget.choose_client,
          remark:widget.remarks,
          onResult:(String remark)=> setState((){
            RemarkController.text=remark;
          }),
          theme:theme,
        ),
      );
    });
  }

  Future getService(String item_id) async
  {
    service_list=await service.getService(context,token);
    for(var ser in service_list)
    {
      if(item_id==ser.id)
      {
        service_name=ser.name!;
      }
    }
  }

  onSubtotal()
  {
    setState(() {
      var subtotal_count=0;
      for (int i = 0; i < contactForms.length; i++)
      {
        Invoice_list_add item = contactForms[i];
        debugPrint("Item id: ${item.contactModel.item_id}");
        debugPrint("Description: ${item.contactModel.description}");
        debugPrint("Price: ${item.contactModel.price}");
        debugPrint("Qty: ${item.contactModel.qty}");
        subtotal_count=subtotal_count+int.parse(item.contactModel.subtotal);
      }
      for (int i = 0; i < editForms.length; i++) {
        Invoice_edit_list item = editForms[i];
        debugPrint("Item id: ${item.edit_model.item_id}");
        debugPrint("Description: ${item.edit_model.description}");
        debugPrint("Price: ${item.edit_model.price}");
        debugPrint("Qty: ${item.edit_model.qty}");
        subtotal_count=subtotal_count+int.parse(item.edit_model.subtotal);
      }
      print(subtotal_count);
      SubtotalController.text=subtotal_count.toString();
      GrandtotalController.text=SubtotalController.text;
      DuetotalController.text=(int.parse(GrandtotalController.text)-int.parse(PaidtotalController.text)).toString();
    }
    );
  }

  onResult(List<Invoice_list_add> contactForms_data)
  {
    var subtotal_count=0;
    setState(() {
      contactForms=contactForms_data;
      if(contactForms.length!=0)
      {
        for (int i = 0; i < contactForms.length; i++) {
          Invoice_list_add item= contactForms[i];
          debugPrint("Item id: ${item.contactModel.item_id}");
          debugPrint("Description: ${item.contactModel.description}");
          debugPrint("Price: ${item.contactModel.price}");
          debugPrint("Qty: ${item.contactModel.qty}");
          subtotal_count=subtotal_count+int.parse(item.contactModel.subtotal);
        }
        for (int i = 0; i < editForms.length; i++) {
          Invoice_edit_list item = editForms[i];
          debugPrint("Item id: ${item.edit_model.item_id}");
          debugPrint("Description: ${item.edit_model.description}");
          debugPrint("Price: ${item.edit_model.price}");
          debugPrint("Qty: ${item.edit_model.qty}");
          subtotal_count=subtotal_count+int.parse(item.edit_model.subtotal);
        }
        SubtotalController.text=subtotal_count.toString();
        GrandtotalController.text=(int.parse(SubtotalController.text)).toString();
        DuetotalController.text=(int.parse(GrandtotalController.text)-int.parse(PaidtotalController.text)).toString();
      }
      else
      {
        for (int i = 0; i < editForms.length; i++) {
          Invoice_edit_list item = editForms[i];
          debugPrint("Item id: ${item.edit_model.item_id}");
          debugPrint("Description: ${item.edit_model.description}");
          debugPrint("Price: ${item.edit_model.price}");
          debugPrint("Qty: ${item.edit_model.qty}");
          subtotal_count=subtotal_count+int.parse(item.edit_model.subtotal);
        }
        SubtotalController.text=subtotal_count.toString();
        GrandtotalController.text=(int.parse(SubtotalController.text)).toString();
        DuetotalController.text=(int.parse(GrandtotalController.text)-int.parse(PaidtotalController.text)).toString();
      }
    });
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

  Future getClient(String client_name) async
  {
    client_list=await Client_service.getClient(context,token);
    for(var client in client_list)
    {
      if(client_name==client.name)
      {
        client_id=client.id!;
      }
    }
  }

  Future updateInvoice() async
  {
    List array_list=[];
    if(contactForms.length!=0)
    {
      for (int i = 0; i < contactForms.length; i++) {
        Invoice_list_add item= contactForms[i];
        var map = Map();
        map['id']="";
        map['item_id']=item.contactModel.item_id;
        map['descr']=item.contactModel.description;
        map['price']=item.contactModel.price;
        map['qty']=item.contactModel.qty;
        array_list.add(map);
      }
      for (int i = 0; i < editForms.length; i++) {
        Invoice_edit_list item = editForms[i];
        var map = Map();
        map['id']=item.edit_model.quo_item_id;
        map['item_id']=item.edit_model.item_id;
        map['descr']=item.edit_model.description;
        map['price']=item.edit_model.price;
        map['qty']=item.edit_model.qty;
        array_list.add(map);
      }
    }
    else
    {
      for (int i = 0; i < editForms.length; i++) {
        Invoice_edit_list item = editForms[i];
        var map = Map();
        map['id']=item.edit_model.quo_item_id;
        map['item_id']=item.edit_model.item_id;
        map['descr']=item.edit_model.description;
        map['price']=item.edit_model.price;
        map['qty']=item.edit_model.qty;
        array_list.add(map);
      }
    }

    var response=await Invoice_service.addInvoice(
        widget.invoice_no,client_id,widget.inv_date,
        widget.due_date,SubtotalController.text,'',GrandtotalController.text,
        PaidtotalController.text,DuetotalController.text,RemarkController.text,'1',
        '',array_list,token);

    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Invoice()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
    }
  }

  LoadTheme() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      theme = (prefs.getBool('theme') ?? false);
    });
  }
}
