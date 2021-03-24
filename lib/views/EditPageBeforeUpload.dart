import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class EditPageBeforeUpload extends StatelessWidget {
  Future<File> setFile;
  File fileUpload;
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  EditPageBeforeUpload({Key key, @required this.fileUpload}) : super(key: key);

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

  removeImage() {
    fileUpload = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "New Post",
          style: TextStyle(
              fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
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
                    fileUpload,
                    fit: BoxFit.cover,
                  ))),
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
    );
  }
}
