// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Auth/emailsend.dart';
import 'package:first_app/Auth/forgetpass.dart';
import 'package:first_app/Auth/login.dart';
import 'package:first_app/Auth/register.dart';
import 'package:first_app/home.dart';
import 'package:first_app/profilepage/about.dart';
import 'package:first_app/profilepage/myaccount.dart';
import 'package:first_app/profilepage/mycompany.dart';
import 'package:first_app/profilepage/payment/add.dart';
import 'package:first_app/profilepage/payment/payment.dart';
import 'package:first_app/profilepage/profile.dart';
import 'package:first_app/Auth/register2.dart';
//import 'package:first_app/Auth/verifyemail.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDe_sTw4GmzrRrD-QguYGMS9J8VGn-2QWQ',
          appId: '1:433699137442:android:0f2c32cf1fa7982540b4fb',
          messagingSenderId: '433699137442',
          projectId: 'bright-e0f97'));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var themeData = ThemeData(
      textTheme: GoogleFonts.outfitTextTheme(),
    );
    return MaterialApp(
      home: //Home(),
          FirebaseAuth.instance.currentUser == null
              ? const Login()
              : const Home(),
      theme: themeData,
      routes: {
        'login': (context) => const Login(),
        'register': (context) => const Signup(),
//        'verifyemail': (context) => const VerifyEmail(),
        'forgetpass': (context) => const ForgotPassword(),
        'emailsend': (context) => const SendEmail(),
        'home': (context) => const Home(),
        'register2': (context) => const Register(),
        'profile': (context) => const Profile(),
        'myaccount': (context) => const MyAccount(),
        'mycompany': (context) => const MyCompany(),
        'payment': (context) => const Payment(),
        'add': (context) => const AddPayment(),
        'about': (context) => const About(),
      },
    );
  }
}
