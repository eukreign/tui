part of tui;

class RenderLoop {
  Duration _interval;
  bool _stop = false;

  RenderLoop({int milliseconds: 50}) {
    _interval = new Duration(milliseconds: milliseconds);
  }

  void start([Function update_callback]) {
    new Timer(_interval, () {
      if (_stop) return;
      if (update_callback != null) {
        update_callback();
      } else {
        update();
      }
      new Timer(_interval, ()=>start(update_callback));
    });
  }

  void update() {
    throw "Either pass an update function to start() or extend the RenderLoop and implement update() method.";
  }

  void stop() {
    _stop = true;
  }

}
