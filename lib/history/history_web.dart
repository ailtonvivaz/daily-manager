import 'dart:html' as html;

class History {
  void pushState(String url) {
    html.window.history.pushState('', '', url);
  }
}
