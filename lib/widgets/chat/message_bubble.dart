import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  const MessageBubble(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.username})
      : super(key: key);

  // Future<dynamic> getUser() async {
  //   DocumentSnapshot<Map<String, dynamic>>? user =
  //       await FirebaseFirestore.instance.collection("users").doc(userId).get();
  //   // print(user.data()!["username"]);
  //   return user.data()!["username"];
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(12),
            ),
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMe ? "You" : "",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.surface),
                ),
              ],
            ),
          ),
        ]);
  }
}
