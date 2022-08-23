import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/add_post_screen.dart';
import 'package:instagram_clone/screen/feed_screen.dart';
import 'package:instagram_clone/screen/profile_screen.dart';
import 'package:instagram_clone/screen/search_screen.dart';

import '../provider/provider.dart';

const webScreenSize = 600;
final currentId = UserProvider().getUser;
final FirebaseAuth current = FirebaseAuth.instance;
String id = currentId.id;
List<Widget> homescreen = [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          Text('post'),
          ProfileScreen(userId:current.currentUser!.uid ),
        ];