import 'dart:io';

import 'package:chat_app_flutter/modal/user.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AlterUploadView extends StatefulWidget {
  // final UserProfile gCurrentUser;
  // AlterUploadView({this.gCurrentUser});
  @override
  _AlterUploadViewState createState() => _AlterUploadViewState();
}

class _AlterUploadViewState extends State<AlterUploadView> {
  File file;
  bool _permissionStatus = false;
  final picker = ImagePicker();
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  Future captureImagesWithCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      if (pickedFile != null) {
        this.file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future pickImageFromGallery() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (pickedFile != null) {
        this.file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget displayScreen() {
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
                onPressed: () {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          backgroundColor: Colors.black,
                          title: Text(
                            "New Post",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          children: <Widget>[
                            SimpleDialogOption(
                              child: Text(
                                "Open Camera",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => captureImagesWithCamera(),
                            ),
                            SimpleDialogOption(
                              child: Text(
                                "Open Gallery",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => pickImageFromGallery(),
                            ),
                            SimpleDialogOption(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                }),
          )
        ],
      ),
    );
  }

  removeImage() {
    setState(() {
      file = null;
    });
  }

  getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlacemark = placemarks[0];
    String completeAddress =
        '${mPlacemark.subThoroughfare} ${mPlacemark.thoroughfare},${mPlacemark.subLocality} ${mPlacemark.locality},${mPlacemark.subAdministrativeArea} ${mPlacemark.administrativeArea},${mPlacemark.postalCode} ${mPlacemark.country}';
    String specificAddress = '${mPlacemark.locality}, ${mPlacemark.country}';
    locationTextEditingController.text = specificAddress;
  }

  void listenForPermissionStatus() async {
    final status = await Permission.storage.request().isGranted;
    // setState() triggers build again
    setState(() => _permissionStatus = true);
  }

  displayUploadImageFromScreen() {
    return _permissionStatus
        ? Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                "New Post",
                style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => print("Tapped"),
                  child: Text(
                    "Share",
                    style: TextStyle(
                        color: Colors.lightGreenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: removeImage(),
              ),
            ),
            body: ListView(
              children: [
                Container(
                  height: 230.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        child: Image.file(
                          file,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                ListTile(
                  leading: CircleAvatar(
                      // backgroundImage: CachedNetworkImageProvider(
                      //   widget.gCurrentUser.url,
                      // ),
                      ),
                  title: Container(
                    width: 250.0,
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: descriptionTextEditingController,
                      decoration: InputDecoration(
                        hintText: "Say something about your image...",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.person_pin_circle,
                    color: Colors.white,
                    size: 36.0,
                  ),
                  title: Container(
                    width: 100.0,
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: locationTextEditingController,
                      decoration: InputDecoration(
                        hintText: "Write location..",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                    width: 220.0,
                    height: 110.0,
                    alignment: Alignment.center,
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0)),
                      color: Colors.green,
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Get current location",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => getUserCurrentLocation(),
                    ))
              ],
            ),
          )
        : Container(
            child: Text("Loading..."),
          );
  }

  @override
  Widget build(BuildContext context) {
    listenForPermissionStatus();
    return file != null ? displayUploadImageFromScreen() : displayScreen();
  }
}
