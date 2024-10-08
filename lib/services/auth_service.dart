import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soccer_app/Screens/Account/login_screen.dart';
import 'package:soccer_app/Screens/Dashboard%20Screens/fan_dashboard_screen.dart';
import 'package:soccer_app/Screens/Dashboard%20Screens/player_dashboard_screen.dart';
import 'package:soccer_app/Screens/Widgets/bottomNavBar.dart';

import '../models/user_model.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the currently logged in user
  Future<UserModel?> getUser() async {
    User? firebaseUser = auth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        log("User document does not exist.");
        return null;
      }
    } else {
      log("No Firebase user is currently logged in.");
      return null;
    }
  }

  // Sign up method
  Future<void> signUp(String email, String password, UserModel userModel,
      String role, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Add user data to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(userModel.toJson());

      // Save user data to Shared Preferences
      await saveUserToPreferences(userCredential.user!.uid, email, role);

      // Navigate to the appropriate dashboard based on user role
      navigateToRoleBasedScreen(role, context);

      log("User signed up: ${userCredential.user?.uid}");
    } on FirebaseAuthException catch (e) {
      handleAuthError(e);
    } catch (e) {
      log('Sign up error: $e');
    }
  }

  // Login method
  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email, password: password);

      log('UserCredential: $userCredential');
      User? user = userCredential.user;

      if (user != null) {
        log('User ID: ${user.uid}');
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .get();

        log('UserDoc exists: ${userDoc.exists}');

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          log("My User ==> $userData");

          // Ensure the role is correctly retrieved
          String role = userData['role'];
          log("User role: $role");

          // Save user data to SharedPreferences (if needed)
          await saveUserToPreferences(user.uid, email, role);

          // Navigate to role-based screen
          navigateToRoleBasedScreen(role, context);
        } else {
          Fluttertoast.showToast(
            msg: "User data not found.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    } catch (e) {
      log('Login error: $e');

      Fluttertoast.showToast(
        msg: "Login failed. Please check your credentials.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Save user data to SharedPreferences
  Future<void> saveUserToPreferences(
      String uid, String email, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('email', email);
    await prefs.setString('role', role);
  }

  // Navigate to the appropriate dashboard based on user role
  void navigateToRoleBasedScreen(String? role, BuildContext context) {
    if (role == "Team Coach") {
      Get.offAll(() => const BottomNavBarScreen());
    } else if (role == "Player") {
      Get.offAll(() => const PlayerDashboardScreen());
    } else if (role == "Fan") {
      Get.offAll(() => const FanDashboardScreen());
    } else {
      log('Unknown user role: $role');
      Fluttertoast.showToast(
        msg: "Unknown role. Please contact support.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Handle Firebase authentication errors
  void handleAuthError(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      Fluttertoast.showToast(
        msg: "Provided password is too weak",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else if (e.code == 'email-already-in-use') {
      Fluttertoast.showToast(
        msg: "The account already exists for that email.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Sign out method
  Future<void> signOut(BuildContext context) async {
    try {
      await auth.signOut();
      await clearUserPreferences(); // Clear the saved preferences
      Get.snackbar('title', 'Succesfuly signedOut');

      Get.offAll(() => const LoginScreen());
    } catch (e) {
      Get.snackbar('title', 'Error logging out. Please try again.');
    }
  }

  Future<void> clearUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
