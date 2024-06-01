// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast

class CompanyRegister extends StatefulWidget {
  const CompanyRegister({super.key});

  @override
  State<CompanyRegister> createState() => _CompanyRegisterState();
}

class _CompanyRegisterState extends State<CompanyRegister> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyLinkedInController =
      TextEditingController();
  final TextEditingController companyWebsiteController =
      TextEditingController();
  final TextEditingController companyIndustryController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildTextField({
    required String labelText,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1),
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: ShapeDecoration(
        color: backgroundColor,
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
      ),
    );
  }

  Future<void> saveCompanyData() async {
    try {
      await FirebaseFirestore.instance.collection('companies').add({
        'companyName': companyNameController.text.trim(),
        'companyLinkedIn': companyLinkedInController.text.trim(),
        'companyWebsite': companyWebsiteController.text.trim(),
        'companyIndustry': companyIndustryController.text.trim(),
      });
      Fluttertoast.showToast(msg: 'Company information saved successfully');
      Navigator.pushNamed(
          context, 'Service'); // Navigate to home after successful registration
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to save company information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
              left: 21,
              top: 74,
              right: 21,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tell Us about your company.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 27),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 14,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField(
                          labelText: 'Company Name',
                          hintText: 'Enter your company name',
                          controller: companyNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name is required";
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          labelText: 'Company LinkedIn',
                          hintText: 'Link for Company LinkedIn',
                          controller: companyLinkedInController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Link for Company LinkedIn is required";
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          labelText: 'Company Website',
                          hintText: 'Company Website',
                          controller: companyWebsiteController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Link for your website is required";
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          labelText: 'Company Industry',
                          hintText: 'Enter the company industry',
                          controller: companyIndustryController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter the company industry";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: SizedBox(
                            width: screenWidth * 0.7,
                            child: buildButton(
                              text: 'Register',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  saveCompanyData();
                                }
                              },
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  height: 150,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 21),
                      const Text(
                        'Already have an account?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: 280,
                        height: 40,
                        child: buildButton(
                          text: 'Skip for now',
                          onPressed: () {
                            Navigator.pushNamed(context, 'services');
                          },
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
