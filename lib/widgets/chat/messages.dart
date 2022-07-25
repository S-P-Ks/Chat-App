import 'package:chatapp/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CharMessages extends StatelessWidget {
  const CharMessages({Key? key}) : super(key: key);

  Future<User> getUser() async {
    User? user = await FirebaseAuth.instance.currentUser;
    return user!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // print(chatDocs!.size);
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chats")
                .orderBy("createdAt", descending: true)
                .snapshots(),
            builder: (ctx, chatSnapShot) {
              if (chatSnapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = chatSnapShot.data!.docs
                  as List<QueryDocumentSnapshot<Object?>>;
              final u = futureSnapshot.data as User;

              return ListView.builder(
                reverse: true,
                itemCount: chatSnapShot.data!.size,
                itemBuilder: (ctx, index) {
                  return MessageBubble(
                    message: "${data[index]["text"]}",
                    isMe: data[index]["userId"] == u.uid,
                    username: data[index]["username"],
                    userId: u.uid,
                  );
                },
              );
            });
      },
    );
  }
}
