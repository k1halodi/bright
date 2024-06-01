import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchBarContainer extends StatefulWidget {
  final void Function(bool)? onSearchStateChanged;
  final void Function(List<Map<String, dynamic>>)? onSearchResults;
  final TextEditingController searchTextController; // Add this line

  const SearchBarContainer({
    Key? key,
    this.onSearchStateChanged,
    this.onSearchResults,
    required this.searchTextController, // Add this line
  }) : super(key: key);

  @override
  _SearchBarContainerState createState() => _SearchBarContainerState();
}

class _SearchBarContainerState extends State<SearchBarContainer> {
  final TextEditingController _searchTextController = TextEditingController();
  List<Map<String, dynamic>> _filteredCompanies = [];
  bool _isLoading = false;

  @override
  void dispose() {
    print("Disposing SearchBarContainer");
    _searchTextController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isNotEmpty) {
      if (mounted) {
        print("Setting state to loading");
        setState(() => _isLoading = true);
      }
    } else {
      if (mounted) {
        setState(() {
          _filteredCompanies = [];
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('MarketingCompany')
          .where('companyName', isGreaterThanOrEqualTo: query)
          .get();

      if (mounted) {
        setState(() {
          _filteredCompanies = snapshot.docs.map((doc) => doc.data()).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      print('Error searching: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during search.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: widget
                        .searchTextController, // Use the passed controller
                    onChanged: (query) => _performSearch(query),
                    decoration: InputDecoration(
                      hintText: 'Search Marketing Companies...',
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.grey),
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
                          horizontal: 15, vertical: 15),
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
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_filteredCompanies.isNotEmpty ||
              _searchTextController.text.isEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCompanies.length,
                itemBuilder: (context, index) {
                  final company = _filteredCompanies[index];
                  return _buildCompanyCard(company);
                },
              ),
            )
          else
            const Center(child: Text('No results found')),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company) {
    var companyName = company['companyName'] ?? 'Unknown';
    var companyPic = company['companyPic'] ?? '';
    var industry = company['indusrty'] ?? 'Unknown';
    var rate = company['rate'] ?? 'Unknown';
    var services = company['services'] ?? 'Unknown';
    var discount = company['discount'] ?? 'Unknown';
    var recom = company['recom'] ?? 'Unknown';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                companyPic.isNotEmpty
                    ? Image.network(
                        companyPic,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/default_profile.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        industry,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildRating(rate),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Services: $services',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              'Discount: $discount',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            _buildTag(recom),
          ],
        ),
      ),
    );
  }

  Widget _buildRating(String rate) {
    return Row(
      children: [
        Text(
          rate,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(width: 1.5),
        const Icon(
          Icons.star_rate_rounded,
          color: Color(0xFFF46D6D),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF46D6D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}
