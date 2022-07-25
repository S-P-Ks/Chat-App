import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewMessage extends StatefulWidget {
  NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = "";
  var _token = "";
  final _controller = TextEditingController();
  dynamic u;

  Future<void> getUser() async {
    User? user = await FirebaseAuth.instance.currentUser;
    u = user!;
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        _token = value!;
      });
    });
  }

  Future<void> saveToken(String uuid) async {
    await getUser();
    await FirebaseFirestore.instance
        .collection("UserToken")
        .doc(uuid)
        .update({"token": _token});
  }

  Future<void> sendPushMessage(String token) async {
    print("Sending message");
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(
            "eFAe_tubRfGiWtss2RYWX4:APA91bG1ChdEML7H8gl3jwN2g2ZMGdGEBFNo7NsUNuuP-Sy3j9iueEyuiUe5ymjR8sJo8fwCcTKGjaQfa3kPqattpe9sB2obfy17v8kb36jvkSbKsmsMJZCOGRbheeig-jDd0mNnHp6V"),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  int _messageCount = 0;

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String constructFCMPayload(String? token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final uid = user!.uid;

    u = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    final username =
        u.data()["username"] != null ? u.data()["username"] : "Anonymous";
    final userImg = u.data()["username"];
    print(userImg);
    FirebaseFirestore.instance.collection("chats").add({
      "text": _enteredMessage,
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "username": username,
      "userImage": userImg,
    });

    saveToken(uid);

    setState(() {
      _enteredMessage = "";
    });
    _controller.clear();

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("UserToken")
        .doc(username)
        .get();

    String token = snap["token"];

    sendPushMessage(token);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Send a message"),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Theme.of(context).colorScheme.secondary,
          )
        ],
      ),
    );
  }
}
