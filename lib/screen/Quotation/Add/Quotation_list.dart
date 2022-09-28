import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Quotation/Quotation_item_model.dart';
import 'package:dks_hrm/screen/Quotation/Add/Quotation_sample_add_modal.dart';
import 'package:dks_hrm/screen/Quotation/Add/Quotation_sample_list_add.dart';
import 'package:dks_hrm/screen/Quotation/Quotation.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Quotation_service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Quotation_list extends StatefulWidget {

  List<String> service_drop_list=[];
  String choose_client;
  String quote_no;
  String valid_date;
  String quo_date;
  String remarks;
  List<String> client_drop_list=[];
  bool theme;

  Quotation_list({
    required this.service_drop_list,required this.choose_client,
    required this.quote_no,required this.valid_date,required this.quo_date,
    required this.remarks,required this.client_drop_list,required this.theme,
    Key? key}) : super(key: key);


  @override
  _Quotation_listState createState() => _Quotation_listState();
}

class _Quotation_listState extends State<Quotation_list> {

  late String token="";
  List<Quotation_sample_list_add> contactForms = List.empty(growable: true);
  final ScrollController scrollController=ScrollController();
  bool checker=false;
  bool data_check=false;
  final TextEditingController SubtotalController=TextEditingController();
  final TextEditingController ClientController=TextEditingController();
  final TextEditingController GrandtotalController=TextEditingController();
  final TextEditingController DiscountController=TextEditingController();
  bool client_check=false;
  List<Quotation_item_model> quotation_item_list=[];
  List<Client_model> client_list=[];
  late String client_id;
  String total="0";



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Loadtoken();
    SubtotalController.text="0";
    GrandtotalController.text="0";
    DiscountController.text="0";
    ClientController.text=widget.choose_client;
  }


  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Scaffold(
      appBar: AppBar(
        title: Text("Add Quotation List",style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: IconButton(
              icon: const Icon(Icons.restart_alt,color: Colors.white,size: 26,),
               onPressed: () {
                 setState(() {
                   if(client_check==false)
                     client_check=true;
                   else
                     client_check=false;
                 });
              },
            ),
          ),
        ],
      ),
      body:
      Container(
          color: HexColor("#F9FAFF"),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Scrollbar(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            client_check==false?
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: HexColor("#f5f5f5"),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              height: 50,
                              child: Row(
                                children: [
                                  SizedBox(width:15.0),
                                  Flexible(
                                    child:
                                    Row(
                                      children: [
                                        Icon(Icons.person,color: Colors.black38,),
                                        SizedBox(width:5),
                                        Container(
                                          width: 1.0,
                                          height: 25.0,
                                          color:Color(0xff7B7A7A),
                                        ),
                                        SizedBox(width:8.0),
                                        Text(
                                          widget.choose_client,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ):
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
                                            hintText: "Select Client",
                                          ),
                                        );
                                      },
                                      onSelected: (value){
                                        ClientController.text=value.toString();
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
                            SizedBox(height: 20,),
                            data_check==true?
                            Text("Quotation Item List",style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold),):
                            SizedBox(),
                            SizedBox(height: 15,),
                            Scrollbar(
                              isAlwaysShown: true,
                              controller: scrollController,
                              scrollbarOrientation: ScrollbarOrientation.bottom,
                              child:dynamiclist(),
                            ),
                            SizedBox(height: 10,),
                            GestureDetector(
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
                            data_check==true?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text("Summary",style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
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
                                       padding: const EdgeInsets.only(left:13.0,right:8.0),
                                       child: Text("₹",style: TextStyle(color: Colors.black,fontSize: 16),),
                                     ),
                                     Container(
                                       width: 1.0,
                                       height: 25.0,
                                       color:Color(0xff7B7A7A),
                                     ),
                                     SizedBox(width:8.0),
                                     Flexible(
                                       child: TextField(
                                         controller: DiscountController,
                                         keyboardType: TextInputType.number,
                                         style: TextStyle(
                                           color: Colors.black87,
                                         ),
                                         onChanged: (value){
                                           setState(() {
                                             GrandtotalController.text=(int.parse(SubtotalController.text)-int.parse(value)).toString();
                                           });
                                         },
                                         decoration: InputDecoration(
                                             border: InputBorder.none,
                                             hintText: 'Discount',
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
                                                 Text("Estimated Amt:",style: TextStyle(color:Colors.grey,fontSize: 16),),
                                                 SizedBox(height: 2,),
                                                 Text("Discount:",style: TextStyle(color:Colors.grey,fontSize: 16),),
                                          //       SizedBox(height: 2,),
                                         //        Text("Grand Total:",style: TextStyle(color:Colors.grey,fontSize: 16),),
                                               ],
                                             ),
                                           ),
                                           Expanded(
                                             flex: 1,
                                             child: Column(
                                               crossAxisAlignment: CrossAxisAlignment.end,
                                               children: [
                                                 Text("₹ "+SubtotalController.text,style: TextStyle(color:Colors.black,fontSize: 16),),
                                                 SizedBox(height: 2,),
                                                 Text("₹"+DiscountController.text,style: TextStyle(color:Colors.black,fontSize: 16),),
                                             //    SizedBox(height: 2,),
                                             //    Text("₹"+GrandtotalController.text,style: TextStyle(color:Colors.black,fontSize: 14),),
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
                            ):SizedBox(),
                          ],
                        ),
                      ),
                    )
              ],
            ),
          ),
        ),
      bottomNavigationBar:
      data_check==true?
      TouchRippleEffect(
        rippleColor: Colors.white60,
        onTap: (){
          if(client_check==false)
            {
              _onLoading();
               addQuotation(widget.choose_client);
            }
          else
            {
              _onLoading();
              addQuotation(ClientController.text);
            }
        },
        child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
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
      ):SizedBox(),
    ):
      Scaffold(
        appBar: AppBar(
          title: Text("Add Quotation List",style: TextStyle(color: Colors.white),),
          backgroundColor: HexColor(Colors_theme.dark_app_color),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: IconButton(
                icon: const Icon(Icons.restart_alt,color: Colors.white,size: 26,),
                onPressed: () {
                  setState(() {
                    if(client_check==false)
                      client_check=true;
                    else
                      client_check=false;
                  });
                },
              ),
            ),
          ],
        ),
        backgroundColor: HexColor(Colors_theme.dark_background),
        body:
        Container(
          color:HexColor(Colors_theme.dark_background),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Scrollbar(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        client_check==false?
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: HexColor(Colors_theme.dark_app_color),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          height: 50,
                          child: Row(
                            children: [
                              SizedBox(width:15.0),
                              Flexible(
                                child:
                                Row(
                                  children: [
                                    Icon(Icons.person,color: Colors.white24,),
                                    SizedBox(width:5),
                                    Container(
                                      width: 1.0,
                                      height: 25.0,
                                      color:Color(0xff7B7A7A),
                                    ),
                                    SizedBox(width:8.0),
                                    Text(
                                      widget.choose_client,style: (TextStyle(color:Colors.white,fontSize: 14)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ):
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
                                        hintText: "Select Client",
                                      ),
                                    );
                                  },
                                  onSelected: (value){
                                    ClientController.text=value.toString();
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
                        SizedBox(height: 20,),
                        data_check==true?
                        Text("Quotation Item List",style: TextStyle(color:Colors.white,fontSize: 16,fontWeight: FontWeight.bold),):
                        SizedBox(),
                        SizedBox(height: 15,),
                        Scrollbar(
                          isAlwaysShown: true,
                          controller: scrollController,
                          scrollbarOrientation: ScrollbarOrientation.bottom,
                          child:dynamiclist(),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
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
                              children:
                              [
                                Icon(Icons.add_circle_outline,color: Theme.of(context).primaryColor,),
                                Text("Add More Items",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        data_check==true?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Summary",style: TextStyle(color:Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
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
                                    padding: const EdgeInsets.only(left:13.0,right:8.0),
                                    child: Text("₹",style: TextStyle(color: Colors.white,fontSize: 16),),
                                  ),
                                  Container(
                                    width: 1.0,
                                    height: 25.0,
                                    color:Color(0xff7B7A7A),
                                  ),
                                  SizedBox(width:8.0),
                                  Flexible(
                                    child: TextField(
                                      controller: DiscountController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          GrandtotalController.text=(int.parse(SubtotalController.text)-int.parse(value)).toString();
                                        });
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Discount',
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
                              decoration: BoxDecoration(
                                color: HexColor(Colors_theme.dark_app_color),
                                borderRadius: BorderRadius.circular(7),
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
                                              Text("Estimated Amt:",style: TextStyle(color:Colors.grey,fontSize: 16),),
                                              SizedBox(height: 2,),
                                              Text("Discount:",style: TextStyle(color:Colors.grey,fontSize: 16),),
                                              //       SizedBox(height: 2,),
                                              //        Text("Grand Total:",style: TextStyle(color:Colors.grey,fontSize: 16),),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text("₹ "+SubtotalController.text,style: TextStyle(color:Colors.white,fontSize: 16),),
                                              SizedBox(height: 2,),
                                              Text("₹"+DiscountController.text,style: TextStyle(color:Colors.white,fontSize: 16),),
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
                        ):SizedBox(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar:
        data_check==true?
        TouchRippleEffect(
          rippleColor: Colors.white60,
          onTap: (){
            if(client_check==false)
            {
              _onLoading();
              addQuotation(widget.choose_client);
            }
            else
            {
              _onLoading();
              addQuotation(ClientController.text);
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
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
        ):SizedBox(),
      );
  }

  Loadtoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
    });
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


  void _displayBottomSheet()
  {
    showModalBottomSheet(context: context, enableDrag: true,builder: (BuildContext c){
      return Container(
        color: HexColor(Colors_theme.dark_app_color),
        child:
        Quotation_sample_add_modal(
          contactForms:contactForms,
          service_drop_list:widget.service_drop_list,
          onResult: ()=> onResult(contactForms),
          theme:widget.theme,
        ),
      );
    });
  }

  onResult(List<Quotation_sample_list_add> contactForms_data)
  {
    var subtotal_count=0;
    data_check=true;
    setState(() {
      contactForms=contactForms_data;
      if(contactForms.length!=0)
        {
          for (int i = 0; i < contactForms.length; i++) {
            Quotation_sample_list_add item= contactForms[i];
            debugPrint("Item id: ${item.contactModel.item_id}");
            debugPrint("Description: ${item.contactModel.description}");
            debugPrint("Price: ${item.contactModel.price}");
            debugPrint("Qty: ${item.contactModel.qty}");
            subtotal_count=subtotal_count+int.parse(item.contactModel.subtotal);
            SubtotalController.text=subtotal_count.toString();
            GrandtotalController.text=(int.parse(SubtotalController.text)-int.parse(DiscountController.text)).toString();
          }
        }
      else
        {
          data_check=false;
          SubtotalController.text="0";
          GrandtotalController.text="0";
          DiscountController.text="0";
        }
   //   checker=true;
    });
  }

  List<String> searchData(String param)
  {
    List<String> result=widget.client_drop_list.where((element) => element.toLowerCase().contains(param.toLowerCase())).toList();
    return result;
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

  Future addQuotation(String client_name) async
  {
    client_list=await Client_service.getClient(context,token);
    for(var cat in client_list)
    {
      if(widget.choose_client.toString()==cat.name)
      {
        client_id=cat.id;
      }
    }

    if(contactForms.length!=0)
    {
      List array_list=[];
      var subtotal_count=0;
      for (int i = 0; i < contactForms.length; i++) {
        Quotation_sample_list_add item = contactForms[i];
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
      var response=await Quotation_service.addQuotation(widget.quote_no,client_id,widget.quo_date,
          widget.valid_date,SubtotalController.text,"",DiscountController.text,GrandtotalController.text,
          "SEND",widget.remarks, '1','',array_list,token);
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
    else
    {
      Notify_widget.notify("Please add the invoice");
      Navigator.pop(context);
    }
  }







}
