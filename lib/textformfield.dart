import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimaryTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final OutlineInputBorder? border;
  final double width;
  final double height;
  final Color? fillColor;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const PrimaryTextFormField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.border,
    required this.width,
    required this.height,
    this.fillColor,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: fillColor ?? Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: border,
          hintText: hintText,
          filled: true,
          fillColor: fillColor ?? Colors.white,
          hintStyle: TextStyle(color: Colors.black54),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }
}