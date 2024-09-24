import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/widgets/auth_wrapper.dart';
import 'package:flutter_sample/src/widgets/common_app_bar.dart';
import 'package:flutter_sample/src/widgets/common_app_icon.dart';
import 'package:flutter_sample/src/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterComfirmScreen extends StatefulWidget {
  final Map<String, String> arguments;

  const RegisterComfirmScreen({
    super.key,
    required this.arguments
  });

  @override
  State<RegisterComfirmScreen> createState() => _RegisterComfirmScreenState();
}

class  _RegisterComfirmScreenState extends State<RegisterComfirmScreen> {
  final _forKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // 各 Controller に初期値を設定
    nameController = TextEditingController(text: widget.arguments['name']);
    emailController = TextEditingController(text: widget.arguments['email']);
    passwordController = TextEditingController(text: widget.arguments['password']);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
  
  // パスワードの表示を隠すために、最後の文字以外を*に変換する
  String _maskPassword(String password) {
    return '*' * (password.length);
  } 

  @override
  Widget build(BuildContext context) {

    void register() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final name = nameController.text;
      final email = emailController.text;
      final password = passwordController.text;

      // ローディングダイアログを表示
      DialogUtils.showLoadingDialog(context);

      // 登録メソッドを呼び出す
      await authProvider.register(name, email, password);

      if (!context.mounted) return;

      // ローディングダイアログを非表示
      DialogUtils.hideLoadingDialog(context);

      // エラーメッセージがある場合は、SnackBar で表示
      if (authProvider.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.message!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        );
      // ログイン成功時は、AuthWrapper に遷移する
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
          (route) => false, // 以前の画面を削除する
        );
      }
    }

    return Scaffold(
      appBar: const CommonAppBar(title: 'Register Confrim'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const CommonAppIcon(size: 100),
            const SizedBox(height: 30),
            Form(
              key: _forKey,
              child: Column(
                children: [
                  _buildConfirmationRow('Name', nameController.text),
                  const SizedBox(height: 15),
                  _buildConfirmationRow('Email', emailController.text),
                  const SizedBox(height: 15),
                  _buildConfirmationRow('Password', _maskPassword(passwordController.text)),
                  const SizedBox(height: 50),
                  CommonButton(
                    text: 'Register',
                    onPressed: register,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 確認画面の行を作成する
  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      )
    );
  }
}
