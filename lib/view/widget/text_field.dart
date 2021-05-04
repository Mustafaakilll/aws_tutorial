import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(this.controller, this.text, this.isSecure, {Key key}) : super(key: key);

  final String text;
  final bool isSecure;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        obscureText: isSecure,
        decoration: InputDecoration(
          labelText: text,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
}
