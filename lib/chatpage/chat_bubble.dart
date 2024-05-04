import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  String message;
  bool isCurrentUser;
  ChatBubble({super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.red,
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
