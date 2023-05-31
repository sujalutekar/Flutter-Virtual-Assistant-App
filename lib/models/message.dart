import 'package:flutter/material.dart';

class Message {
  final String content;
  bool isMe;
  final Color color;

  Message({
    required this.content,
    required this.isMe,
    required this.color,
  });
}
