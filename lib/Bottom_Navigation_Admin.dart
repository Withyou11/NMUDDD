import 'package:english_study_app/AboutUs_Screen.dart';
import 'package:english_study_app/LoginScreen.dart';
import 'package:english_study_app/Setting_Screen.dart';
import 'package:english_study_app/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'HomeScreen.dart';
import 'HomeScreen_Admin.dart';

class NavigationBottomAdmin extends StatefulWidget {
  const NavigationBottomAdmin({Key? key}) : super(key: key);

  @override
  State<NavigationBottomAdmin> createState() => _NavigationBottomAdminState();
}

class _NavigationBottomAdminState extends State<NavigationBottomAdmin> {
  int _indexCurrent = 0;
  final _screen = [
    const Scaffold(body: HomeScreenAdmin()),
    const Scaffold(body: SetttingScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_indexCurrent],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(80, 207, 116, 1),
        currentIndex: _indexCurrent,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 12,
        selectedFontSize: 15,
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
                size: 30,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black87,
              size: 30,
            ),
            label: 'Setting',
          ),
        ],
        // fixedColor: Colors.black87,
        onTap: (index) {
          setState(() {
            _indexCurrent = index;
          });
        },
      ),
    );
  }
}
