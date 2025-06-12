import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';


class ProfilePicture extends StatelessWidget {

  Uint8List? decodeImage(String? base64String) {
  if (base64String == null || base64String.isEmpty) return null;
  try {
    return base64Decode(base64String);
  } catch (e) {
      print('Error decoding image: $e');
    return null;
  }
}
  final String? base64Photo;

  const ProfilePicture({super.key, this.base64Photo});

  @override
  Widget build(BuildContext context) {
    final imageBytes = decodeImage(base64Photo);

    return CircleAvatar(
      radius: 40,
      backgroundImage:
          imageBytes != null ? MemoryImage(imageBytes) : AssetImage('images/default.png') as ImageProvider,
    );
  }
}