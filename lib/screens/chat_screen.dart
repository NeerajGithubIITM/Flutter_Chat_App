import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    // See the 'firebase_messaging' package's docs for these parts
    fbm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg) {
        print(msg);
        return;
      },
      onResume: (msg) {
        print(msg);
        return;
      },
    );
    // For onLaunch and onResume to run in android, add a key value pair in the notification while sending it from the Cloud Messaging of firebase.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo[900],
            Colors.deepPurple[800],
            Colors.pink[400],
            Colors.pink[100],
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('Flutter Chat'),
          actions: <Widget>[
            DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Logout'),
                      ],
                    ),
                  ),
                  value: 'Logout',
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'Logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Messages(),
              ),
              NewMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
