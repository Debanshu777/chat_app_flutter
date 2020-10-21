import 'package:chat_app_flutter/services/database.dart';
import 'package:chat_app_flutter/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExploreView extends StatefulWidget {
  @override
  _ExploreViewState createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
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
          // Container(
          //   decoration: BoxDecoration(
          //       color: Colors.blue, borderRadius: BorderRadius.circular(30)),
          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          //   child: Text(
          //     "Message",
          //     style: simpleTextStyle(),
          //   ),
          // )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context,
          isAppTitle: false, strTitle: "Explore", disappearBackButton: false),
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
