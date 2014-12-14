part of tui;

// window will figure out the stacking order of views
// update all Canvas objects with occlusion information
// then ask each view to render with their canvas

class Window {

  View2 header;
  View2 main;
  View2 footer;

  List<String> buffer = [];
  StreamSubscription<String> input;

  void start() {
    stdin.echoMode = false;
    stdin.lineMode = false;
    input = stdin.transform(ASCII.decoder).listen(handle_input);
  }

  void stop() {
    stdin.echoMode = true;
    stdin.lineMode = true;
    input.cancel();
  }

  void handle_input(String key) {
    print(key.substring(1));
    if (key == 'q') stop();
  }

}
