import 'package:flutter/material.dart';

// 共通のパスワード入力
class CommonPasswordInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool isObscure; // 初期値としてのisObscureはfinalで定義する
  final bool showToggleIcon; // パスワード表示/非表示のアイコンを表示するかどうか

  const CommonPasswordInput({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.validator,
    this.isObscure = true, // デフォルトでtrueに設定
    this.showToggleIcon = true, // デフォルトでtrueに設定
  });

  @override
  State<CommonPasswordInput> createState() => _CommonPasswordInputState();
}

class _CommonPasswordInputState extends State<CommonPasswordInput> {
  late bool _isObscure; // 状態管理用の変数

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure; // 初期値を設定
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: _isObscure, // パスワード表示/非表示切り替え
          cursorColor: Colors.pink,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.pink, width: 2),
            ),
            suffixIcon: widget.showToggleIcon ? 
              IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure; // 表示状態の切り替え
                  });
                },
              ) : null,
          ),
          onChanged: widget.onChanged,
          validator: widget.validator,
        ),
      ],
    );
  }
}