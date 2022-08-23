import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/provider.dart';
import 'package:instagram_clone/reponsive/mobile_screen.dart';
import 'package:instagram_clone/reponsive/reponsive_layout_screen.dart';
import 'package:instagram_clone/reponsive/web_screen.dart';
import 'package:instagram_clone/resource/auth_method.dart';
import 'package:instagram_clone/screen/home_screen.dart';
import 'package:instagram_clone/screen/login_screen.dart';
import 'package:instagram_clone/utilis/color.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screen/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCcFQjsmnbMOOId3hw6iipe84jiAWWBnJM',
          appId: "1:86024798468:web:c4aa758fce858b6361d051",
          messagingSenderId: "86024798468",
          projectId: "instagram-clone-c98d8",
          storageBucket: "instagram-clone-c98d8.appspot.com"),
    );
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme:FlexThemeData.dark(scheme: FlexScheme.custom, colors: FlexSchemeColor.from(primary: Colors.blue),darkIsTrueBlack: true, ),
        home: StreamBuilder(
          stream: _auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ResponsiveLayout(
                    mobileScreenLayout: MobileScreen(),
                    webScreenLayout: WebScreen());
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }
            return LoginScreen();
          },
        ),
        // home: SignUpScreen(),
        
      ),
    );
  }
}
