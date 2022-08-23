import 'package:flutter/material.dart';
import 'package:instagram_clone/utilis/color.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  final TextInputType textType;
  const TextInputField({
    Key? key,
    required this.controller,
     this.isPassword = false,
    required this.hintText,
    required this.textType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: controller,
      keyboardType: textType,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: blueColor,width: 1)),
        enabledBorder: inputBorder,
        contentPadding: const EdgeInsets.all(8)
      ),
    );
  }
}
