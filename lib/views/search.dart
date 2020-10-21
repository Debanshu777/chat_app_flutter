import 'package:chat_app_flutter/helper/constants.dart';
import 'package:chat_app_flutter/services/database.dart';
import 'package:chat_app_flutter/views/conversationScreen.dart';
import 'package:chat_app_flutter/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();
  QuerySnapshot searchSnapshort;
  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshort = val;
      });
    });
  }

  createChatroomAndStartConversation(String username) {
    if (username != Constants.myName) {
      String chatroomId = getChatRoomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatroomMap = {
        "users": users,
        "chatroomId": chatroomId,
      };
      databaseMethods.createChatRoom(chatroomId, chatroomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatroomId)));
    } else {
      Fluttertoast.showToast(
        msg: "You can't send message to yourself",
        toastLength: Toast.LENGTH_SHORT,
      );
      print("You can't send message to yourself");
    }
  }

  Widget searchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: mediumTextStyle(),
              ),
              Text(
                userEmail,
                style: mediumTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Message",
                style: simpleTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget searchList() {
    return searchSnapshort != null
        ? ListView.builder(
            itemCount: searchSnapshort.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshort.docs[index].data()["username"],
                userEmail: searchSnapshort.docs[index].data()["email"],
              );
            })
        : Container();
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context,
          isAppTitle: false, strTitle: "Search", disappearBackButton: true),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Username",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff007EF4),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Image.asset("assets/images/search_white.png"),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}
