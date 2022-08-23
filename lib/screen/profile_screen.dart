import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/provider.dart';
import 'package:instagram_clone/resource/firestrore_method.dart';
import 'package:instagram_clone/utilis/color.dart';
import 'package:instagram_clone/utilis/functions.dart';

import 'package:instagram_clone/widget/follow_buttton.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userSnap =
          await _cloudStore.collection('users').doc(widget.userId).get();
      userData = userSnap.data()!;
      setState(() {});
      //get userPost length
      var postNum = await _cloudStore
          .collection('posts')
          .where('id', isEqualTo: widget.userId)
          .get();
      postLen = postNum.docs.length;
      follower = userData['follower'].length;
      following = userData['following'].length;
      isFollowing = userSnap
          .data()!['follower']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showMySnackBar(context, e.toString());
    }
  }

  int postLen = 0;
  int follower = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = true;

  Map<String, dynamic> userData = {};
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).getUser;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(userData['username']),
              centerTitle: false,
              backgroundColor: mobileBackgroundColor,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            backgroundColor: Colors.grey,
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, 'Posts'),
                                    buildStatColumn(follower, 'Followers'),
                                    buildStatColumn(following, 'Following'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    currentUser.id == widget.userId
                                        ? const FollowButton(
                                            backgroundColor: Colors.transparent,
                                            borderColor: Colors.grey,
                                            text: "Edit Profile",
                                            textColor: Colors.white)
                                        : isFollowing
                                            ?  FollowButton(
                                                backgroundColor: Colors.white,
                                                borderColor: Colors.grey,
                                                text: 'Unfollow',
                                                function:(){
                                                  FireStoreMethod().userFollow(currentUser.id, widget.userId);
                                                  setState(() {
                                                    following --;
                                                    isFollowing = false;
                                                  });
                                                },
                                                textColor: Colors.black)
                                            :  FollowButton(
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.blue,
                                                text: 'Follow',
                                                function:(){
                                                  FireStoreMethod().userFollow(currentUser.id, widget.userId);
                                                  setState(() {
                                                    following ++;
                                                    isFollowing = true;
                                                  });
                                                },
                                                textColor: Colors.white),
                                    currentUser.id == widget.userId
                                        ? FollowButton(
                                            backgroundColor: Colors.transparent,
                                            borderColor: Colors.grey,
                                            text: "Log Out",
                                            function: () async{
                                             await FirebaseAuth.instance.signOut();
                                            },
                                            textColor: Colors.white)
                                        : Container()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                      Divider(),
                      FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          future: _cloudStore
                              .collection('posts')
                              .where('id', isEqualTo: widget.userId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return GridView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 4,
                                        mainAxisSpacing: 4,
                                        childAspectRatio: 1),
                                itemBuilder: (_, i) {
                                  final postImages =
                                      snapshot.data!.docs[i]['photoUrl'];
                                  return Container(
                                      color: Colors.grey,
                                      child: Image.network(postImages, fit: BoxFit.cover,));
                                });
                          })
                    ],
                  ),
                )
              ],
            ));
  }

//follower post and following
  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
