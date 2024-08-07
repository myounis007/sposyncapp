// ignore_for_file: must_be_immutable, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:soccer_app/Screens/Widgets/app_colors.dart';

class CustomTextTField extends StatelessWidget {
  String? hintText;
  bool readOnly;
  Color? color;
  TextEditingController? controller;
  IconData? prefixIcon;
  VoidCallback? onTap;
  Widget? child;
  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;
  IconData? suffixIcon;

  CustomTextTField({
    super.key,
    this.controller,
    required this.readOnly,
    this.prefixIcon,
    this.validator,
    this.child,
    this.color = Colors.white,
    this.onChanged,
    this.suffixIcon,
    this.hintText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: TextFormField(
        validator: validator,
        onChanged: onChanged,
        readOnly: readOnly,
        onTap: onTap,
        controller: controller,
        decoration: InputDecoration(
          fillColor: color,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
