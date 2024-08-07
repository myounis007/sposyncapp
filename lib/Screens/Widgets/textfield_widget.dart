// ignore_for_file: must_be_immutable, implicit_call_tearoffs

import 'package:flutter/material.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  TextEditingController? controller;
  String hintText;
  String? initialValue;
  bool obsecureText;
  bool? readOnly;
  double? fontSize;
  Widget? child;
  InputDecoration? decoration;
  String? Function(String?)? validator;
  VoidCallback? onPressed;
  TextInputType? keyboardType;
  IconData? prefixIcon;
  Widget? suffixIcon;
  TextFieldWidget(
      {super.key,
      required this.hintText,
      this.controller,
      this.child,
      this.initialValue,
      this.decoration,
      this.readOnly = false,
      this.validator,
      this.obsecureText = false,
      this.prefixIcon,
      this.onPressed,
      this.fontSize = 12,
      this.keyboardType,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      onTap: onPressed,
      readOnly: readOnly!,
      cursorColor: AppColors.red,
      validator: validator,
      obscureText: obsecureText,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5)),
          hintStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.grey500),
          hintText: hintText,
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.red,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.lightGrey,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5))),
    );
  }
}
