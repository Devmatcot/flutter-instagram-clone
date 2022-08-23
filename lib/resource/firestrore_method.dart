import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/model/comment.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/resource/stroage_method.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethod {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

// upload post future function
  Future<String> uploadImage(Uint8List file, String description,
      String username, String id, String proImage) async {
    String res = "some error occurr";
    try {
      String postId = const Uuid().v1();
      String photoUrl =
          await StorageMethod().uploadToStore('posts', file, true);
      PostModel post = PostModel(
          id: id,
          username: username,
          description: description,
          postId: postId,
          photoUrl: photoUrl,
          dataPublish: DateTime.now(),
          proImage: proImage,
          like: []);
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      return res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likeStore(String userId, String postId, List like) async {
    try {
      if (like.contains(userId)) {
        await _firestore.collection('posts').doc(postId).update({
          'like': FieldValue.arrayRemove([userId])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'like': FieldValue.arrayUnion([userId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //comments
  Future<void> comment(String posId, String text, UserModel user) async {
    try {
      if (text.isEmpty) {
        return;
      }
      Comment commentData = await Comment(
          user: user, date: DateTime.now(), text: text, commentLike: []);
      await _firestore
          .collection('posts')
          .doc(posId)
          .collection('comments')
          .doc()
          .set(commentData.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  //follow and unFollow function
  Future<void> userFollow(String userId, String followId) async {
   try {
      DocumentSnapshot snap =
        await _firestore.collection('users').doc(userId).get();
    List following = (snap.data()! as dynamic)['following'];
    if (following.contains(followId)) {
      await _firestore.collection('users').doc(userId).update({
        'follower': FieldValue.arrayRemove([userId])
      });
      await _firestore.collection('users').doc(userId).update({
        'following': FieldValue.arrayRemove([followId])
      });
    }
    // else condition
     else {
      await _firestore.collection('users').doc(followId).update({
        'follower': FieldValue.arrayUnion([userId])
      });

      await _firestore.collection('users').doc(userId).update({
        'following': FieldValue.arrayUnion([followId])
      });
    }
   } catch (e) {
     print(e);
   }
  }
}
