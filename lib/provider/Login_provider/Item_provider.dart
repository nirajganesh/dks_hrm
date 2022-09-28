import 'package:flutter/material.dart';

class Item_provider with ChangeNotifier
{
   int _subtotal=0;
   int get subtotal => _subtotal;

   void update_subtotal(int value)
   {
       _subtotal=_subtotal+value;
       notifyListeners();
   }
   void clear_subtotal()
   {
     _subtotal=0;
     notifyListeners();
   }
}