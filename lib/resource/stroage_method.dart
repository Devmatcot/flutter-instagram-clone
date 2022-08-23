
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadToStore(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
  if (isPost) {
    String id = const  Uuid().v1();
   ref = ref.child(id);
  }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot task = await uploadTask;
    String downloadLink = await task.ref.getDownloadURL();
    String link = '$downloadLink.jpg';
    return link;
  }
 
}
