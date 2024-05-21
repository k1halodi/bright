import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCompany extends StatefulWidget {
  const MyCompany({super.key});

  @override
  State<MyCompany> createState() => _MyCompanyState();
}

class _MyCompanyState extends State<MyCompany> {
  final _companyNameController = TextEditingController();
  final _companyWebsiteController = TextEditingController();
  final _industryController = TextEditingController();

  String companyId = ""; // To store the document ID of userCompany

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userCompanyQuery = await FirebaseFirestore.instance
          .collection('userCompanies')
          .where('userId', isEqualTo: currentUser.uid)
          .limit(1)
          .get();

      if (userCompanyQuery.docs.isNotEmpty) {
        final userCompanyDoc = userCompanyQuery.docs.first;

        setState(() {
          _companyNameController.text =
              userCompanyDoc.data()['companyName'] ?? '';
          _companyWebsiteController.text =
              userCompanyDoc.data()['companyWebsite'] ?? '';
          _industryController.text = userCompanyDoc.data()['industry'] ?? '';
          companyId = userCompanyDoc.id;
        });
      }
    }
  }

  void _saveDataToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // If companyId is not empty, update existing document, else create a new one
        if (companyId.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('userCompanies')
              .doc(companyId)
              .update({
            'companyName': _companyNameController.text,
            'companyWebsite': _companyWebsiteController.text,
            'industry': _industryController.text,
          });
        } else {
          await FirebaseFirestore.instance.collection('userCompanies').add({
            'userId': user.uid,
            'companyName': _companyNameController.text,
            'companyWebsite': _companyWebsiteController.text,
            'industry': _industryController.text,
          });
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Company',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, 'profile');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(21.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Company',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add, or change your Company details.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 30),
            Container(
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
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Company Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextFormField(
                    controller: _companyNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Company Website',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextFormField(
                    controller: _companyWebsiteController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Industry',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextFormField(
                    controller: _industryController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc('your_user_id')
                            .update({
                          'companyName': _companyNameController.text,
                          'companyWebsite': _companyWebsiteController.text,
                          'industry': _industryController.text,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Saved successfully'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Something went wrong. Please try again later.'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 140, vertical: 12),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(width: 1),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyWebsiteController.dispose();
    _industryController.dispose();
    super.dispose();
  }
}
