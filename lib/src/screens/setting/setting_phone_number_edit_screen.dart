import 'package:flutter/material.dart';
import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/services/setting_service.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/validation_utils.dart';
import 'package:flutter_sample/src/widgets/auth_wrapper.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:flutter_sample/src/widgets/common_input.dart';
import 'package:provider/provider.dart';

class SettingPhoneNumberEditScreen extends StatefulWidget {
  const SettingPhoneNumberEditScreen({ super.key});
  
  @override
  State<SettingPhoneNumberEditScreen> createState() => _SettingPhoneNumberEditScreenState();
}

class _SettingPhoneNumberEditScreenState extends State<SettingPhoneNumberEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final SettingService settingService = SettingService();
  TextEditingController phoneNumberController = TextEditingController();
  AuthProvider? authProvider;
  
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> updatePhoneNumber() async {
    DialogUtils.showLoadingDialog(context);

    // 電話番号変更処理
    final result = await settingService.updatePhoneNumber(phoneNumberController.text);
    
    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('電話番号を変更しました',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
            )
          ),
        )
      );
      await authProvider?.successPhoneNumber();

      if (!mounted) return;

      DialogUtils.hideLoadingDialog(context);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
        (route) => false, // 以前の画面を削除する
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('電話番号の変更に失敗しました',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
            )
          ),
        )
      );
      DialogUtils.hideLoadingDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('電話番号変更'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('新しい電話番号を入力してください', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CommonInput(
                    controller: phoneNumberController,
                    label: 'Phone Number',
                    obscureText: false,
                    validator: (value) => ValidationUtils.validatePhoneNumber(value),
                  ),
                  const SizedBox(height: 20),
                  CommonButton(
                    text: '電話番号を変更',
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();
                      if (!isValid) {
                        return;
                      } else {
                        // 電話番号変更処理
                        updatePhoneNumber();
                      }
                    },
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );  
  }
}
