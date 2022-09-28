import 'package:dks_hrm/model/Invoice/Invoice_dynamic_model.dart';
import 'package:dks_hrm/widget/Invoice/Invoice_dynamic_widget.dart';
import 'package:flutter/material.dart';
class multi_form extends StatefulWidget {

  const multi_form({Key? key}) : super(key: key);

  @override
  _multi_formState createState() => _multi_formState();
}

class _multi_formState extends State<multi_form> {

  List<Invoice_dynamic_model> users=[];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Users Form'),
      ),
      body: users.length <= 0? Center(
        child: Text('Add form by tapping[+] button below'),
      ):ListView.builder(
          itemCount: users.length,
          itemBuilder:(_,i)=> Invoice_dynamic_widget(user: users[i], onDelete: ()=>OnDelete(i),),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAddForm,
      ),
    );
  }

  void OnDelete(int index)
  {
    setState(() {
      users.removeAt(index);
    });
  }

  void onAddForm()
  {
    setState(() {
      users.add(Invoice_dynamic_model());
    });
  }
}
