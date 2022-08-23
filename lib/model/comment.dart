import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/model/user.dart';

class Comment {
  UserModel user;
  DateTime date;
  String text;
  List commentLike;
  Comment({
    required this.user,
    required this.date,
    required this.text,
    required this.commentLike,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user.toJson(),
      'date': date,
      'text': text,
      'commentLike': commentLike,
    };
  }

  



  
}
