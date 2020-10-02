import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MessageImagePicker extends StatefulWidget {
  final Function(File pickedImage) pickImageFn;

  MessageImagePicker(this.pickImageFn);

  @override
  _MessageImagePickerState createState() => _MessageImagePickerState();
}

class _MessageImagePickerState extends State<MessageImagePicker> {
  File _pickedImage;

  void clearImg() {
    setState(() {
      _pickedImage = null;
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 80, maxWidth: 150);

    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.pickImageFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
