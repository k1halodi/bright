// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BaseScaffold extends StatefulWidget {
  final Widget body;
  final int initialIndex;

  const BaseScaffold(
      {required this.body,
      this.initialIndex = 0,
      Key? key,
      required AppBar appBar})
      : super(key: key);

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the respective screen
    switch (index) {
      case 0:
        Navigator.pushNamed(context, 'home');

      case 1:
        Navigator.pushNamed(context, 'report');

      case 2:
        Navigator.pushNamed(context, 'chat');

      case 3:
        Navigator.pushNamed(context, 'profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.body,
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 21, right: 21, top: 10, bottom: 10),
        child: Container(
          width: 349,
          height: 66.33,
          padding: const EdgeInsets.all(10),
          decoration: ShapeDecoration(
            color: Colors.black.withOpacity(0.85),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 14,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: GNav(
            backgroundColor: Colors.transparent,
            color: Colors.white,
            activeColor: Colors.white,
            rippleColor: Colors.grey,
            gap: 5,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            selectedIndex: _selectedIndex,
            onTabChange: _onTabChange,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.file_copy_sharp,
                text: 'Report',
              ),
              GButton(
                icon: Icons.chat,
                text: 'Chat',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
