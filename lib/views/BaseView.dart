import 'package:chat_app_flutter/views/fragments/AlterUploadView.dart';
import 'package:chat_app_flutter/views/fragments/ExploreView.dart';
import 'package:chat_app_flutter/views/fragments/FeedView.dart';
import 'package:chat_app_flutter/views/fragments/ProfileView.dart';

import 'package:flutter/material.dart';

import 'fragments/NotificationView.dart';

class BaseView extends StatefulWidget {
  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  get authMethods => null;

  int _pageIndex = 0;
  PageController _pageController;

  List<Widget> tabPages = [
    FeedView(),
    ExploreView(),
    // UploadView(),
    NotificationView(),
    ProfileView()
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onTabTapped(int index) {
      if (index == 2) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AlterUploadView()));
      }
      this._pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }

    void onPageChanged(int page) {
      setState(() {
        this._pageIndex = page;
      });
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white54,
        backgroundColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Container(
                child: Icon(
                  Icons.add_a_photo_outlined,
                ),
              ),
              label: "Photos",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "Notification",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
              backgroundColor: Colors.black),
        ],
      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
