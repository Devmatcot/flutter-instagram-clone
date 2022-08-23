import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/reponsive/reponsive_layout_screen.dart';
import 'package:instagram_clone/resource/auth_method.dart';
import 'package:instagram_clone/screen/signup_screen.dart';
import 'package:instagram_clone/utilis/color.dart';
import 'package:instagram_clone/utilis/functions.dart';
import 'package:instagram_clone/widget/input_field.dart';

import '../reponsive/mobile_screen.dart';
import '../reponsive/web_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  void signIn() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResponsiveLayout(
              mobileScreenLayout:  MobileScreen(),
              webScreenLayout: WebScreen()),
        ),
      );
    } else {
      showMySnackBar(context, res);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 64),
                  //logo
                  SvgPicture.asset(
                    'assets/logo.svg',
                    color: Colors.white,
                    height: 64,
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  //input field
                  TextInputField(
                      controller: _emailController,
                      hintText: 'e-mail',
                      textType: TextInputType.emailAddress),
                  const SizedBox(
                    height: 24,
                  ),
                  TextInputField(
                      controller: _passwordController,
                      hintText: 'password',
                      isPassword: true,
                      textType: TextInputType.text),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap:signIn,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : Text(
                              'Log In',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                  // Flexible(child: Container(), flex: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Dont have an account'),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: ((context) => SignUpScreen()),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Sign up',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  // Flexible(child: Container(), flex: 1,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
