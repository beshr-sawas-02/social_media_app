import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
        required this.label,
        required this.hint,
        this.prefixIcon,
        this.textInputType,
        required this.controller,
        this.isPassword});

  final String label;
  final String hint;

  final IconData? prefixIcon;
  final TextInputType? textInputType;

  final TextEditingController controller;

  final bool? isPassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        obscureText: isPassword ?? false,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          prefix: prefixIcon ==null?null : Icon(prefixIcon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hint,
          labelText: label,
        ),
      ),
    );
  }
}
