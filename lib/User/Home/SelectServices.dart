// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'package:first_app/User/Home/contact.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectServices extends StatefulWidget {
  final String companyId;

  const SelectServices({super.key, required this.companyId});

  @override
  State<SelectServices> createState() => _SelectServicesState();
}

class _SelectServicesState extends State<SelectServices> {
  Widget buildText(String text,
      {FontWeight fontWeight = FontWeight.w400,
      double fontSize = 14,
      Color color = Colors.black}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  late Set<ChooseService> selectedServices;
  late Future<DocumentSnapshot> _companyFuture;
  late Future<List<ChooseService>> _servicesFuture;
  late String _currentUserId;
  late String? companyPic;
  late String companyName; // Define companyPic variable

  @override
  void initState() {
    super.initState();
    selectedServices = {};
    _companyFuture = FirebaseFirestore.instance
        .collection('MarketingCompany')
        .doc(widget.companyId)
        .get()
        .then((snapshot) {
      setState(() {
        companyPic = snapshot.data()?['companyPic'];
        companyName = snapshot.data()?['companyName'];
      });
      return snapshot;
    });

    _servicesFuture = _fetchServices();

    // Get the current user's ID
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('Current User ID: $_currentUserId'); // Add this line for debugging
  }

  Future<List<ChooseService>> _fetchServices() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('MarketingCompany')
        .doc(widget.companyId)
        .collection('service1')
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data();
      return ChooseService(
        id: doc.id,
        imagePath: data['image'] ?? '',
        title: data['serviceName'] ?? 'Unknown',
        priceRange: data['priceRange'] ?? 'Unknown',
      );
    }).toList();
  }

  Future<void> _saveProposal(String userId, String userName, String userPic,
      String? companyPic, String companyName) async {
    await FirebaseFirestore.instance.collection('Proposals').add({
      'userId': userId,
      'userName': userName,
      'userPic': userPic,
      'companyId': companyName,
      'companyPic': companyPic, // Use companyPic here
      'selectedServices':
          selectedServices.map((service) => service.title).toList(),
      'status': 'Pending',
      'amount': '0',
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUserId)
        .snapshots();
  }

  Widget buildServiceContainer(ChooseService service) {
    bool isSelected = selectedServices.contains(service);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedServices.remove(service);
          } else {
            selectedServices.add(service);
          }
        });
      },
      child: Container(
        width: 159.50,
        height: 130,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 14,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              service.imagePath,
              height: 50,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
            const SizedBox(height: 10),
            Text(
              service.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 5),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Price Range:\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: service.priceRange,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getUserDataStream(),
      builder: (context, userSnapshot) {
        if (userSnapshot.hasError) {
          return Center(child: Text('Error: ${userSnapshot.error}'));
        }

        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = userSnapshot.data!.data();
        final userId = userData?['id'] ?? 'Unknown';
        final userName = userData?['name'] ?? 'Unknown';
        final userPic = userData?['profilePhotoUrl'] ?? '';

        return FutureBuilder<DocumentSnapshot>(
          future: _companyFuture,
          builder: (context, companySnapshot) {
            if (companySnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (companySnapshot.hasError) {
              return Center(child: Text('Error: ${companySnapshot.error}'));
            } else if (!companySnapshot.hasData ||
                companySnapshot.data!.data() == null) {
              return const Center(child: Text('No data found'));
            } else {
              var data = companySnapshot.data!.data() as Map<String, dynamic>;
              var companyName = data['companyName'] ?? 'Unknown';
              var companyPic = data['companyPic'] ?? '';
              var industry = data['indusrty'] ?? 'Unknown';
              var rate = data['rate'] ?? 'Unknown';
              var services = data['services'] ?? 'Unknown';
              var discount = data['discount'] ?? 'Unknown';
              var recom = data['Recom'] ?? 'Unknown';
              var companySize = data['companySize'] ?? 'Unknown';
              var companyWebsite = data['companyWebsite'] ?? 'Unknown';
              var overview = data['overview'] ?? 'Unknown';

              return Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(
                        companyPic,
                        discount,
                        recom,
                        services,
                        companyName,
                        industry,
                        rate,
                        context,
                      ),
                      const SizedBox(height: 50),
                      _buildContactOptions(
                          companyName,
                          industry,
                          companySize,
                          companyWebsite,
                          services,
                          overview,
                          userId,
                          userName,
                          userPic),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildHeader(
    String imageUrl,
    String discount,
    String recom,
    String services,
    String companyName,
    String industry,
    String rate,
    BuildContext context,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 165,
      padding: const EdgeInsets.only(
        top: 50,
        right: 21,
        bottom: 20,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 10,
            offset: Offset(4, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_outlined),
              ),
              Image.network(imageUrl, height: 50, width: 50, fit: BoxFit.cover),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText(
                    companyName,
                    fontWeight: FontWeight.w600,
                  ),
                  buildText(
                    industry,
                    fontSize: 12,
                    color: const Color(0xFF8D8D8D),
                  ),
                  Row(
                    children: List.generate(
                      int.tryParse(rate) ?? 0,
                      (index) => const Icon(
                        Icons.star_rate_rounded,
                        color: Color(0xFFF46D6D),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: buildText(
                    services,
                    fontSize: 10,
                    color: const Color(0xFF666666),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF46D6D),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: buildText(
                  recom,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactOptions(
    String companyName,
    String industry,
    String companySize,
    String companyWebsite,
    String services,
    String overview,
    String userId,
    String userName,
    String userPic,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 23, left: 21, right: 21, bottom: 100),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 10,
            offset: Offset(4, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            'What the services you need from',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
          Text(
            companyName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 30),
          FutureBuilder<List<ChooseService>>(
            future: _servicesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No services found'));
              } else {
                var services = snapshot.data!;
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final crossAxisCount = constraints.maxWidth < 200 ? 1 : 2;
                    final mainAxisSpacing =
                        constraints.maxWidth < 200 ? 16.0 : 32.0;
                    final crossAxisSpacing =
                        constraints.maxWidth < 200 ? 16.0 : 32.0;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: mainAxisSpacing,
                        crossAxisSpacing: crossAxisSpacing,
                        childAspectRatio: (159.50 / 130),
                      ),
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildServiceContainer(services[index]);
                      },
                    );
                  },
                );
              }
            },
          ),
          const SizedBox(height: 80),
          Container(
            width: 311,
            height: 40,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 14,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                await _saveProposal(
                    _currentUserId, userName, userPic, companyPic, companyName);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CompanyDetails(companyId: widget.companyId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize:
                    const Size(167, 34), // Set the minimum size for the button
              ),
              child: const Text(
                'Contact',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChooseService {
  final String id;
  final String imagePath;
  final String title;
  final String priceRange;

  ChooseService({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.priceRange,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChooseService &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
