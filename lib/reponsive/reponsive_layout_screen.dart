import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/provider.dart';
import 'package:instagram_clone/resource/auth_method.dart';

import 'package:instagram_clone/utilis/global_file.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  Widget mobileScreenLayout;
  Widget webScreenLayout;
  ResponsiveLayout({
    Key? key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    super.initState();
    getData();
  }
  void getData() async{
   await Provider.of<UserProvider>(context, listen: false).refreshUser();
  
  }
  AuthMethod auth = AuthMethod();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraint) {
      if (constraint.maxWidth > webScreenSize) {
        //web version
        return widget.webScreenLayout;
      } 
      else {
        //mobile version
        return widget.mobileScreenLayout;
      }
    });
  }
}
