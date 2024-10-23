import 'package:flutter/material.dart';
class MessageBox extends StatefulWidget {
  final ValueChanged<String> onSendMessage;
  const MessageBox({required this.onSendMessage,super.key});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final TextEditingController _controller = TextEditingController();
  @override

  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) => Padding(padding: EdgeInsets.all(8.0),child: TextField(
      controller: _controller,
      maxLines: 1,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(
          color: Colors.black38,
          width: 1.0,
        )
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
      suffix: IconButton(
        onPressed: (){
           widget.onSendMessage(_controller.text);
           _controller.text = '';
        },
        icon: Icon(Icons.send),
      )
    ),
    onSubmitted: (value){
        widget.onSendMessage(value);
        _controller.text = '';
    },
  ),);
}
