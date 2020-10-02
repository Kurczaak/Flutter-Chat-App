import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntp/ntp.dart';
import '../pickers/message_image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();
  File _userImageFile;

  void _pickedImage(File image) {
    setState(() {
      _userImageFile = image;
    });
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();

    var url = '';
    DateTime _myTime = await NTP.now();
    if (_userImageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user-images')
          .child(user.uid + 'jpg');
      await ref.putFile(_userImageFile).onComplete;
      url = await ref.getDownloadURL();
    }
    Firestore.instance.collection('chat').add(
      {
        'text': _enteredMessage,
        'image': url,
        'createdAt': _myTime,
        'userId': user.uid,
        'username': userData['username'],
        'userImage': userData['image_url'],
      },
    );

    _controller.clear();
    setState(() {
      _userImageFile = null;
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                  color: Colors.grey,
                  child: _userImageFile != null
                      ? Image.file(_userImageFile)
                      : null),
              MessageImagePicker(_pickedImage),
            ],
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
