import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/provider.dart';
import 'package:instagram_clone/utilis/color.dart';
import 'package:instagram_clone/widget/comment_card.dart';
import 'package:provider/provider.dart';

import '../resource/firestrore_method.dart';

class CommentScreen extends StatefulWidget {
  final postId;
  CommentScreen({required this.postId});
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  FirebaseFirestore cloudStore = FirebaseFirestore.instance;
  @override
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: cloudStore
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('date', descending: false)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No comment yet, be the first to comment',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final snap = snapshot.data!.docs[index].data();
                      // print(snap);
                      return CommentCard(snap: snap);
                    });
              }),
            ),
          ),
          // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          //   stream: cloudStore
          //       .collection('post')
          //       .doc(widget.postId)
          //       .collection('comments')
          //       .snapshots(),
          //   builder: ((context, snapshot) {
          //      if (snapshot.connectionState == ConnectionState.waiting) {
          //     return Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   }
          //     return ListView.builder(
          //       itemCount: snapshot.data!.docs.length,
          //       itemBuilder: (context, index) {
          //       final snap = snapshot.data!.docs[index].data();
          //       return CommentCard(snap: snap);
          //     });
          //   }),
          // ), // CommentCard(snap: ),

          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
                // color: Colors.blueAccent,
                height: kToolbarHeight,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.only(right: 16, left: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userData.photoUrl),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        // isCollapsed: true,
                        contentPadding: EdgeInsets.only(left: 8, right: 8),
                        hintText: 'Comment as ${userData.username}',
                        border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(70)),
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                    )),
                    IconButton(
                        onPressed: () async {
                          await FireStoreMethod()
                              .comment(widget.postId, commentController.text,
                                  userData)
                              .then((value) => commentController.clear());
                        },
                        icon: Icon(Icons.send))
                  ],
                )),
          )
        ],
      ),
    );
  }
}
