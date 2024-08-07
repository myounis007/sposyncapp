// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:soccer_app/Screens/Account/login_screen.dart';
// import 'package:soccer_app/Screens/Dashboard%20Screens/coach_dashboard_screen..dart';
// import 'package:soccer_app/Screens/Dashboard%20Screens/fan_dashboard_screen.dart';
// import 'package:soccer_app/Screens/Dashboard%20Screens/player_dashboard_screen.dart';
// import 'package:soccer_app/Screens/Widgets/text_widget.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _startLoading();
//   }

//   Future<void> _startLoading() async {
//     // Simulate a delay while loading data
//     await Future.delayed(const Duration(seconds: 3));

//     // Load necessary data
//     await _loadData();

//     // Check if the user is logged in
//     _checkLogin();
//   }

//   Future<void> _loadData() async {
//     // TODO: Load your data here
//     // For example, fetching initial data from a database, API, etc.
//     await Future.delayed(const Duration(seconds: 1)); // Simulate data loading
//   }

//   Future<void> _checkLogin() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? uid = prefs.getString('uid');
//     String? role = prefs.getString('role');

//     if (uid != null && role != null) {
//       // User is logged in, navigate to role-specific screen
//       _navigateToRoleBasedScreen(role);
//     } else {
//       // User is not logged in, navigate to login screen
//       Get.offAll(() => const LoginScreen());
//     }
//   }

//   void _navigateToRoleBasedScreen(
//     String role,
//   ) {
//     switch (role) {
//       case 'Team Coach':
//         Get.offAll(
//           () => const CoachDashboardScreen(),
//         );
//         break;
//       case 'Fan':
//         Get.offAll(
//           () => FanDashboardScreen(),
//         );
//         break;
//       case 'Player':
//         Get.offAll(
//           () => const PlayerDashboardScreen(),
//         );
//         break;
//       default:
//         Get.offAll(() => const LoginScreen());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: Image.asset(
//               'assets/images/Soccer Logo.jpg',
//               height: 130,
//             ),
//           ),
//           Center(
//             child: LargeText(title: 'Sposync'),
//           )
//         ],
//       ),
//     );
//   }
// }
