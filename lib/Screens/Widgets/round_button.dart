// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';

class RoundButton extends StatelessWidget {
  bool isLoading = false;
  String title;
  double? height;
  double? width;
  VoidCallback? onPressed;
  RoundButton({
    super.key,
    required this.title,
    this.onPressed,
    MaterialColor? color,
    this.height,
    this.width,
    bool? loading,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height * .06,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: MediumText(
            title: title,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

//Small Container

class SmallContainer extends StatelessWidget {
  Widget? child;

  SmallContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Expanded(
      child: Container(
          height: height * .06,
          width: width * .9,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 223, 141, 135),
            borderRadius: BorderRadius.circular(10),
          ),
          child: child),
    );
  }
}

// Small Round Button
class SmallButton extends StatelessWidget {
  String title;
  VoidCallback? onPressed;
  Widget? child;
  SmallButton({super.key, this.child, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return InkWell(
      onTap: onPressed,
      child: Container(
          height: height * .05,
          width: width * .4,
          decoration: BoxDecoration(
            color: AppColors.red,
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(color: AppColors.white),
            ),
          )),
    );
  }
}
