import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

Future<String> createUser({
  required String email,
  required String uid,
  required String username,
  required Uint8List file,
}) async {
  final url = Uri.parse('http://127.0.0.1:8080/users');
  final base64image = base64Encode(file);

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "Uid": uid,
      "Username": username,
      "Email": email,
      "Picture": base64image,
    }),
  );
  String res = "some error occured";
  if (response.statusCode == 200) {
    res = "success";
  } else {
    res = "Backend error: ${response.statusCode} - ${response.body}";
  }
  return res;
}

Future<void> updateUser(String uid) async {
  final url = Uri.parse('http://10.0.0.180:8080/users/$uid');

  final base64Image = base64Encode(Uint8List.fromList([/* your new bytes */]));

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "Username": "updatedUser",
      "Email": "updated@example.com",
      "Picture": base64Image,
    }),
  );

  if (response.statusCode == 200) {
    print("User updated");
  } else {
    print("Update failed: ${response.statusCode}");
  }
}


