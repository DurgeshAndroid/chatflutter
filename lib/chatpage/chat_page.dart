import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chat_service.dart';
import 'package:flutter_chat/chatpage/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  String receiveUserEmailID;
  String receiveUserUserID;

  ChatPage(
      {super.key,
      required this.receiveUserEmailID,
      required this.receiveUserUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there something to send..
    if (_messageController.text.isNotEmpty) {
      _chatService.sendMessage(
          widget.receiveUserUserID, _messageController.text);

      // Clear controller after sending message..
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveUserEmailID),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          const SizedBox(
            height: 25.0,
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(
          widget.receiveUserUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading...."));
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildMessageItem(doc))
                .toList(),
          );
        }
      },
    );
  }

  // build message list..
  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    //align the message to right if sender is the current user,Otherwise to the left..
    var alignment = data['senderId'] == _firebaseAuth.currentUser?.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: data['senderId'] == _firebaseAuth.currentUser?.uid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: data['senderId'] == _firebaseAuth.currentUser?.uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail'].toString()),
            const SizedBox(
              height: 5,
            ),
            ChatBubble(
              message: data['message'].toString(),
              isCurrentUser: data['senderId'] == _firebaseAuth.currentUser?.uid
                  ? true
                  : false,
            ),
          ],
        ),
      ),
    );

    // if (_firebaseAuth.currentUser!.email != data['email']) {
    //   return data['email'] != null
    //       ? ListTile(
    //           title: Text(data['email'].toString()),
    //           onTap: () {
    //             Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (context) => ChatPage(
    //                           receiveUserEmailID: data['email'],
    //                           receiveUserUserID: data['uid'],
    //                         )));
    //           },
    //         )
    //       : Container();
    // } else {
    //   return Container();
    // }
  }

  // build input message..
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              labelText: 'Enter your message',
              hintText: 'Message',
              // prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          )),
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_circle_right_outlined,
                size: 40,
              ))
        ],
      ),
    );
  }
}
