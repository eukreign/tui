import 'dart:io';
import 'dart:convert';
import 'package:console/console.dart';
import 'package:tui/tui.dart';

main() {
  var tree = new TreeModel();
  tree.root.add(new TreeNode(1, "One")..add(new TreeNode(2, "Two")..add(new TreeNode(3, "Sub Two")))
           ..add(new TreeNode(4, "Three")));
  tree.root.add(new TreeNode(5, "Four"));
  tree.root.add(new TreeNode(6, "Five"));
  tree.root.add(new TreeNode(7, "Six"));
  tree.root.add(new TreeNode(8, "Seven"));
  tree.root.add(new TreeNode(9, "Eight")..add(new TreeNode(10, "Nine")..add(new TreeNode(11, "Sub Nine")))
           ..add(new TreeNode(12, "Ten")));

  Terminal.init();
  Terminal.eraseDisplay(2);

  var pos = 0;
  var file = new File('head.txt');
  List<String> text = file.readAsLinesSync();
  
  var treeView = new TreeView(tree)
                      ..col = 3
                      ..row = 3
                      ..height = 4
                      ..width = 20;
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
        Terminal.moveToColumn(1);
        stdin.echoMode = true;
        stdin.lineMode = true;
        exit(0);
        break;
    }
  });
}
