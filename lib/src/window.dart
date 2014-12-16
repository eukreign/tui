part of tui;

// Window is the top-level view that contains menu, status bar, title, etc

class Window extends View {

  Screen screen;

  RenderLoop loop;
  StreamSubscription<String> input;

  void start() {
    stdin.echoMode = false;
    stdin.lineMode = false;
    loop = new RenderLoop();
    input = stdin.transform(ASCII.decoder).listen(onKey);

    print(ANSI.ERASE_SCREEN);
    loop.start(() {
      screen = new Screen(new Size(80,12));
      var canvas = screen.canvas();
      this.resize(canvas.size, canvas.position);
      this.render(canvas);
      print(ANSI.CURSOR_HOME);
      print(screen.toString());
    });
  }

  void onKey(String key) {

  }

  void stop() {
    stdin.echoMode = true;
    stdin.lineMode = true;
    loop.stop();
    input.cancel();
  }

}