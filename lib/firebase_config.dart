import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static FirebaseOptions get firebaseOptions => const FirebaseOptions(
        appId: '1:505654584252:android:7670dba9139194a9c841b9',
        apiKey: 'AIzaSyC5WfcJHJAJ7INUbyyzJtxHuuwMEKjPjUY',
        messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
        projectId: 'authchatting', // 505654584252
        databaseURL: 'YOUR_DATABASE_URL',
        storageBucket: 'YOUR_STORAGE_BUCKET',
      );
}
