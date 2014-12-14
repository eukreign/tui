import 'dart:io';
import 'dart:convert';
import 'package:tui/tui.dart';
import 'package:path/path.dart';

class FileNode extends TreeNode {
  FileNode(this.entity) {
    filename = basename(entity.path);
    if (entity is File)
      leaf = true;
  }

  String filename;
  FileSystemEntity entity;

  bool _opened = false;
  bool get opened => _opened;
  void set opened(bool value) {
    if (value && !leaf) {
      loadChildren();
      _opened = true;
    } else {
      _opened = false;
    }
  }

  void loadChildren() {
    (entity as Directory).listSync().forEach((e) => add(new FileNode(e)));
  }

}

class FileTree extends TreeModel {

  FileTree() {
    var path = Platform.environment['HOME'];
    var dir = new Directory(path);
    dir.listSync().forEach((e) => root.add(new FileNode(e)));
  }

}

class FileBrowser extends TreeView {

  FileBrowser(model): super(model);

  String render_row(FileNode node) {
    return ' '*node.depth + node.filename;
  }

}

main() {
  var tree = new FileTree();

  print(ANSI.ERASE_SCREEN);

  /*
  var pos = 0;
  var file = new File('head.txt');
  List<String> text = file.readAsLinesSync();
  *
   */

  var treeView = new FileBrowser(tree)
                      ..col = 3
                      ..row = 3
                      ..height = 10
                      ..width = 40;
  treeView.render();

  stdin.echoMode = false;
  stdin.lineMode = false;
  stdin.transform(ASCII.decoder).listen((String key) {
    switch (key) {
      case KeyCode.UP:
        treeView.move_up();
        break;
      case KeyCode.LEFT:
        treeView.move_left();
        break;
      case KeyCode.DOWN:
        treeView.move_down();
        break;
      case KeyCode.RIGHT:
        treeView.move_right();
        break;
      case "q":
        stdin.echoMode = true;
        stdin.lineMode = true;
        exit(0);
        break;
    }
  });
}
