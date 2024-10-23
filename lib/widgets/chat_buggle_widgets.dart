import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String? photoUrl;
  final String message;
  final double _iconSize = 24.0;
  const ChatBubble(
      {required this.isMine,
        required this.photoUrl,
        required this.message,
        super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    widgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: photoUrl == null
                  ? const _DefaultPerSonWidgets()
                  : CachedNetworkImage(
                imageUrl: photoUrl!,
                width: _iconSize,
                height: _iconSize,
                fit: BoxFit.fitWidth,
                errorWidget: (context, url,
                    error) => const _DefaultPerSonWidgets(),
                placeholder: (context, url) => const _DefaultPerSonWidgets(),
              )
          ),
        )
    );

    //thêm phần chứa câu trả lời vào trang,xử lý markdown
    widgets.add(Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_iconSize),
        color: isMine ? Colors.black26 : Colors.black87,
      ),
      padding: const EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      child: MarkdownBody(
        data: message,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(color: Colors.white, fontSize: 16),
          h1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          code: TextStyle(
            backgroundColor: Colors.grey.shade200,
            fontFamily: 'monospace',
          ),
        ),
      ),
    ));

    //Chia lượt cho câu hỏi và câu trả lời
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: isMine ? widgets.reversed.toList() : widgets,
      ),
    );
  }

}
class _DefaultPerSonWidgets extends StatelessWidget {
  const _DefaultPerSonWidgets({super.key});

  @override
  Widget build(BuildContext context) => Icon(
    Icons.person,
    color: Colors.black,
    size: 24,
  );
}
