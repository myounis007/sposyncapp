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
  final FirebaseAuth authSignUp = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth signout = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final formkey = GlobalKey<FormState>();
   final FirebaseAuth _auth = FirebaseAuth.instance;
  

 // In your FirebaseService class
Future<UserModel?> getUser() async {
  User? firebaseUser = _auth.currentUser;
  if (firebaseUser != null) {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    
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


// for signup
  Future<void> signUp(
    String email,
    String password,
    UserModel userModel,
    String role,
    context,
  ) async {
    try {
      UserCredential userCredential =
          await authSignUp.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user data to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(userModel.toJson())
          .then((value) {
        if (role == "Team Coach") {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'BottomNavBarScreen',
            (route) => false,
          );
        } else if (role == "Player") {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'PlayerDashboardScreen',
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'FanDashboardScreen',
            (route) => false,
          );
        }
      });

      log("User signed up: ${userCredential.user?.uid}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: "Provided password is too weak",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        log('your password must be 6 character or more.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            webShowClose: true,
            fontSize: 16.0);
        log('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  // login ❌❌❌❌❌❌❌❌❌❌❌❌❌
  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    log(email);
    log(password);
    try {
      // Check if the email exists in Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1) // Limit the result to 1 document
              .get();

      if (snapshot.docs.isEmpty) {
        // Handle the case where no user document exists
        log('User does not exist');
        Fluttertoast.showToast(
          msg: "User does not exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      // Retrieve the user's document
      DocumentSnapshot<Map<String, dynamic>> userDoc = snapshot.docs.first;

      // Check if the provided password matches the stored password
      String storedPassword =
          userDoc['password']; // Retrieve the password from Firestore

      if (password == storedPassword) {
        // Authentication successful
        String uid = userDoc.id;
        UserModel user = UserModel.fromJson(userDoc.data()!);

        // Save user data to SharedPreferences
        await saveUserToPreferences(uid, email, user.role!);

        // Determine the role and navigate to the appropriate screen
        navigateToRoleBasedScreen(user.role, context);
      } else {
        // Handle incorrect password
        log('Incorrect password');
        Fluttertoast.showToast(
          msg: "Incorrect password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      // Handle other errors
      log('Login error: $e');
      Fluttertoast.showToast(
        msg: "An error occurred during login. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> saveUserToPreferences(
      String uid, String email, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('email', email);
    await prefs.setString('role', role);
  }

// for navigation
  void navigateToRoleBasedScreen(String? role, BuildContext context) {
    if (role == "Team Coach") {
      Get.offAll(() => const BottomNavBarScreen());
    } else if (role == "Player") {
      Get.offAll(() =>  PlayerDashboardScreen());
    } else if (role == "Fan") {
      Get.offAll(() => const FanDashboardScreen());
    } else {
      // Handle unknown role
      log('Unknown user role: $role');
      Fluttertoast.showToast(
        msg: "Unknown role. Please contact support.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<UserModel?> fetchUserData(String uid) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Future<void> saveLoginState(bool isLoggedIn, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('role', role);
  }

  //signOut google
  Future<void> signOut(BuildContext context) async {
    await signout.signOut();
    Get.offAll(const LoginScreen());
  }

  // logout firebase
  Future<void> firebaseLogout(BuildContext context) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully logged out'),
          backgroundColor: Colors.green,
        ),
      );
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out. Please try again.')),
      );
    }
  }
}
