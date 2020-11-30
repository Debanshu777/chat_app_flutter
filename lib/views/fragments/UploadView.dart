import 'dart:collection';
import 'dart:io';

import 'package:chat_app_flutter/views/BaseView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_gallery/image_gallery.dart';

class UploadView extends StatefulWidget {
  @override
  _UploadViewState createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  ScrollController _scrollController = new ScrollController();
  Map<dynamic, dynamic> allImageTemp = new HashMap();
  List allImage = new List();
  List allNameList = new List();
  List pageImage = new List();
  String url;
  int end = 10, start = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadImageList();
  }

  Future<void> loadImageList() async {
    allImageTemp = await FlutterGallaryPlugin.getAllImages;
    setState(() {
      url = (allImageTemp['URIList'] as List)[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BaseView()));
          },
        ),
        automaticallyImplyLeading: true,
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Next",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 17,
              ),
            ),
          )
        ],
        title: Text(
          "Gallery",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Image.file(
                File(url.toString()),
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: StaggeredGridView.countBuilder(
                controller: _scrollController,
                crossAxisCount: 3,
                itemCount: (allImageTemp['URIList'] as List).length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      url = (allImageTemp['URIList'] as List)[index];
                    });
                  },
                  child: Image.file(
                    File((allImageTemp['URIList'] as List)[index].toString()),
                    fit: BoxFit.cover,
                  ),
                ),
                staggeredTileBuilder: (index) => StaggeredTile.count(
                    (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              height: MediaQuery.of(context).size.height / 2,
            ),
          ],
        ),
      ),
    );
  }
}
