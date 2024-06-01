// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/User/navbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Make sure to import the BaseScaffold file

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BaseScaffold(
      initialIndex: 3, // Assuming Profile is the 4th tab
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userData = snapshot.data!.data();
            final name = userData?['name'] ?? 'Unknown';
            final imageUrl = userData?['profilePhotoUrl'] ?? '';

            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: 21,
                    vertical: MediaQuery.of(context).padding.top),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null,
                          child: imageUrl.isEmpty
                              ? const Image(
                                  image: AssetImage(
                                      'assets/images/default_profile.png'))
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getGreeting(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
                    const SizedBox(height: 18),
                    buildButton(
                      screenWidth,
                      'Sign Out',
                      'assets/images/ic_round-logout.png',
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushNamed(context, 'welcome');
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildButton(double screenWidth, String text, String imagePath,
      {required VoidCallback onPressed}) {
    return SizedBox(
      width: screenWidth * 0.9,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          shadowColor: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(image: AssetImage(imagePath)),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
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

  String getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }
}
