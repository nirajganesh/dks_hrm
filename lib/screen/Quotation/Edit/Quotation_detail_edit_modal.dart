
import 'package:dks_hrm/constants/Colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
class Quotation_detail_edit_modal extends StatefulWidget {

  Quotation_detail_edit_modal({
    required this.quote_id,
    required this.quote_date,
    required this.valid_date,
    required this.client_name,
    required this.status,
    required this.remark,
    required this.onResult,
    required this.theme,
    Key? key}) : super(key: key);

  final String quote_id;
  final String quote_date;
  final String valid_date;
  final String client_name;
  final String status;
  final String remark;
  final bool theme;
  final Function(String,String) onResult;


  @override
  _Quotation_detail_edit_modalState createState() => _Quotation_detail_edit_modalState();
}

class _Quotation_detail_edit_modalState extends State<Quotation_detail_edit_modal> {

  final TextEditingController Remarkcontroller=TextEditingController();
  final TextEditingController Statuscontroller=TextEditingController();
  List<String> status_list=<String>['SEND','APPROVED','REJECTED','REVISED'];
  late String choose_status;



  @override
  void initState() {
    super.initState();
    Remarkcontroller.text=widget.remark;
    choose_status=widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return 
      widget.theme==true?
      Scaffold(
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:5.0),
                    child: Text("Edit Quotation Details",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                  ),
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.clear,color: Colors.black,))
                ],
              ),
              SizedBox(height: 20,),
              Opacity(
                opacity: 0.6,
                child: Container(
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
                        child: Icon(Icons.inventory,color: Colors.black38),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        color:Color(0xff7B7A7A),
                      ),
                      SizedBox(width:8.0),
                      Container(
                        child:Text(widget.quote_id,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Opacity(
                opacity: 0.6,
                child: Container(
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
                      Text(widget.client_name,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Opacity(
                opacity: 0.6,
                child: GestureDetector(
                  onTap: (){

                  },
                  child:
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor("#f5f5f5"),
                      borderRadius: BorderRadius.circular(40),
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
                                widget.quote_date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Opacity(
                opacity: 0.6,
                child: GestureDetector(
                  onTap: (){

                  },
                  child:
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: HexColor("#f5f5f5"),
                      borderRadius: BorderRadius.circular(40),
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
                                widget.valid_date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                    DropdownButton(
                      value: choose_status,
                      onChanged: (newvalue){
                        setState(() {
                          choose_status=newvalue as String;
                        });
                      },
                      underline: SizedBox(),
                      dropdownColor: Colors.white,
                      hint:Text(choose_status.toString()+"                                                   ",style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
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
                  Navigator.pop(context);
                  widget.onResult(choose_status,Remarkcontroller.text);
                },
                child: Text("Save Details",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    ):
      Scaffold(
        backgroundColor: HexColor(Colors_theme.dark_background),
        body:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:5.0),
                      child: Text("Edit Quotation Details",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                    ),
                    GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.clear,color: Colors.white,))
                  ],
                ),
                SizedBox(height: 20,),
                Opacity(
                  opacity: 0.6,
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
                          padding: const EdgeInsets.only(left:8.0,right:8.0),
                          child: Icon(Icons.inventory,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Container(
                          child:Text(widget.quote_id,style: (TextStyle(color: Colors.white,fontSize: 14)),),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Opacity(
                  opacity: 0.6,
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
                          padding: const EdgeInsets.only(left:8.0,right:8.0),
                          child: Icon(Icons.person,color: Colors.white24),
                        ),
                        Container(
                          width: 1.0,
                          height: 25.0,
                          color:Color(0xff7B7A7A),
                        ),
                        SizedBox(width:8.0),
                        Text(widget.client_name,style: (TextStyle(color: Colors.white,fontSize: 14)),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Opacity(
                  opacity: 0.6,
                  child: GestureDetector(
                    onTap: (){

                    },
                    child:
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: HexColor(Colors_theme.dark_app_color),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(width:10.0),
                          Flexible(
                            child:
                            Row(
                              children: [
                                Icon(Icons.date_range,color: Colors.white24,),
                                SizedBox(width:5),
                                Container(
                                  width: 1.0,
                                  height: 25.0,
                                  color:Color(0xff7B7A7A),
                                ),
                                SizedBox(width:8.0),
                                Text(
                                  widget.quote_date,style: (TextStyle(color: Colors.white,fontSize: 14)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Opacity(
                  opacity: 0.6,
                  child: GestureDetector(
                    onTap: (){

                    },
                    child:
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: HexColor(Colors_theme.dark_app_color),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(width:10.0),
                          Flexible(
                            child:
                            Row(
                              children: [
                                Icon(Icons.date_range,color: Colors.white24,),
                                SizedBox(width:5),
                                Container(
                                  width: 1.0,
                                  height: 25.0,
                                  color:Color(0xff7B7A7A),
                                ),
                                SizedBox(width:8.0),
                                Text(
                                  widget.valid_date,style: (TextStyle(color: Colors.white,fontSize: 14)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                      DropdownButton(
                        value: choose_status,
                        onChanged: (newvalue){
                          setState(() {
                            choose_status=newvalue as String;
                          });
                        },
                        underline: SizedBox(),
                        dropdownColor: Colors.black,
                        hint:Text(choose_status.toString()+"                                                   ",style: TextStyle(color:HexColor("#0c0c0c"),fontSize: 15),),
                        items:status_list.map((valueitem) {
                          return DropdownMenuItem(
                              value: valueitem,
                              child:Text(valueitem.toString(),style: TextStyle(color:Colors.white,fontSize: 15),)
                          );
                        }).toList(),
                      ),
                    ],
                  ),
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
                          controller: Remarkcontroller,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Remarks',
                              hintStyle: TextStyle(
                                  color: Colors.white24
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
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
                    Navigator.pop(context);
                    widget.onResult(choose_status,Remarkcontroller.text);
                  },
                  child: Text("Save Details",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      );
  }



}
