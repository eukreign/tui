import "package:tui/tui.dart";
import "dart:io";
import "dart:async";
import "dart:convert";


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
  var box1 = new Box("1")..size=new Size(18,8)..position=new Position(0,0);
  var box2 = new Box("2")..size=new Size(18,8)..position=new Position(8,2);
  var box5 = new Box("31")..size=new Size(18,8)..position=new Position(4,4);
  fixed.children.addAll([box1, box2, box5]);

  var loop = new RenderLoop();

  stdin.echoMode = false;
  stdin.lineMode = false;
  var sub = stdin.transform(ASCII.decoder).listen((String key) {
    switch (key) {
      case KeyCode.UP:
        box1.position = new Position(box1.x, box1.y-1);
        break;
      case KeyCode.LEFT:
        box1.position = new Position(box1.x-1, box1.y);
        break;
      case KeyCode.DOWN:
        box1.position = new Position(box1.x, box1.y+1);
        break;
      case KeyCode.RIGHT:
        box1.position = new Position(box1.x+1, box1.y);
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
    var size = new Size(80,12);
    var screen = new Screen(size);
    var canvas = screen.canvas();
    fixed.render(canvas);
    print(ANSI.CURSOR_HOME);
    print(screen.toString());
  });

}