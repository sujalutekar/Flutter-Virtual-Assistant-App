import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType textInputType;

  const MyTextFormField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.textInputAction,
    required this.validator,
    required this.onFieldSubmitted,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: textInputType,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        contentPadding: const EdgeInsets.only(left: 15),
        border: InputBorder.none,
        labelStyle: const TextStyle(color: Colors.pink),
        labelText: labelText,
      ),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
