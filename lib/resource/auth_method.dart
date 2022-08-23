import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/model/user.dart';

import 'stroage_method.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static String userUid = _auth.currentUser!.uid;
  Future<UserModel> getUserDetail() async{
    User _currrentUser = _auth.currentUser!;
  final snap =  await _firestore.collection('users').doc(_currrentUser.uid).get();
  
    return UserModel.fromSnap(snap);
  }

  Future<String> signUpUser(
      {required String email,
      required String username,
      required String password,
      required String bio,
      required Uint8List file}) async {
    String res = 'Some error occur';
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          (password.isNotEmpty || password.length > 6) ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // register user to database

        String photoUrl =
            await StorageMethod().uploadToStore('profilePics', file, false);

        UserModel user = UserModel(
            id: cred.user!.uid,
            username: username,
            bio: bio,
            email: email,
            photoUrl: photoUrl,
            follwer: [],
            following: []);

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = 'Registration is Successful';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
 

  //login user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Error Occur';
    try {
      if (email.isNotEmpty || password.isEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        return res;
      }
    } catch (e) {
      return res = e.toString();
    }
    return res;
  }
}
