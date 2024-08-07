// ignore_for_file: implicit_call_tearoffs

import 'dart:developer';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:soccer_app/Screens/Account/otp_screen.dart';
import 'package:soccer_app/Screens/Widgets/round_button.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/Screens/Widgets/textfield_widget.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';
import '../../models/user_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Variable
  bool isChecked = false;
  bool isHidden = true;
  // Loading state
  bool isLoading = false;
  String? role;

  // Formkey
  final formkey = GlobalKey<FormState>();

  String dropdownValue = 'Role';
  bool roleSelected = false;
  TextEditingController ownerTypeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController teamController = TextEditingController();
  // Controllers for Coach
  TextEditingController coachName = TextEditingController();
  TextEditingController coachEmail = TextEditingController();
  TextEditingController coachPassword = TextEditingController();
  TextEditingController coachTeam = TextEditingController();
  TextEditingController coachContact = TextEditingController();
  TextEditingController coachExperience = TextEditingController();

  // Controllers for Player
  TextEditingController playerName = TextEditingController();
  TextEditingController playerEmail = TextEditingController();
  TextEditingController playerPassword = TextEditingController();
  TextEditingController playerPosition = TextEditingController();
  TextEditingController playerContact = TextEditingController();
  // Controllers for Fan
  TextEditingController fanName = TextEditingController();
  TextEditingController fanEmail = TextEditingController();
  TextEditingController fanPassword = TextEditingController();
  TextEditingController fanFavouriteTeam = TextEditingController();

  // Function to Select Role
  void showRoleSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: MediumText(title: 'Select Your Role'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <String>[
              'Team Coach',
              'Player',
              'Fan',
            ].map<Widget>((String value) {
              return ListTile(
                title: Text(value),
                onTap: () {
                  setState(() {
                    dropdownValue = value;
                    ownerTypeController.text = value;
                    roleSelected = true;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget getRoleSpecificWidgets() {
    double height = MediaQuery.sizeOf(context).height;
    switch (dropdownValue) {
      case 'Team Coach':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediumText(title: 'Name:'),
            TextFieldWidget(
              keyboardType: TextInputType.name,
              hintText: 'Enter Name',
              controller: coachName,
              prefixIcon: Icons.person_2,
              validator: RequiredValidator(errorText: 'Please enter name'),
            ),
            SizedBox(height: height * .01),
            MediumText(title: 'Email:'),
            TextFieldWidget(
              keyboardType: TextInputType.emailAddress,
              hintText: 'Enter Email',
              controller: coachEmail,
              prefixIcon: Icons.email_outlined,
              validator: RequiredValidator(errorText: 'Please enter email'),
            ),
            SizedBox(height: height * .01),
            MediumText(title: 'Password:'),
            TextFieldWidget(
              validator:
                  RequiredValidator(errorText: 'Please Enter your Password'),
              obsecureText: isHidden,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Enter your Password',
              controller: coachPassword,
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
                  )),
            ),
            SizedBox(height: height * .01),
            MediumText(title: 'Team Name:'),
            TextFieldWidget(
                keyboardType: TextInputType.name,
                hintText: 'Enter Team Name',
                controller: coachTeam,
                prefixIcon: Icons.person_2,
                validator:
                    RequiredValidator(errorText: 'Please enter team name')),
            SizedBox(height: height * .01),
            MediumText(title: 'Contact Info:'),
            TextFieldWidget(
                hintText: 'Enter Contact Info',
                controller: coachContact,
                prefixIcon: Icons.contact_page_outlined,
                validator:
                    RequiredValidator(errorText: 'Please enter contact')),
            SizedBox(height: height * .01),
            MediumText(title: 'Experience:'),
            TextFieldWidget(
                keyboardType: TextInputType.number,
                hintText: 'Enter Experience',
                controller: coachExperience,
                prefixIcon: Icons.e_mobiledata,
                validator:
                    RequiredValidator(errorText: 'Please enter experience')),
          ],
        );
      case 'Player':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediumText(title: 'Name:'),
            TextFieldWidget(
              keyboardType: TextInputType.name,
              hintText: 'Enter Name',
              controller: playerName,
              validator: RequiredValidator(errorText: 'Please enter name'),
              prefixIcon: Icons.person_2,
            ),
            SizedBox(height: height * .01),
            MediumText(title: 'Email:'),
            TextFieldWidget(
              keyboardType: TextInputType.emailAddress,
              hintText: 'Enter Email',
              controller: playerEmail,
              validator: RequiredValidator(errorText: 'Please enter email'),
              prefixIcon: Icons.email_outlined,
            ),
            SizedBox(height: height * .01),
            MediumText(title: 'Password:'),
            TextFieldWidget(
              validator:
                  RequiredValidator(errorText: 'Please Enter your Password'),
              obsecureText: isHidden,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Enter your Password',
              controller: playerPassword,
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
                  )),
            ),
            SizedBox(height: height * .01),
            MediumText(title: 'Position:'),
            TextFieldWidget(
                hintText: 'Enter Position',
                controller: playerPosition,
                prefixIcon: Icons.person_3_outlined,
                validator:
                    RequiredValidator(errorText: 'Please enter position')),
            SizedBox(height: height * .01),
            MediumText(title: 'Contact Info:'),
            TextFieldWidget(
                hintText: 'Enter Contact Info',
                controller: playerContact,
                prefixIcon: Icons.email_outlined,
                validator:
                    RequiredValidator(errorText: 'Please enter contact info')),
          ],
        );
      case 'Fan':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediumText(title: 'Email:'),
            TextFieldWidget(
                keyboardType: TextInputType.emailAddress,
                hintText: 'Enter Email',
                controller: fanEmail,
                prefixIcon: Icons.email_outlined,
                validator: RequiredValidator(errorText: 'Please enter email')),
            SizedBox(height: height * .01),
            MediumText(title: 'Password:'),
            TextFieldWidget(
              validator:
                  RequiredValidator(errorText: 'Please Enter your Password'),
              obsecureText: isHidden,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Enter your Password',
              controller: fanPassword,
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
                  )),
            ),
            SizedBox(height: height * .01),
            MediumText(title: 'Favourite Team:'),
            TextFieldWidget(
              keyboardType: TextInputType.name,
              hintText: 'Enter Favourite Team:',
              controller: fanFavouriteTeam,
              validator: RequiredValidator(
                  errorText: 'Please enter favourite team name'),
              prefixIcon: Icons.supervisor_account,
            ),
          ],
        );
      default:
        return Container();
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
                      topRight: Radius.circular(30))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SingleChildScrollView(
                  child: Form(
                    key: formkey,
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
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              SizedBox(
                                height: height * .012,
                              ),
                              LargeText(title: "Let's create account for you"),
                              SmallText(
                                title: "Let's sign up for explore .",
                                color: AppColors.grey500,
                              ),
                              Image.asset(
                                'assets/images/Soccer Logo.jpg',
                                height: height * .12,
                              ),
                              LargeText(title: 'Sposync!'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        MediumText(title: 'Select your Role:'),
                        TextFieldWidget(
                          onPressed: () {
                            showRoleSelectionDialog(context);
                          },
                          readOnly: true,
                          hintText: 'Select Role',
                          controller: ownerTypeController,
                          prefixIcon: Icons.person,
                          suffixIcon: IconButton(
                              onPressed: () {
                                showRoleSelectionDialog(context);
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: AppColors.red,
                              )),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        if (roleSelected) getRoleSpecificWidgets(),
                        SizedBox(
                          height: height * .01,
                        ),
                        // Row(
                        //   children: [
                        //     Checkbox(
                        //         activeColor: AppColors.red,
                        //         value: isChecked,
                        //         onChanged: (value) {
                        //           setState(() {
                        //             isChecked = value!;
                        //           });
                        //         }),
                        //     // InkWell(
                        //     //   onTap: () {
                        //     //     setState(() {
                        //     //       isChecked = !isChecked;
                        //     //     });
                        //     //   },
                        //     //   child: SmallText(
                        //     //     title: "Keep me signed in",
                        //     //     color: AppColors.grey500,
                        //     //   ),
                        //     // ),
                        //     const Spacer(),
                        //   ],
                        // ),
                        SizedBox(
                          height: height * .04,
                        ),
                        RoundButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });

                                // await saveData(dropdownValue);

                                setState(
                                  () {
                                    isLoading = false;
                                  },
                                );

                                UserModel userModel;

                                switch (dropdownValue) {
                                  case 'Team Coach':
                                    userModel = UserModel(
                                      role: dropdownValue,
                                      name: coachName.text,
                                      email: coachEmail.text,
                                      team: coachTeam.text,
                                      password: coachPassword.text,
                                      contact: coachContact.text,
                                      experience:
                                          int.parse(coachExperience.text),
                                    );

                                    if (await EmailOTP.sendOTP(
                                        email: coachEmail.text)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("OTP has been sent"),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("OTP failed sent")));
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OTPScreen(
                                          myUserModel: userModel,
                                          email: coachEmail.text,
                                          password: coachPassword.text,
                                          role: 'Team Coach',
                                        ),
                                      ),
                                    );
                                    // coachEmail.clear();
                                    // coachContact.clear();
                                    // coachName.clear();
                                    // coachExperience.clear();
                                    // coachPassword.clear();
                                    // coachTeam.clear();

                                    break;
                                  case 'Player':
                                    userModel = UserModel(
                                        email: playerEmail.text,
                                        name: playerName.text,
                                        role: dropdownValue,
                                        position: playerPosition.text,
                                        contact: playerContact.text,
                                        password: playerPassword.text);

                                    if (await EmailOTP.sendOTP(
                                        email: playerEmail.text)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("OTP has been sent")));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("OTP failed sent")));
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OTPScreen(
                                          myUserModel: userModel,
                                          email: playerEmail.text,
                                          password: playerEmail.text,
                                          role: 'Player',
                                        ),
                                      ),
                                    );
                                    // playerContact.clear();
                                    // playerEmail.clear();
                                    // playerName.clear();
                                    // playerPassword.clear();
                                    // playerPosition.clear();

                                    break;
                                  case 'Fan':
                                    log('Sending OTP to: ${fanEmail.text}');
                                    userModel = UserModel(
                                        role: dropdownValue,
                                        email: fanEmail.text,
                                        password: fanPassword.text,
                                        favouriteTeam: fanFavouriteTeam.text);

                                    if (await EmailOTP.sendOTP(
                                        email: fanEmail.text)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("OTP has been sent")));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("OTP failed sent")));
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OTPScreen(
                                          myUserModel: userModel,
                                          email: fanEmail.text,
                                          password: fanPassword.text,
                                          role: 'Fan',
                                        ),
                                      ),
                                    );
                                    // fanEmail.clear();
                                    // fanFavouriteTeam.clear();
                                    // fanName.clear();
                                    // fanPassword.clear();
                                    break;
                                }
                              }
                            },
                            // ignore: prefer_const_constructors
                            title: 'Send OTP'),
                        // SizedBox(height: height * .01),
                        // Center(
                        //   child: SmallText(
                        //     title: "You can connect with",
                        //     color: AppColors.grey500,
                        //   ),
                        // ),
                        SizedBox(height: height * .01),
                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     SizedBox(
                        //       width: width * .01,
                        //     ),
                        //     SmallContainer(
                        //       child: Center(
                        //         child: Row(
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: [
                        //             Image.asset(
                        //               'assets/images/google.png',
                        //               height: height * .04,
                        //             ),
                        //             SizedBox(
                        //               width: width * .03,
                        //             ),
                        //             const Text(
                        //               'Sign in with Google',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 14,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: width * .01,
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: height * .01,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
