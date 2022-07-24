import 'package:chatapp/screens/auth_screen.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.pink,
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.blue,
            onPrimary: Colors.yellow,
            secondary: Colors.black,
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.redAccent,
            background: Colors.pink,
            onBackground: Colors.pinkAccent,
            surface: Colors.amber,
            onSurface: Colors.white,
          )),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
          ;
        },
      ),
    );
  }
}
