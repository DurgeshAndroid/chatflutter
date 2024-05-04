import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/model/message.dart';

class ChatService extends ChangeNotifier {
  // instance of Auth..
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Instance of firestore..
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //Send Message
  Future<void> sendMessage(String receiverId, String message) async {
    // Get current user details...
    final String? currentUserID = _firebaseAuth.currentUser?.uid.toString();
    final String? currentEmailId = _firebaseAuth.currentUser?.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //Create a message..
    Message newMessage = Message(
        senderId: currentUserID!,
        senderEmail: currentEmailId!,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

    //construct char room with room id from current user id and receiver id(sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverId];
    ids.sort(); //Sort the ids(this ensure the chat room is always the same  for any pair of people)
    String chatRoomId = ids.join("-");

    //add messasge to database...
    await _firebaseFirestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());
  }

  // Get Message
  Stream<QuerySnapshot> getMessages(
      String receiverUserId, String currentUserID) {
    //construct char room with room id from current user id and receiver id(sorted to ensure uniqueness) same as Send message..
    List<String> ids = [receiverUserId, currentUserID];
    ids.sort(); //Sort the ids(this ensure the chat room is always the same  for any pair of people)
    String chatRoomId = ids.join("-");

    //fetch messages from database...
    return _firebaseFirestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
