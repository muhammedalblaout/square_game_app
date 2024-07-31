import 'dart:math';
import 'dart:ui';

import '../models/power_up_item.dart';
import '../models/item.dart';
import '../models/moving_item.dart';

bool wallCollide(
    MovingItem item, double centerX, double centerY, int fieldSize) {
  bool status = false;
  double vx = item.v.dx;
  double vy = item.v.dy;
  final Offset centerPosition = Offset(item.position.dx, item.position.dy)
      .translate(item.size / 2, item.size / 2);

  if (centerPosition.dx - (item.size / 2) <= centerX - (fieldSize / 2)) {
    var dx = centerPosition.dx - (item.size / 2) - (centerX - (fieldSize / 2));
    item.setPosition(Offset(item.position.dx - dx, item.position.dy));

    vx = vx * -1;
    status = true;
  }
  if (centerPosition.dx + (item.size / 2) >= centerX + (fieldSize / 2)) {
    var dx = centerPosition.dx + (item.size / 2) - (centerX + (fieldSize / 2));
    item.setPosition(Offset(item.position.dx - dx, item.position.dy));
    vx = vx * -1;
    status = true;
  }
  if (centerPosition.dy - (item.size / 2) <= centerY - (fieldSize / 2)) {
    var dy = centerPosition.dy - (item.size / 2) - (centerY - (fieldSize / 2));
    item.setPosition(Offset(item.position.dx, item.position.dy - dy));
    vy = vy * -1;
    status = true;
  }
  if (centerPosition.dy + (item.size / 2) >= centerY + (fieldSize / 2)) {
    var dy = centerPosition.dy + (item.size / 2) - (centerY + (fieldSize / 2));
    item.setPosition(Offset(item.position.dx, item.position.dy - dy));
    vy = vy * -1;
    status = true;
  }
  item.setV(Offset(vx, vy));

  return status;
}
bool collide(Item item1, Item item2) {

  bool isCollided = false;
  final Offset centerItem1Position =
  Offset(item1.position.dx, item1.position.dy)
      .translate(item1.size / 2, item1.size / 2);

  final Offset centerItem2Position =
  Offset(item2.position.dx, item2.position.dy)
      .translate(item2.size / 2, item2.size / 2);

  if ((centerItem1Position.dx + (item1.size / 2)) >=
      (centerItem2Position.dx - (item2.size / 2)) &&
      centerItem1Position.dx <=
          (centerItem2Position.dx + (item2.size / 2)) ||
      (centerItem2Position.dx + (item2.size / 2)) >=
          (centerItem1Position.dx - (item1.size / 2)) &&
          centerItem2Position.dx <=
              (centerItem1Position.dx + (item1.size / 2))) {
    if ((centerItem1Position.dy + (item1.size / 2)) >=
        (centerItem2Position.dy - (item2.size / 2)) &&
        centerItem1Position.dy <=
            (centerItem2Position.dy + (item2.size / 2)) ||
        (centerItem2Position.dy + (item2.size / 2)) >=
            (centerItem1Position.dy - (item1.size / 2)) &&
            centerItem2Position.dy <=
                (centerItem1Position.dy + (item1.size / 2))) {
      isCollided = true;
    }
  }

  return isCollided;
}
void transferEnergy(MovingItem item1, MovingItem items2) {
  double fDistance = sqrt(((item1.position.dx - items2.position.dx) * (item1.position.dx - items2.position.dx)) +
      ((item1.position.dy - items2.position.dy) * (item1.position.dy - items2.position.dy)));
  double nx = (items2.position.dx-item1.position.dx ) / fDistance;
  double ny = ( items2.position.dy-item1.position.dy ) / fDistance;
  double tx = -ny;
  double ty = nx;

  double dpTan1 = item1.v.dx * tx + item1.v.dy * ty;
  double dpTan2 =  items2.v.dx * tx +  items2.v.dy  * ty;

  double dpNorm1 =  item1.v.dx * nx + item1.v.dy * ny;
  double dpNorm2 = items2.v.dx * nx +  items2.v.dy  * ny;

  double m1 = (dpNorm1 * (item1.size - items2.size) + 2.0 * item1.size * dpNorm2) / (item1.size + items2.size);
  double m2 = (dpNorm2 * (-item1.size + items2.size) + 2.0 * item1.size * dpNorm1) / (item1.size + items2.size);

  items2.setV(Offset(tx * dpTan2 + nx * m2, ty * dpTan2 + ny * m1));
  item1.setV(Offset(tx * dpTan1 + nx * m2, ty * dpTan1 + ny * m1));

  item1.setPosition(Offset(item1.position.dx + item1.v.dx,
      item1.position.dy + item1.v.dy));

  items2.setPosition(Offset(
      items2.position.dx + items2.v.dx,
      items2.position.dy + items2.v.dy));
}
PowerUpItem genaratePowerUpItem(
    List<Item> list, double centerX, double centerY, int fieldSize, int size) {
  bool repeat = true;
  Random random = Random();
  double randomX = 0.0;
  double randomY = 0.0;
  do {
    repeat = false;
    randomX =
        random.nextInt(fieldSize-size)+ centerX - ((fieldSize ) / 2);

    randomY =
        random.nextInt(fieldSize-size) + centerY - ((fieldSize) / 2);
    for (int i = 0; i < list.length; i++) {
      if ((list[i].position.dx - (list[i].size / 2)) < randomX &&
          randomX < (list[i].position.dx + (list[i].size / 2))) {
        if ((list[i].position.dy - (list[i].size / 2)) < randomY &&
            randomX < (list[i].position.dy + (list[i].size / 2))) {
          repeat = true;
        }
      }
    }
  } while (repeat);
  return PowerUpItem(position: Offset(randomX, randomY), size: size.toDouble());
}

