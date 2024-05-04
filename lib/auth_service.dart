import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  // instance of Auth..
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Instance of firestore..
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Sign in
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      // add new Document for user in the users collection,if user doesn't exists...
      // Special for Login User.
      _firebaseFirestore.collection("users").doc(userCredential.user?.uid).set(
          {"uid": userCredential.user?.uid, "email": email},
          SetOptions(merge: true));

      return userCredential;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signInAnonymous(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();

      // add new Document for user in the users collection,if user doesn't exists...
      // Special for Login User.
      _firebaseFirestore.collection("users").doc(userCredential.user?.uid).set({
        "uid": userCredential.user?.uid,
        "uName": "userName${userCredential.user?.uid}"
      }, SetOptions(merge: true));

      // create document for user in the users collection,after creating user..
      // Special for SignUp User.
      // _firebaseFirestore.collection("users").doc(userCredential.user?.uid).set({
      //   "uid": userCredential.user?.uid,
      //   "uName": "userName$userCredential.user?.uid"
      // });
      return userCredential;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign out
  Future<void> signout() async {
    return await FirebaseAuth.instance.signOut();
  }
}
