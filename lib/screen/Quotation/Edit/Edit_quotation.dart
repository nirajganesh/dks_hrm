import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_item_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_service_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Quotation/Quotation.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Quotation_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class Edit_quotation extends StatefulWidget {

  String id;
  String token;
  List<String> client_drop_list=[];
  List<String> service_drop_list=[];
  String  quotation_no;
  String quotation_date;
  String valid_till;
  String remarks;
  String sub_total;
  String total;
  String discount;
  String status;
  String client_name;

  Edit_quotation({required this.quotation_no,required this.quotation_date,required this.valid_till,
    required this.remarks,required this.id,required this.client_drop_list,required this.service_drop_list,
    required this.token,required this.sub_total,required this.total,required this.discount,required this.status,
    required this.client_name,Key? key}) : super(key: key);

  @override
  _Edit_quotationState createState() => _Edit_quotationState();

}

class _Edit_quotationState extends State<Edit_quotation> {

  final TextEditingController Validtillcontroller= TextEditingController();
  final TextEditingController datecontroller= TextEditingController();
  final TextEditingController Clientcontroller= TextEditingController();
  final TextEditingController Remarkcontroller= TextEditingController();
  final TextEditingController Quotationnocontroller= TextEditingController();
  final TextEditingController Descriptioncontroller= TextEditingController();
  final TextEditingController Pricecontroller= TextEditingController();
  final TextEditingController Qtycontroller= TextEditingController();
  final TextEditingController Discountcontroller= TextEditingController();
  final TextEditingController Grandtotalcontroller= TextEditingController();
  final TextEditingController Totalcontroller= TextEditingController();

  late String choose_service;
  late String choose_client;
  late String choose_status;
  List<String> status_list=<String>['SEND','APPROVED','REJECTED','REVISED'];
  List<Client_model> client_list=[];
  List<Service_model> service_list=[];
  late String client_id;
  late String service_id;
  List<Quotation_item_model> quotation_item_list=[];
  DateTime dateTime_que=DateTime.now();
  DateTime dateTime_valid=DateTime.now();
  String quotation_Date='(quotation_date)';
  String valid_Date='(valid_date)';
  List<Quotation_service_model> quotation_service_list=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getQuotation_item(widget.id,widget.token).then((value){
        Pricecontroller.text=quotation_item_list[0].price;
        Descriptioncontroller.text=quotation_item_list[0].descr;
        Qtycontroller.text=quotation_item_list[0].qty;
        setState(() {
          Grandtotalcontroller.text=widget.total;
          Totalcontroller.text=widget.sub_total;
        });
    });
    choose_status=widget.status;
    choose_client=widget.client_name;
    choose_service=widget.service_drop_list.first;
    Quotationnocontroller.text=widget.quotation_no;
    datecontroller.text=widget.quotation_date;
    Remarkcontroller.text=widget.remarks;
    Validtillcontroller.text=widget.valid_till;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Quotation",style: TextStyle(color: Colors.white),),
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
                        child: Icon(Icons.inventory,color: Colors.black38),
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
                        child:Text(Quotationnocontroller.text,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime(2010), lastDate:DateTime(2030)).then((date){
                      setState(() {
                        dateTime_que=date!;
                        datecontroller.text=dateTime_que.day.toString()+"-"+dateTime_que.month.toString()+"-"+dateTime_que.year.toString();
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
                                datecontroller.text+quotation_Date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
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
                        dateTime_valid=date!;
                        Validtillcontroller.text=dateTime_valid.day.toString()+"-"+dateTime_valid.month.toString()+"-"+dateTime_valid.year.toString();
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
                                Validtillcontroller.text+valid_Date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
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
                SizedBox(height:20),
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
                      DropdownButton(
                        value: choose_status,
                        onChanged: (newvalue){
                          setState(() {
                            choose_status=newvalue as String;
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
                    ],
                  ),
                ),
                SizedBox(height:20),
                GestureDetector(
                  onTap: (){
                    if(choose_client==null)
                    {
                      Notify_widget.notify("Please select the client");
                    }
                    else
                    {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) =>Quotation_edit(
                      //   quote_id:widget.id,
                      //   service_drop_list:widget.service_drop_list,
                      //   choose_client:choose_client,
                      //   quote_no:widget.quotation_no,
                      //   valid_date:Validtillcontroller.text,
                      //   quo_date:Validtillcontroller.text,
                      //   remarks:Remarkcontroller.text,
                      //   status:choose_status,
                      //   total:widget.total,
                      //   sub_total:widget.sub_total,
                      //   discount:widget.discount,
                      // )),);


                      // Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_item_quotation(
                      //   quote_id:widget.id,
                      //   service_drop_list:widget.service_drop_list,
                      //   choose_client:choose_client,
                      //   quote_no:widget.quotation_no,
                      //   valid_date:Validtillcontroller.text,
                      //   quo_date:Validtillcontroller.text,
                      //   remarks:Remarkcontroller.text,
                      //   status:choose_status,
                      //   total:widget.total,
                      //   sub_total:widget.sub_total,
                      //   discount:widget.discount,
                      // )),);
                    }

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit,color: Theme.of(context).primaryColor,size: 20,),
                      SizedBox(width: 4,),
                      Text("Edit All Items",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

  Future getQuotation_item(String quo_id,String token) async
  {
    quotation_item_list=await Quotation_service.getQuotation_item(context,quo_id,token);
  }

  Future updateQuotation() async
  {
    client_list=await Client_service.getClient(context,widget.token);
    for(var cat in client_list)
    {
      if(choose_client.toString()==cat.name)
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
    var maparray = {'id':quotation_item_list[0].id,'quotation_id':quotation_item_list[0].quotation_id,'item_id':service_id, 'descr': Descriptioncontroller.text, 'price': Pricecontroller.text,'qty':Qtycontroller.text};
    var response=await Quotation_service.updateQuotation(
        widget.id,Quotationnocontroller.text,client_id,datecontroller.text,
        Validtillcontroller.text,Totalcontroller.text,'',Discountcontroller.text,
        Grandtotalcontroller.text,choose_status, Remarkcontroller.text,'1','',maparray,widget.token);
    if(response['status']==200)
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
          Quotation()), (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.pop(context);
      Notify_widget.notify(response['message']);
    }
  }

  Future getQuotation_service() async
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
