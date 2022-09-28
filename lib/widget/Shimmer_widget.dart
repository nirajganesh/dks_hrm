import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Shimmer_widget
{
   static Widget shimmer()
   {
      return Shimmer.fromColors(
         baseColor: Colors.grey[300]!,
         highlightColor: Colors.grey[100]!,
         child: ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) {
               return Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(16),
                  ),
                  child: const SizedBox(height: 80),
               );
            },
         ),
      );
   }

   static Widget dark_shimmer()
   {
      return Shimmer.fromColors(
         baseColor: Colors.grey[300]!,
         highlightColor: Colors.grey[100]!,
         child: ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) {
               return Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(16),
                  ),
                  child: const SizedBox(height: 80),
               );
            },
         ),
      );
   }


   static Widget shimmer_setting()
   {
          return Shimmer.fromColors(
             baseColor: Colors.grey[300]!,
             highlightColor: Colors.grey[100]!,
             child:Column(
                children: [
                   Container(
                     height: 80,
                     width: 80,
                     decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.grey.withOpacity(0.8),
                     ),
                   ),
                   SizedBox(height: 30,),
                   Container(
                      height: 280,
                      width: double.infinity,
                      decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(15),
                         color: Colors.grey.withOpacity(0.8),
                      ),
                   ),
                ],
             )
          );
   }
}