part of tui;

/**
 * A Canvas provides constrained read/write access to the Screen.
 *
 * When a container view is ready to render its child views it
 * will create a new Canvas object that is smaller than the
 * container's Canvas but hopefuly large enough for child. It
 * will then call the child's render() method passing in the
 * Canvas.
 *
 * A View's render() method should not try to write outside the
 * canvas width/height boundary.
 *
 */
class Canvas extends Object with Sizable, Positionable {

  Screen _screen;

  Canvas(Size size, Position offset, this._screen) {
    this.size = size;
    this.position = offset;
  }

  // Create a new canvas offset from this one.
  Canvas canvas(Size size, Position offset) {
    offset.x += x;
    offset.y += y;
    return new Canvas(size, offset, _screen);
  }

  // Returns true if there is already something written at this point.
  bool occluded(int x, int y) =>
    _screen.occluded(position.x+x, position.y+y);

  // Writes to a point on the canvas.
  void write(int x, int y, String char) =>
    _screen.write(position.x+x, position.y+y, char);

  // Returns value at this point.
  String stringAt(int x, int y) =>
    _screen.stringAt(position.x+x, position.y+y);

}
