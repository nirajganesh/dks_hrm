import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Contact/ContactModel.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Invoice_edit_modal extends StatefulWidget {

  Invoice_edit_modal({
    required this.contactModel,
    required this.onResult_edit,
    required this.service_drop_list,
    required this.theme,
    Key? key}) : super(key: key);

  final Function onResult_edit;
  final ContactModel contactModel;
  List<String> service_drop_list=[];
  final bool theme;


  final TextEditingController Servicecontroller=TextEditingController();
  final TextEditingController Descriptioncontroller=TextEditingController();
  final TextEditingController Pricecontroller=TextEditingController();
  final TextEditingController Qtycontroller=TextEditingController();
  List<ContactModel> contact_list=[];
  late String token="";
  List<String> service_drop=[];
  List<Service_model> service_list=[];

  @override
  _Invoice_edit_modalState createState() => _Invoice_edit_modalState();
}

class _Invoice_edit_modalState extends State<Invoice_edit_modal> {

  final TextEditingController Servicecontroller=TextEditingController();
  final TextEditingController Descriptioncontroller=TextEditingController();
  final TextEditingController Pricecontroller=TextEditingController();
  final TextEditingController Qtycontroller=TextEditingController();
  List<ContactModel> contact_list=[];
  late String token="";
  List<String> service_drop=[];
  List<Service_model> service_list=[];
  String total="0";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Servicecontroller.text=widget.contactModel.item_name;
    Descriptioncontroller.text=widget.contactModel.description;
    Pricecontroller.text=widget.contactModel.price;
    Qtycontroller.text=widget.contactModel.qty;
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
              Text("Edit Invoice Items",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
              GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.clear,color: Colors.black,)
              )
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
                    Text("Save Invoice ",style: TextStyle(color: Colors.white,fontSize: 16),),
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
          color: HexColor(Colors_theme.dark_background),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Edit Invoice Items",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.clear,color: Colors.white,)
                  )
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
                    Padding(
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
                                color:Colors.white24
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
                  color:HexColor(Colors_theme.dark_app_color),
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
                        Text("Save Invoice ",style: TextStyle(color: Colors.white,fontSize: 16),),
                        Icon(Icons.arrow_forward_rounded,color: Colors.white,size: 14,),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  onEdit()
  {
    String subtotal_value=(int.parse(Pricecontroller.text)*int.parse(Qtycontroller.text)).toString();
    setState(() {
      widget.contactModel.item_name=Servicecontroller.text;
      widget.contactModel.qty=Qtycontroller.text;
      widget.contactModel.description=Descriptioncontroller.text;
      widget.contactModel.price=Pricecontroller.text;
      widget.contactModel.subtotal=subtotal_value;
    }
    );
    Navigator.of(context).pop();
    widget.onResult_edit();
  }

  List<String> searchData(String param)
  {
    List<String> result=service_drop.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }

  Future getService() async
  {
    service_list=await service.getService(context,token);
    for(var ser in service_list)
    {
      service_drop.add(ser.name.toString());
    }
  }

  Loadtoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
      getService();
    });
  }

  onSubtotal()
  {
    setState(() {
    }
    );
  }

}
