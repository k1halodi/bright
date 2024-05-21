import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchBarContainer extends StatefulWidget {
  @override
  _SearchBarContainerState createState() => _SearchBarContainerState();
}

class _SearchBarContainerState extends State<SearchBarContainer> {
  final TextEditingController _searchTextController = TextEditingController();
  List<Map<String, dynamic>> _filteredCompanies = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true); // Start loading

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(
              'marketing_companies') // Replace with your collection name
          .where('name', isGreaterThanOrEqualTo: query) // Basic filtering
          .get();

      setState(() {
        _filteredCompanies = snapshot.docs.map((doc) => doc.data()).toList();
        _isLoading = false; // Stop loading
      });
    } catch (e) {
      print('Error searching: $e');
      setState(() => _isLoading = false);

      // Handle search error (show a snackbar, dialog, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during search.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Full width on all devices
      height: 81,
      padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width:
                MediaQuery.of(context).size.width, // Full width on all devices
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Align search and icon
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchTextController,
                    onChanged: (query) => _performSearch(query),
                    decoration: InputDecoration(
                      hintText: 'Search Marketing Companies...',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _performSearch(_searchTextController.text),
                  child: const Icon(Icons.search, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Display search results or loading indicator
          if (_isLoading)
            const CircularProgressIndicator()
          else if (_filteredCompanies.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCompanies.length,
                itemBuilder: (context, index) {
                  final company = _filteredCompanies[index];
                  return ListTile(
                    title: Text(company['name']),
                    // Display other relevant company details
                  );
                },
              ),
            )
          else if (_searchTextController
              .text.isNotEmpty) // Show "No Results" if searched and no results
            const Center(child: Text('No results found')),
        ],
      ),
    );
  }
}
