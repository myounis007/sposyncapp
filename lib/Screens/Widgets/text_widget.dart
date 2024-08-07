// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

// Small Text Widget
class SmallText extends StatelessWidget {
  String title;
  double? fontSize;
  VoidCallback? onPressed;
  Color? color;
  SmallText(
      {super.key,
      required this.title,
      this.onPressed,
      this.fontSize = 14,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: fontSize, color: color),
      ),
    );
  }
}

// Large Text Widget
class LargeText extends StatelessWidget {
  String title;
  double? fontSize;
  Color? color;
  LargeText(
      {super.key,
      required this.title,
      this.fontSize = 24,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: fontSize, fontWeight: FontWeight.bold, color: color),
    );
  }
}

// Medium text widget
class MediumText extends StatelessWidget {
  String title;
  double? fontSize;
  Color? color;
  MediumText(
      {super.key,
      required this.title,
      this.fontSize = 16,
      this.color = Colors.black,
      int? size,
      FontWeight? fontWeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.w500, color: color),
      ),
    );
  }
}
