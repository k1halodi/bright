// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/User/navbar.dart';
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedOrderState = 'Completed';

  List<Map<String, dynamic>> orders = [];

  bool isBudgetSet = false;
  double budgetAmount = 0.0;
  final TextEditingController budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBudgetFromFirebase();
    fetchOrdersFromFirebase();
  }

  Future<void> fetchBudgetFromFirebase() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Handle user not logged in scenario
        return;
      }
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      var data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('budget')) {
        setState(() {
          budgetAmount = data['budget'];
          isBudgetSet = true;
        });
      }
    } catch (e) {
      // Handle errors appropriately
    }
  }

  Future<void> fetchOrdersFromFirebase() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Handle user not logged in scenario
        return;
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Proposals')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      var fetchedOrders = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'status': data['status'],
          'companyName':
              data['companyId'], // Ensure companyName is retrieved correctly
          'companyPic': data['companyPic'],
          'amount':
              '\$${data['amount']}', // Assuming 'amount' is in your Firestore data
          'selectedServices':
              (data['selectedServices'] as List<dynamic>).join(', '),
        };
      }).toList();

      setState(() {
        orders = fetchedOrders;
      });
    } catch (e) {
      print('Error fetching orders: $e');
      // Handle errors appropriately
    }
  }

  Future<void> setBudget() async {
    double? newBudget = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Budget'),
          content: TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter budget amount'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(double.tryParse(budgetController.text));
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle user not logged in scenario
      return;
    }
    if (newBudget != null) {
      setState(() {
        budgetAmount = newBudget;
        isBudgetSet = true;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        'budget': newBudget,
      }, SetOptions(merge: true));
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
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
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
                const SizedBox(height: 13),
                const Text(
                  'Your Budget',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isBudgetSet ? '\$$budgetAmount' : '\$0',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                      onPressed: setBudget,
                      child: Text(
                        isBudgetSet ? 'Set' : 'Set',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 114, 114),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
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
          backgroundColor: selectedOrderState == state ||
                  (state == 'In Progress' &&
                      (selectedOrderState == 'In Progress' ||
                          selectedOrderState == 'Pending'))
              ? Colors.black
              : Colors.white,
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
                color: selectedOrderState == state ||
                        (state == 'In Progress' &&
                            (selectedOrderState == 'In Progress' ||
                                selectedOrderState == 'Pending'))
                    ? Colors.white
                    : Colors.black,
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
    required String companyName,
    required String amount,
    required String selectedServices,
    required String? companyPic,
    required String serviceId, // Add serviceId parameter
    required VoidCallback onDetailsPressed,
    required VoidCallback onRatePressed,
  }) {
    String getStatusIcon(String status) {
      switch (status) {
        case 'Completed':
          return 'assets/images/greenDot.png';
        case 'In Progress': // Removed the extra space after 'In Progress'
        case 'Pending': // Added case for 'Pending'
          return 'assets/images/yellowDot.png';
        case 'Cancelled':
          return 'assets/images/redDot.png';
        default:
          return 'assets/images/greenDot.png'; // Default to green for other statuses
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
                if (companyPic != null)
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(companyPic),
                  ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
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
                      'Total amount Spent',
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
              selectedServices,
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
    return BaseScaffold(
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
              title: 'Total Amount Spent',
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
                            selectedOrderState == order['status'] ||
                            (selectedOrderState == 'In Progress' &&
                                (order['status'] == 'In Progress' ||
                                    order['status'] == 'Pending'))) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: buildOrderCard(
                              status: order['status'],
                              companyName: order['companyName'],
                              amount: order['amount'],
                              selectedServices: order['selectedServices'],
                              companyPic: order['companyPic'],
                              serviceId: order['serviceId'] ??
                                  '', // Use empty string as default if serviceId is null
                              onDetailsPressed: () {
                                if (order['status'] == 'Completed') {
                                  Navigator.pushNamed(
                                    context,
                                    'details',
                                    arguments: {
                                      'status': order['status'],
                                      'companyName': order['companyName'],
                                      'companyPic': order['companyPic'],
                                      'amount': order['amount'],
                                      'selectedServices':
                                          order['selectedServices'],
                                    },
                                  );
                                } else if (order['status'] == 'In Progress') {
                                  Navigator.pushNamed(
                                    context,
                                    'Pdetails',
                                    arguments: {
                                      'status': order['status'],
                                      'companyName': order['companyName'],
                                      'companyPic': order['companyPic'],
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
                                      'companyName': order['companyName'],
                                      'companyPic': order['companyPic'],
                                      'amount': order['amount'],
                                      'selectedServices':
                                          order['selectedServices'],
                                    },
                                  ); // Pass serviceId as argument
                                }else if (order['status'] == 'Pending') {
                                  Navigator.pushNamed(
                                    context,
                                    'Cdetails',
                                    arguments: {
                                      'status': order['status'],
                                      'companyName': order['companyName'],
                                      'companyPic': order['companyPic'],
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
