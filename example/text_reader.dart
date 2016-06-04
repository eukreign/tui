import "package:tui/tui.dart";
import "dart:io";
import "dart:async";
import "dart:convert";

class Scrollable extends View {

  Scrollable(List<String> text) {
    this.text = text.map((l)=>new Text(l)).toList();
  }

}

class FileReader extends Window {

  Scrollable scrollable;

  FileReader() {
    scrollable = new Scrollable(["No file loaded."]);
    children = [scrollable];
    new File('file_browser.dart').readAsLines().then((text) {
      int i = 1;
      scrollable.text = text.map((l)=>new Text(l)..position=new Position(0,i++)).toList().sublist(0,12);
    });
  }

  void onKey(String key) {
    switch (key) {
      case KeyCode.UP:
        break;
      case KeyCode.LEFT:
        break;
      case KeyCode.DOWN:
        break;
      case KeyCode.RIGHT:
        break;
      case "q":
        stop();
    }
  }
}

main() {
  new FileReader().start();
}