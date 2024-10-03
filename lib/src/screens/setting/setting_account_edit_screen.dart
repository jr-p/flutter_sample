import 'package:flutter/material.dart';
import 'package:flutter_sample/src/services/api_exception.dart';
import 'package:flutter_sample/src/services/setting_service.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/snackbar_utils.dart';
import 'package:flutter_sample/src/utils/validation_utils.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:flutter_sample/src/widgets/common_input.dart';
import 'package:flutter_sample/src/widgets/common_password_input.dart';

class SettingAccountEditScreen extends StatefulWidget {
  const SettingAccountEditScreen({ super.key });

  @override
  State<SettingAccountEditScreen> createState() => _SettingAccountEditScreenState();
}

class _SettingAccountEditScreenState extends State<SettingAccountEditScreen> {
  final SettingService settingService = SettingService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    getUser();
  }

  void getUser () async {
    final user = await settingService.getUser();
    _emailController.text = user.email;
  }

  void updateAccountInfo() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    // ローディングダイアログを表示
    DialogUtils.showLoadingDialog(context);

    try {
      await settingService.updateUser(_emailController.text, _passwordController.text);
      if (!mounted) return;
      SnackbarUtils.showSnackbar(context, 'アカウント情報を更新しました');
      DialogUtils.hideLoadingDialog(context);
      Navigator.of(context).pop();

    } on ApiException catch (e) {
      DialogUtils.hideLoadingDialog(context);
      SnackbarUtils.showSnackbar(context, e.message);
    
    } catch (e) {
      DialogUtils.hideLoadingDialog(context);
      SnackbarUtils.showSnackbar(context, 'アカウント情報の更新に失敗しました');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'アカウント情報変更'), 
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('新しいアカウント情報を入力してください', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CommonInput(
                    label: 'Email',
                    controller: _emailController,
                    obscureText: false,
                    validator: (value) => ValidationUtils.validateEmail(value),
                  ),
                  const SizedBox(height: 30),
                  CommonPasswordInput(
                    label: 'Password',
                    controller: _passwordController,
                    validator: (value) => ValidationUtils.validatePassword(value),
                  ),
                  const SizedBox(height: 30),
                  CommonPasswordInput(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    validator: (value) => ValidationUtils.validateConfirmPassword(value, _passwordController.text),
                    showToggleIcon: false,
                  ),
                  const SizedBox(height: 50),
                  CommonButton(
                    text: 'アカウント情報を更新',
                    onPressed: updateAccountInfo,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}