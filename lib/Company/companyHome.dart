import 'package:first_app/Company/navbar1.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  String? _companyName;
  List<Map<String, dynamic>> orders = [];
  List<bool> isVisibleList = [];

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  Future<void> initializeUser() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        print('User is not authenticated');
      } else {
        setState(() {
          _currentUser = user;
        });
        await fetchCompanyName();
        fetchOrdersFromFirebase();
      }
    });
  }

  Future<void> fetchCompanyName() async {
    try {
      if (_currentUser == null) return;

      DocumentSnapshot companyDoc =
          await _firestore.collection('Company').doc(_currentUser!.uid).get();
      if (companyDoc.exists) {
        setState(() {
          _companyName = companyDoc['name'];
        });
      } else {
        print('Company document does not exist.');
      }
    } catch (e) {
      print('Error fetching company name: $e');
    }
  }

  Future<void> fetchOrdersFromFirebase() async {
    try {
      if (_companyName == null) {
        print('Company name is not available.');
        return;
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('Proposals')
          .where('companyId', isEqualTo: _companyName)
          .where('status', whereIn: ['Pending']).get();

      if (querySnapshot.docs.isEmpty) {
        print('No proposals found for the current user.');
      }

      var fetchedOrders = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        print('Fetched data: $data');
        return {
          'status': data['status'],
          'companyName': data['companyId'],
          'companyPic': data['companyPic'],
          'amount': '\$${data['amount']}',
          'selectedServices':
              (data['selectedServices'] as List<dynamic>? ?? []).join(', '),
          'userName': data['userName'],
          'userPic': data['userPic'],
          'documentId': doc.id,
        };
      }).toList();

      setState(() {
        orders = fetchedOrders;
        isVisibleList = List.filled(fetchedOrders.length, true);
      });

      print('Orders: $orders');
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream() {
    if (_currentUser == null) {
      return const Stream.empty();
    }
    return _firestore.collection('Company').doc(_currentUser!.uid).snapshots();
  }

  Future<void> updateOrderStatus(String documentId, String status) async {
    try {
      await _firestore
          .collection('Proposals')
          .doc(documentId)
          .update({'status': status});
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BaseScaffoldd(
      initialIndex: 0,
      appBar: AppBar(
        title: const Text('Home'),
      ),
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
                        final imageUrl = userData?['Pic'] ?? '';

                        return Column(
                          children: [
                            _buildUserProfileSection(context, name, imageUrl),
                            const SizedBox(height: 70),
                            ...orders.asMap().entries.map((entry) {
                              int index = entry.key;
                              var order = entry.value;
                              return Visibility(
                                visible: isVisibleList[index],
                                child: RequestContainer(
                                  screenWidth: screenWidth,
                                  imagePath: order['userPic'] ??
                                      'assets/images/default_profile.png',
                                  requesterName: order['userName'] ?? 'Unknown',
                                  requestDetails:
                                      order['selectedServices'] ?? 'N/A',
                                  onReject: () {
                                    setState(() {
                                      isVisibleList[index] = false;
                                      updateOrderStatus(
                                          order['documentId'], 'Cancelled');
                                    });
                                  },
                                  onAccept: () {
                                    // Handle accept action
                                  },
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildUserProfileSection(
    BuildContext context, String name, String imageUrl) {
  return Container(
    padding: const EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 16),
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
    child: Row(
      children: [
        CircleAvatar(
          radius: 27,
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
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
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 1),
            Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

class RequestContainer extends StatelessWidget {
  final double screenWidth;
  final String imagePath;
  final String requesterName;
  final String requestDetails;
  final VoidCallback onReject;
  final VoidCallback onAccept;

  const RequestContainer({
    required this.screenWidth,
    required this.imagePath,
    required this.requesterName,
    required this.requestDetails,
    required this.onReject,
    required this.onAccept,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      padding: const EdgeInsets.all(15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/images/PinkDot.png'),
              const SizedBox(width: 5),
              const Text(
                'New request',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imagePath),
                    fit: BoxFit.fill,
                  ),
                  shape: const OvalBorder(),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    requesterName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Request for: $requestDetails',
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 10,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
