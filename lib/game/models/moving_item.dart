import 'dart:ui';

import 'item.dart';

class MovingItem extends Item{
   Offset v;
   int id;

   Color color;

   MovingItem({

    required this.color,
     required this.v,
     required this.id,
     required super.position, required super.size

  });


   void setV(Offset newV){
     v=newV;
   }

}