import 'package:flutter/material.dart';
import 'package:flutter_sample/src/services/setting_service.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/validation_utils.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:flutter_sample/src/widgets/common_drawer.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser () async {
    final user = await settingService.getUser();
    emailController.text = user['email'];
  }

  void updateAccountInfo() async {
    // ローディングダイアログを表示
    DialogUtils.showLoadingDialog(context);

    await settingService.updateUser(emailController.text, passwordController.text);

    if (!mounted) return;

    // アカウント情報更新処理
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('アカウント情報を更新しました',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold
          )
        ),
      )
    );
    
    // ローディングダイアログを非表示
    DialogUtils.hideLoadingDialog(context);

    // 画面を閉じる
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      endDrawer: const CommonDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CommonInput(
                label: 'Email',
                controller: emailController,
                obscureText: false,
                validator: (value) => ValidationUtils.validateEmail(value),
              ),
              const SizedBox(height: 30),
              CommonPasswordInput(
                label: 'Password',
                controller: passwordController,
                validator: (value) => ValidationUtils.validatePassword(value),
              ),
              const SizedBox(height: 30),
              CommonPasswordInput(
                label: 'Confirm Password',
                controller: confirmPasswordController,
                validator: (value) => ValidationUtils.validateConfirmPassword(value, passwordController.text),
                showToggleIcon: false,
              ),
              const SizedBox(height: 50),
              CommonButton(
                text: 'アカウント情報を更新',
                onPressed: () {
                  final isValid = _formKey.currentState!.validate();
                  if (!isValid) {
                    return;
                  } else {
                    updateAccountInfo(); 
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}