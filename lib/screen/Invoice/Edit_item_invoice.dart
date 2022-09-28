import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Contact/ContactModel.dart';
import 'package:dks_hrm/model/Invoice/Invoice_item_model.dart';
import 'package:dks_hrm/model/Quotation/Edit_item_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_service_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Invoice/Invoice.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Invoice_service.dart';
import 'package:dks_hrm/services/Quotation_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/ContactFormItemWidget.dart';
import 'package:dks_hrm/widget/Edit_formItemWidget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Edit_item_invoice extends StatefulWidget {

  List<String> service_drop_list=[];
  String choose_client;
  String inv_no;
  String due_date;
  String inv_date;
  String remarks;
  String inv_id;
  String total;
  String total_due;
  String total_paid;

   Edit_item_invoice({
     required this.inv_id,
     required this.service_drop_list,
     required this.choose_client,
     required this.inv_no,
     required this.due_date,
     required this.inv_date,
     required this.remarks,
     required this.total,
     required this.total_due,
     required this.total_paid,
     Key? key,}) : super(key: key);

  @override
  _Edit_item_invoiceState createState() => _Edit_item_invoiceState();
}

class _Edit_item_invoiceState extends State<Edit_item_invoice> {

  List<ContactFormItemWidget> contactForms = List.empty(growable: true);
  List<Edit_formItemWidget> editForms_item = List.empty(growable: true);
  List<Service_model> service_list=[];
  List<Client_model> client_list=[];
  String token='';
  List<Quotation_service_model> quotation_service_list=[];
  List<Invoice_item_model> invoice_item_list=[];
  String choose_service='';
  late String service_id;
  final ScrollController scrollController=ScrollController();
  final TextEditingController Totalduecontroller= TextEditingController();
  final TextEditingController Totalpaidcontroller= TextEditingController();
  final TextEditingController Grandtotalcontroller= TextEditingController();
  final TextEditingController Totalcontroller= TextEditingController();
  int subtotal_count=0;
  late String client_id;
  late String service_name;
  bool checker=false;
  bool valuefirst = false;
  late String invoice_item_id;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    choose_service=widget.service_drop_list.first;
    Totalduecontroller.text=widget.total_due;
    Grandtotalcontroller.text=widget.total;
    Totalpaidcontroller.text=widget.total_paid;
    Loadtoken();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          title: Text("Item List",style: TextStyle(color: Colors.white),),
          backgroundColor: Theme.of(context).primaryColor,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions:<Widget> [
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: IconButton(
                icon: const Icon(Icons.add_circle_outline,color: Colors.white,size: 26,),
                onPressed: () {
                  onAdd();
                  //   Navigator.push(context, MaterialPageRoute(builder: (context) =>Add_client(token:token)),);
                },
              ),
            ),
          ],
        ),
        body:
        SingleChildScrollView(
          child: Column(
            children: [
              Scrollbar(
              //  isAlwaysShown: true,
                controller: scrollController,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child:Column(
                  children: [
                    SizedBox(height: 10,),
                    editdynamiclist(),
                    SizedBox(height: 10,),
                    dynamiclist(),
                  ],
                ),
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height:10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Paid to invoice',style: TextStyle(fontSize: 17.0), ),
                              Checkbox(
                                checkColor: Theme.of(context).primaryColor,
                                activeColor: Theme.of(context).primaryColor,
                                value: this.valuefirst,
                                onChanged: (bool? value) {
                                  setState(() {
                                    this.valuefirst = value!;
                                    if(valuefirst==false)
                                      {
                                        Totalduecontroller.text=Totalpaidcontroller.text;
                                        Totalpaidcontroller.text="0";
                                      }
                                    else
                                      {
                                        Totalpaidcontroller.text=Totalduecontroller.text;
                                        Totalduecontroller.text="0";
                                      }
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height:10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Amount due",style:TextStyle(fontSize: 14,color: Colors.grey),),
                                          SizedBox(width: 10,),
                                          Text("₹"+Totalduecontroller.text,style:const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Amount paid",style:TextStyle(fontSize: 14,color: Colors.grey),),
                                          SizedBox(width: 10,),
                                          Text("₹"+Totalpaidcontroller.text,style:const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold)),
                                          // Consumer<Item_provider>
                                          //   (builder: (context,provider,child){
                                          //     return Text("₹"+provider.subtotal.toString(),style:const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold));
                                          //  }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height:10),
                          Divider(height: 2,color: Colors.grey,thickness: 1,),
                          SizedBox(height:10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Grand Total",style:TextStyle(fontSize: 14,color: Colors.grey),),
                              SizedBox(width: 10,),
                              Text("₹"+Grandtotalcontroller.text, style:const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Divider(height: 2,color: Colors.grey,thickness: 1,),
                          SizedBox(height: 20,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0)),
                              minimumSize: Size(double.infinity, 45),
                            ),
                            onPressed: () {
                              _onLoading();
                              editInvoice();
                            },
                            child: Text("Save Invoice",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }

  onSubtotal()
  {
    setState(() {
      subtotal_count=0;
      for (int i = 0; i < contactForms.length; i++)
      {
        ContactFormItemWidget item = contactForms[i];
        debugPrint("Item id: ${item.contactModel.item_id}");
        debugPrint("Description: ${item.contactModel.description}");
        debugPrint("Price: ${item.contactModel.price}");
        debugPrint("Qty: ${item.contactModel.qty}");
        subtotal_count=subtotal_count+int.parse(item.contactModel.subtotal);
      }
      for (int i = 0; i < editForms_item.length; i++) {
        Edit_formItemWidget item = editForms_item[i];
        debugPrint("Item id: ${item.edit_item_model.item_id}");
        debugPrint("Description: ${item.edit_item_model.description}");
        debugPrint("Price: ${item.edit_item_model.price}");
        debugPrint("Qty: ${item.edit_item_model.qty}");
        subtotal_count=subtotal_count+int.parse(item.edit_item_model.subtotal);
      }
      print(subtotal_count);
      Totalduecontroller.text=subtotal_count.toString();
      Grandtotalcontroller.text=Totalduecontroller.text;
     }
    );
  }

  onSave() {
    bool allValid = true;
    contactForms
        .forEach((element) => allValid = (allValid && element.isValidated()));
    if (allValid) {
      for (int i = 0; i < contactForms.length; i++) {
        ContactFormItemWidget item = contactForms[i];
        debugPrint("Item id: ${item.contactModel.item_id}");
        debugPrint("Description: ${item.contactModel.description}");
        debugPrint("Price: ${item.contactModel.price}");
        debugPrint("Qty: ${item.contactModel.qty}");
      }
    } else {
      debugPrint("Form is Not Valid");
    }
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

  Widget editdynamiclist()
  {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: editForms_item.length,
        controller: scrollController,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, index) {
          return editForms_item[index];
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

  Future editInvoice() async
  {
    client_list=await Client_service.getClient(context,token);
    for(var cat in client_list)
    {
      if(widget.choose_client.toString()==cat.name)
      {
        client_id=cat.id;
      }
    }
    service_list=await service.getService(context,token);
    for(var ser in service_list)
    {
      if(choose_service.toString()==ser.name)
      {
        service_id=ser.id!;
      }
    }
    List array_list=[];
    for (int i = 0; i < editForms_item.length; i++)
    {
      Edit_formItemWidget item = editForms_item[i];
      debugPrint("Item id: ${item.edit_item_model.item_id}");
      debugPrint("Description: ${item.edit_item_model.description}");
      debugPrint("Price: ${item.edit_item_model.price}");
      debugPrint("Qty: ${item.edit_item_model.qty}");
      var map = Map();
      map['id']=item.edit_item_model.quo_item_id;
      map['invoice_id']=widget.inv_id;
      map['item_id']=item.edit_item_model.item_id;
      map['descr']=item.edit_item_model.description;
      map['price']=item.edit_item_model.price;
      map['qty']=item.edit_item_model.qty;
      array_list.add(map);
    }

    if(contactForms.length!=0)
    {
      for(int i=0;i< contactForms.length;i++)
      {
        ContactFormItemWidget item = contactForms[i];
        if(item.contactModel.item_id=="")
        {
          checker=true;
        }
      }
      if(checker==true)
      {
        Notify_widget.notify("Please fill the form");
        Navigator.of(context).pop();
      }
      else
      {
        print(checker);
        for (int i = 0; i < contactForms.length; i++)
        {
          ContactFormItemWidget item = contactForms[i];
          debugPrint("Item id: ${item.contactModel.item_id}");
          debugPrint("Description: ${item.contactModel.description}");
          debugPrint("Price: ${item.contactModel.price}");
          debugPrint("Qty: ${item.contactModel.qty}");
          var map = Map();
          map['invoice_id']="";
          map['item_id']=item.contactModel.item_id;
          map['descr']=item.contactModel.description;
          map['price']=item.contactModel.price;
          map['qty']=item.contactModel.qty;
          array_list.add(map);
        }
        print(array_list);
        //   var maparray = {'id':quotation_item_list[0].id,'quotation_id':quotation_item_list[0].quotation_id,'item_id':service_id, 'descr': Descriptioncontroller.text, 'price': Pricecontroller.text,'qty':Qtycontroller.text};
        var response=await Invoice_service.updateInvoice(widget.inv_id,widget.inv_no,client_id,widget.inv_date,widget.due_date,Grandtotalcontroller.text,
            '',Grandtotalcontroller.text,widget.total_paid,widget.total_due,widget.remarks,'1','',array_list,token);
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
    }
    else
    {
      for (int i = 0; i < contactForms.length; i++)
      {
        ContactFormItemWidget item = contactForms[i];
        debugPrint("Item id: ${item.contactModel.item_id}");
        debugPrint("Description: ${item.contactModel.description}");
        debugPrint("Price: ${item.contactModel.price}");
        debugPrint("Qty: ${item.contactModel.qty}");
        var map = Map();
        map['id']="";
        map['item_id']=item.contactModel.item_id;
        map['descr']=item.contactModel.description;
        map['price']=item.contactModel.price;
        map['qty']=item.contactModel.qty;
        array_list.add(map);
      }
      print(array_list);
      var response=await Invoice_service.updateInvoice(widget.inv_id,widget.inv_no,client_id,widget.inv_date,widget.due_date,Grandtotalcontroller.text,
          '',Grandtotalcontroller.text,widget.total_paid,widget.total_due,widget.remarks,'1','',array_list,token);
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

 //   var maparray = {'id':invoice_item_id,'item_id':service_id, 'descr': Descriptioncontroller.text, 'price': Pricecontroller.text,'qty':Qtycontroller.text};

  }

  Future getInvoice_item(String inv_id,String token) async
  {
    invoice_item_list=await Invoice_service.getInvoice_item(context,inv_id,token);
  }

  Future getInvoice_service() async
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

  onAdd()
  {
    setState(() {
      ContactModel _contactModel = ContactModel(id: contactForms.length,item_name: '',description:'', qty: '1', item_id: '', price: '', subtotal: '',);
      contactForms.add(ContactFormItemWidget(
        index: contactForms.length,
        contactModel: _contactModel,
        onRemove: () => onRemove(_contactModel),
        service_drop_list:widget.service_drop_list,
        onSubtotal:()=> onSubtotal(),
      ),
      );
      print(_contactModel.id);
    });
  }

  onRemove(ContactModel contact)
  {
    setState(() {
      int index = contactForms
          .indexWhere((element) => element.contactModel.id == contact.id);
      if (contactForms != null) contactForms.removeAt(index);
      onSubtotal();
    }
    );
  }

  onAddEditform(String item_id,String price,String descr,String qty,String quo_item_id )
  {
    getService(item_id).then((value){
      setState(() {
        Edit_item_model _editModel=Edit_item_model(id: editForms_item.length, description:descr, qty: qty, item_id: item_id, price: price, subtotal: '',service_name: service_name, quo_item_id:quo_item_id);
        editForms_item.add(Edit_formItemWidget(
          index: editForms_item.length,
          edit_item_model: _editModel,
          service_drop_list:widget.service_drop_list,
          onSubtotal:()=>onSubtotal(),
        ),
        );
      });
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

  Loadtoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
      getInvoice_item(widget.inv_id, token).then((value){
        for(var data in invoice_item_list)
        {
          onAddEditform(data.item_id,data.price,data.descr,data.qty,data.id);
        }
      });
    });
  }
}
