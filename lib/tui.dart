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

class Location {
  int x, y;
  Location(this.x, this.y);
  Location.from(Location location) {
    x = location.x;
    y = location.y;
  }
}
