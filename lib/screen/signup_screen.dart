import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resource/auth_method.dart';
import 'package:instagram_clone/screen/login_screen.dart';
import 'package:instagram_clone/utilis/color.dart';
import 'package:instagram_clone/utilis/functions.dart';
import 'package:instagram_clone/widget/input_field.dart';

import '../reponsive/mobile_screen.dart';
import '../reponsive/reponsive_layout_screen.dart';
import '../reponsive/web_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? selectedImage;
  bool isLoading = false;
  bool imageIconTap = false;
  selectImage() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (file == null) {
      return;
    }
    Uint8List image = await file.readAsBytes();
    setState(() {
      selectedImage = image;
      
    });
  }

  void signUp() async {
    try {
      setState(() {
      isLoading = true;
    });
    
    String res = await AuthMethod().signUpUser(
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        file: selectedImage!);
    setState(() {
      isLoading = false;
    });
    if (res != 'Registration is Successful') {
      showMySnackBar(context, res);
      return;
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => ResponsiveLayout(
                mobileScreenLayout: MobileScreen(),
                webScreenLayout: WebScreen(),
              )),
        ),
      );
    }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showMySnackBar(context, 'Provide Data For The Field');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 64,
                ),
                //logo
                SvgPicture.asset(
                  'assets/logo.svg',
                  color: Colors.white,
                  height: 64,
                ),
                const SizedBox(
                  height: 34,
                ),
                Stack(
                  children: [
                    selectedImage != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white24,
                            backgroundImage: MemoryImage(selectedImage!),
                          )
                        : const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white24,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                    Positioned(
                      bottom: -10,
                      right: 5,
                      child: IconButton(
                        onPressed: () => selectImage(),
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                //input field
                //username
                TextInputField(
                    controller: _usernameController,
                    hintText: 'Enter User-name',
                    textType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                //email
                TextInputField(
                    controller: _emailController,
                    hintText: 'Enter your e-mail',
                    textType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                //password
                TextInputField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    isPassword: true,
                    textType: TextInputType.text),
                const SizedBox(
                  height: 24,
                ),
                //bio
                TextInputField(
                    controller: _bioController,
                    hintText: 'Enter your Bio',
                    textType: TextInputType.emailAddress),

                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: signUp,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : const Text('Register'),
                    decoration: ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                // Flexible(
                // child: Container(),
                // flex: 2,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Already have an account'),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: ((context) => LoginScreen()),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: const Text('Login',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                // Flexible(
                //   child: Container(),
                //   flex: 1,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
