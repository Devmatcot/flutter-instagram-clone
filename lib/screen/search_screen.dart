import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screen/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;
  bool isShowUser = false;
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: searchController,
          onFieldSubmitted: (text) {
            setState(() {
              isShowUser = true;
            });
          },
          decoration: InputDecoration(label: Text('Search for')),
        ),
      ),
      body: isShowUser
          ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: _cloudStore
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (_, i) {
                        final dataCom = snapshot.data!.docs[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(dataCom['photoUrl']),
                          ),
                          title: Text(dataCom['username']),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProfileScreen(userId: dataCom['id']),
                            ),
                          ),
                        );
                      });
                }
                // return ;
              })
          : FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: _cloudStore.collection('posts').get(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                // return ;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 18,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Reels',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      StaggeredGrid.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 10,
                        children:
                            List.generate(snap.data!.docs.length, (index) {
                          final photoLink = snap.data!.docs[index];
                          return StaggeredGridTile.count(
                            crossAxisCellCount: (index % 7 == 0) ? 2 : 1,
                            mainAxisCellCount: (index % 7 == 0) ? 2 : 1,
                            child: Image.network(photoLink['photoUrl'],
                                fit: BoxFit.cover),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}
