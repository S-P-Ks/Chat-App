import 'package:chatapp/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import '../widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        actions: [
          DropdownButton<DropdownButton>(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            onChanged: (itemIdentifirer) {
              FirebaseAuth.instance.signOut();
            },
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: const [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Logout"),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: Scaffold(
          body: Container(
        child: Column(
          children: [Expanded(child: CharMessages()), NewMessage()],
        ),
      )),
    );
  }
}
