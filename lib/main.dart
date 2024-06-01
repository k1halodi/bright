import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Company/companyHome.dart';
import 'package:first_app/Company/companyProfile.dart';
import 'package:first_app/Company/CompanyReport/compnayReport.dart';
import 'package:first_app/User/Report/Cdetails.dart';
import 'package:first_app/User/Report/Pdetails.dart';
import 'package:first_app/User/Report/details.dart';
import 'package:first_app/Company/sendRequest.dart';
import 'package:first_app/CompanyAuth/CompanyServices.dart';
import 'package:first_app/CompanyAuth/Clogin.dart';
import 'package:first_app/CompanyAuth/Cregister.dart';
import 'package:first_app/CompanyAuth/companyRegister.dart';
import 'package:first_app/User/Home/SelectServices.dart';
import 'package:first_app/User/Home/aboutcompany.dart';
import 'package:first_app/User/Chat/chat.dart';
import 'package:first_app/User/Home/contact2.dart';
import 'package:first_app/User/Report/report.dart';
import 'package:first_app/UserAuth/emailsend.dart';
import 'package:first_app/UserAuth/forgetpass.dart';
import 'package:first_app/UserAuth/login.dart';
import 'package:first_app/UserAuth/register.dart';
import 'package:first_app/User/Home/home.dart';
import 'package:first_app/User/ProfilePage/about.dart';
import 'package:first_app/User/ProfilePage/myaccount.dart';
import 'package:first_app/User/ProfilePage/mycompany.dart';
import 'package:first_app/User/ProfilePage/payment/add.dart';
import 'package:first_app/User/ProfilePage/payment/payment.dart';
import 'package:first_app/User/ProfilePage/profile.dart';
import 'package:first_app/UserAuth/register2.dart';
import 'package:first_app/Welcome/User&Company.dart';
import 'package:first_app/Welcome/WelcomePage.dart';
import 'package:first_app/Welcome/welcome.dart';
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
    projectId: 'bright-e0f97',
    storageBucket: 'gs://bright-e0f97.appspot.com', // Ensure this is set
  ));

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
      home: const Service(),

      // home: FirebaseAuth.instance.currentUser == null
      //   ? const LoginType()
      // : FutureBuilder(
      //   future: determineHomeScreen(),
      // builder: (context, snapshot) {
      // if (snapshot.connectionState == ConnectionState.waiting) {
      // return const CircularProgressIndicator();
      //} else if (snapshot.hasData) {
      // return snapshot.data as Widget;
      //} else {
      // return const LoginType();
      //}
      //  },
      // ),
      theme: themeData,
      routes: {
        'welcome': (context) => const SplashScreen(),
        'login': (context) => const Login(),
        'register': (context) => const Signup(),
        'forgetpass': (context) => const ForgotPassword(),
        'emailsend': (context) => const SendEmail(),
        'home': (context) => const Home(),
        'register2': (context) => const Register(),
        'profile': (context) => const Profile(),
        'myaccount': (context) => const MyAccount(),
        'mycompany': (context) => const MyCompany(),
        'payment': (context) => const Payment(),
        'add': (context) => const AddPayment(),
        'SelectServices': (context) => const SelectServices(
              companyId: 'company1',
            ),
        'about': (context) => const About(),
        'WelcomePage': (context) => const WelcomeScreen(),
        'aboutcompany': (context) => const AboutCompany(companyId: 'company10'),
        'Contact2': (context) => const C_contact2(
              companyId: 'company1',
            ),
        'chat': (context) => const Chat(),
        'report': (context) => const Report(),
        //company
        'companyRegister': (context) => const CompanyRegister(),
        'CompanyServices': (context) => const Service(),
        'sendrequest': (context) => const SendRequest(),
        'companyHome': (context) => const CompanyHome(),
        'companyProfile': (context) => const CompanyProfile(),
        'companyReport': (context) => const CompanyReport(),
        'details': (context) => const Details(),
        'Pdetails': (context) => const PDetails(),
        'Cdetails': (context) => const CDetails(),
        'User&Company': (context) => const LoginType(),
        'Clogin': (context) => const cLogin(),
        'Cregister': (context) => const CompanySignup(),
      },
    );
  }

  Future<Widget> determineHomeScreen() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      DocumentSnapshot companySnapshot = await FirebaseFirestore.instance
          .collection('companies')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        return const Home();
      } else if (companySnapshot.exists) {
        return const CompanyHome();
      }
    }
    return const LoginType();
  }
}
