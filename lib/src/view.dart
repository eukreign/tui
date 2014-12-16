part of tui;

abstract class View extends Object with Sizable, Positionable {

  bool get hasChildren => children.isNotEmpty;

  List<Text> text = [];
  List<View> children = [];

  // The update() method is called by resize() or from your
  // own code when something about the data this view represents
  // changes. Common thing is to use this in callbacks for async
  // events that modify data
  //
  //  async_op().then((data) { view.data = data; view.update() }
  //
  // If update() is of any complexity and you have multiples async calls then
  // reduce the number of calls to update() by waiting for all operations to finish,
  // on the other hand if the async operations will take a long time and you want
  // the screen to update with at least partial results, then go ahead and call update()
  // with each async completion.
  //
  // var async1 = async_op();
  // var async2 = async_op2();
  // new Future.wait([async1,async2]).then(update);
  //
  void update() {
    // called when resize happens or new data is available for this view
    // update text objects
  }

  // passed in Size with available size
  // the View should save the size
  // a parent View will use this to get an idea of what the size requirements
  // are of its child elements, after all children have been resized
  // it will then pass in Canvas object of that size to render()
  // it is okay to modify the size during this function call,
  // the parent will check for changes in size (making it smaller)
  // to adjust other children or do something else

  // called when:
  // 1. app is initially loaded
  // 2. this view is added to another view
  // 3. the parent view changes size
  void resize(Size size, Position position) {
    this.size = size;
    this.position = position;
    resize_children();
    update();
  }

  void render(Canvas canvas) {
    render_texts(canvas);
    render_children(canvas);
  }

  void render_texts(Canvas canvas) {
    for (var line in text) {
      render_text(line, canvas);
    }
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

  // default implementation just calls each child
  // with it's existing size/position to trigger the initial update
  void resize_children() {
    for (var view in children) {
      view.resize(view.size, view.position);
    }
  }

  void render_children(Canvas canvas) {
    for (var view in children) {
      render_child(view, canvas);
    }
  }

  // calls view.render() with new canvas
  void render_child(View view, Canvas canvas) {
    view.render(canvas.canvas(view.size, view.position));
  }

}



class Box extends View {

  String border;
  String color;

  Box(this.border, this.color);

  void update() {
    text = [];
    text.addAll([
    new Text(border*width)..color = color,
    new Text(border*width)..color = color..position = new Position(0, 1)]);
    for (int i = 1; i < height-1; i++) {
      text.add(new Text(border*2)..color = color..position = new Position(0, i));
      text.add(new Text(border*2)..color = color..position = new Position(width-2, i));
    }
    text.addAll([
    new Text(border*width)..color = color..position = new Position(0, height-1),
    new Text(border*width)..color = color..position = new Position(0, height-2),
    ]);
  }

  void resize_children() {
    for (var view in children) {
      var child_size = new Size.from(size);
      child_size.height -= 4;
      child_size.width -= 4;
      var child_position = new Position(2, 2);
      view.resize(child_size, child_position);
    }
  }

}

class CenteredText extends View {
  String content;
  CenteredText(this.content);
  void update() {
    var x = ((width/2)-(content.length/2)).toInt();
    var y = (height/2).toInt()-1;
    text = [new Text(content)..position=new Position(x,y)];
  }
}