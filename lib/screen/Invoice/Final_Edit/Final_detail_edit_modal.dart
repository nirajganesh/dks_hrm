import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
class Final_detail_edit_modal extends StatefulWidget {

  Final_detail_edit_modal({
    required this.inv_id,
    required this.inv_date,
    required this.due_date,
    required this.client_name,
    required this.remark,
    required this.onResult,
    Key? key}) : super(key: key);

  final String inv_id;
  final String inv_date;
  final String due_date;
  final String client_name;
  final String remark;
  final Function(String) onResult;

  @override
  _Final_detail_edit_modalState createState() => _Final_detail_edit_modalState();


}

class _Final_detail_edit_modalState extends State<Final_detail_edit_modal> {

  final TextEditingController Remarkcontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Text("Edit Invoice Details",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
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
                        child:Text(widget.inv_id,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),),
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
                                widget.inv_date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
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
                                widget.due_date,style: (TextStyle(color: HexColor("#0c0c0c"),fontSize: 14)),
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
                  widget.onResult(Remarkcontroller.text);
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
