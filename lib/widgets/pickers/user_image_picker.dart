import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFunc;

  UserImagePicker(this.imagePickFunc);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      // We don't need the high quality images taken by the camera
      // We'll reduce the size of the images stored in the firebase cloud (nearly 200kB down to 5-10 kB)
      imageQuality: 80,
      maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFunc(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.black38,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add image'),
        ),
      ],
    );
  }
}
