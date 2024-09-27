import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/validation_utils.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_app_icon.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:flutter_sample/src/widgets/common_input.dart';
import 'package:provider/provider.dart';

// ログイン画面
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void login() {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      } else {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final email = emailController.text;
        final password = passwordController.text;
        // ログインメソッドを呼び出す
        authProvider.login(email, password);
      }
    }

    return Scaffold(
      appBar: const CommonAppBar(title: 'Login'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Snackbarを表示するためのコールバック
              if (authProvider.message != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(authProvider.message!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              }
              // ローディングダイアログを表示・非表示するためのコールバック
              if (authProvider.isLoading) {
                DialogUtils.showLoadingDialog(context);
              } else {
                DialogUtils.hideLoadingDialog(context);
              }
            });
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const CommonAppIcon(size: 100),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonInput(
                            label: 'Email',
                            controller: emailController,
                            obscureText: false,
                            validator: (value) =>
                                ValidationUtils.validateEmail(value)),
                        const SizedBox(height: 30),
                        CommonInput(
                            label: 'Password',
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) =>
                                ValidationUtils.validatePassword(value)),
                        const SizedBox(height: 50),
                        CommonButton(
                          text: 'Login',
                          onPressed: login,
                        ),
                        const SizedBox(height: 80),
                        GestureDetector(
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 100));
                            Navigator.pushNamed(context, '/password/reset');
                          },
                          child: const Text(
                            'パスワードを忘れた方はこちら',
                            style: TextStyle(
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 100));
                            Navigator.pushNamed(context, '/register/input');
                          },
                          child: const Text(
                            '会員登録がまだの方はこちら',
                            style: TextStyle(
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            );
          },
        ),
      ),
    );
  }
}
