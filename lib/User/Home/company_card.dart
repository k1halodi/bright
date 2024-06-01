// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'package:first_app/User/Home/SelectServices.dart';
import 'package:first_app/User/Home/aboutcompany.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget buildCompanyCard(BuildContext context, String companyId) {
  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('MarketingCompany')
        .doc(companyId)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.data() == null) {
        return const Text('No data found');
      } else {
        var data = snapshot.data!.data() as Map<String, dynamic>;
        var companyName = data['companyName'] ?? 'Unknown';
        var companyPic =
            data['companyPic'] ?? ''; // Provide a default value if it's null
        var indusrty = data['indusrty'] ?? 'Unknown';
        var rate = data['rate'] ?? 'Unknown';
        var services = data['services'] ?? 'Unknown';
        var Discount = data['Discount'] ?? 'Unknown';
        var Recom = data['Recom'] ?? 'Unknown';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
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
            children: [
              _buildCompanyHeader(
                  companyName, indusrty, rate, companyPic, Discount, Recom),
              const SizedBox(height: 8),
              _buildCompanyDetails(services, Discount, Recom),
              const SizedBox(height: 15),
              _buildActionButtons(
                  context, companyId), // Pass context and companyId
              const SizedBox(height: 15),
              Text(
                Discount,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromARGB(255, 229, 140, 140),
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}

Widget _buildCompanyHeader(String companyName, String indusrty, String rate,
    String companyPic, String Discount, String Recom) {
  return Row(
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
      const SizedBox(width: 5),
      Expanded(
        child: Column(
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
              indusrty,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: 10),
      Row(
        children: [
          Text(
            rate,
            textAlign: TextAlign.center,
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
      ),
    ],
  );
}

// ignore: non_constant_identifier_names
Widget _buildCompanyDetails(String services, String Discount, String Recom) =>
    Row(
      children: [
        Expanded(
          child: Text(
            services,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF46D6D),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            Recom,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );

Widget _buildActionButtons(BuildContext context, String companyId) {
  return Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectServices(companyId: companyId),
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
      const SizedBox(width: 50),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutCompany(companyId: companyId),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize:
                const Size(167, 34), // Set the minimum size for the button
          ),
          child: const Text(
            'About',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    ],
  );
}
