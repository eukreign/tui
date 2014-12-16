import "package:tui/tui.dart";


class BouncingBoxes extends Window {

  Box box1, box2, box3;

  BouncingBoxes() {
    box1 = new Box("1", "1")
            ..size=new Size(18,8)
            ..position=new Position(0,0);
    box2 = new Box("2", "2")
            ..size=new Size(18,8)
            ..position=new Position(8,2);
    box3 = new Box("3", "31")
            ..size=new Size(18,8)
            ..position=new Position(4,4);

    children.addAll([box1, box2, box3]);

    box1.children.add(new CenteredText("box 1"));

  }

  void onKey(String key) {
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
        stop();
    }
  }
}

main() {
  new BouncingBoxes().start();
}