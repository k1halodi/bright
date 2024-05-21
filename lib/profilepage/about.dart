import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
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
        padding: EdgeInsets.only(
          top: screenHeight * 0.02,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth,
              padding: const EdgeInsets.only(bottom: 15),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Bright',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Bridging the Gap in Digital Marketing',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 21),
            const Text(
              'Introducing Bright Marketing',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.9,
              child: const Text(
                'Bright Marketing serves as a pivotal application connecting digital marketing companies and clients.\n \nEmpowers businesses to navigate the intricacies of the digital landscape, ensuring successful achievement of marketing objectives.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 21),
            const Text(
              'Objectives of Bright Marketing',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: screenWidth * 0.9,
              child: const Text(
                'Simplify the Process:\n'
                'Bright Marketing aims to simplify the complex processes of finding, hiring, and collaborating with digital marketing professionals.\n\n'
                'Connect with Reputable Professionals:\n'
                'The objective is to connect businesses with reputable digital marketing experts.\n\n'
                'Enhance Collaboration and Communication:\n'
                'Bright Marketing offers robust project management tools and real-time communication channels.\n\n'
                'Track and Measure Performance:\n'
                'The platform provides comprehensive analytics and reporting features.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
