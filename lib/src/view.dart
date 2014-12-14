part of tui;

class View {

  Size size;
  Location offset;

  bool get isLeaf => _text != null;
  bool get hasChildren => _nodes.isNotEmpty;

  String _text;
  String get text => _text;
  void set text(String text) {
    if (hasChildren) throw "Cannot set text on container type.";
    _text = text;
  }

  List<View> _nodes = [];
  List<View> get nodes {
    if (isLeaf) throw "Cannot access nodes on leaf type.";
    return _nodes;
  }

  void render(Canvas canvas) {
  }

}

