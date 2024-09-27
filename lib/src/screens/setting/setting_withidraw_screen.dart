import 'package:flutter/material.dart';
import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/services/setting_service.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/widgets/auth_wrapper.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:provider/provider.dart';

class SettingWithidrawScreen extends StatefulWidget {
  const SettingWithidrawScreen({ super.key });

  @override
  State<SettingWithidrawScreen> createState() => _SettingWithidrawScreenState();
}

class _SettingWithidrawScreenState extends State<SettingWithidrawScreen> {
  final SettingService settingService = SettingService();
  AuthProvider? authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> withidraw() async {
    DialogUtils.showLoadingDialog(context);
    // 退会処理
    final result = await settingService.withdraw();

    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('退会しました',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
            )
          ),
        )
      );
      await authProvider?.successWithidraw();

      if (!mounted) return;

      DialogUtils.hideLoadingDialog(context);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthWrapper()),
        (route) => false
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('退会に失敗しました',
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
        title: const Text('退会'),
      ),
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
                onPressed: () {
                  withidraw();
                },
              ),
            ],
          ),
        ),
      ),
    );  
  }
}