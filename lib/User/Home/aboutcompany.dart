// ignore_for_file: unused_element

import 'package:first_app/User/Home/SelectServices.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class AboutCompany extends StatefulWidget {
  final String companyId; // Define companyId as a required parameter

  const AboutCompany(
      {super.key,
      required this.companyId}); // Constructor with required companyId

  @override
  State<AboutCompany> createState() => _AboutCompanyState();
}

class _AboutCompanyState extends State<AboutCompany> {
  late Future<DocumentSnapshot>
      _companyFuture; // Declare _companyFuture variable

  @override
  void initState() {
    super.initState();
    _companyFuture =
        FirebaseFirestore.instance // Initialize _companyFuture in initState
            .collection('MarketingCompany')
            .doc(widget.companyId)
            .get();
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
          var industry =
              data['indusrty'] ?? 'Unknown'; // Correct 'indusrty' to 'industry'
          var rate = data['rate'] ?? 'Unknown';
          var services = data['services'] ?? 'Unknown';
          var discount =
              data['discount'] ?? 'Unknown'; // Correct 'Discount' to 'discount'
          var recom = data['Recom'] ?? 'Unknown'; // Correct 'Recom' to 'recom'
          var companySize = data['CompanySize'] ??
              'Unknown'; // Correct 'Companysize' to 'companySize'
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
                  _buildContactOptions(companyName, industry, companySize,
                      companyWebsite, services, overview),
                ],
              ),
            ),
          );
        }
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
                  buildText(industry),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  buildText(rate, fontSize: 12, fontWeight: FontWeight.w300),
                  const SizedBox(width: 1.5),
                  const Icon(
                    Icons.star_rate_rounded,
                    color: Color(0xFFF46D6D),
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

  Widget _buildContactOptions(
      String companyName,
      String industry,
      String companySize,
      String companyWebsite,
      String services,
      String overview) {
    return Container(
      width: double.infinity,
      height: 800,
      padding: const EdgeInsets.only(
        top: 20,
        left: 27,
        right: 19,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 14,
            offset: Offset(4, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText('About', fontSize: 16, fontWeight: FontWeight.w600),
          const SizedBox(height: 20),
          buildText('Overview', fontSize: 14, fontWeight: FontWeight.w600),
          const SizedBox(height: 1),
          buildText(
            overview,
            fontSize: 14,
          ),
          const SizedBox(height: 15),
          buildText(
            'Website',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 1),
          buildText(companyWebsite),
          const SizedBox(height: 15),
          buildText(
            'Industry',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 1),
          buildText(industry),
          const SizedBox(height: 15),
          buildText(
            'Company size',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 1),
          buildText(companySize),
          const SizedBox(height: 15),
          buildText(
            'Our Services',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 1),
          buildText(services),
          const SizedBox(height: 60),
          Center(
            child: Container(
              width: 180,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SelectServices(companyId: widget.companyId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(
                      167, 34), // Set the minimum size for the button
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
          ),
        ],
      ),
    );
  }

  // Utility method to create styled text widgets
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

  // Utility method to define text style
  TextStyle _textStyle(double fontSize, Color color, FontWeight fontWeight) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
