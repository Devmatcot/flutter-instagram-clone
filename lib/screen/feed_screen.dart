import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utilis/color.dart';
import 'package:instagram_clone/widget/post_card.dart';

class FeedScreen extends StatelessWidget {
  FirebaseFirestore cloudStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset('assets/logo.svg',
            color: Colors.white, height: 32),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.mail_outline_rounded))
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: cloudStore.collection('posts').snapshots(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                //there are 2 way to get the itemcount other is snapshot.data!.doc.length
                itemCount: snapshot.requireData.size,
                itemBuilder: (context, index) {
                  final snap = snapshot.data!.docs[index].data();
                  return PostCard(
                    snap: snap,
                  );
                });
          }),
    );
  }
}
