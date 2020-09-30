import 'package:chat_app_flutter/helper/autenticate.dart';
import 'package:chat_app_flutter/helper/constants.dart';
import 'package:chat_app_flutter/helper/helperfunctions.dart';
import 'package:chat_app_flutter/services/auth.dart';
import 'package:chat_app_flutter/views/search.dart';
import 'package:flutter/material.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  AuthMethods authMethods = new AuthMethods();
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getuserNameSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}
