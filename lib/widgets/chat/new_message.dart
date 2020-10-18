// Stateful widget to manage the send button i.e only allow sending if something is typed.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    _controller.clear();
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    // The users collection has documents whose names are the userIds
    // .get() simply gets the data in the specified location, but more importantly it returns a future

    Firestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      // We store a timestamp for each message so that we can order the messages by the 'createdAt' field
      // Timestamp is a class made available by the cloud_firestore import.

      'userId': user.uid,
      // Mapping messages to users.

      'username' : userData['username'],
      // To display on top of each message.

      'userImage' : userData['image_url'],
      // We were already using data from 'users collection. Convenient to use this also.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              controller: _controller,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: 'Send a message..',
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Colors.black26,
                //filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.deepPurple[900],
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
