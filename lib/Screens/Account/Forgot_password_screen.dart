// ignore_for_file: implicit_call_tearoffs

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:soccer_app/Screens/Account/otp_screen.dart';
import 'package:soccer_app/Screens/Widgets/round_button.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';

import '../Widgets/textfield_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final formkey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Soccer Logo.jpg',
                height: height * .14,
              ),
              LargeText(
                title: "Forgot Password?",
                color: AppColors.black,
              ),
              MediumText(
                title: "Enter your email to continue",
                color: AppColors.grey500,
                fontSize: 13,
              ),
              SizedBox(
                height: height * .06,
              ),
              TextFieldWidget(
                validator:
                    RequiredValidator(errorText: 'Please Enter valid Email'),
                keyboardType: TextInputType.emailAddress,
                hintText: 'Enter your Email',
                controller: email,
                prefixIcon: Icons.email_outlined,
              ),
              SizedBox(
                height: height * .1,
              ),
              SmallButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OTPScreen()));
                  }
                },
                title: "Submit",
              )
            ],
          ),
        ),
      ),
    );
  }
}
