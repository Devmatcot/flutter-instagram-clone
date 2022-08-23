import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String username;
  final String description;
  final String postId;
  final String photoUrl;
  final DateTime dataPublish;
  final like;
  final String proImage;

  const PostModel(
      {required this.id,
      required this.username,
      required this.description,
      required this.postId,
      required this.photoUrl,
      required this.dataPublish,
      required this.proImage,
      required this.like});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'description': description,
      'postId': postId,
      'photoUrl': photoUrl,
      'dataPublish': dataPublish,
      'proImage': proImage,
      'like': like
    };
  }

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return PostModel(
        id: snapshot['id'],
        username: snapshot['username'],
        description: snapshot['description'],
        postId: snapshot['postId'],
        photoUrl: snapshot['photoUrl'],
        dataPublish: snapshot['dataPublish'],
        proImage: snapshot['proImage'],
        like: snapshot['like'],

        );
  }
}
