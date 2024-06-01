import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/User/navbar.dart';
import 'package:first_app/User/Home/search_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:first_app/User/Home/company_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  bool _isSearching = false; // Add a state variable to track search state
  List<Map<String, dynamic>> _searchResults = [];
  final TextEditingController _searchTextController =
      TextEditingController(); // Added TextEditingController

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    if (_currentUser == null) {
      return const Stream.empty();
    }
    return _firestore.collection('users').doc(_currentUser!.uid).snapshots();
  }

  void _handleSearchStateChanged(bool isSearching) {
    setState(() {
      _isSearching = isSearching;
    });
  }

  void _handleSearchResults(List<Map<String, dynamic>> results) {
    setState(() {
      _searchResults = results;
      _isSearching = true; // Start showing search results
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: _isSearching
          ? _buildSearchResultsContent()
          : _buildOriginalHomeContent(),
      initialIndex: 0,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFf5f5f5),
        centerTitle: true,
        elevation: 0.0,
      ),
    );
  }

  Widget _buildOriginalHomeContent() => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: getUserDataStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final userData = snapshot.data!.data();
                          final name = userData?['name'] ?? 'Unknown';
                          final imageUrl = userData?['profilePhotoUrl'] ?? '';

                          return Column(
                            children: [
                              _buildUserProfileSection(
                                context,
                                name,
                                imageUrl,
                              ),
                              SearchBarContainer(
                                searchTextController:
                                    _searchTextController, // Passing the controller
                                onSearchStateChanged: _handleSearchStateChanged,
                                onSearchResults: _handleSearchResults,
                              ),
                              if (!_isSearching)
                                Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      buildCompanyCard(context, 'company1'),
                                      const SizedBox(height: 15),
                                      buildCompanyCard(context, 'company2'),
                                      const SizedBox(height: 15),
                                      buildCompanyCard(context, 'company3'),
                                      const SizedBox(height: 15),
                                      buildCompanyCard(context, 'company4'),
                                      const SizedBox(height: 15),
                                      buildCompanyCard(context, 'company5'),
                                      const SizedBox(height: 15),
                                      buildCompanyCard(context, 'company6'),
                                      const SizedBox(height: 15),
                                      buildCompanyCard(context, 'company7'),
                                      const SizedBox(height: 15),
                                      buildCompanyCard(context, 'company8'),
                                      const SizedBox(height: 15),
                                      buildCompanyCard(context, 'company9'),
                                      const SizedBox(height: 15),
                                      buildCompanyCard(context, 'company10'),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSearchResultsContent() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(21.0),
        child: Column(
          children: [
            SearchBarContainer(
              searchTextController:
                  _searchTextController, // Pass the controller
              onSearchStateChanged: _handleSearchStateChanged,
              onSearchResults: _handleSearchResults,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final company = _searchResults[index];
                  final companyName = company['companyName'] ?? '';
                  final services = company['services'] ?? '';
                  final query = _searchTextController.text.toLowerCase();

                  if (companyName.toLowerCase().contains(query) ||
                      services.toLowerCase().contains(query)) {
                    return buildCompanyCard(context, company['id']);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(
      BuildContext context, String name, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:
                imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            child: imageUrl.isEmpty
                ? const Image(
                    image: AssetImage('assets/images/default_profile.png'))
                : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getGreeting(),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 1),
              Text(
                name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
