// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:first_app/User/Home/home.dart';
import 'package:first_app/Welcome/WelcomePage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    // Check login status (replace with your actual logic)
    Future.delayed(const Duration(seconds: 3), () async {
      bool isLoggedIn = await checkLoginStatus(); // Implement this function

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isLoggedIn ? const Home() : const WelcomeScreen(),
        ),
      );
    });
  }

  // Replace with your actual login status check logic
  Future<bool> checkLoginStatus() async {
    // Example: Check if a token exists in shared preferences
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getString('token') != null;
    return false; // Default to not logged in for this example
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          // Fade in the entire logo
          opacity: _animation,
          child: Image.asset(
            'assets/images/WLogo.png', // Make sure this asset path is correct
            width: 300, // Adjust size as needed
            height: 300, // Adjust size as needed
          ),
        ),
      ),
    );
  }
}

// ... (MainAppScreen remains the same)
