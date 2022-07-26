import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String? userId;
  MessageBubble(
      {this.userId,
      required this.message,
      required this.isMe,
      required this.username});

  Future<dynamic> getUserImg() async {
    dynamic user =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    print(user.data()!["username"]);
    String url = await user.data()["imageURL"];
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final userimg = getUserImg();
    return Container(
      key: UniqueKey(),
      margin: const EdgeInsets.all(10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 140,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMe ? "You" : username,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // if (!isMe)
          //   Positioned(
          //     left: 125,
          //     top: -10,
          //     child: CircleAvatar(
          //       radius: 20,
          //       backgroundImage: NetworkImage(userimg),
          //     ),
          //   ),
          // if (isMe)
          //   Positioned(
          //     right: 0,
          //     top: -10,
          //     child: CircleAvatar(
          //       radius: 20,
          //     ),
          //   ),
          FutureBuilder(
              future: getUserImg(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Positioned(
                    right: isMe ? 0 : null,
                    top: -10,
                    left: isMe ? null : 125,
                    child: const CircleAvatar(
                      radius: 20,
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return Positioned(
                    right: isMe ? 0 : null,
                    top: -10,
                    left: isMe ? null : 125,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(snapshot.data as String),
                    ),
                  );
                }
                print("Active");
                return Positioned(
                  right: isMe ? 0 : null,
                  top: -10,
                  left: isMe ? null : 125,
                  child: CircleAvatar(
                    radius: 20,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
