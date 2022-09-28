import 'package:dks_hrm/model/Client/Client_model.dart';
import 'package:dks_hrm/model/Contact/ContactModel.dart';
import 'package:dks_hrm/model/Quotation/Quotation_service_model.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/screen/Quotation/Quotation.dart';
import 'package:dks_hrm/services/Client_service.dart';
import 'package:dks_hrm/services/Quotation_service.dart';
import 'package:dks_hrm/widget/ContactFormItemWidget.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiContactForm extends StatefulWidget {

  List<String> service_drop_list=[];
  String choose_client;
  String quote_no;
  String valid_date;
  String quo_date;
  String remarks;

  MultiContactForm({required this.service_drop_list,required this.choose_client,
    required this.quote_no,required this.valid_date,required this.quo_date,required this.remarks,
    Key? key}) : super(key: key);

  @override
  _MultiContactFormState createState() => _MultiContactFormState();
}


class _MultiContactFormState extends State<MultiContactForm> {
  List<ContactFormItemWidget> contactForms = List.empty(growable: true);
  List<Service_model> service_list=[];
  List<Client_model> client_list=[];
  String token='';
  List<Quotation_service_model> quotation_service_list=[];
  String choose_service='';
  late String service_id;
  final ScrollController scrollController=ScrollController();
  final TextEditingController Discountcontroller= TextEditingController();
  final TextEditingController Subtotalcontroller= TextEditingController();
  final TextEditingController Grandtotalcontroller= TextEditingController();
  final TextEditingController Totalcontroller= TextEditingController();
  int subtotal_count=0;
  late String client_id;
  bool checker=false;


  //var item_provider;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  child: 
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Summary",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight:FontWeight.bold),),
                        ),
                        SizedBox(height:10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.5),width: 1.0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller:Discountcontroller,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          color: Colors.black87,
                                        ),
                                        onChanged: (text){
                                          discount_change();
                                          setState(() {
                                          });
                                        },
                                        decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Discount',
                                            hintStyle: TextStyle(
                                                color: Colors.black38
                                            )
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Sub Total",style:TextStyle(fontSize: 14,color: Colors.grey),),
                                          SizedBox(width: 10,),
                                          Text("₹"+Subtotalcontroller.text,style:const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold)),
                                          // Consumer<Item_provider>
                                          //   (builder: (context,provider,child){
                                          //     return Text("₹"+provider.subtotal.toString(),style:const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold));
                                          //  }),
                                        ],
                                      ),
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
                                addQuotation();
                          },
                          child: Text("Save Quotation",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
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


  onSubtotal()
  {
    setState(() {
      subtotal_count=0;
      Discountcontroller.text="0";
      for (int i = 0; i < contactForms.length; i++) {
        ContactFormItemWidget item = contactForms[i];
        debugPrint("Item id: ${item.contactModel.item_id}");
        debugPrint("Description: ${item.contactModel.description}");
        debugPrint("Price: ${item.contactModel.price}");
        debugPrint("Qty: ${item.contactModel.qty}");
        subtotal_count=subtotal_count+int.parse(item.contactModel.subtotal);
      }
      Subtotalcontroller.text=subtotal_count.toString();
      Grandtotalcontroller.text=Subtotalcontroller.text;
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

  discount_change()
  {
    Grandtotalcontroller.text=((int.parse(Subtotalcontroller.text)-int.parse(Discountcontroller.text))).toString();
  }

  Loadtoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
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

  Future addQuotation() async
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
            print(array_list);
            var response=await Quotation_service.addQuotation(widget.quote_no,client_id,widget.quo_date,widget.valid_date
                ,Subtotalcontroller.text,'',Discountcontroller.text,Grandtotalcontroller.text,"SEND",
                widget.remarks,'0','',array_list,token);
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
      }
    else
      {
        Notify_widget.notify("Please add the quotation");
        Navigator.pop(context);
      }

  }


}
