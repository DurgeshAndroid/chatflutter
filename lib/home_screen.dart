import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chatpage/chat_page.dart';
import 'package:flutter_chat/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController username = TextEditingController(text: "");

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _getFCMToken();
  }

  Future<void> _getFCMToken() async {
    await _firebaseMessaging.getToken().then((token) {
      if (kDebugMode) {
        print('FCM_Token: $token');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          //signout button.
          IconButton(onPressed: signout, icon: const Icon(Icons.logout))
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       TextField(
      //         controller: username,
      //         decoration: InputDecoration(
      //           labelText: 'Enter your username',
      //           hintText: 'Username',
      //           prefixIcon: const Icon(Icons.person),
      //           border: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(10.0),
      //             borderSide: const BorderSide(color: Colors.grey),
      //           ),
      //           focusedBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(10.0),
      //             borderSide: const BorderSide(color: Colors.blue),
      //           ),
      //           errorBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(10.0),
      //             borderSide: const BorderSide(color: Colors.red),
      //           ),
      //           enabledBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(10.0),
      //             borderSide: const BorderSide(color: Colors.grey),
      //           ),
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 10,
      //       ),
      //       TextField(
      //         controller: username,
      //         decoration: InputDecoration(
      //           labelText: 'Enter password',
      //           hintText: 'Password',
      //           prefixIcon: const Icon(Icons.lock),
      //           border: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(10.0),
      //             borderSide: const BorderSide(color: Colors.grey),
      //           ),
      //           focusedBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(10.0),
      //             borderSide: const BorderSide(color: Colors.blue),
      //           ),
      //           errorBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(10.0),
      //             borderSide: const BorderSide(color: Colors.red),
      //           ),
      //           enabledBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(10.0),
      //             borderSide: const BorderSide(color: Colors.grey),
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      body: _buildUserList(context),
      // bottomNavigationBar: _signout(),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading...."));
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildListItem(doc))
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    if (_firebaseAuth.currentUser!.email != data['email']) {
      return data['email'] != null
          ? ListTile(
              title: Text(data['email'].toString()),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatPage(
                              receiveUserEmailID: data['email'],
                              receiveUserUserID: data['uid'],
                            )));
              },
            )
          : Container();
    } else {
      return Container();
    }
  }

  void signout() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signout();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
