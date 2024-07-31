import 'dart:ui';

class Item{
   Offset position;
   double size;

   Item({
    required this.position,
    required this.size,
  });
  void setPosition(Offset newPosition){
    position=newPosition;
  }


  void setSize(double newSize){
    size=newSize;
  }
}