import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cardify_flutter/requests/requests.dart';
import 'package:cardify_flutter/models/user.dart' as models;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          file != null) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        models.User user = models.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          photo: file,
          following: [],
          friends: [],
        );

        // add user to local database
        await createUser(user: user);

        res = 'success';
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // login user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
