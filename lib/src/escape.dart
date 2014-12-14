part of tui;

abstract class ANSI {

  static const String ESC = "\x1b[";

  static const String CURSOR_HOME = "${ESC}H";
  static const String CURSOR_HOME_COL = "\r";

  static const String HIDE_CURSOR = "${ESC}?25l";
  static const String SHOW_CURSOR = "${ESC}?25h";

  static const String MOUSE_TRACKING_ON = "${ESC}?1000h${ESC}?1002h";
  static const String MOUSE_TRACKING_OFF = "${ESC}?1002l${ESC}?1000l";

  static const String ERASE_SCREEN = "${ESC}2J";
  static const String ERASE_TO_END_OF_LINE = "${ESC}K";

  String set_cursor_position(int x, int y) {
    return ESC+"${y+1};${x+1}H";
  }

  String move_cursor_up(int x) {
    if (x < 1) return "";
    return ESC+"${x}A";
  }

  String move_cursor_down(int x) {
    if (x < 1) return "";
    return ESC+"${x}B";
  }

  String move_cursor_right(int x) {
    if (x < 1) return "";
    return ESC+"${x}C";
  }

  String move_cursor_left(int x) {
    if (x < 1) return "";
    return ESC+"${x}D";
  }

}

abstract class KeyCode {

  static const String UP = "${ANSI.ESC}A";
  static const String DOWN = "${ANSI.ESC}B";
  static const String RIGHT = "${ANSI.ESC}C";
  static const String LEFT = "${ANSI.ESC}D";

  static const String HOME = "${ANSI.ESC}H";
  static const String END = "${ANSI.ESC}F";

  static const String F1 = "${ANSI.ESC}M";
  static const String F2 = "${ANSI.ESC}N";
  static const String F3 = "${ANSI.ESC}O";
  static const String F4 = "${ANSI.ESC}P";
  static const String F5 = "${ANSI.ESC}Q";
  static const String F6 = "${ANSI.ESC}R";
  static const String F7 = "${ANSI.ESC}S";
  static const String F8 = "${ANSI.ESC}T";
  static const String F9 = "${ANSI.ESC}U";
  static const String F10 = "${ANSI.ESC}V";
  static const String F11 = "${ANSI.ESC}W";
  static const String F12 = "${ANSI.ESC}X";

  static const String INS = "${ANSI.ESC}2~";
  static const String DEL = "${ANSI.ESC}3~";
  static const String PAGE_UP = "${ANSI.ESC}5~";
  static const String PAGE_DOWN = "${ANSI.ESC}6~";

  static const String SPACE = " ";

}