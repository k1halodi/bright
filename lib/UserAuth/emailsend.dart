// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class SendEmail extends StatelessWidget {
  const SendEmail({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 21), // Added padding here
          child: SizedBox(
            height: MediaQuery.of(context)
                .size
                .height, // Ensure the container takes the entire height of the screen
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Space the children equally
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      const SizedBox(
                          height: 100), // Placeholder for top padding
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.5,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x19000000),
                                    blurRadius: 10,
                                    offset: Offset(4, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 40),
                                  Image.asset(
                                    "assets/images/Flat.png",
                                    height: 120,
                                  ),
                                  const SizedBox(height: 36),
                                  const Text(
                                    'We have sent a password recovery instructions to your email',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF1F1F1F),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Did not receive the email? Check your spam filter or resend.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF8F8F8F),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 70), // Add 50 pixels of space
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 10,
                        offset: Offset(4, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 0, 0, 0), // Change background color to white
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color.fromARGB(
                              255, 255, 255, 255), // Change text color to black
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
