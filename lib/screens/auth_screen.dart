import 'dart:io';
import 'dart:math';

import 'package:chatapp/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;
  void _submitAuthForm(String email, String password, String usern,
      File? userImage, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;

    var user;

    try {
      var message = "";
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        // authResult = await _auth.signInWithEmailAndPassword(
        //     email: email, password: password);

        var authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        user = authResult.user;
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        user = authResult.user;

        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child(authResult.user!.uid + ".jpg");

        await ref
            .putFile(userImage!)
            .whenComplete(() => print("Image uploaded successfully."));

        final imgurl = await ref.getDownloadURL();

        FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set({"email": email, "username": usern, "imageURL": imgurl});
      }
      setState(() {
        isLoading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        isLoading = false;
      });
      var message = "An error occured pls check the credential.";

      if (e.message != null) {
        message = e.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print(e);

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(child: AuthForm(_submitAuthForm, isLoading)),
    );
  }
}
