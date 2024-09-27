import 'package:flutter/material.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
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
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    DialogUtils.showLoadingDialog(context);
    
    // パスワードリセット処理(未実装)
    Future.delayed(const Duration(seconds: 2));
    //await authProvider.resetPassword(emailController.text);

    if (!mounted) return;

    DialogUtils.hideLoadingDialog(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'パスワードリセットの処理は未実装です',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold
          )
        )
      )
    );

    Navigator.of(context).pop();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'パスワードリセット'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _forKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              CommonInput(
                label: 'Email',
                controller: emailController,
                obscureText: false,
                validator: (value) => ValidationUtils.validateEmail(value),
              ),
              const SizedBox(height: 20),
              CommonButton(
                text: 'パスワードリセット',
                onPressed: () {
                  final isValid = _forKey.currentState!.validate(); 
                  if (!isValid) {
                    return;
                  } else {
                    resetPassword();
                  }
                },
              ),
            ],
          )
        ),
      ),
    );
  }
}