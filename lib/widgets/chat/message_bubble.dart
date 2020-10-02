import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String img;
  final String imageUrl;
  final bool isMe;
  final Key key;

  MessageBubble(this.message, this.username, this.img, this.imageUrl, this.isMe,
      {this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(overflow: Overflow.visible, children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            width: 140,
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Text(
                  username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.black),
                ),
                if (img != '') Image.network(img),
              ],
            ),
          ),
          Positioned(
            top: -5,
            right: !isMe ? 2 : null,
            left: isMe ? 2 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                imageUrl,
              ),
              radius: 20,
            ),
          ),
        ]),
      ],
    );
  }
}
