library tui;

import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';

part 'src/screen.dart';
part 'src/canvas.dart';

part 'src/text.dart';
part 'src/view.dart';

part 'src/tree.dart';
part 'src/window.dart';
part 'src/escape.dart';

class Size {
  int width, height;
  Size(this.width, this.height);
  Size.from(Size size) {
    width = size.width;
    height = size.height;
  }
}

abstract class Sizable {
  Size size;
  int get width => size.width;
  int get height => size.height;
}

class Position {
  int x, y;
  Position(this.x, this.y);
  Position.from(Position position) {
    x = position.x;
    y = position.y;
  }
}

class Positionable {
  Position position = new Position(0,0);
  int get x => position.x;
  int get y => position.y;
}