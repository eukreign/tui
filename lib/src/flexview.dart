part of tui.flexbox;

// see: http://css-tricks.com/snippets/css/a-guide-to-flexbox/

enum FlexDirection {
  row,
  row_reverse,
  column,
  column_reverse
}

enum FlexWrap {
  nowrap,
  wrap,
  wrap_reverse
}

class FlexFlow {
  FlexDirection direction = FlexDirection.row;
  FlexWrap wrap = FlexWrap.nowrap;
}

enum JustifyContent {
  flex_start,
  flex_end,
  center,
  space_between,
  space_around
}

enum AlignItems {
  flex_start,
  flex_end,
  center,
  baseline,
  stretch
}

enum AlignContent {
  flex_start,
  flex_end,
  center,
  space_between,
  space_around,
  stretch
}

class FlexContainer {
  FlexFlow flex_flow = new FlexFlow();
  FlexDirection get flex_direction => flex_flow.direction;
  FlexWrap get flex_wrap => flex_flow.wrap;
  JustifyContent justify_content = JustifyContent.flex_start;
  AlignItems align_items = AlignItems.stretch;
  AlignContent align_content = AlignContent.stretch;
}

class Flex {
  int _grow = 0;
  int get grow => _grow;
  void set grow(int grow) {
    if (grow < 0) throw "Negative numbers are invalid.";
    this.grow = grow;
  }

  int _shrink = 1;
  int get shrink => _shrink;
  void set shrink(int shrink) {
    if (shrink < 0) throw "Negative numbers are invalid.";
    this.shrink = shrink;
  }

  int basis = null; // auto
}

enum AlignSelf {
  flex_start,
  flex_end,
  center,
  baseline,
  stretch
}

class FlexItem {
  Flex flex_flex = new Flex();
  int get flex_grow => flex_flex.grow;
  int get flex_shrink => flex_flex.shrink;
  int get flex_basis => flex_flex.basis;

  AlignSelf align_self = null; // auto
}

class FlexView extends View with FlexContainer, FlexItem {

}