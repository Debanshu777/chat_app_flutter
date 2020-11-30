import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AlterUploadView extends StatefulWidget {
  @override
  _AlterUploadViewState createState() => _AlterUploadViewState();
}

class _AlterUploadViewState extends State<AlterUploadView> {
  File file;

  captureImagesWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "New Post",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Open Camera",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: captureImagesWithCamera(),
              ),
              SimpleDialogOption(
                child: Text(
                  "Open Gallery",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: pickImageFromGallery(),
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  displayScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add_a_photo_outlined,
            color: Colors.grey,
            size: 200.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0)),
              child: Text(
                "Upload Image",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              color: Colors.green,
              onPressed: () => takeImage(context),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return displayScreen();
  }
}
