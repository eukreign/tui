part of tui;

/**
 * Screen is the main buffer shared by all Canvas write operations.
 *
 * Once all View.render() methods have been called the Screen writes
 * its buffer to stdout. It will try to optimize things by only writing
 * lines that have changed from the previous buffer.
 *
 */
class Screen {

  Size _size;
  int get width => _size.width;
  int get height => _size.height;

  List<List<String>> _buffer = [];
  List<List<String>> _previous_buffer = [];

  Screen(Size size) {
    _size = size;
    clear();
  }

  void resize(Size size) {
    _size = size;
    clear();
  }

  void clear() {
    _previous_buffer = _buffer;
    _buffer = new List.generate(height, (_)=>new List.filled(width, null));
  }

  Canvas canvas([Size size, Location offset]) {
    return new Canvas(
        size!=null?size:new Size.from(this._size),
        offset!=null?offset:new Location(0,0), this);
  }

  String toString() {
    return _buffer.map((line)=>line.map((char)=>char!=null?char:" ").join()).join('\n');
  }

  bool occluded(int x, int y) {
    return _buffer[y][x] != null;
  }

  void write(int x, int y, String char) {
    _buffer[y][x] = char;
  }

  String stringAt(int x, int y) {
    return _buffer[y][x];
  }

}