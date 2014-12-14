part of tui;

abstract class View extends Object with Sizable, Positionable {

  bool get hasChildren => children.isNotEmpty;

  List<Text> text = [];
  List<View> children = [];

  // Called before render() to give the view
  // an opportunity to make any changes to text
  // before being rendered
  void update();

  // passed in Size with available size
  // the View should save the size
  // a parent View will use this to get an idea of what the size requirements
  // are of its child elements, after all children have been resized
  // it will then pass in Canvas object of that size to render()
  // it is okay to modify the size during this function call,
  // the parent will check for changes in size (making it smaller)
  // to adjust other children or do something else
  void resize(Size size) {
    this.size = size;
  }

  void render(Canvas canvas) {
    for (var line in text) {
      render_text(line, canvas);
    }
    resize_children();
    render_children(canvas);
  }

  // 1. Writes the text object to Canvas
  void render_text(Text text, Canvas canvas) {

    var iter = text.iterator;
    var x = text.x;
    var y = text.y;

    var opened = false;
    var last_x;
    var last_y;

    for (;x < canvas.width; x++) {

      if (iter.moveNext()) {

        if (!canvas.occluded(x, y)) {

          var value = iter.current;

          if (!opened) {
            // need to figure out where we left off from before
            // open() might take into account the entire stack, just like close does
            value = iter.stack.last.node.open() + value;
            opened = true;
          }

          canvas.write(x, y, value);

          last_x = x;
          last_y = y;

        } else if (opened) {

          opened = false;
          String last = canvas.stringAt(last_x, last_y);
          canvas.write(last_x, last_y, last + iter.last_stack.map((t)=>t.close()).join());

        }
      }
    }
    if (opened && last_x != null && last_y != null) {
      String last = canvas.stringAt(last_x, last_y);
      canvas.write(last_x, last_y, last + iter.last_stack.map((t)=>t.close()).join());
    }
  }

  void resize_children() {
    for (var view in children) {
      view.resize(size);
    }
  }

  void render_children(Canvas canvas) {
    for (var view in children) {
      render_child(view, canvas);
    }
  }

  // Calls view.update(), figures out sizing for canvas,
  // calls view.render() with new canvas
  void render_child(View view, Canvas canvas) {
    view.update();
    view.render(canvas.canvas(size, view.position));
  }

}



class Box extends View {

  String _border;
  Box(this._border);

  void update() {
    text = [];
    text.addAll([
    new Text(_border.substring(0,1) * width)..color = _border,
    new Text(_border.substring(0,1) * width)..color = _border..position = new Position(0, 1)]);
    for (int i = 1; i < height-1; i++) {
      text.add(new Text(_border.substring(0,1) * 2)..color = _border..position = new Position(0, i));
      text.add(new Text(_border.substring(0,1) * 2)..color = _border..position = new Position(width-2, i));
    }
    text.addAll([
    new Text(_border.substring(0,1) * width)..color = _border..position = new Position(0, height-1),
    new Text(_border.substring(0,1) * width)..color = _border..position = new Position(0, height-2),
    ]);
  }

}

class Fixed extends View {

  void resize_children() {
    // does not resize children since everything if absolutely positioned/fixed
  }

  void update() {

  }

}