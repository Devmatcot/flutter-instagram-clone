import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/provider.dart';
import 'package:instagram_clone/resource/firestrore_method.dart';
import 'package:instagram_clone/utilis/functions.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/utilis/color.dart';
import 'package:provider/provider.dart';

import '../screen/comment_screen.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    super.initState();
    getComment();
  }

  bool isLikeAnimating = false;
  int commentLen = 0;
  getComment() async {
    try {
      final comment = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = comment.docs.length;
    } catch (e) {
      showMySnackBar(context, 'error occur');
    }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['proImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      widget.snap['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: const Text('More'),
                              children: ['Delete', 'Share', 'Report']
                                  .map(
                                    (e) => InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 10),
                                          child: Text(e),
                                        ),
                                        onTap: () {
                                          // remove the dialog box
                                          Navigator.of(context).pop();
                                        }),
                                  )
                                  .toList(),
                            );
                          });
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child:
                      Image.network(widget.snap['photoUrl'], fit: BoxFit.cover),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: Icon(Icons.favorite, size: 100, color: Colors.red),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () async {
                      final data = widget.snap;
                      await FireStoreMethod()
                          .likeStore(userData.id, data['postId'], data['like']);
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.snap['like'].contains(userData.id),
                  smallLike: true,
                  onEnd: () async {},
                  child: IconButton(
                      onPressed: () async {
                        final likeData = widget.snap;
                        await FireStoreMethod().likeStore(
                            userData.id, likeData['postId'], likeData['like']);
                      },
                      icon: widget.snap['like'].contains(userData.id)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border)),
                ),
                ActionButton(
                    icon: Icons.comment,
                    onTap: () {
                      print(widget.snap['postId']);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => CommentScreen(
                                  postId: widget.snap['postId'],
                                )),
                      );
                    }),
                ActionButton(icon: Icons.send_rounded, onTap: () {}),
                Spacer(),
                ActionButton(
                    icon: Icons.bookmark_border_outlined, onTap: () {}),
              ],
            ),
          ),
          Text('${widget.snap['like'].length} likes',
              style: Theme.of(context).textTheme.bodyText1),
          const SizedBox(
            height: 8,
          ),
          RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            text: TextSpan(
              children: [
                TextSpan(
                    text: widget.snap['username'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '  ${widget.snap['description']}'),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          InkWell(
              onTap: () {},
              child: Text(
                'view all $commentLen comments',
                style: TextStyle(fontSize: 16, color: secondaryColor),
              )),
          const SizedBox(
            height: 8,
          ),
          Text(
            DateFormat.yMMMEd().format(widget.snap['dataPublish'].toDate()),
            style: TextStyle(color: secondaryColor, fontSize: 12),
          )
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onTap;
  const ActionButton({
    Key? key,
    required this.icon,
    this.color = Colors.white,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => onTap(),
        icon: Icon(
          icon,
          color: color,
        ));
  }
}
