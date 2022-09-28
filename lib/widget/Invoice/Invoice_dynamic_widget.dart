import 'package:dks_hrm/model/Invoice/Invoice_dynamic_model.dart';
import 'package:flutter/material.dart';

typedef OnDelete();
class Invoice_dynamic_widget extends StatefulWidget {


  final Invoice_dynamic_model user;
  final state=_Invoice_dynamic_widgetState();
  final OnDelete onDelete;

  Invoice_dynamic_widget({required this.user,required this.onDelete});

  @override
  _Invoice_dynamic_widgetState createState() => state;

  bool? isValid() => state.validate();
}

class _Invoice_dynamic_widgetState extends State<Invoice_dynamic_widget> {

  final form=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                leading: Icon(Icons.people),
                title: Text('User Form'),
                actions:<Widget> [
                  IconButton(
                      onPressed: widget.onDelete,
                      icon: Icon(Icons.delete),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.user.fullname,
                  onSaved: (val) =>widget.user.fullname=val,
                  validator: (val) => val!.length> 3 ?null: 'Full Name is Invalid',
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter Your full name'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.user.email,
                  onSaved: (val) =>widget.user.email=val,
                  validator: (val) => val!.contains('@') ?null: 'Email is Invalid',
                  decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter Your Email'
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool? validate()
  {
    var valid=form.currentState?.validate();
    if(valid!) form.currentState?.save();
    return valid;
  }
}

