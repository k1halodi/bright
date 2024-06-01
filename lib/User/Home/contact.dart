// ignore_for_file: unused_element, avoid_print, non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/User/Home/contact2.dart';
import 'package:flutter/material.dart';

class CompanyDetails extends StatefulWidget {
  final String companyId;

  const CompanyDetails({super.key, required this.companyId});

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
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

  Set<String> selectedServices = {};
  late Future<DocumentSnapshot> _companyFuture;

  @override
  void initState() {
    super.initState();
    _companyFuture = FirebaseFirestore.instance
        .collection('MarketingCompany')
        .doc(widget.companyId)
        .get();
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error getting image URL: $e');
      return ''; // Return an empty string or a placeholder image URL in case of error
    }
  }

  Future<void> _saveContactMethod(String contactMethod) async {
    try {
      DocumentReference proposalDoc = FirebaseFirestore.instance
          .collection('Proposals')
          .doc(widget.companyId);

      // Check if the document exists
      DocumentSnapshot docSnapshot = await proposalDoc.get();
      if (docSnapshot.exists) {
        // Document exists, update it
        await proposalDoc.update({'howContact': contactMethod});
      } else {
        // Document does not exist, create it
        await proposalDoc.set({'howContact': contactMethod});
      }
    } catch (e) {
      print('Error saving contact method: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _companyFuture,
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
                  _buildContactOptions(context, companyName),
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

  Widget _buildTag(String Recom) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0.5),
      decoration: BoxDecoration(
        color: const Color(0xFFF46D6D),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        Recom,
        textAlign: TextAlign.center,
        style: _textStyle(10, Colors.black, FontWeight.w300),
      ),
    );
  }

  Widget _buildContactOptions(BuildContext context, String companyName) {
    return Container(
      width: double.infinity,
      height: 650,
      padding: const EdgeInsets.only(top: 23, left: 21, right: 21),
      decoration: _containerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'How do you prefer to be contacted from',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '$companyName?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 60),
          _buildContactButton(context, Icons.chat, 'Chat'),
          const SizedBox(height: 25),
          _buildContactButton(context, Icons.call, 'Phone Call'),
          const SizedBox(height: 25),
          _buildContactButton(context, Icons.video_call, 'Zoom Meeting'),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildContactButton(BuildContext context, IconData icon, String text) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: _containerDecoration(),
      child: ElevatedButton(
        onPressed: () async {
          await _saveContactMethod(text);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => C_contact2(companyId: widget.companyId),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          shadowColor: Colors.black,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const Spacer(),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  ShapeDecoration _containerDecoration({Color color = Colors.white}) {
    return ShapeDecoration(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadows: const [
        BoxShadow(
          color: Color(0x19000000),
          blurRadius: 14,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    );
  }

  TextStyle _textStyle(double fontSize, Color color, FontWeight fontWeight) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}
