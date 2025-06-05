import 'package:cardify_flutter/screens/login_screen.dart';
import 'package:cardify_flutter/screens/signup_screen.dart';
import 'package:cardify_flutter/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cardify_flutter/responsive/responsive_layout_screen.dart';
import 'package:cardify_flutter/responsive/mobile_screen_layout.dart';
import 'package:cardify_flutter/responsive/web_screen_layout.dart';
import 'package:cardify_flutter/screens/login_screen.dart';
import 'package:cardify_flutter/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDB_xsIYVHPYhjitRSi0J63woO2pYW4kps",
        appId: "1:1016059809118:web:78838e8dae6072fa41d3cf",
        messagingSenderId: "1016059809118",
        projectId: "cardify-85387",
        storageBucket: "cardify-85387.firebasestorage.app",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cardify',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
