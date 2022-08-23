import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/provider.dart';
import 'package:instagram_clone/resource/auth_method.dart';
import 'package:instagram_clone/utilis/color.dart';
import 'package:instagram_clone/utilis/global_file.dart';
import 'package:provider/provider.dart';

class MobileScreen extends StatefulWidget {
  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late PageController controller;
  AuthMethod testAuth = AuthMethod();
  @override
  void initState() {
    testAuth.getUserDetail();
    controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  int _pageIndex = 0;
  void changepage(int index) {
      controller.jumpToPage(index);
    setState(() {
    });
  }
  void navigateToPage(int page){
    controller.jumpToPage(page);
    setState(() {
      _pageIndex = page;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: homescreen,
        controller: controller,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.black,
        onTap: navigateToPage,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
            Icons.home,
            color: _pageIndex == 0 ? primaryColor : secondaryColor,
          )),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _pageIndex == 1 ? primaryColor : secondaryColor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,
                  color: _pageIndex == 2 ? primaryColor : secondaryColor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite,
                  color: _pageIndex == 3 ? primaryColor : secondaryColor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _pageIndex == 4 ? primaryColor : secondaryColor)),
        ],
      ),
    );
  }
}
