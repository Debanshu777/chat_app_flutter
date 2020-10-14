import 'package:chat_app_flutter/helper/autenticate.dart';
import 'package:chat_app_flutter/services/auth.dart';
import 'package:flutter/material.dart';

import '../chatRooms.dart';

class FeedView extends StatefulWidget {
  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  AuthMethods authMethods = new AuthMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.jpg",
          height: 50,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatRooms()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset("assets/images/send.png"),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blue,
    );
  }
}
