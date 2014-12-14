part of tui;

class _TextNodeIteratorPointer {
  Text node; int index;
  _TextNodeIteratorPointer(this.node, this.index);
}

class TextNodeIterator implements Iterator<String> {

  // represents single character
  String current;

  // all of the parent nodes of the last String returned
  List<Text> last_stack = [];

  // current text node
  Iterator<String> string;

  // all of the parent text nodes, this is used to
  // apply all of the previous styles up to this point
  final stack = new Queue<_TextNodeIteratorPointer>();

  TextNodeIterator(Text _first) {
    stack.add(new _TextNodeIteratorPointer(_first, 0));
  }

  bool moveNext() {

    if (string != null) {
      if (string.moveNext()) {
        current = string.current;
        return true;
      } else {
        string = null;
        stack.removeLast();
      }
    }

    while (stack.isNotEmpty) {
      var last = stack.last;
      Text node = last.node;
      if (node.isLeaf) {
        last_stack = stack.map((p)=>p.node).toList();
        string = node.text.split('').iterator;
        return moveNext();
      } else if (node._nodes.length > last.index) {
        Text child_node = node._nodes[last.index++];
        stack.add(new _TextNodeIteratorPointer(child_node, 0));
      } else {
        node = stack.removeLast().node;
      }
    }
    return false;
  }

}


// Text is like the equivalent of a Pen object in graphics tool kits
// it is an API to describe what should be rendered eventually to the screen

// it should be possible to seek() and iterate from a certain point when parts
// of the text are occluded or line breaks, this class will have to figure out what formatting
// style needs to be applied given where we are in the text

// above seek ability is also how we'll support multiple lines

// text can be iterated without formatting, to get the visual length of this
// text can also be iterated with formatting to actually render it on screen
class Text extends IterableBase<String> with Positionable {

  bool get isLeaf => _text != null;
  bool get hasChildren => _nodes.isNotEmpty;

  String _text;
  String get text => _text;
  void set text(String text) {
    if (hasChildren) throw "Cannot set text on container type.";
    _text = text;
  }

  List<Text> _nodes = [];
  List<Text> get nodes {
    if (isLeaf) throw "Cannot access nodes on leaf type.";
    return _nodes;
  }

  bool bold = false;
  bool italics = false;
  String color;

  TextNodeIterator get iterator => new TextNodeIterator(this);

  Text([this._text]);

  void apply(Text text) {
    bold = text.bold;
    italics = text.italics;
    color = text.color;
  }

  void _verify(Text text) {
    // check that none of the children
    // have a style set to true, that's
    // already set to true in style passed in
    // this prevents issue where close() here
    // will close the style of a parent style

    // pseudo code:
    // 1. check that nothing in style is also set to true here
    // 2. set all style elements to true in style that are true here
    // 3. call _verify(style) on content elements down the line

    // maybe instead of throwing error we can just handle this
    // by ignoring styles set somewhere in the parent?
  }

  String open() {
    if (color != null)
      return "\x1b[${color}m";
    else
      return "\x1b[31m";
  }

  String close() {
    return "\x1b[0m";
  }

  Text add([String text = ""]) {
    var node = new Text(text);
    nodes.add(node);
    return node;
  }

}
