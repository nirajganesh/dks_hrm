import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Invoice/Invoice_item_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_service_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Invoice/Edit_item_invoice.dart';
import 'package:dks_hrm/services/Invoice_service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Edit_invoice extends StatefulWidget {

  String id;
  String token;
  List<String> client_drop_list=[];
  List<String> service_drop_list=[];
  String invoice_no;
  String invoice_date;
  String due_date;
  String remark;
  String total;
  String total_paid;
  String total_due;
  String client_name;


  Edit_invoice({required this.id,required this.client_drop_list,required this.service_drop_list,
    required this.invoice_no,required this.invoice_date,required this.due_date,required this.remark,
    required this.token,required this.total,required this.total_paid,required this.total_due,
    required this.client_name,Key? key}) : super(key: key);


  @override
  _Edit_invoiceState createState() => _Edit_invoiceState();
}


class _Edit_invoiceState extends State<Edit_invoice> {
  final TextEditingController Duedatecontroller= TextEditingController();
  final TextEditingController Invoicedatecontroller= TextEditingController();
  final TextEditingController Clientcontroller= TextEditingController();
  final TextEditingController Remarkcontroller= TextEditingController();
  final TextEditingController Invoicenocontroller= TextEditingController();
  final TextEditingController Descriptioncontroller= TextEditingController();
  final TextEditingController Pricecontroller= TextEditingController();
  final TextEditingController Qtycontroller= TextEditingController();
  final TextEditingController Grandtotalcontroller= TextEditingController();
  final TextEditingController Duetotalcontroller= TextEditingController();
  final TextEditingController Paidtotalcontroller= TextEditingController();

  late String choose_client;
  late String client_id;
  List<Client_model> client_list=[];
  late String choose_service;
  late String service_id;
  List<Service_model> service_list=[];
  List<Invoice_item_model> invoice_item_list=[];
  late String invoice_item_id;

  DateTime dateTime_inv=DateTime.now();
  DateTime dateTime_due=DateTime.now();
  String invoice_Date='(invoice date)';
  String due_Date='(due date)';
  List<Quotation_service_model> quotation_service_list=[];
  bool valuefirst = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInvoice_item(widget.id,widget.token).then((value){
      invoice_item_id=invoice_item_list[0].id;
      Pricecontroller.text=invoice_item_list[0].price;
      Descriptioncontroller.text=invoice_item_list[0].descr;
      Qtycontroller.text=invoice_item_list[0].qty;
      setState(() {
        Grandtotalcontroller.text=widget.total;
        Paidtotalcontroller.text=widget.total_paid;
        Duetotalcontroller.text=widget.total_due;
        if(Paidtotalcontroller.text=='0')
          {
            valuefirst=false;
          }
        else
          {
            valuefirst=true;
          }
      });
    });

    choose_client=widget.client_name;
    choose_service=widget.service_drop_list.first;
    Invoicenocontroller.text=widget.invoice_no;
    Invoicedatecontroller.text=widget.invoice_date;
    Duedatecontroller.text=widget.due_date;
    Remarkcontroller.text=widget.remark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Invoice",style: TextStyle(color: Colors.white),),
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
          child:  SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border:Border.all(width: 2.0, color: const Color(0xff7B7A7A)),
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
                      Container(
                        child:Text(choose_client,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border:Border.all(width: 2.0, color: const Color(0xff7B7A7A)),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Icon(Icons.inventory,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Container(
                        child:Text(widget.invoice_no,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        dateTime_inv=date!;
                        Invoicedatecontroller.text=dateTime_inv.day.toString()+"-"+dateTime_inv.month.toString()+"-"+dateTime_inv.year.toString();
                      });
                    });
                  },
                  child:
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border:Border.all(width: 2.0, color: const Color(0xff7B7A7A)),
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
                                Invoicedatecontroller.text+invoice_Date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
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
                        dateTime_due=date!;
                        Duedatecontroller.text=dateTime_due.day.toString()+"-"+dateTime_due.month.toString()+"-"+dateTime_due.year.toString();
                      });
                    });
                  },
                  child:
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border:Border.all(width: 2.0, color: const Color(0xff7B7A7A)),
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
                                Duedatecontroller.text+due_Date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border:Border.all(width: 2.0, color: const Color(0xff7B7A7A)),
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
                          controller: Remarkcontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Remarks',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  //  Text("Add Service to Invoice",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Edit_item_invoice(
                          inv_id:widget.id,
                          service_drop_list:widget.service_drop_list,
                          choose_client:choose_client,
                          inv_no:widget.invoice_no,
                          due_date:Duedatecontroller.text,
                          inv_date:Invoicedatecontroller.text,
                          remarks:Remarkcontroller.text,
                          total:widget.total,
                          total_due:widget.total_due,
                          total_paid:widget.total_paid,
                        )),);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.edit,color: Theme.of(context).primaryColor,),
                          Text("Edit More Items",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getInvoice_item(String inv_id,String token) async
  {
    invoice_item_list =await Invoice_service.getInvoice_item(context, inv_id, token);
  }



}
