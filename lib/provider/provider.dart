import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/resource/auth_method.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
      id: '',
      username: '',
      bio: '',
      email: '',
      photoUrl: '',
      follwer: [],
      following: []);
  UserModel get getUser => _user;

  final AuthMethod _authMethod = AuthMethod();

  Future<void> refreshUser() async {
    try {
      UserModel user = await _authMethod.getUserDetail();
      _user = user;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
