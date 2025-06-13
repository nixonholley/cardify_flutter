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
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.get('APIKEY'),
        appId: dotenv.get('APPID'),
        messagingSenderId: dotenv.get('MESSAGINGSENDERID'),
        projectId: dotenv.get('PROJECTID'),
        storageBucket: dotenv.get('STORAGEBUCKET'),
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
