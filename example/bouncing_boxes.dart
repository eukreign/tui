import "package:tui/tui.dart";
import 'dart:io';
import "dart:async";
import 'dart:convert';


// window will figure out the stacking order of views
// update all Canvas objects with occlusion information
// then ask each view to render with their canvas

class Window {

  View2 header;
  View2 main;
  View2 footer;

  List<String> buffer = [];
  StreamSubscription<String> input;

  void start() {
    stdin.echoMode = false;
    stdin.lineMode = false;
    input = stdin.transform(ASCII.decoder).listen(handle_input);
  }

  void stop() {
    stdin.echoMode = true;
    stdin.lineMode = true;
    input.cancel();
  }

  void handle_input(String key) {
    print(key.substring(1));
    if (key == 'q') stop();
  }

}



class Box extends View {

  String _border;
  Box(this._border);

  void render(Canvas canvas) {
    var full = new Text(_border.substring(0,1) * canvas.width)..color = _border;
    _render_line(0, 0, full, canvas);
    _render_line(1, 0, full, canvas);
    var border = new Text(_border.substring(0,1) * 2)..color = _border;
    for (int j = 2; j < canvas.height-2; j++) {
      _render_line(j, 0, border, canvas);
      _render_line(j, canvas.width-2, border, canvas);
    }
    _render_line(canvas.height-2, 0, full, canvas);
    _render_line(canvas.height-1, 0, full, canvas);
  }

  void _render_line(int j, int i, Text text, Canvas canvas) {

    var iter = text.iterator;
    var opened = false;

    int last_i, last_j;
    for (; i < canvas.width; i++) {

      if (iter.moveNext()) {

        if (!canvas.occluded(i, j)) {
          if (!opened) {
            canvas.write(i, j, iter.stack.last.node.open()+iter.current);
            opened = true;
          } else {
            canvas.write(i, j, iter.current);
          }
          last_j = j;
          last_i = i;
        } else if (opened) {
          opened = false;
          String last = canvas.stringAt(last_i, last_j);
          canvas.write(last_i, last_j, last + iter.last_stack.map((t)=>t.close()).join());
        }
      }
    }
    if (last_j != null && last_i != null) {
      String last = canvas.stringAt(last_i, last_j);
      canvas.write(last_i, last_j, last + iter.last_stack.map((t)=>t.close()).join());
    }
  }
}

class Fixed extends View {
  Size measure(int width, int height) {
    return new Size(width, height);
  }
  void render(Canvas canvas) {
    for (var node in nodes) {
      node.render(canvas.canvas(node.size, node.offset));
    }
  }
}


class RenderLoop {
  Duration _interval;
  bool _stop = false;
  List inputs = [];

  RenderLoop({int milliseconds: 50}) {
    _interval = new Duration(milliseconds: milliseconds);
  }

  void start([Function update_callback]) {
    new Timer(_interval, () {
      if (_stop) return;
      if (update_callback != null) {
        update_callback();
      } else {
        update();
      }
      new Timer(_interval, ()=>start(update_callback));
    });
  }

  void update() {
    throw "Either pass an update function to start() or extend the RenderLoop and implement update() method.";
  }

  void stop() {
    _stop = true;
    inputs.forEach((i)=>i.cancel());
  }

}

main() {
  var fixed = new Fixed();
  var box1 = new Box("1")..size=new Size(18,8)..offset=new Location(0,0);
  var box2 = new Box("2")..size=new Size(18,8)..offset=new Location(8,2);
  var box5 = new Box("31")..size=new Size(18,8)..offset=new Location(4,4);
  fixed.nodes.addAll([box1, box2, box5]);

  var loop = new RenderLoop();

  stdin.echoMode = false;
  stdin.lineMode = false;
  var sub = stdin.transform(ASCII.decoder).listen((String key) {
    switch (key) {
      case KeyCode.UP:
        box1.offset = new Location(box1.offset.x, box1.offset.y-1);
        break;
      case KeyCode.LEFT:
        box1.offset = new Location(box1.offset.x-1, box1.offset.y);
        break;
      case KeyCode.DOWN:
        box1.offset = new Location(box1.offset.x, box1.offset.y+1);
        break;
      case KeyCode.RIGHT:
        box1.offset = new Location(box1.offset.x+1, box1.offset.y);
        break;
      case "q":
        stdin.echoMode = true;
        stdin.lineMode = true;
        loop.stop();
        break;
    }
  });

  loop.inputs = [sub];

  print(ANSI.ERASE_SCREEN);
  loop.start(() {
    var screen = new Screen(new Size(80,12));
    var canvas = screen.canvas();
    fixed.render(canvas);
    print(ANSI.CURSOR_HOME);
    print(screen.toString());
  });

}