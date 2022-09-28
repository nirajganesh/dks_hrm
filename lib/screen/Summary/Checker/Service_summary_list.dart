import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:dks_hrm/model/Service/Service_model.dart';
import 'package:dks_hrm/model/Summary/Service_summary_model.dart';
import 'package:dks_hrm/screen/Summary/Edit_service_summary.dart';
import 'package:dks_hrm/screen/Summary/Service_summary.dart';
import 'package:dks_hrm/services/Summary_service.dart';
import 'package:dks_hrm/services/service.dart';
import 'package:dks_hrm/widget/Notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
class Service_summary_list extends StatefulWidget {

  Service_summary_list({
    Key? key,
    required this.index,
    required this.service_summary_model,
    required this.onResult,
    required this.theme,
   }) : super(key: key);

  final index;
  Service_summary_model service_summary_model;
  final Function onResult;
  final bool theme;

  final state=_Service_summary_listState();
  List<Service_summary_model> contact_list=[];


  @override
  _Service_summary_listState createState() => state;
  bool isValidated() => state.validate();

}


class _Service_summary_listState extends State<Service_summary_list> {
  List<String> service_drop_list=[];
  List<Service_model> service_list=[];
  final formKey = GlobalKey<FormState>();
  late String token;


  @override
  void initState() {
    super.initState();
    Loadtoken();
  }

  @override
  Widget build(BuildContext context) {
    return
      widget.theme==true?
      Material(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top:7.0),
          child: Form(
            key: formKey,
            child:
            Container(
              decoration: BoxDecoration(
                color:Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffe8e8e8),
                    blurRadius: 5.0, // soften the shadow//extend the shadow
                    offset: Offset(
                        0,5
                    ),
                  ),
                ],
                borderRadius: BorderRadius.circular(7),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        GestureDetector(
                          onTap:()
                          {

                          },
                          child:
                          Container(
                            child:
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Row(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex:1,
                                      child:
                                      Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children:
                                        [
                                          Text(widget.service_summary_model.item_name!,style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                                          SizedBox(height: 5,),
                                          Text(widget.service_summary_model.descr!,style: TextStyle(color: Colors.black38,fontSize: 14),),
                                          SizedBox(height: 5,),
                                          Text(widget.service_summary_model.qty!,style: TextStyle(color: Colors.black38,fontSize: 14),),
                                          SizedBox(height: 5,),
                                        ],
                                      )
                                  ),
                                  Expanded(
                                      flex:1,
                                      child: Column(
                                        crossAxisAlignment:CrossAxisAlignment.end,
                                        mainAxisAlignment:MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height:15,
                                            child:
                                            Checkbox(
                                                value: widget.service_summary_model.isSelected,
                                                onChanged:(value)
                                                {
                                                  setState(()
                                                  {
                                                    widget.service_summary_model.isSelected=value;
                                                    widget.onResult;
                                                  });
                                                }
                                             ),
                                          ),
                                          SizedBox(height: 8,),
                                          Text(widget.service_summary_model.date!,style: TextStyle(color: Colors.black,fontSize: 14),),
                                          SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment:CrossAxisAlignment.end,
                                            children: [
                                              Flexible(
                                                flex:4,
                                                child: Row(
                                                  mainAxisAlignment:MainAxisAlignment.end,
                                                  children: [
                                                    TouchRippleEffect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      rippleColor: Colors.white60,
                                                      onTap:(){
                                                        getService().then((value){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_service_summary(
                                                            service_drop_list: service_drop_list,
                                                            token:token,
                                                            client_id:widget.service_summary_model.client_id!,
                                                            id:widget.service_summary_model.id!,
                                                            qty:widget.service_summary_model.qty!,
                                                            date:widget.service_summary_model.date!,
                                                            billed: widget.service_summary_model.is_billed!,
                                                            description: widget.service_summary_model.descr!,
                                                            service_name: widget.service_summary_model.item_name!,
                                                            theme:widget.theme,
                                                            )
                                                           ),
                                                          );
                                                        });
                                                      },
                                                      child: Container(
                                                        width:35,
                                                        height:35,
                                                        decoration:BoxDecoration(
                                                          borderRadius: BorderRadius.circular(25),
                                                          color: Color(0xffFFA74D),
                                                        ),
                                                        child:Icon(Icons.edit,color:Colors.white,size: 20,),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5,),
                                                    TouchRippleEffect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      rippleColor: Colors.white60,
                                                      onTap: (){
                                                        Delete_dailog(widget.service_summary_model.id!);
                                                      },
                                                      child: Container(
                                                        width:35,
                                                        height:35,
                                                        decoration:BoxDecoration(
                                                          borderRadius: BorderRadius.circular(25),
                                                          color: Color(0xffE71157),
                                                        ),
                                                        child: Icon(Icons.delete,size: 20,color: Colors.white,),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ):
      Material(
        child: Container(
          decoration: BoxDecoration(
            color:HexColor(Colors_theme.dark_app_color),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top:7.0),
            child: Form(
              key: formKey,
              child:
              Container(
                decoration: BoxDecoration(
                  color:HexColor(Colors_theme.dark_app_color),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap:()
                        {

                        },
                        child: Container(
                          child:
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Row(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex:1,
                                    child:
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.service_summary_model.item_name!,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                                        SizedBox(height: 5,),
                                        Text(widget.service_summary_model.descr!,style: TextStyle(color: Colors.white24,fontSize: 14),),
                                        SizedBox(height: 5,),
                                        Text(widget.service_summary_model.qty!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                        SizedBox(height: 5,),
                                      ],
                                    )
                                ),
                                Expanded(
                                    flex:1,
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.end,
                                      mainAxisAlignment:MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height:15,
                                          child:
                                          Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor: Colors.white
                                            ),
                                            child: Checkbox(
                                                value: widget.service_summary_model.isSelected,
                                                onChanged:(value)
                                                {
                                                  setState(()
                                                  {
                                                    widget.service_summary_model.isSelected=value;
                                                    widget.onResult;
                                                  });
                                                }
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8,),
                                        Text(widget.service_summary_model.date!,style: TextStyle(color: Colors.white,fontSize: 14),),
                                        SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment:CrossAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              flex:4,
                                              child: Row(
                                                mainAxisAlignment:MainAxisAlignment.end,
                                                children: [
                                                  TouchRippleEffect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    rippleColor: Colors.white60,
                                                    onTap:(){
                                                      getService().then((value){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Edit_service_summary(
                                                          service_drop_list: service_drop_list,
                                                          token:token,
                                                          client_id:widget.service_summary_model.client_id!,
                                                          id:widget.service_summary_model.id!,
                                                          qty:widget.service_summary_model.qty!,
                                                          date:widget.service_summary_model.date!,
                                                          billed: widget.service_summary_model.is_billed!,
                                                          description: widget.service_summary_model.descr!,
                                                          service_name: widget.service_summary_model.item_name!,
                                                          theme:widget.theme,
                                                        )
                                                        ),
                                                        );
                                                      });
                                                    },
                                                    child: Container(
                                                      width:35,
                                                      height:35,
                                                      decoration:BoxDecoration(
                                                        borderRadius: BorderRadius.circular(25),
                                                        color: Color(0xffFFA74D),
                                                      ),
                                                      child:Icon(Icons.edit,color:Colors.white,size: 20,),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  TouchRippleEffect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    rippleColor: Colors.white60,
                                                    onTap: (){
                                                      Delete_dailog_dark(widget.service_summary_model.id!);
                                                    },
                                                    child: Container(
                                                      width:35,
                                                      height:35,
                                                      decoration:BoxDecoration(
                                                        borderRadius: BorderRadius.circular(25),
                                                        color: Color(0xffE71157),
                                                      ),
                                                      child: Icon(Icons.delete,size: 20,color: Colors.white,),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }

  bool validate() {
    bool validate = formKey.currentState!.validate();
    if (validate) formKey.currentState!.save();
    return validate;
  }

  void Delete_dailog(String id)
  {
    showDialog(
        context: context,
        builder:(ctx)=>AlertDialog(
          title: Center(
            child: Text(
              "Alert for Delete",style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(left:12.0,right:12.0),
            child: Text(
              "Do yow want to delete the service_summary in list?",textAlign: TextAlign.center,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 16,fontFamily:'Montserrat_regular')),
            ),
          ),

          actions: <Widget>[
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color:Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("Cancel"),
                ),
                SizedBox(width:6),
                FlatButton(
                  onPressed: () {
                    deleteService_summary(ctx,id);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: HexColor("#F30808"),
                  child: Text("Delete",style:(TextStyle(color: Colors.white)),),
                ),
              ],
            )
          ],
        )
    );
  }

  void Delete_dailog_dark(String id)
  {
    showDialog(
        context: context,
        builder:(ctx)=>AlertDialog(
          backgroundColor: HexColor(Colors_theme.dark_app_color),
          title: Center(
            child: Text(
              "Alert for Delete",style: (TextStyle(color: Colors.white,fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat_bold')),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(left:12.0,right:12.0),
            child: Text(
              "Do yow want to delete the service summary in list?",textAlign: TextAlign.center,style: (TextStyle(color: Colors.white,fontSize: 16,fontFamily:'Montserrat_regular')),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color:Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Text("Cancel",style:(TextStyle(color: Colors.white))),
                ),
                SizedBox(width:6),
                FlatButton(
                  onPressed: () {
                    deleteService_summary(ctx,id);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: HexColor("#F30808"),
                  child: Text("Delete",style:(TextStyle(color: Colors.white)),),
                ),
              ],
            )
          ],
        )
    );
  }



  Loadtoken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
    });
  }

  Future getService() async
  {
    service_list=await service.getService(context,token);
    for(var ser in service_list)
    {
      service_drop_list.add(ser.name.toString());
    }
  }

  Future deleteService_summary(BuildContext ctx,String id) async
  {
    var response=await Summary_service.deleteService_summary(id,token!);
    if(response['status']==200)
    {
      Navigator.of(ctx).pop();
      Notify_widget.notify(response['message']);
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) =>Service_summary(
          token: token,
          client_id: widget.service_summary_model.client_id!)),
      );
    }
    else
    {
      Navigator.of(ctx).pop();
      Notify_widget.notify(response['message']);
    }
  }
}
