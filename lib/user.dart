import 'package:firebase_auth/firebase_auth.dart';

class User {
  String id;
  String email;

  User.fromFirebase(FirebaseUser user) {
    id = user.uid;
    email = user.email;
  }
}
