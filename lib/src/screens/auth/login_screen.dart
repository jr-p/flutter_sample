import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/route_utils.dart';
import 'package:flutter_sample/src/utils/snackbar_utils.dart';
import 'package:flutter_sample/src/utils/validation_utils.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_app_icon.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:flutter_sample/src/widgets/common_input.dart';
import 'package:flutter_sample/src/widgets/common_navigator_text.dart';
import 'package:provider/provider.dart';

// ログイン画面
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void login() async {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) return;

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final email = _emailController.text;
      final password = _passwordController.text;

      DialogUtils.showLoadingDialog(context);

      // ログインメソッドを呼び出す
      await authProvider.login(email, password);

      if (!context.mounted) return;
      DialogUtils.hideLoadingDialog(context);

      if (authProvider.message != null) {
        SnackbarUtils.showSnackbar(context, authProvider.message!); 
      } else {
        RouteUtils.navigateToAuthWrapper(context);
      }
    }

    return Scaffold(
      appBar: const CommonAppBar(title: 'Login'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
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
                      controller: _emailController,
                      obscureText: false,
                      validator: (value) => ValidationUtils.validateEmail(value)
                    ),
                    const SizedBox(height: 30),
                    CommonInput(
                      label: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) => ValidationUtils.validatePassword(value)
                    ),
                    const SizedBox(height: 50),
                    CommonButton(
                      text: 'Login',
                      onPressed: login,
                    ),
                    const SizedBox(height: 80),
                    CommonNavigatorText(
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 100));
                        Navigator.pushNamed(context, '/password/reset');
                      },
                      text: 'パスワードを忘れた方はこちら'
                    ),
                    const SizedBox(height: 30),
                    CommonNavigatorText(
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 100));
                        Navigator.pushNamed(context, '/register/input');
                      },
                      text:'会員登録がまだの方はこちら',
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
