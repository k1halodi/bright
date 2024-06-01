// ignore_for_file: unused_label, depend_on_referenced_packages, file_names, prefer_const_constructors, unused_element, unnecessary_new, unnecessary_null_comparison
import 'package:flutter/material.dart';

class CDetails extends StatefulWidget {
  const CDetails({super.key});

  @override
  State<CDetails> createState() => _CDetailsState();
}

class _CDetailsState extends State<CDetails> {
  late Map<String, dynamic> orderData;

  @override
  Widget build(BuildContext context) {
    orderData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, orderData),
            const SizedBox(height: 80),
            _buildNoOrdersContent()
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailsContent(Map<String, dynamic> orderData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, orderData),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNoOrdersContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/NoOrders.png'),
        const SizedBox(height: 50),
        const Text(
          'We are sorry for that, The request you made is cancelled!\nTry to send request again, or contact us.\nThank you',
          textAlign: TextAlign.center, // Center align the text
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> orderData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
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
              Image.asset(_getStatusIcon(orderData['status'])),
              const SizedBox(width: 5),
              Text(
                orderData['status'],
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
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_outlined),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 17,
                backgroundImage: NetworkImage(orderData['companyPic']),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 1),
                  Text(
                    orderData['companyName'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total amount spent',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    orderData['amount'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            orderData['selectedServices'],
            style: const TextStyle(
              color: Color(0xFF7A7A7A),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusIcon(String status) {
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
}
