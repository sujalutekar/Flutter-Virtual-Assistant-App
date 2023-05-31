import 'package:flutter/material.dart';
import 'package:jarvis/models/message.dart';

class ChatItem extends StatelessWidget {
  final Message message;
  // bool userMessage;
  // final String aiMessage;

  ChatItem({
    super.key,
    required this.message,
    // required this.userMessage,
    // required this.aiMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: message.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message.content,
                // textAlign: userMessage ? TextAlign.end : TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
