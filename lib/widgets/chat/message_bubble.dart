import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String userImage;
  final bool isMe;
  final Key key;

  MessageBubble(
    this.message,
    this.isMe,
    this.username,
    this.userImage, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.green[800] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight: !isMe ? Radius.circular(12) : Radius.circular(0),
                ),
              ),
              width: 200,
              // This width is ignored unless the Container is wrapped in a Row because the Conatiner lies in a Listview
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    username != null ? username : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.white
                          : Theme.of(context).accentTextTheme.headline6.color,
                    ),
                  ),
                  Text(
                    message != null ? message : '',
                    style: TextStyle(
                      color: isMe
                          ? Colors.white
                          : Theme.of(context).accentTextTheme.headline6.color,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: isMe ? null : 180,
          right: !isMe ? null : 180,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
