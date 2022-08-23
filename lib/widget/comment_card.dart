import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/profile_screen.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ProfileScreen(userId: snap['user']['id']))),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                snap['user']['photoUrl'],
              ),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${snap['user']['username']} :',
                            style: const TextStyle(fontWeight: FontWeight.bold,)
                          ),
                          TextSpan(
                            text: ' ${snap['text']}',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat.yMMMd().format(
                          snap['date'].toDate(),
                        ),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400,),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.favorite,
                size: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
