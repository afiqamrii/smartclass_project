import 'package:flutter/material.dart';

class MyLoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool _validate = false;

  MyLoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText, // Hide password
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          errorText: _validate ? 'Value Can\'t Be Empty' : null,
        ),
        validator: validator,
      ),
    );
  }
}
