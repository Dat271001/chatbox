import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GenAiWorker {
  late final GenerativeModel _model;

  final List<ChatContent> _content = [];
  final StreamController<List<ChatContent>>  _streamController = StreamController.broadcast();

  Stream<List<ChatContent>> get stream => _streamController.stream;
  GenAiWorker() {
    //const apiKey = String.fromEnvironment('apiKey');
    _model = GenerativeModel(model: 'gemini-1.5-pro',
        apiKey: dotenv.env['API_KEY'] ?? '');
  }

  void sendToGemini(String message) async {
    try {
      _content.add(ChatContent.user(message));
      _streamController.sink.add(_content);
      final response = await _model.generateContent([Content.text(message)]);

      final String? text = response.text;
      if (text == null){
        _content.add(ChatContent.gemini('Unable'));
      }else{
        _content.add(ChatContent.gemini(text));
      }
    } catch (e) {
      _content.add(ChatContent.gemini('Unable'));
    }
    _streamController.sink.add(_content);
  }
}

enum Sender {user, gemini}
 class ChatContent{
    final Sender sender;
    final String message;

    ChatContent.user (this.message) : sender = Sender.user;
    ChatContent.gemini (this.message) : sender = Sender.gemini;
}
