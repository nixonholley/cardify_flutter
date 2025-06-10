import 'dart:convert';

import 'package:cardify_flutter/resources/storage_methods.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:cardify_flutter/requests/requests.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || file!=null){
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        print(cred.user!.uid);

        //String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        // add user to firebase database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username' : username,
          'uid': cred.user!.uid,
          'email' : email,
          'friends' : [],
          'following' : [],
          //'photoUrl' : photoUrl,
        });

        // add user to local database
        await createUser(email: email, uid: cred.user!.uid, username: username, file: file);

        res = 'success';
      }
    }
    catch(err){
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
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }
    }
    catch(err){
      res = err.toString();
    }
    return res; 
  }
}