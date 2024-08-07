import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soccer_app/Screens/Dashboard%20Screens/player_dashboard_screen.dart';
import 'package:soccer_app/Screens/Widgets/bottomNavBar.dart';

import 'Screens/Account/splash_screen.dart';
import 'Screens/Dashboard Screens/fan_dashboard_screen.dart';
import 'Screens/Widgets/app_colors.dart';
import 'firebase_options.dart';

Future<void> main() async {
  EmailOTP.config(
    appName: 'Sposync',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v4,
    otpLength: 6,
   
    appEmail: 'myounis4707@gmail.com',
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.white, centerTitle: true),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryTextTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        'BottomNavBarScreen': (context) => const BottomNavBarScreen(),
        'PlayerDashboardScreen': (context) => const PlayerDashboardScreen(),
        'FanDashboardScreen': (context) => const FanDashboardScreen(),
      },
    );
  }
}
