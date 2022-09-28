import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Quotation/Edit_item_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Quotation_edit_item_modal extends StatefulWidget {

  Quotation_edit_item_modal({
    required this.edit_model,
    required this.onResult_edit,
    required this.theme,
    Key? key}) : super(key: key);

  final Function onResult_edit;
  final Edit_item_model edit_model;
  final bool theme;

  @override
  _Quotation_edit_item_modalState createState() => _Quotation_edit_item_modalState();
}

class _Quotation_edit_item_modalState extends State<Quotation_edit_item_modal> {

  final TextEditingController Servicecontroller=TextEditingController();
  final TextEditingController Descriptioncontroller=TextEditingController();
  final TextEditingController Pricecontroller=TextEditingController();
  final TextEditingController Qtycontroller=TextEditingController();
  List<Edit_item_model> edit_list=[];
  late String token="";
  List<String> service_drop=[];
  List<Service_model> service_list=[];
  late String service_id;
  String total="0";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Servicecontroller.text=widget.edit_model.service_name;
    Descriptioncontroller.text=widget.edit_model.description;
    Pricecontroller.text=widget.edit_model.price;
    Qtycontroller.text=widget.edit_model.qty;
    Loadtoken();
    total=(int.parse(Pricecontroller.text)*int.parse(Qtycontroller.text)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return 
      widget.theme==true?
      Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:5.0),
                child: Text("Edit More Items",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
              ),
              GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.clear,color: Colors.black,))
            ],
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
                      return searchData(textEditingValue.text);
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
                          hintText: Servicecontroller.text,
                        ),
                      );
                    },
                    onSelected: (value)
                    {
                      Servicecontroller.text=value.toString();
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
          SizedBox(height: 15,),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: HexColor("f5f5f5"),
              borderRadius: BorderRadius.circular(40),
            ),
            height: 50,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:10.0,right:10.0),
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
                    controller: Descriptioncontroller,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Description',
                        hintStyle: TextStyle(
                            color: Colors.black38
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15,),
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
                  padding: const EdgeInsets.only(left:10.0,right:10.0),
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
                    onChanged: (value){
                      setState(() {
                        if(value=='')
                          value!=0;
                        total=(int.parse(Qtycontroller.text)*int.parse(value)).toString();
                      });
                    },
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
          SizedBox(height: 15,),
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
                  padding: const EdgeInsets.only(left:10.0,right:10.0),
                  child: Icon(Icons.list,color: Colors.black38),
                ),
                Container(
                  width: 1.0,
                  height: 25.0,
                  color:Color(0xff7B7A7A),
                ),
                SizedBox(width:8.0),
                Flexible(
                  child: TextField(
                    controller: Qtycontroller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    onChanged: (value){
                      setState(() {
                        if(value=='')
                          value!=0;
                        total=(int.parse(Pricecontroller.text)*int.parse(value)).toString();
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Quntity',
                        hintStyle: TextStyle(
                            color: Colors.black38
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0)),
              minimumSize: Size(double.infinity, 45),
            ),
            onPressed: () {
              onEdit();
            },
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: ₹"+total,style: TextStyle(color: Colors.white,fontSize: 16),),
                Row(
                  children: [
                    Text("Save Quotation ",style: TextStyle(color: Colors.white,fontSize: 16),),
                    Icon(Icons.arrow_forward_rounded,color: Colors.white,size: 14,),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ):
      Container(
        decoration: BoxDecoration(
            color: HexColor(Colors_theme.dark_background)
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              color: HexColor(Colors_theme.dark_background)
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:5.0),
                      child: Text("Edit More Items",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                    ),
                    GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.clear,color: Colors.white,))
                  ],
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
                      Padding
                        (
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
                            return searchData(textEditingValue.text);
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
                                hintText: Servicecontroller.text,
                                hintStyle: TextStyle(
                                  color: Colors.white24
                                ),
                              ),
                            );
                          },
                          onSelected: (value)
                          {
                            Servicecontroller.text=value.toString();
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
                SizedBox(height: 15,),
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
                        padding: const EdgeInsets.only(left:10.0,right:10.0),
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
                          controller: Descriptioncontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Description',
                              hintStyle: TextStyle(
                                  color: Colors.white24
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
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
                        padding: const EdgeInsets.only(left:10.0,right:10.0),
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
                          onChanged: (value){
                            setState(() {
                              if(value=='')
                                value!=0;
                              total=(int.parse(Qtycontroller.text)*int.parse(value)).toString();
                            });
                          },
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
                SizedBox(height: 15,),
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
                        padding: const EdgeInsets.only(left:10.0,right:10.0),
                        child: Icon(Icons.list,color: Colors.white24),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Flexible(
                        child: TextField(
                          controller: Qtycontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (value){
                            setState(() {
                              if(value=='')
                                value!=0;
                              total=(int.parse(Pricecontroller.text)*int.parse(value)).toString();
                            });
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Quntity',
                              hintStyle: TextStyle(
                                  color: Colors.white24
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  onPressed: () {
                    onEdit();
                  },
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total: ₹"+total,style: TextStyle(color: Colors.white,fontSize: 16),),
                      Row(
                        children: [
                          Text("Save Quotation ",style: TextStyle(color: Colors.white,fontSize: 16),),
                          Icon(Icons.arrow_forward_rounded,color: Colors.white,size: 14,),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  onEdit()
  {
    getService_id(Servicecontroller.text).then((value){
      String subtotal_value=(int.parse(Pricecontroller.text)*int.parse(Qtycontroller.text)).toString();
      setState(() {
        widget.edit_model.item_id=service_id;
        widget.edit_model.service_name=Servicecontroller.text;
        widget.edit_model.qty=Qtycontroller.text;
        widget.edit_model.description=Descriptioncontroller.text;
        widget.edit_model.price=Pricecontroller.text;
        widget.edit_model.subtotal=subtotal_value;
      }
      );
      Navigator.of(context).pop();
      widget.onResult_edit();
    });
  }

  onSubtotal()
  {
    setState(() {
      // subtotal_count=0;
      // for (int i = 0; i < widget.contactForms.length; i++) {
      //   Quotation_sample_list_add item= widget.contactForms[i];
      //   debugPrint("Item id: ${item.contactModel.item_id}");
      //   debugPrint("Description: ${item.contactModel.description}");
      //   debugPrint("Price: ${item.contactModel.price}");
      //   debugPrint("Qty: ${item.contactModel.qty}");
      // subtotal_count=subtotal_count+int.parse(item.contactModel.subtotal);
    }
      // if(valuefirst==false)
      // {
      //   Duetotalcontroller.text=subtotal_count.toString();
      //   Grandtotalcontroller.text=Duetotalcontroller.text;
      //   Paidtotalcontroller.text="0";
      // }
      // else
      // {
      //   Paidtotalcontroller.text=subtotal_count.toString();
      //   Grandtotalcontroller.text=Paidtotalcontroller.text;
      //   Duetotalcontroller.text="0";
      // }
      // }
    );
  }

  List<String> searchData(String param)
  {
    List<String> result=service_drop.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }

  Loadtoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
      getService();
    });
  }

  Future getService_id(String service_name) async
  {
    service_list=await service.getService(context,token);
    for(var ser in service_list)
      {
        if(service_name==ser.name.toString())
          {
            service_id=ser.id.toString();
          }
      }
  }

  Future getService() async
  {
    service_list=await service.getService(context,token);
    for(var ser in service_list)
    {
      service_drop.add(ser.name.toString());
    }
  }
}
