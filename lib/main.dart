import 'package:chatbox/widgets/chat_buggle_widgets.dart';
import 'package:chatbox/widgets/message_box_widget.dart';
import 'package:chatbox/worker/genai_worker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GenAiWorker _worker = GenAiWorker();
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom(){
    if (_controller.hasClients){
      _controller.jumpTo(_controller.position.maxScrollExtent);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gemini',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
          backgroundColor: Color(0xFF2C3E50),
          centerTitle: true,
          toolbarHeight: 100,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              Expanded(child: StreamBuilder<List<ChatContent>>(
                  stream: _worker.stream,
                  builder: (context, snapshot) {
                    final List<ChatContent> data = snapshot.data ?? [];

                    WidgetsBinding.instance.addPostFrameCallback((_){
                      _scrollToBottom();
                    });

                    return ListView(
                      controller: _controller,
                      children: data.map((e) {
                        final bool isMine = e.sender == Sender.user;
                        return ChatBubble(isMine: e.sender == Sender.user,
                            photoUrl: null,
                            message: e.message);
                      }).toList(),
                    );
                  }
              )),
              MessageBox(onSendMessage: (value) {
                _worker.sendToGemini(value);
              },)
            ],
          ),
        ),
      ),
    );
  }
}




