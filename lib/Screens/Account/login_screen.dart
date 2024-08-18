// ignore_for_file: must_be_immutable, implicit_call_tearoffs

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:soccer_app/Screens/Account/Forgot_password_screen.dart';
import 'package:soccer_app/Screens/Account/sign_up_screen.dart';
import 'package:soccer_app/Screens/Widgets/round_button.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/Screens/Widgets/textfield_widget.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';
import 'package:soccer_app/models/user_model.dart';
import 'package:soccer_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserModel? userModel;
  FirebaseService authLogin = FirebaseService();
  bool isChecked = false;
  bool isHidden = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> handleLogin() async {
    if (formKey.currentState!.validate()) {
      log(emailController.text);
      log(passwordController.text);
      try {
        // Call the login method with email, password, and context
        await authLogin.login(
          emailController.text.trim(),
          passwordController.text.trim(),
          context,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Login failed. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please fill in all fields.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.apptheme,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height * .95,
              width: width,
              decoration: BoxDecoration(
                color: AppColors.apptheme,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                height: height * .01,
                                width: width * .2,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              SizedBox(height: height * .012),
                              LargeText(title: 'Welcome Back!'),
                              SizedBox(height: height * .01),
                              SmallText(
                                title: "Let's sign in to continue exploring.",
                                color: AppColors.grey500,
                              ),
                              SizedBox(height: height * .012),
                              Image.asset(
                                'assets/images/Soccer Logo.jpg',
                                height: height * .14,
                              ),
                              LargeText(title: 'Sposync!'),
                            ],
                          ),
                        ),
                        SizedBox(height: height * .02),
                        MediumText(title: 'Email or Phone Number:'),
                        TextFieldWidget(
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'Please enter your email'),
                            EmailValidator(
                                errorText: 'Enter a valid email address')
                          ]),
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter your Email',
                          controller: emailController,
                          prefixIcon: Icons.email_outlined,
                        ),
                        SizedBox(height: height * .02),
                        MediumText(title: 'Password:'),
                        TextFieldWidget(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Your Password';
                            }
                            return null;
                          },
                          obsecureText: isHidden,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: 'Enter your Password',
                          controller: passwordController,
                          prefixIcon: Icons.lock_outline_rounded,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                            icon: Icon(
                              isHidden
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.red,
                            ),
                          ),
                        ),
                        SizedBox(height: height * .02),
                        Row(
                          children: [
                            // Checkbox(
                            //   activeColor: AppColors.red,
                            //   value: isChecked,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       isChecked = value!;
                            //     });
                            //   },
                            // ),
                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       isChecked = !isChecked;
                            //     });
                            //   },
                            //   child: SmallText(
                            //     title: "Keep me signed in",
                            //     color: AppColors.grey500,
                            //   ),
                            // ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: SmallText(
                                title: 'Forgot Password',
                                color: AppColors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * .06),
                        RoundButton(
                          height: 55,
                          width: width,
                          onPressed: () {
                            handleLogin();
                          },
                          title: "log In",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SmallText(
                              title: "Don't have an account?",
                              color: AppColors.black,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                              child: MediumText(
                                title: 'Sign up Now',
                                color: AppColors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
