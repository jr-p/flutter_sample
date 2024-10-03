import 'package:flutter/material.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/snackbar_utils.dart';
import 'package:flutter_sample/src/utils/validation_utils.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:flutter_sample/src/widgets/common_input.dart';

// パスワードリセット画面
class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _forKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    final isValid = _forKey.currentState!.validate();
    if (!isValid) return;

    DialogUtils.showLoadingDialog(context);
    
    // パスワードリセット処理(未実装)
    Future.delayed(const Duration(seconds: 2));
    //await authProvider.resetPassword(_emailController.text);

    if (!mounted) return;

    DialogUtils.hideLoadingDialog(context);
    SnackbarUtils.showSnackbar(context, 'パスワードリセットの処理は未実装です');
    Navigator.of(context).pop();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Reset Password'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _forKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              CommonInput(
                label: 'Email',
                controller: _emailController,
                obscureText: false,
                validator: (value) => ValidationUtils.validateEmail(value),
              ),
              const SizedBox(height: 20),
              CommonButton(
                text: 'Reset Password',
                onPressed: resetPassword, 
              ),
            ],
          )
        ),
      ),
    );
  }
}