import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soccer_app/Screens/Widgets/bottomNavBar.dart';


import '../Dashboard Screens/fan_dashboard_screen.dart';
import '../Dashboard Screens/player_dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  Future<void> _startLoading() async {
    await Future.delayed(const Duration(seconds: 3));
    await _checkLogin();
  }

  Future<void> _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    String? role = prefs.getString('role');

    log("User ID: $uid"); // Debug statement
    log("User Role: $role"); // Debug statement

    if (uid != null && role != null) {
      _navigateToRoleBasedScreen(role);
    } else {
      Get.offAll(const LoginScreen());
    }
  }

  void _navigateToRoleBasedScreen(String role) {
    switch (role) {
      case 'Team Coach':
        Get.offAll(const BottomNavBarScreen());
        break;
      case 'Fan':
        Get.offAll( const FanDashboardScreen());
        break;
      case 'Player':
        Get.offAll(const PlayerDashboardScreen());
        break;
      default:
        Get.offAll(const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/Soccer Logo.jpg', // Replace with your image path
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
