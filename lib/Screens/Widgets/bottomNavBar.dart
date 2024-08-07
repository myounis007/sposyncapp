// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:soccer_app/edit_and_view_ofroles/Coach/coach_screen.dart';
import 'package:soccer_app/Screens/Dashboard%20Screens/coach_dashboard_screen..dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  List screens = [
    CoachDashboardScreen(),
    CoachScreen(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        unselectedItemColor: AppColors.grey500,
        backgroundColor: AppColors.apptheme,
        selectedItemColor: AppColors.white,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text(
              "Home",
              style: TextStyle(color: AppColors.black),
            ),
          ),

          SalomonBottomBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: Text(
              "Profile",
              style: TextStyle(color: AppColors.black),
            ),
          ),
        ],
      ),
      body: screens[_currentIndex],
    );
  }
}
