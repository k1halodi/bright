// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class C_contact2 extends StatefulWidget {
  final String companyId;

  const C_contact2({super.key, required this.companyId});

  @override
  State<C_contact2> createState() => _C_contact2State();
}

class _C_contact2State extends State<C_contact2> {
  late Future<DocumentSnapshot> _companyFuture;

  @override
  void initState() {
    super.initState();
    _companyFuture = FirebaseFirestore.instance
        .collection('MarketingCompany')
        .doc(widget.companyId)
        .get();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _companyFuture, // Use _companyFuture
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text('No data found'));
        } else {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          var companyName = data['companyName'] ?? 'Unknown';
          var companyPic = data['companyPic'] ?? '';
          var industry = data['indusrty'] ?? 'Unknown';
          var rate = data['rate'] ?? 'Unknown';
          var services = data['services'] ?? 'Unknown';
          var discount = data['discount'] ?? 'Unknown';
          var recom = data['Recom'] ?? 'Unknown';

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
                  _buildContactOptions(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildHeader(
      String companyPic,
      String discount,
      String recom,
      String services,
      String companyName,
      String industry,
      String rate,
      BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 55, bottom: 20, right: 21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 14,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 21),
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
                  const SizedBox(width: 16),
                  _buildCompanyInfo(companyName, industry),
                ],
              ),
              _buildRating(rate),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 21),
            child: Row(
              children: [
                Text(
                  services,
                  style:
                      _textStyle(10, const Color(0xFF666666), FontWeight.w300),
                ),
                const SizedBox(width: 15),
                _buildTag(recom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo(String companyName, String industry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          companyName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          industry,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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

  Widget _buildTag(String recom) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0.5),
      decoration: BoxDecoration(
        color: const Color(0xFFF46D6D),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        recom,
        textAlign: TextAlign.center,
        style: _textStyle(10, Colors.black, FontWeight.w300),
      ),
    );
  }

  Widget _buildContactOptions() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: 650,
      padding: const EdgeInsets.all(21),
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
          const SizedBox(
            height: 40,
          ),
          Image.asset('assets/images/Contact.png'),
          const SizedBox(
            height: 40,
          ),
          buildText(
            'Thank You!\nWe sent your information to the marketing company. Someone will be in contact with you within an hour.',
            textAlign: TextAlign.center,
            fontSize: 20,
          ),
          const SizedBox(
            height: 80,
          ),
          Container(
            width: screenWidth * 0.8,
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
              onPressed: () {
                Navigator.pushNamed(context, 'home');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.white,
                elevation: 0.5,
                shadowColor: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildText(
                    'Go to Home',
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(width: 10),
                  Image.asset('assets/images/ProfileB.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle(double fontSize, Color color, FontWeight fontWeight) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
