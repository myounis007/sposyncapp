// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:soccer_app/edit_and_view_ofroles/Coach/coach_screen.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';

import '../Dashboard Screens/coach_dashboard_screen..dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  final List<Widget> screens = [
    CoachDashboardScreen(), // Home screen
    CoachScreen(), // Profile screen
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.grey500,
        backgroundColor: AppColors.apptheme,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
      ),
    );
  }
}
