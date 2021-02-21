import 'dart:async';

class TextBloc {
  var _textController = StreamController<String>();
  Stream<String> get textStream => _textController.stream;

  updateText(String text) {
    if (text == null || text == "") {
      _textController.sink.add(text);
    }
  }

  dispose() {
    _textController.close();
  }
}
