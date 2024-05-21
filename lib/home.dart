import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/search_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    if (_currentUser == null) {
      // Handle the case where the user is not logged in
      return const Stream.empty(); // Return an empty stream
    }
    return _firestore.collection('users').doc(_currentUser!.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: getUserDataStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          // Handle errors more specifically
                          if (snapshot.error is FirebaseException) {
                            FirebaseException e =
                                snapshot.error as FirebaseException;
                            if (e.code == 'permission-denied') {
                              return const Center(
                                child: Text(
                                    'You do not have permission to view this data.'),
                              );
                            } else if (e.code == 'cancelled') {
                              return const Center(
                                child:
                                    Text('Connection to Firestore timed out.'),
                              );
                            }
                          }
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final userData = snapshot.data!.data();
                        final name = userData?['name'] ?? 'Unknown';
                        final imageUrl = userData?['profile_picture'] ?? '';

                        return _buildUserProfileSection(
                            context, name, imageUrl);
                      },
                    ),
                    SearchBarContainer()
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildUserProfileSection(
      BuildContext context, String name, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8.0), // Adjust padding
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
                imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            child: imageUrl.isEmpty ? const Icon(Icons.person, size: 40) : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $name',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
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
