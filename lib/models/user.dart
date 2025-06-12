import 'dart:convert';

import 'package:flutter/services.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final Uint8List? photo;
  final List following;
  final List friends;

  const User({
    required this.username,
    required this.uid,
    required this.email,
    this.photo,
    required this.following,
    required this.friends
  });

  Map<String, dynamic> toJson() => {
    'username' :  username,
    'uid' : uid,
    'email' : email,
    'photo': photo != null ? base64Encode(photo!) : null,
    'following' : following,
    'friends' : friends,
  };
}