part of tui;

class TreeNode {

  int id;
  String label;
  int get depth {
    if (_parent != null) return _parent.depth + 1;
    return 0;
  }
  bool opened = false;

  TreeNode _parent;
  List<TreeNode> _children = [];

  TreeNode(this.id, this.label);

  TreeNode add(TreeNode node) {
    node._parent = this;
    _children.add(node);
    return node;
  }
}

class TreeNodeIterator implements Iterator<TreeNode> {
  TreeNode current;
  TreeModel _model;
  final _queue = new Queue<List>();

  TreeNodeIterator(this._model) {
    _queue.add([_model.root, 0]); 
  }

  bool moveNext() {
    while (_queue.isNotEmpty) {
      var parent = _queue.last;
      if (parent[0]._children.length > parent[1]) {
        TreeNode node = parent[0]._children[parent[1]++];
        current = node;
        if (node.opened && node._children.isNotEmpty)
          _queue.add([node, 0]);
        return true;
      } else {
        _queue.removeLast();
      }
    }
    return false;
  }

}

class TreeModel extends IterableBase<TreeNode> {

  final _controller = new StreamController<Map>.broadcast();
  Stream<Set> get changes => _controller.stream;

  final root = new TreeNode(0, 'root');

  Iterator<TreeNode> get iterator => new TreeNodeIterator(this);
  
  int indexOf(TreeNode target) {
    int i = 0;
    for (var node in this) {
      if (node == target)
        return i;
      i++;
    }
    return null;
  }
}

class View {
  int row;
  int col;
  int height;
  int width;
}

class TreeView extends View {

  int position = 0;
  int cursor = 0;

  TreeModel _model;

  TreeView(this._model);

  void move_up() {

    if (cursor > 0) {
      cursor--;
      if (cursor < position) {
        position--;
      }
      render();
    }

  }

  void move_left() {
    var node = _model.skip(cursor).first;
    if (node._parent._parent != null) {
      node._parent.opened = false;
      cursor = _model.indexOf(node._parent);
      position = min(cursor, position);
      render();
    }
  }

  void move_down() {
    var len = _model.length-1;
    if (len > cursor) {
      cursor++;
      if (cursor >= (position+height)) {
        position++;
      }
      render();
    }
  }

  void move_right() {
    var node = _model.skip(cursor).first;
    if (node._children.isNotEmpty) {
      node.opened = true;
      move_down();
    }
  }

  void render() {
    var iter = _model.skip(position).iterator;
    for (var i = 0; i < height; i++) {
      Terminal.moveCursor(row: row+i, column: col);
      Terminal.eraseLine();
      if (iter.moveNext()) {
        String line = ' '*iter.current.depth + iter.current.label;
        if (i == (cursor-position)) Terminal.setBackgroundColor(2);
        Terminal.write(line.substring(0, min(line.length, width)));
        if (i == (cursor-position)) Terminal.resetBackgroundColor();
      }
    }
  }

}