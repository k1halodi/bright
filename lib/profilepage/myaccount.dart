// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  // Controllers for user information
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDateOfBirth;

  // Controllers for company information
  final _companyNameController = TextEditingController();
  final _companyWebsiteController = TextEditingController();
  final _industryController = TextEditingController();

  String?
      userCompanyId; // Store the document ID of the user's associated company

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user data
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc.data()!['name'] ?? '';
          _emailController.text = userDoc.data()!['email'] ?? '';
          _selectedGender = userDoc.data()!['gender'];
          _selectedDateOfBirth = userDoc.data()!['dateOfBirth'].toDate();
        });

        // Fetch company data from userCompanies collection
        final userCompanyQuery = await FirebaseFirestore.instance
            .collection('userCompanies')
            .where('userId', isEqualTo: user.uid)
            .get();

        if (userCompanyQuery.docs.isNotEmpty) {
          final companyDoc = userCompanyQuery.docs.first;
          setState(() {
            _companyNameController.text =
                companyDoc.data()['companyName'] ?? '';
            _companyWebsiteController.text =
                companyDoc.data()['companyWebsite'] ?? '';
            _industryController.text = companyDoc.data()['industry'] ?? '';
            userCompanyId = companyDoc.id; // Store the document ID
          });
        }
      }
    }
  }

  Future<void> _saveData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update user data
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': _nameController.text,
          'email': _emailController.text,
          'gender': _selectedGender,
          'dateOfBirth': Timestamp.fromDate(_selectedDateOfBirth!),
        });

        // Update (or create) company data in userCompanies
        if (userCompanyId != null) {
          // Update existing company document
          await FirebaseFirestore.instance
              .collection('userCompanies')
              .doc(userCompanyId)
              .update({
            'companyName': _companyNameController.text,
            'companyWebsite': _companyWebsiteController.text,
            'industry': _industryController.text,
          });
        } else {
          // Create new company document
          await FirebaseFirestore.instance.collection('userCompanies').add({
            'userId': user.uid,
            'companyName': _companyNameController.text,
            'companyWebsite': _companyWebsiteController.text,
            'industry': _industryController.text,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved successfully!')),
        );
      }
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
          'Account',
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
        padding: const EdgeInsets.all(21),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Account',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Add or change your profile details.',
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
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Gender',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                          items: ['Male', 'Female']
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Day of Birth',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  _selectedDateOfBirth ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null &&
                                picked != _selectedDateOfBirth) {
                              setState(() {
                                _selectedDateOfBirth = picked;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  _selectedDateOfBirth != null
                                      ? "${_selectedDateOfBirth!.toLocal()}"
                                      : 'Select date',
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          height: 40,
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
                            onPressed: () async {
                              // Update user data in Firebase
                              try {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc('your_user_id')
                                    .update({
                                  'name': _nameController.text,
                                  'email': _emailController.text,
                                  'gender': _selectedGender,
                                  'dateOfBirth': _selectedDateOfBirth,
                                });

                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Saved successfully!'),
                                  ),
                                );
                              } catch (e) {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Try again later.'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
