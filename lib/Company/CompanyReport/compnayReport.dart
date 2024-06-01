// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Company/navbar1.dart';
import 'package:flutter/material.dart';

class CompanyReport extends StatefulWidget {
  const CompanyReport({super.key});

  @override
  State<CompanyReport> createState() => _CompanyReportState();
}

class _CompanyReportState extends State<CompanyReport> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedOrderState = 'Completed';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> orders = [];
  String? _companyName;
  User? _currentUser;

  bool isBudgetSet = false;
  double budgetAmount = 0.0;
  final TextEditingController budgetController = TextEditingController();

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
          .get();

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
      });

      print('Orders: $orders');
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Widget buildText(
    String text, {
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 14,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.left,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget buildInfoAndBudgetCard(
      {required String title, required String amount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  amount,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOrderButton(String text, String state, String iconPath) {
    return Container(
      decoration: ShapeDecoration(
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
        onPressed: () {
          setState(() {
            selectedOrderState = state;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedOrderState == state ? Colors.black : Colors.white,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(iconPath, height: 10), // Adjust height as needed
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color:
                    selectedOrderState == state ? Colors.white : Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderCard({
    required String status,
    required String userPic,
    required String userName,
    required String amount,
    required String selectedServices,
    required String serviceId, // Add serviceId parameter
    required VoidCallback onDetailsPressed,
    required VoidCallback onRatePressed,
  }) {
    String getStatusIcon(String status) {
      switch (status) {
        case 'Completed':
          return 'assets/images/greenDot.png';
        case 'In Progress':
          return 'assets/images/yellowDot.png';
        case 'Cancelled':
          return 'assets/images/redDot.png';
        default:
          return 'assets/images/greenDot.png';
      }
    }

    return GestureDetector(
      // Use GestureDetector to capture taps on the card
      onTap: onDetailsPressed, // Call onDetailsPressed when tapped
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
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
                Image.asset(getStatusIcon(status)),
                const SizedBox(width: 5),
                Text(
                  status,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (userPic != null)
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(userPic),
                  ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total amount come',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      amount,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Request for: $selectedServices',
              style: const TextStyle(
                color: Color.fromARGB(255, 87, 87, 87),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 34,
                    decoration: ShapeDecoration(
                      color: Colors.black,
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
                      onPressed: onDetailsPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: Container(
                    height: 34,
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
                      onPressed: onRatePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Rate',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmountSpent = 0;
    for (var order in orders) {
      if (order['status'] == 'Completed') {
        totalAmountSpent += double.parse(order['amount'].replaceAll(
            RegExp(r'[^\d.]'), '')); // Remove '$' and convert to double
      }
    }
    return BaseScaffoldd(
      initialIndex: 1,
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoAndBudgetCard(
              title: 'Total Amount Come',
              amount: '\$${totalAmountSpent.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 28),
            const Text(
              'Your orders',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildOrderButton(
                    'Completed', 'Completed', 'assets/images/greenDot.png'),
                buildOrderButton('In Progress', 'In Progress',
                    'assets/images/yellowDot.png'),
                buildOrderButton(
                    'Cancelled', 'Cancelled', 'assets/images/redDot.png'),
              ],
            ),
            const SizedBox(height: 1),
            Expanded(
              child: orders.isNotEmpty
                  ? ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        if (selectedOrderState == 'All orders' ||
                            selectedOrderState == order['status']) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: buildOrderCard(
                              status: order['status'],
                              userName: order['userName'],
                              amount: order['amount'],
                              selectedServices: order['selectedServices'],
                              userPic: order['userPic'],
                              serviceId: order['serviceId'] ??
                                  '', // Use empty string as default if serviceId is null
                              onDetailsPressed: () {
                                if (order['status'] == 'Completed') {
                                  Navigator.pushNamed(
                                    context,
                                    'companyDetails',
                                    arguments: {
                                      'status': order['status'],
                                      'companyName': order['userName'],
                                      'companyPic': order['userPic'],
                                      'amount': order['amount'],
                                      'selectedServices':
                                          order['selectedServices'],
                                    },
                                  );
                                } else if (order['status'] == 'In Progress') {
                                  Navigator.pushNamed(
                                    context,
                                    'PcompanyDetails',
                                    arguments: {
                                      'status': order['status'],
                                      'companyName': order['userName'],
                                      'companyPic': order['userPic'],
                                      'amount': order['amount'],
                                      'selectedServices':
                                          order['selectedServices'],
                                    },
                                  ); // Pass serviceId as argument
                                } else if (order['status'] == 'Cancelled') {
                                  Navigator.pushNamed(
                                    context,
                                    'Cdetails',
                                    arguments: {
                                      'status': order['status'],
                                      'companyName': order['userName'],
                                      'companyPic': order['userPic'],
                                      'amount': order['amount'],
                                      'selectedServices':
                                          order['selectedServices'],
                                    },
                                  ); // Pass serviceId as argument
                                }
                              },
                              onRatePressed: () {
                                // Navigate to rate page
                              },
                            ),
                          );
                        }
                        return Container();
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                              'assets/images/NoOrders.png'), // Replace with your image asset
                          const SizedBox(height: 20),
                          const Text(
                            'Sorry, you don’t have any orders in this category yet!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
