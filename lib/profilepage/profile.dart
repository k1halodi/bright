import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final int _currentIndex = 3; // Changed to final to adhere to linter rule

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildProfileScreenContent(context),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: (index) {
          context.go(GoRouterState.of(context)
              .uri
              .replace(queryParameters: {'tab': '$index'}).toString());
        },
        iconSize: 30,
        activeColor: Colors.black,
        selectedIndex: _currentIndex,
        barItems: [
          BarItem(
            icon: Icons.home,
            title: 'Home',
          ),
          BarItem(
            icon: Icons.report,
            title: 'Report',
          ),
          BarItem(
            icon: Icons.chat,
            title: 'Chat',
          ),
          BarItem(
            icon: Icons.settings,
            title: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildProfileScreenContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.07, // Adjust horizontal padding
            vertical: 75,
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/jj.png'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Khaled',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 50),
              buildButton(
                screenWidth,
                'Account',
                'assets/images/Icon-left.png',
                onPressed: () {
                  Navigator.pushNamed(context, 'myaccount');
                },
              ),
              const SizedBox(height: 18),
              buildButton(
                screenWidth,
                'Company',
                'assets/images/Vector.png',
                onPressed: () {
                  Navigator.pushNamed(context, 'mycompany');
                },
              ),
              const SizedBox(height: 18),
              buildButton(
                screenWidth,
                'Billing & Payment',
                'assets/images/Payment.png',
                onPressed: () {
                  Navigator.pushNamed(context, 'payment');
                },
              ),
              const SizedBox(height: 18),
              buildButton(
                screenWidth,
                'Password & Security',
                'assets/images/Password.png',
                onPressed: () {},
              ),
              const SizedBox(height: 18),
              buildButton(
                screenWidth,
                'Help',
                'assets/images/Help.png',
                onPressed: () {},
              ),
              const SizedBox(height: 18),
              buildButton(
                screenWidth,
                'About Bright',
                'assets/images/About.png',
                onPressed: () {
                  Navigator.pushNamed(context, 'about');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(double screenWidth, String text, String imagePath,
      {required VoidCallback onPressed}) {
    return SizedBox(
      width: screenWidth * 0.9, // Adjust button width
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white, // Set background color here
          elevation: 0.5, // Remove shadow
          shadowColor: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(image: AssetImage(imagePath)),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black, // Set text color to black
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(
              Icons.navigate_next_rounded,
              size: 35,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
