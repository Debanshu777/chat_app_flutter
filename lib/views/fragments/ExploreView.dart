import 'package:chat_app_flutter/widgets/widget.dart';
import 'package:flutter/material.dart';

class ExploreView extends StatefulWidget {
  @override
  _ExploreViewState createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context,
          isAppTitle: false, strTitle: "Explore", disappearBackButton: false),
      backgroundColor: Colors.green,
    );
  }
}
