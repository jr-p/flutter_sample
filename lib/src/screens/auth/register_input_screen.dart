import 'package:flutter_sample/src/services/auth_service.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/validation_utils.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_app_icon.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:flutter_sample/src/widgets/common_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/src/widgets/common_password_input.dart';

// 登録情報入力画面
class RegisterInputScreen extends StatefulWidget {
  const RegisterInputScreen({super.key});

  @override
  State<RegisterInputScreen> createState() => _RegisterInputScreenState();
}

class _RegisterInputScreenState extends State<RegisterInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    authService = AuthService();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void navigateToRegisterConfirmScreen () async {
    DialogUtils.showLoadingDialog(context);

    final response = await authService.checkUser(_emailController.text);

    if (!mounted) return;

    if (response) {
      DialogUtils.hideLoadingDialog(context);
      Navigator.of(context).pushNamed('/register/confirm', arguments: {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone_number': _phoneNumberController.text,
        'password': _passwordController.text,
      });
    } else {
      // ユーザーが存在する場合
      DialogUtils.hideLoadingDialog(context);
      // メールアドレスのバリデーションエラーを表示ション
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('このメールアドレスは既に登録されています'),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Register'),
      body: SingleChildScrollView(
        // 追加
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const CommonAppIcon(size: 100),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CommonInput(
                      label: 'Name',
                      controller: _nameController,
                      obscureText: false,
                      validator: (value) => ValidationUtils.validateName(value),
                    ),
                    const SizedBox(height: 30),
                    CommonInput(
                      label: 'Email',
                      controller: _emailController,
                      obscureText: false,
                      validator: (value) =>
                          ValidationUtils.validateEmail(value),
                    ),
                    const SizedBox(height: 30),
                    CommonInput(
                      label: 'Phone Number',
                      controller: _phoneNumberController,
                      obscureText: false,
                      validator: (value) =>
                          ValidationUtils.validatePhoneNumber(value),
                    ),
                    const SizedBox(height: 30),
                    CommonPasswordInput(
                      label: 'Password',
                      controller: _passwordController,
                      validator: (value) =>
                          ValidationUtils.validatePassword(value),
                    ),
                    const SizedBox(height: 30),
                    CommonPasswordInput(
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      validator: (value) =>
                          ValidationUtils.validateConfirmPassword(
                              value, _passwordController.text),
                      showToggleIcon: false,
                    ),
                    const SizedBox(height: 50),
                    CommonButton(
                      text: 'Confirm',
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        if (!isValid) {
                          return;
                        } else {
                          navigateToRegisterConfirmScreen();
                        }
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
