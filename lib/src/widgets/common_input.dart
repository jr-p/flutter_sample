import 'package:flutter/material.dart';

// 共通の入力フォーム
class CommonInput extends StatelessWidget{
  const CommonInput({
    super.key,
    required this.label,
    required this.controller,
    required this.obscureText,
    this.hintText,
    this.onChanged,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}