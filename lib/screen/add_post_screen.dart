import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/provider/provider.dart';
import 'package:instagram_clone/resource/firestrore_method.dart';
import 'package:provider/provider.dart';

import '../utilis/color.dart';
import '../utilis/functions.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController _descriptionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;
  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _postImage(String uid, String username, proImage) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await FireStoreMethod().uploadImage(
          _file!, _descriptionController.text, username, uid, proImage);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showMySnackBar(context, 'Uploaded Successfully');
        clearImage ();
      } else {
        setState(() {
          _isLoading = false;
        });
        showMySnackBar(context, res);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showMySnackBar(context, error.toString());
    }
  }
  void clearImage (){
    _file= null;
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserData = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Scaffold(
            body: Center(
              child: TextButton.icon(
                  onPressed: () => _selectImage(context),
                  icon: Icon(Icons.arrow_circle_up_sharp),
                  label: Text('Upload Image')),
            ),
          )
        : Scaffold(
            appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: clearImage,
                ),
                actions: [
                  TextButton(
                      onPressed: () => _postImage(
                          UserData.id, UserData.username, UserData.photoUrl),
                      child: Text('Post'))
                ],
                title: const Text(
                  'Post to',
                ),
                centerTitle: false),
            body: Column(
              children: [
                _isLoading
                    ? LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(UserData.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ));
  }
}
