import 'package:chat_app_flutter/widgets/widget.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context,
          isAppTitle: false, strTitle: "Profile", disappearBackButton: false),
      backgroundColor: Colors.red,
    );
  }
}
