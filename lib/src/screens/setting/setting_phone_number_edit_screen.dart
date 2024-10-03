import 'package:flutter/material.dart';
import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/services/api_exception.dart';
import 'package:flutter_sample/src/services/setting_service.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/route_utils.dart';
import 'package:flutter_sample/src/utils/snackbar_utils.dart';
import 'package:flutter_sample/src/utils/validation_utils.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
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
  TextEditingController _phoneNumberController = TextEditingController();
  AuthProvider? authProvider;
  
  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> updatePhoneNumber() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    DialogUtils.showLoadingDialog(context);

    try {
      await settingService.updatePhoneNumber(_phoneNumberController.text);
      await authProvider.successPhoneNumber();
      if (!mounted) return;
      SnackbarUtils.showSnackbar(context, '電話番号を変更しました');
      DialogUtils.hideLoadingDialog(context);
      RouteUtils.navigateToAuthWrapper(context);

    } on ApiException catch (e) {
      DialogUtils.hideLoadingDialog(context);
      SnackbarUtils.showSnackbar(context, e.message);
    } catch (e) {
      SnackbarUtils.showSnackbar(context, '電話番号の変更に失敗しました');
      DialogUtils.hideLoadingDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '電話番号変更'), 
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
                    controller: _phoneNumberController,
                    label: 'Phone Number',
                    obscureText: false,
                    validator: (value) => ValidationUtils.validatePhoneNumber(value),
                  ),
                  const SizedBox(height: 20),
                  CommonButton(
                    text: '電話番号を変更',
                    onPressed: updatePhoneNumber,
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
