import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      // The future contains info about the current logged in user, which we will user later to check if the new message is by the user
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('createdAt',
                  descending:
                      true) // ordering by timestamp field. descending makes sure the latest message is the bottom-most.
              .snapshots(),
          // snapshot().listen sets up an active listener. The instance is updated everytime the data in the firestore changes.

          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data.documents;
            return ListView.builder(
              reverse:
                  true, // To make it list(verb) elements from bottom to top.
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                chatDocs[index]['text'],
                chatDocs[index]['userId'] == futureSnapshot.data.uid,
                // Is the logged in user sending the message?

                chatDocs[index]['username'],
                chatDocs[index]['userImage'],
                key: ValueKey(chatDocs[index].documentID),
              ), 
            );
          },
        );
      },
    );
  }
}

// Technically, using FutureBuilder inside the StreamBuilder i.e only where it is required would also work
// But creating new Futures every time the Stream updates... Not efficient.
// The FutureBuilder only carries info about the logged in user, which is not going to change everytime a new message comes in.
