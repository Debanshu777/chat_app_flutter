import 'package:chat_app_flutter/widgets/widget.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context,
          isAppTitle: false,
          strTitle: "Notification",
          disappearBackButton: false),
      backgroundColor: Colors.yellow,
    );
  }
}
