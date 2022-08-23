import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String bio;
  final String email;
  final String photoUrl;
  final List? follwer;
  final List? following;
  UserModel({
    required this.id,
    required this.username,
    required this.bio,
    required this.email,
    required this.photoUrl,
    required this.follwer,
    required this.following,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'bio': bio,
      'email': email,
      'photoUrl': photoUrl,
      'follower': follwer,
      'following': following
    };
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data()as Map <String, dynamic>);
    return UserModel(
        id: snapshot['id'],
        username: snapshot['username'],
        bio: snapshot['bio'],
        email: snapshot['email'],
        photoUrl: snapshot['photoUrl'],
        follwer: snapshot['follwer'],
        following: snapshot['following']);
  }
}
