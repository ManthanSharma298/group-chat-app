import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './messageContainer.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatView = snapshot.data.documents;
              return ListView.builder(
                reverse: true,
                itemCount: chatView.length,
                itemBuilder: (context, index) => MessageContainer(
                  message: chatView[index]['text'],
                  isUser: chatView[index]['userId'] == futureSnapshot.data.uid,
                  username: chatView[index]['username'],
                  imageUrl: chatView[index]['imageUrl'],
                  key: ValueKey(chatView[index].documentID),
                ),
              );
            });
      },
    );
  }
}
