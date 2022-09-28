import 'package:dks_hrm/screen/Invoice/Invoice.dart';
import 'package:dks_hrm/services/Invoice_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:flutter/material.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Contact/ContactModel.dart';
import 'package:dks_hrm/model/Quotation/Quotation_service_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Quotation_service.dart';
import 'package:dks_hrm/widget/ContactFormItemWidget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class Add_multiForm_invoice extends StatefulWidget {

  String token;
  List<String> client_drop_list=[];
  List<String> service_drop_list=[];
  String inv_last_id;
  String choose_client;
  String remarks;

  Add_multiForm_invoice({required this.client_drop_list,
    required this.service_drop_list,required this.token,
    required this.inv_last_id,required this.choose_client,
    required this.remarks,Key? key}) : super(key: key);


  @override
  _Add_multiForm_invoiceState createState() => _Add_multiForm_invoiceState();

}

class _Add_multiForm_invoiceState extends State<Add_multiForm_invoice> {

  final TextEditingController Duedatecontroller= TextEditingController();
  final TextEditingController Invoicedatecontroller= TextEditingController();
  final TextEditingController Clientcontroller= TextEditingController();
  final TextEditingController Remarkcontroller= TextEditingController();
  final TextEditingController Invoicenocontroller= TextEditingController();
  final TextEditingController Descriptioncontroller= TextEditingController();
  final TextEditingController Pricecontroller= TextEditingController();
  final TextEditingController Qtycontroller= TextEditingController();
  List<Quotation_service_model> quotation_service_list=[];
  final TextEditingController Grandtotalcontroller= TextEditingController();
  final TextEditingController Duetotalcontroller= TextEditingController();
  final TextEditingController Paidtotalcontroller= TextEditingController();
  final TextEditingController Subtotalcontroller= TextEditingController();

  late String client_id;
  List<Client_model> client_list=[];
  late String choose_service;
  late String service_id;
  List<Service_model> service_list=[];
  DateTime dateTime_inv=DateTime.now();
  DateTime dateTime_due=DateTime.now();
  String invoice_Date='(invoice_date)';
  String due_Date='(due_date)';
  late String inv_last_id;
  late String value_inv_no;
  bool valuefirst = false;
  bool checker=false;
  final ScrollController scrollController=ScrollController();
  List<ContactFormItemWidget> contactForms = List.empty(growable: true);
  int subtotal_count=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    choose_service=widget.service_drop_list.first;

    value_inv_no=widget.inv_last_id;
    int idx = value_inv_no.indexOf("S");
    int increase_value=int.parse(value_inv_no.substring(idx+1).trim())+1;
    inv_last_id = "DS"+increase_value.toString();

    Invoicedatecontroller.text=dateTime_inv.day.toString()+"-"+dateTime_inv.month.toString()+"-"+dateTime_inv.year.toString();
    Duedatecontroller.text=dateTime_due.day.toString()+"-"+dateTime_due.month.toString()+"-"+dateTime_due.year.toString();

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
                isAlwaysShown: true,
                controller: scrollController,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child:dynamiclist(),
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
                              Text('Paid In Advance',style: TextStyle(fontSize: 17.0), ),
                              Checkbox(
                                checkColor: Theme.of(context).primaryColor,
                                activeColor: Theme.of(context).primaryColor,
                                value: this.valuefirst,
                                onChanged: (bool? value) {
                                  setState(() {
                                    this.valuefirst = value!;
                                    if(this.valuefirst==true)
                                    {
                                      Paidtotalcontroller.text=Duetotalcontroller.text;
                                      Duetotalcontroller.text='0';
                                    }
                                    else
                                    {
                                      Duetotalcontroller.text=Paidtotalcontroller.text;
                                      Paidtotalcontroller.text='0';
                                    }

                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height:10),
                          Divider(height: 2,color: Colors.grey,thickness: 1,),
                          SizedBox(height:10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Amount Due",style:TextStyle(fontSize: 14,color: Colors.grey),),
                                  SizedBox(width: 10,),
                                  Text("₹"+Duetotalcontroller.text,style:TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Amount Paid",style:TextStyle(fontSize: 14,color: Colors.grey),),
                                  SizedBox(width: 5,),
                                  Text("₹"+Paidtotalcontroller.text,style:TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height:10),
                          Divider(height: 2,color: Colors.grey,thickness: 1,),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Grand Total",style:TextStyle(fontSize: 14,color: Colors.grey),),
                              SizedBox(width: 10,),
                              Text("₹"+Grandtotalcontroller.text,style:TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
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
                              addInvoice();
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

  onAdd()
  {
    setState(() {
      ContactModel _contactModel = ContactModel(id: contactForms.length,item_name: "",description:'', qty: '1', item_id: '', price: '', subtotal: '',);
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


  onSubtotal()
  {
    setState(() {
      subtotal_count=0;
      for (int i = 0; i < contactForms.length; i++) {
        ContactFormItemWidget item = contactForms[i];
        debugPrint("Item id: ${item.contactModel.item_id}");
        debugPrint("Description: ${item.contactModel.description}");
        debugPrint("Price: ${item.contactModel.price}");
        debugPrint("Qty: ${item.contactModel.qty}");
        subtotal_count=subtotal_count+int.parse(item.contactModel.subtotal);
      }
      if(valuefirst==false)
        {
          Duetotalcontroller.text=subtotal_count.toString();
          Grandtotalcontroller.text=Duetotalcontroller.text;
          Paidtotalcontroller.text="0";
        }
      else
        {
          Paidtotalcontroller.text=subtotal_count.toString();
          Grandtotalcontroller.text=Paidtotalcontroller.text;
          Duetotalcontroller.text="0";
        }
      }
    );
  }

  onSave() {
    bool allValid = true;
    //If any form validation function returns false means all forms are not valid
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
      Fluttertoast.showToast(
          msg: contactForms.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      //Submit Form Here
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

  Future addInvoice() async
  {
    client_list=await Client_service.getClient(context,widget.token);
    for(var cat in client_list)
    {
      if(widget.choose_client.toString()==cat.name)
      {
        client_id=cat.id;
      }
    }
    service_list=await service.getService(context,widget.token);
    for(var ser in service_list)
    {
      if(choose_service.toString()==ser.name)
      {
        service_id=ser.id!;
      }
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
        Notify_widget.notify("Please fill the quotation form");
        Navigator.pop(context);
      }
      else
      {
        List array_list=[];
        for (int i = 0; i < contactForms.length; i++) {
          ContactFormItemWidget item = contactForms[i];
          debugPrint("Item id: ${item.contactModel.item_id}");
          debugPrint("Description: ${item.contactModel.description}");
          debugPrint("Price: ${item.contactModel.price}");
          debugPrint("Qty: ${item.contactModel.qty}");
          subtotal_count=subtotal_count+int.parse(item.contactModel.subtotal);
          var map = Map();
          map['item_id']=item.contactModel.item_id;
          map['descr']=item.contactModel.description;
          map['price']=item.contactModel.price;
          map['qty']=item.contactModel.qty;
          array_list.add(map);
        }
        var response=await Invoice_service.addInvoice(inv_last_id,client_id,Invoicedatecontroller.text,
            '0',Grandtotalcontroller.text,Grandtotalcontroller.text,Paidtotalcontroller.text,
            Duetotalcontroller.text,Duedatecontroller.text,widget.remarks,
            '1','',array_list,widget.token);
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
      Notify_widget.notify("Please add the invoice");
      Navigator.pop(context);
    }
  }

  Future getInvoice_service() async
  {
    service_list=await service.getService(context,widget.token);
    for(var ser in service_list)
    {
      if(choose_service.toString()==ser.name)
      {
        service_id=ser.id!;
      }
    }
    quotation_service_list=await Quotation_service.getQuotation_item_service(context,service_id,widget.token);
  }
}
