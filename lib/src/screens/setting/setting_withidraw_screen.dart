import 'package:flutter/material.dart';
import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/services/api_exception.dart';
import 'package:flutter_sample/src/services/setting_service.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/route_utils.dart';
import 'package:flutter_sample/src/utils/snackbar_utils.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:provider/provider.dart';

class SettingWithidrawScreen extends StatefulWidget {
  const SettingWithidrawScreen({ super.key });

  @override
  State<SettingWithidrawScreen> createState() => _SettingWithidrawScreenState();
}

class _SettingWithidrawScreenState extends State<SettingWithidrawScreen> {
  final SettingService settingService = SettingService();

  Future<void> withidraw() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    DialogUtils.showLoadingDialog(context);
    // 退会処理
    try {
      await settingService.withdraw();
      await authProvider.successWithidraw();
      if (!mounted) return;
      SnackbarUtils.showSnackbar(context, '退会しました');
      DialogUtils.hideLoadingDialog(context);
      RouteUtils.navigateToAuthWrapper(context);

    } on ApiException catch (e) {
      SnackbarUtils.showSnackbar(context, e.message);
      DialogUtils.hideLoadingDialog(context);

    } catch (e) {
      SnackbarUtils.showSnackbar(context, '退会に失敗しました');
      DialogUtils.hideLoadingDialog(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '退会'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text('退会しますか？', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CommonButton(
                text: '退会する',
                onPressed: withidraw, 
              ),
            ],
          ),
        ),
      ),
    );  
  }
}