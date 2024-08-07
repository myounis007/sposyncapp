// ignore_for_file: use_build_context_synchronously

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:soccer_app/Screens/Widgets/round_button.dart';
import 'package:soccer_app/models/user_model.dart';

import '../../services/auth_service.dart';
import '../Widgets/app_colors.dart';
import '../Widgets/text_widget.dart';

class OTPScreen extends StatefulWidget {
  final UserModel? myUserModel;
  final String? email;
  final String? password;
  final String? role;
  const OTPScreen(
      {super.key,
      this.myUserModel,
      this.email,
      this.password,
      this.role,
      String? name,
      EmailOTP? otp});

  @override
  // ignore: library_private_types_in_public_api
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  FirebaseService authenticaton = FirebaseService();
  OtpFieldController otpController = OtpFieldController();
  TextEditingController coachEmail = TextEditingController();
  String? otpPIn;
  String _errorText = '';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.apptheme,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * .099,
            ),
            Center(
              child: Image.asset(
                'assets/images/Soccer Logo.jpg',
                height: height * .14,
              ),
            ),
            Center(
              child: LargeText(
                title: "OTP",
                color: AppColors.red,
              ),
            ),
            MediumText(
              title:
                  'Please check your Email.\nA 4 digit code has been sent to your Email.',
              color: AppColors.grey500,
            ),
            SizedBox(
              height: height * .02,
            ),
            OTPTextField(
              controller: otpController,
              length: 6,
              width: MediaQuery.of(context).size.width,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldWidth: 45,
              fieldStyle: FieldStyle.box,
              outlineBorderRadius: 15,
              style: const TextStyle(fontSize: 17),
              onChanged: (pin) {
                setState(() {
                  otpPIn = pin;
                });
                print("Changed: $pin");
              },
              onCompleted: (pin) {
                setState(() {
                  otpPIn = pin;
                });
                print("Completed: $pin");
              },
            ),
            if (_errorText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorText,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediumText(
                  title: "Didn't receive any code?",
                  color: AppColors.grey500,
                ),
                TextButton(
                  onPressed: () async {
                    if (await EmailOTP.sendOTP(email: widget.email!)) {
                      Fluttertoast.showToast(
                          msg: "6 digit Otp has been Sent",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Otp Sending Failed",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    // Implement resend OTP logic here
                  },
                  child: MediumText(
                    title: 'RESEND',
                    color: AppColors.red,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * .1,
            ),
            SmallButton(
              onPressed: () async {
                if (otpPIn != null && otpPIn!.length == 6) {
                  if (EmailOTP.verifyOTP(otp: otpPIn!) == true) {
                    if (widget.role == 'Player') {
                      await authenticaton.signUp(
                        widget.email!,
                        widget.password!,
                        widget.myUserModel!,
                        widget.role!,
                        context,
                      );
                    } else if (widget.role == 'Fan') {
                      await authenticaton.signUp(
                        widget.email!,
                        widget.password!,
                        widget.myUserModel!,
                        widget.role!,
                        context,
                      );
                    } else {
                      await authenticaton.signUp(
                        widget.email!,
                        widget.password!,
                        widget.myUserModel!,
                        widget.role!,
                        context,
                      );
                    }
                  }
                } else {
                  setState(
                    () {
                      _errorText = 'Please enter a valid 6-digit OTP.';
                    },
                  );
                }
              },
              title: "Verify",
            ),
            const SizedBox(
              height: 5,
            ),
            SmallButton(
              title: 'Go back',
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
