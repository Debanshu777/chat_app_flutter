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
                image_url: searchSnapshort.docs[index].data()["url"],
              );
            })
        : Container();
  }

  Widget searchTile({String userName, String userEmail, String image_url}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundImage: AssetImage("assets/images/profile_default.png"),
            backgroundColor: Colors.transparent,
            child: CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(image_url),
              backgroundColor: Colors.transparent,
            ),
          ),
          SizedBox(
            width: 15,
          ),
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
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white54,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            searchTextEditingController.clear();
                          },
                        ),
                        border: InputBorder.none,
                        hintText: "Search Username",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: (searchTextEditingController.text != "" ||
                      searchTextEditingController.text != null)
                  ? initiateSearch()
                  : Container(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: CircularProgressIndicator())
                    : searchList();
              },
            ),
          ],
        ),
      ),
    );
  }
}
