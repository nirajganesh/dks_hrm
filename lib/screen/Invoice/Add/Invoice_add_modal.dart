import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Contact/ContactModel.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Invoice/Add/Invoice_list_add.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Invoice_add_modal extends StatefulWidget {

  Invoice_add_modal({
    required this.contactForms,
    required this.service_drop_list,
    required this.onResult(),
    required this.theme,
    Key? key}) : super(key: key);

  final List<Invoice_list_add> contactForms;
  final List<String> service_drop_list;
  final Function onResult;
  final bool theme;

  @override
  _Invoice_add_modalState createState() => _Invoice_add_modalState();
}

class _Invoice_add_modalState extends State<Invoice_add_modal> {
  final TextEditingController Servicecontroller=TextEditingController();
  final TextEditingController Descriptioncontroller=TextEditingController();
  final TextEditingController Pricecontroller=TextEditingController();
  final TextEditingController Qtycontroller=TextEditingController();
  bool service_check=false;
  bool description_check=false;
  String token='';
  late String service_id;
  List<Service_model> service_list=[];
  String total="0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Loadtoken();
  }

  @override
  Widget build(BuildContext context) {
    service_check=Servicecontroller.text.isNotEmpty;
    description_check=Descriptioncontroller.text.isNotEmpty;

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
                padding: const EdgeInsets.only(left:6.0),
                child: Text("Add Invoice Items",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
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
                    fieldViewBuilder: (context,ServiceController,focusnode,onEditingComplete){
                      return TextField(
                        style: TextStyle(height: 1),
                        controller: ServiceController,
                        focusNode: focusnode,
                        onEditingComplete: onEditingComplete,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff00ffffff)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff00ffffff)),
                          ),
                          hintText: "Select Service",
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
          service_check==true?
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
          ):
          Opacity(
            opacity: 0.5,
            child: Container(
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
                      readOnly: true,
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
          ),
          SizedBox(height: 15,),
          description_check==true?
          Column(
            children: [
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
                            total=(int.parse(value)*int.parse(Qtycontroller.text)).toString();
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
                            hintText: 'Quantity',
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
            ],
          ):
          Opacity(
            opacity: 0.5,
            child: Column(
              children: [
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
                          readOnly: true,
                          controller: Pricecontroller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          onChanged: (value){
                            setState(() {
                              if(value=='')
                                value!=0;
                              total=(int.parse(value)*int.parse(Qtycontroller.text)).toString();
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
                          readOnly: true,
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
              ],
            ),
          ),
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
              if(Servicecontroller.text=="")
                {
                  Notify_widget.notify("Please Select Service");
                }
              else
                {
                  if(Descriptioncontroller.text=="")
                    {
                      Notify_widget.notify("Please fill the description");
                    }
                  else
                    {
                       if(Pricecontroller.text=="")
                         {
                           Notify_widget.notify("Please fill the description");
                         }
                       else
                         {
                            if(Qtycontroller.text=="")
                              {
                                Notify_widget.notify("Please fill the quantity");
                              }
                            else
                              {
                                onAdd();
                              }
                         }
                    }
                }
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
                  Padding(
                    padding: const EdgeInsets.only(left:6.0),
                    child: Text("Add Invoice Items",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
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
                        fieldViewBuilder: (context,ServiceController,focusnode,onEditingComplete){
                          return TextField(
                            style: TextStyle(height: 1,color: Colors.white),
                            controller: ServiceController,
                            focusNode: focusnode,
                            onEditingComplete: onEditingComplete,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff00ffffff)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff00ffffff)),
                              ),
                              hintText: "Select Service",
                              hintStyle: TextStyle(
                                color:Colors.white24,
                              )
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
              service_check==true?
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
              ):
              Opacity(
                opacity: 0.5,
                child: Container(
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
                          readOnly: true,
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
              ),
              SizedBox(height: 15,),
              description_check==true?
              Column(
                children: [
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
                                total=(int.parse(value)*int.parse(Qtycontroller.text)).toString();
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
                                hintText: 'Quantity',
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
                ],
              ):
              Opacity(
                opacity: 0.5,
                child: Column(
                  children: [
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
                              readOnly: true,
                              controller: Pricecontroller,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              onChanged: (value){
                                setState(() {
                                  if(value=='')
                                    value!=0;
                                  total=(int.parse(value)*int.parse(Qtycontroller.text)).toString();
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
                              readOnly: true,
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
                  ],
                ),
              ),
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
                  if(Servicecontroller.text=="")
                  {
                    Notify_widget.notify("Please Select Service");
                  }
                  else
                  {
                    if(Descriptioncontroller.text=="")
                    {
                      Notify_widget.notify("Please fill the description");
                    }
                    else
                    {
                      if(Pricecontroller.text=="")
                      {
                        Notify_widget.notify("Please fill the description");
                      }
                      else
                      {
                        if(Qtycontroller.text=="")
                        {
                          Notify_widget.notify("Please fill the quantity");
                        }
                        else
                        {
                          onAdd();
                        }
                      }
                    }
                  }
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

  onAdd()  async {
    service_list=await service.getService(context,token);
    for(var ser in service_list)
    {
      if(Servicecontroller.text.toString()==ser.name)
      {
        service_id=ser.id!;
      }
    }
    String subtotal_value=(int.parse(Pricecontroller.text)*int.parse(Qtycontroller.text)).toString();
    setState(() {
      ContactModel contactModel = ContactModel(id: widget.contactForms.length,item_name: Servicecontroller.text,description:Descriptioncontroller.text,
        qty: Qtycontroller.text, item_id: service_id, price:Pricecontroller.text, subtotal: subtotal_value,);
        widget.contactForms.add(Invoice_list_add(
        index: widget.contactForms.length,
        contactModel: contactModel,
        onRemove: () => onRemove(contactModel),
        service_drop_list:widget.service_drop_list,
        onSubtotal:()=> onSubtotal(),
        onEdit:()=>onEdit(),
        theme:widget.theme,
      ),
      );
      print(contactModel.item_id);
    });
    Navigator.of(context).pop();
    widget.onResult();
  }


  onRemove(ContactModel contact)
  {
    int index = widget.contactForms
        .indexWhere((element) => element.contactModel.id == contact.id);
    if (widget.contactForms != null) widget.contactForms.removeAt(index);
    widget.onResult();
  }


  onSubtotal()
  {
    setState(() {
      for (int i = 0; i < widget.contactForms.length; i++) {
        Invoice_list_add item= widget.contactForms[i];
        debugPrint("Item id: ${item.contactModel.item_id}");
        debugPrint("Description: ${item.contactModel.description}");
        debugPrint("Price: ${item.contactModel.price}");
        debugPrint("Qty: ${item.contactModel.qty}");
      }
    }
    );
  }

  onEdit()
  {
    widget.onResult();
  }

  List<String> searchData(String param)
  {
    List<String> result=widget.service_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
  }

  Loadtoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
    });
  }
}
